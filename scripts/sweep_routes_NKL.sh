#!/usr/bin/env bash
# sweep_routes_NKL.sh —— 路线 N（叠加小收益）/ K（FSM 专用）/ L（abc9 -dff）
#
# 当前最好：`&dch -p -f -r; &if -a -v` ⇒ 287/15/13/27 = 16.34%
# 剩余无收益用例：test1（287，最大块）、test3（13）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/sweep_nkl
S=configs/abc_scripts/nkl
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk n_win "&dch -p -f -r" "&if -a -v"          # 当前最好

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}

# 通用：在 abc9 前插入任意前置 pass；$1=case $2=前置 $3=abc9 额外参数 $4=标签
run() {
  timeout 240 yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
$2
abc9 -lut 4 $3 -script $S/n_win.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$4.json stat -json
" > "$D/$1_$4.log" 2>&1
  [ $? -eq 124 ] && { echo "?"; return; }
  stat_of "$D/$1_$4.json"
}

avg() {
  python3 - "$D" "$1" <<'PY'
import json, sys
D, tag = sys.argv[1], sys.argv[2]
base = {"test1": 288, "test2": 25, "test3": 13, "test4": 36}
s = 0.0
for c, b in base.items():
    try:
        d = json.load(open(f"{D}/{c}_{tag}.json", encoding="utf-8"))
        nbt = d["design"]["num_cells_by_type"]
        seq = sum(v for k, v in nbt.items() if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
        s += (b - (d["design"]["num_cells"] - seq)) / b
    except Exception:
        return
print(f"{s/4*100:6.2f}%")
PY
}

show() { # $1=标签 $2=前置 $3=abc9额外参数
  printf '  %-30s' "$1"
  for case in test1 test2 test3 test4; do printf '%-11s' "$(run "$case" "$2" "$3" "$1")"; done
  avg "$D" "$1"
}

echo "=== 路线 N：叠加 LUT 成本模型 ==="
printf '  %-30s %-11s %-11s %-11s %-11s %s\n' "配置" "test1" "test2" "test3" "test4" "平均"
echo "  ---------------------------------------------------------------------------------------"
show "N0_基准"            "" "-script $S/n_win.abc"
show "N1_luts2221"        "" "-luts 2,2,2,1 -script $S/n_win.abc"
show "N2_luts4441"        "" "-luts 4,4,4,1 -script $S/n_win.abc"
show "N3_luts1231"        "" "-luts 1,2,3,1 -script $S/n_win.abc"

echo
echo "=== 路线 K：FSM 专用优化（在 abc9 之前插入）==="
show "K1_fsm"             "fsm" "-script $S/n_win.abc"
show "K2_fsm_recode"      "fsm; fsm_recode" "-script $S/n_win.abc"
show "K3_fsm_opt"         "fsm; fsm_opt" "-script $S/n_win.abc"
show "K4_fsm_recode_opt"  "fsm; fsm_recode; fsm_opt; opt_clean" "-script $S/n_win.abc"

echo
echo "=== 路线 L：abc9 -dff（时序优化；须检查 DFF 是否增加）==="
show "L1_dff"             "" "-dff -script $S/n_win.abc"
show "L2_dff_official"    "" "-dff"
