#!/usr/bin/env bash
# measure_test1_enabled.sh —— 测"显式使能"变体的 LUT 数，并与原版对比
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/test1_en
S=configs/abc_scripts/nkl/n_win.abc

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception as e: print('?')"
}

run() { # $1=verilog $2=top $3=标签
  yosys -q -p "
read_verilog $1
hierarchy -top $2
synth_intel -family cycloneiv -top $2 -run begin:map_luts
abc9 -lut 4 -script $S
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $2 -run map_cells:check
tee -o $D/$3.json stat -json
" > "$D/$3.log" 2>&1
  logic_of "$D/$3.json"
}

echo "=== test1：原版 vs 显式使能变体（格式 逻辑/DFF）==="
printf '  %-28s %s\n' "版本" "逻辑/DFF"
echo "  ------------------------------------"
printf '  %-28s %s\n' "原版 test1" "$(run benchmarks/official/test1.v test1 orig)"
printf '  %-28s %s\n' "显式使能变体" "$(run $D/test1_en.v test1 enabled)"

echo
echo "=== 若变体 DFF 数变了说明结构被改动，需注意 ==="
python3 - "$D/orig.json" "$D/enabled.json" <<'PY'
import json, sys
for p, tag in ((sys.argv[1], "原版"), (sys.argv[2], "变体")):
    try:
        d = json.load(open(p, encoding="utf-8"))
        m = d["modules"]["test1"]
        import collections
        c = collections.Counter(v["type"] for v in m["cells"].values())
        ff = {k: v for k, v in c.items() if "dffeas" in k or "dff" in k}
        tot = sum(c.values())
        print(f"  {tag}: 总单元={tot}  触发器={ff}")
    except Exception as e:
        print(f"  {tag}: 读取失败 {e}")
PY
