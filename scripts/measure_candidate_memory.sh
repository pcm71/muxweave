#!/usr/bin/env bash
# measure_candidate_memory.sh —— 确认多候选机制的内存代价
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/mem_cfg
S="$D/scripts/s_dch.abc"

mem() { # $1=yosys 脚本
  python3 scripts/measure_yosys_self.py 1 -- "$HOME/.local/bin/yosys-baseline" -q -p "$1" \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])"
}

base_cmd() {
  echo "read_verilog benchmarks/official/$1.v; hierarchy -top $1; \
synth_intel -family cycloneiv -top $1 -run begin:map_luts; $2; clean; opt -fast"
}

printf '  %-6s %-14s %-14s %-14s %s\n' "用例" "官方基线" "1 个候选" "2 个候选" "两候选开销"
echo "  ---------------------------------------------------------------------------"
for case in test1 test2 test3 test4; do
  b=$(mem "$(base_cmd $case 'abc9 -lut 4 -W 300')")
  one=$(mem "$(base_cmd $case "abc9 -lut 4 -script $S")")
  two=$(mem "$(base_cmd $case "abc9 -lut 4 -script $S; abc9 -lut 4 -luts 4,4,4,1 -script $S")")
  python3 -c "
b=$b; one=$one; two=$two
print(f'  {\"$case\":<6} {b:<14} {one:<14} {two:<14} {(two-b)/b*100:+.1f}%   (1候选 {(one-b)/b*100:+.1f}%)')"
done
