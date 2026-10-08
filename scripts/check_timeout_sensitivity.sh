#!/usr/bin/env bash
# check_timeout_sensitivity.sh —— 关键自查：&rrr -T 1 是否受机器速度影响？
#
# 风险：`-T` 是按**时间**限的。若 rrr 实际会"跑满"这个预算，那么换一台更快/更慢的机器，
#       迭代次数就不同 ⇒ 结果不可复现 ⇒ 评测机上的成绩可能不是 22.64%。
# 判据：若把 -T 从 0.3 扫到 10 结果都相同，说明 rrr 在 0.3s 内就收敛完了，
#       -T 不是约束条件 ⇒ 结果与机器速度无关（可复现）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/timeout_sens
S=configs/abc_scripts/tosens
mkdir -p "$D" "$S"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}
run() {
  local t0=$(date +%s%N)
  timeout 200 yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -lut 4 -script $S/$2.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$2.json stat -json
" > "$D/$1_$2.log" 2>&1
  local ms=$(( ($(date +%s%N) - t0) / 1000000 ))
  [ $? -eq 124 ] && { echo "TO"; return; }
  echo "$(stat_of "$D/$1_$2.json")/${ms}ms"
}

echo "=== -T 敏感性（格式 逻辑单元/耗时；若随 -T 变化即为不可复现风险）==="
printf '  %-10s %-16s %-16s %-16s\n' "-T" "test3" "test4" "test1"
echo "  ------------------------------------------------------------"
for T in 0.3 1 2 5 10; do
  printf '%s\n' "&rrr -T $T -X 2" "&dch -f -r" "&compress3rs" "&if -a -F 16 -v" > "$S/T$T.abc"
  printf '  %-10s' "$T"
  for c in test3 test4 test1; do printf '%-16s' "$(run "$c" "T$T")"; done
  echo
done
echo
echo "结论判据：若 0.3 与 10 的结果相同 ⇒ -T 不是约束，结果与机器速度无关（安全）。"
