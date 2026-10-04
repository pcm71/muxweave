#!/usr/bin/env bash
# probe_if_help_now.sh —— 取 &if 的完整参数表
#
# 之前 `&if -h` 报 "Design has boxes but box library is not entered"，
# 那些 box 是 `-W` 时序建模插入的 $__ABC9_DELAY。
# 本次**不带 -W** 生成网络，应该没有 box，从而能问出帮助。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
rm -rf _tmp_yosys-abc-* 2>/dev/null

yosys -q -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2 -run begin:map_luts
abc9 -lut 4 -showtmp -nocleanup
" > /dev/null 2>&1

XAIG=$(ls -d _tmp_yosys-abc-* 2>/dev/null | head -1)
echo "临时目录: ${XAIG:-未找到}"
[ -n "${XAIG:-}" ] || exit 1
echo "  input.xaig 大小: $(stat -c%s "$XAIG/input.xaig" 2>/dev/null) 字节"
echo
echo "=== 不带 box 库直接问 &if -h ==="
yosys-abc -c "&read $XAIG/input.xaig; &if -h" 2>&1 | head -50 | sed 's/^/  /'
echo
echo "=== 若仍失败，则先 read_box 再问 ==="
yosys-abc -c "read_box $XAIG/input.box; &read $XAIG/input.xaig; &if -h" 2>&1 | head -50 | sed 's/^/  /'
