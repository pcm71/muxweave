#!/usr/bin/env bash
# mem_attribution.sh —— 定位内存与耗时到底是谁吃的（候选机制 vs &rrr 本身）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/mem_attr
S=configs/abc_scripts/memattr
mkdir -p "$D" "$S"

printf '%s\n' "&dch -p -f -r" "&if -a -v" > "$S/area.abc"
printf '%s\n' "&dch -p -f -r" "&rrr -T 30" "&if -a -v" > "$S/rrr30.abc"
printf '%s\n' "&dch -p -f -r" "&rrr -T 2" "&if -a -v" > "$S/rrr2.abc"

meas() { # $1=case $2=abc9选项 -> "内存KB 耗时s"
  local t0=$(date +%s)
  local j
  j=$(python3 scripts/measure_yosys_self.py 1 -- "$HOME/.local/bin/yosys-baseline" -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
$2
clean
opt -fast
")
  local dt=$(( $(date +%s) - t0 ))
  echo "$j" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['maxrss_self_kb'], d['cpu_total'])" | tr ' ' '\n' | head -1 | tr -d '\n'
  echo " $dt"
}

echo "=== 内存与耗时归因（口径 C54-2；格式 内存KB 墙钟秒）==="
printf '  %-10s %-18s %-18s %-18s\n' "用例" "官方基线" "面积脚本(1候选)" "&rrr -T 30(1候选)"
echo "  --------------------------------------------------------------------------"
for case in test1 test4; do
  b=$(meas "$case" "abc9 -lut 4 -W 300")
  a=$(meas "$case" "abc9 -lut 4 -script $S/area.abc")
  r=$(meas "$case" "abc9 -lut 4 -script $S/rrr30.abc")
  r2=$(meas "$case" "abc9 -lut 4 -script $S/rrr2.abc")
  printf '  %-10s %-18s %-18s %-18s\n' "$case" "$b" "$a" "$r"
  printf '  %-10s %-18s %-18s %-18s\n' "  └ rrr -T 2" "" "" "$r2"
done
echo
echo "读法：比较三列即可判断内存/耗时是'候选机制'造成还是'&rrr 本身'造成。"
