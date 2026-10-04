#!/usr/bin/env bash
# check_rrr_determinism.sh —— 确认 &rrr 的结果可复现（它内部有 job/thread 参数）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/rrr_det
S=configs/abc_scripts/rrr
mkdir -p "$D"

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

one() { # $1=case $2=脚本 $3=输出
  yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -lut 4 -script $S/$2.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $3 stat -json
" > "${3%.json}.log" 2>&1
  logic_of "$3"
}

echo "=== &rrr 确定性检查：同一脚本跑 3 次 ==="
printf '  %-8s %-10s %-10s %-10s %s\n' "用例" "第1次" "第2次" "第3次" "判定"
echo "  ------------------------------------------------------"
for case in test3 test4; do
  a=$(one "$case" r3_T30 "$D/${case}_a.json")
  b=$(one "$case" r3_T30 "$D/${case}_b.json")
  c=$(one "$case" r3_T30 "$D/${case}_c.json")
  v="✓ 确定"; { [ "$a" != "$b" ] || [ "$b" != "$c" ]; } && v="✗ **不确定！**"
  printf '  %-8s %-10s %-10s %-10s %s\n' "$case" "$a" "$b" "$c" "$v"
done

echo
echo "=== 顺带：test3 上 &rrr 的收益是否稳定（基线 13） ==="
echo "  上面三次结果即为 &rrr 下的 test3 逻辑单元数"
