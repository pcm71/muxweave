#!/usr/bin/env bash
# try_opt_dff.sh —— 路线 D：在 abc9 之前把触发器控制集（enable/clear）识别出来
#
# 假设：test4 的 `if(!ena) q<=0; else q<=f5(datain)` 里，`ena` 这个"是否加载"的选择
#   本该由 **LCELL 自带的同步清零/使能** 承担，而不是让组合逻辑去算 `ena & f5(...)`。
#   若组合逻辑只剩 f5(datain)（5 输入），每位 2 个 LUT4 即可 ⇒ test4 理论可到 ~20。
#   Yosys 的 `opt_dff` 正是用来把 `q <= en ? d : c` 这类结构转成带 enable/clear 的触发器。
#
# 本实验在 abc9 之前插入 opt_dff / opt_dff -sat，看 LUT 是否下降。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/opt_dff
mkdir -p "$D"

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}

run() { # $1=case $2=前置 pass $3=标签
  yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
$2
abc9 -lut 4 -script configs/abc_scripts/a9_a_F5.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$3.json stat -json
" > "$D/$1_$3.log" 2>&1
  logic_of "$D/$1_$3.json"
}

echo "=== 在 abc9 前插入触发器控制集识别（格式：逻辑单元/DFF）==="
printf '  %-26s %-12s %-12s %-12s %s\n' "前置处理" "test1" "test2" "test3" "test4"
echo "  -------------------------------------------------------------------------"
printf '  %-26s %-12s %-12s %-12s %s\n' "（无，基准）" \
  "$(run test1 '' base)" "$(run test2 '' base)" "$(run test3 '' base)" "$(run test4 '' base)"
printf '  %-26s %-12s %-12s %-12s %s\n' "opt_dff" \
  "$(run test1 'opt_dff' dff)" "$(run test2 'opt_dff' dff)" "$(run test3 'opt_dff' dff)" "$(run test4 'opt_dff' dff)"
printf '  %-26s %-12s %-12s %-12s %s\n' "opt_dff -sat" \
  "$(run test1 'opt_dff -sat' dffsat)" "$(run test2 'opt_dff -sat' dffsat)" "$(run test3 'opt_dff -sat' dffsat)" "$(run test4 'opt_dff -sat' dffsat)"
printf '  %-26s %-12s %-12s %-12s %s\n' "opt_dff + opt_clean" \
  "$(run test1 'opt_dff; opt_clean' dff2)" "$(run test2 'opt_dff; opt_clean' dff2)" "$(run test3 'opt_dff; opt_clean' dff2)" "$(run test4 'opt_dff; opt_clean' dff2)"

echo
echo "=== 顺带看：test4 里 dffeas 到底用没用 ena/sclr ==="
grep -oE "dffeas[^)]*" "$D/test4_base.log" 2>/dev/null | head -3 | sed 's/^/  /'
python3 - <<'PY'
import json
try:
    d = json.load(open("runs/opt_dff/test4_base.json", encoding="utf-8"))
    m = d["modules"]["test4"]
    ff = [c for c in m["cells"].values() if "dffeas" in c["type"] or "dff" in c["type"]]
    print(f"  触发器单元数={len(ff)}")
    for c in ff[:3]:
        print(f"    类型={c['type']}  端口={list(c['connections'].keys())}")
        print(f"    参数={c.get('parameters', {})}")
except Exception as e:
    print("  读取失败:", e)
PY
