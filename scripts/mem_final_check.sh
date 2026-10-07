#!/usr/bin/env bash
# mem_final_check.sh —— 精确测量当前配置的内存开销，并试几个降内存的变体
#
# 现状：面积 21.86%（288/15/9/30），但内存开销报告为 +14.1%，紧贴细则 15% 的红线。
# 内存口径：C54-2「峰值工作内存，只看 yosys.exe」（scripts/measure_yosys_self.py）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/mem_final
S=configs/abc_scripts/memfinal
mkdir -p "$D" "$S"

printf '%s\n' "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -F 16 -v"   > "$S/cur.abc"
printf '%s\n' "&rrr -T 1 -X 2 -W 4" "&dch -p -f -r" "&if -a -F 16 -v" > "$S/W4.abc"
printf '%s\n' "&rrr -T 1 -X 2 -W 2" "&dch -p -f -r" "&if -a -F 16 -v" > "$S/W2.abc"
printf '%s\n' "&dch -p -f -r" "&if -a -F 16 -v"                   > "$S/norrr.abc"

med() { printf '%s\n' "$@" | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }

memrun() { # $1=case $2=脚本 $3=重复次数
  local out=()
  for i in $(seq "$3"); do
    local v
    v=$(python3 scripts/measure_yosys_self.py 1 -- "$HOME/.local/bin/yosys-baseline" -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -lut 4 -script $S/$2.abc
clean
opt -fast
" | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])")
    out+=("$v")
  done
  med "${out[@]}"
}

echo "=== 内存精测（每格 9 次取中位数；单位 KB）==="
printf '  %-12s %-12s %-12s %-12s %-12s\n' "用例" "官方基线" "当前脚本" "-W 4" "-W 2"
echo "  ------------------------------------------------------------------"
for case in test1 test2 test3 test4; do
  b=$(memrun "$case" cur 9)          # 先跑当前脚本占位（下面会用官方基线覆盖）
  # 官方基线
  base=$(med $(for i in 1 2 3 4 5 6 7 8 9; do
    python3 scripts/measure_yosys_self.py 1 -- "$HOME/.local/bin/yosys-baseline" -q -p "
read_verilog benchmarks/official/$case.v
hierarchy -top $case
synth_intel -family cycloneiv -top $case -run begin:map_luts
abc9 -lut 4 -W 300
clean
opt -fast
" | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])"
  done))
  cur=$(memrun "$case" cur 9)
  w4=$(memrun "$case" W4 9)
  w2=$(memrun "$case" W2 9)
  python3 -c "
b=$base
for name,v in (('当前', $cur), ('-W 4', $w4), ('-W 2', $w2)):
    print(f'  {\"$case\":<12} {b:<12} {v:<12} {(v-b)/b*100:+.1f}%' if name=='当前' else f'  {\"\":<12} {\"\":<12} {v:<12} {(v-b)/b*100:+.1f}%')"
done
echo
echo "注意：脚本本身（不含候选机制）的内存应接近基线；若明显高于基线，说明 &rrr 的仿真缓冲占内存，"
echo "      可用 -W 减少仿真字数。"
