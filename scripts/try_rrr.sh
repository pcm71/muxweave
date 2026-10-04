#!/usr/bin/env bash
# try_rrr.sh —— 用 -T 限制 &rrr 的耗时，看能否保留 test3 的收益（13→11）而不在大用例上超时
#
# 依据：Abc_CommandAbc9Rrr（abc.c:49083）的参数表为
#       "XYZNJKLBDRWTCGVPOAQSabdegh"，其中 -T nTimeout 是超时限制、-N 是作业数、-J 是线程数，
#       默认 fDeterministic = 1（确定性）。
# 上一轮无参数的 &rrr 在 test1 上跑了 >150s 超时，但把 test3 从 13 降到 11。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/rrr
S=configs/abc_scripts/rrr
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; { printf '%s\n' "$@"; echo "&if -a -v"; } > "$S/$n.abc"; }
mk r0_base   "&dch -p -f -r"
mk r1_T5     "&dch -p -f -r" "&rrr -T 5"
mk r2_T15    "&dch -p -f -r" "&rrr -T 15"
mk r3_T30    "&dch -p -f -r" "&rrr -T 30"
mk r4_T10N1  "&dch -p -f -r" "&rrr -T 10 -N 1 -J 1"
mk r5_rrrT5dch "&rrr -T 5" "&dch -p -f -r"

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
  local t0=$(date +%s)
  timeout 300 yosys -q -p "
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
  local rc=$?
  local dt=$(( $(date +%s) - t0 ))
  if [ $rc -eq 124 ]; then echo "TO(${dt}s)"; return; fi
  echo "$(stat_of "$D/$1_$2.json")(${dt}s)"
}

echo "=== &rrr 受限实验（格式 逻辑/耗时；基线 288/25/13/36）==="
printf '  %-14s %-14s %-14s %-14s %s\n' "脚本" "test1" "test2" "test3" "test4"
echo "  -------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-14s' "${tag#r?_}"
  for case in test1 test2 test3 test4; do printf '%-14s' "$(run "$case" "$tag")"; done
  echo
done
