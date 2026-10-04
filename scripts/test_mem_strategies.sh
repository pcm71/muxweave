#!/usr/bin/env bash
# test_mem_strategies.sh —— 找出"多候选但省内存"的实现方式
#
# 实测事实：
#   * 连跑两次 abc9            ⇒ 内存 +1.9%~+5.4%（可接受）
#   * 当前 pass 的 design -save/-load 多候选 ⇒ +24.6%（超 15% 红线，会毁掉效率项）
# ⇒ 说明内存不是"多跑候选"吃的，而是 **`design -save` 的设计副本**吃的。
#   候选实现：A) design -save/-load   B) write_rtlil 到临时文件 + read_rtlil 还原
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/mem_strat
mkdir -p "$D"
S=runs/mem_cfg/scripts/s_dch.abc

mem() {
  python3 scripts/measure_yosys_self.py 1 -- "$HOME/.local/bin/yosys-baseline" -q -p "$1" \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])"
}
pre() {
  echo "read_verilog benchmarks/official/$1.v; hierarchy -top $1; \
synth_intel -family cycloneiv -top $1 -run begin:map_luts"
}

printf '  %-6s %-11s %-11s %-11s %-11s %s\n' "用例" "基线" "A:save/load" "B:临时文件" "A开销" "B开销"
echo "  -------------------------------------------------------------------------------"
for case in test1 test2 test3 test4; do
  b=$(mem "$(pre $case); abc9 -lut 4 -W 300; clean")
  a=$(mem "$(pre $case); design -save pre; design -load pre; abc9 -lut 4 -script $S; design -load pre; abc9 -lut 4 -luts 4,4,4,1 -script $S; clean")
  t="$D/${case}_pre.il"
  bb=$(mem "$(pre $case); write_rtlil $t; design -reset; read_rtlil $t; abc9 -lut 4 -script $S; design -reset; read_rtlil $t; abc9 -lut 4 -luts 4,4,4,1 -script $S; clean")
  python3 -c "
b=$b; a=$a; bb=$bb
print(f'  {\"$case\":<6} {b:<11} {a:<11} {bb:<11} {(a-b)/b*100:+.1f}%     {(bb-b)/b*100:+.1f}%')"
done
echo
echo "读法：B 列（write_rtlil/read_rtlil）若显著低于 A 列，就应把 pass 的候选机制改成临时文件版。"
