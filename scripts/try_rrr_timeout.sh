#!/usr/bin/env bash
# try_rrr_timeout.sh —— 找一个"刚好够 test3 拿到 11、又不让大用例耗时爆炸"的超时值
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/rrr_to
S=configs/abc_scripts/rrrto
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
run() { # $1=case $2=脚本
  local t0=$(date +%s)
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
  [ $? -eq 124 ] && { echo "TO"; return; }
  echo "$(stat_of "$D/$1_$2.json")/$(($(date +%s)-t0))s"
}

echo "=== &rrr 超时扫描（格式 逻辑单元/耗时；基线 288/25/13/36）==="
printf '  %-12s %-14s %-14s %-14s %-14s\n' "-T 值" "test1" "test2" "test3" "test4"
echo "  ----------------------------------------------------------------------"
for T in 1 2 3 5 10; do
  printf '%s\n' "&dch -p -f -r" "&rrr -T $T" "&if -a -v" > "$S/to$T.abc"
  printf '  %-12s' "-T $T"
  for case in test1 test2 test3 test4; do printf '%-14s' "$(run "$case" "to$T")"; done
  echo
done
echo
echo "目标：找到最小的 T 使 test3 仍为 11，同时 test1 的耗时尽量小。"
