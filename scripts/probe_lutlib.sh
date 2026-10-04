#!/usr/bin/env bash
# probe_lutlib.sh —— 看 abc9 自动生成的 LUT 库文件格式，为自定义成本/结构做准备
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
rm -rf _tmp_yosys-abc-* 2>/dev/null

yosys -q -p "
read_verilog benchmarks/official/test4.v
hierarchy -top test4
synth_intel -family cycloneiv -top test4 -run begin:map_luts
abc9 -lut 4 -W 300 -showtmp -nocleanup
" > /dev/null 2>&1

XAIG=$(ls -d _tmp_yosys-abc-* 2>/dev/null | head -1)
echo "临时目录: ${XAIG:-未找到}"
echo
echo "=== lutdefs.txt（-lut 4 自动生成的 LUT 库）==="
cat "$XAIG/lutdefs.txt" 2>/dev/null | sed 's/^/  /'
echo
echo "=== input.box（box 库，前 15 行）==="
head -15 "$XAIG/input.box" 2>/dev/null | sed 's/^/  /'
echo
echo "=== input.sym ==="
head -10 "$XAIG/input.sym" 2>/dev/null | sed 's/^/  /'
