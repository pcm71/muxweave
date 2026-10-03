#!/usr/bin/env bash
# probe_gia_if_help.sh —— 取 &if（GIA 域映射器）的完整选项表
# 之前直接用 `&if -h` 会报 "Empty GIA network"，因此先读入一个真实 AIG 网络再问帮助。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs
rm -rf _tmp_yosys-abc-* 2>/dev/null

# 1) 生成一个带输入网络的 abc9 临时目录（-nocleanup 保留 input.xaig）
yosys -q -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2 -run begin:map_luts
abc9 -lut 4 -W 300 -showtmp -nocleanup
" > runs/gia_probe_gen.log 2>&1

XAIG=$(ls -d _tmp_yosys-abc-* 2>/dev/null | head -1)
echo "临时目录：${XAIG:-未找到}"
[ -n "${XAIG:-}" ] && ls "$XAIG" | sed 's/^/  /'

echo
echo "=== &if -h（GIA 域映射器选项）==="
if [ -n "${XAIG:-}" ] && [ -f "$XAIG/input.xaig" ]; then
  yosys-abc -c "&read $XAIG/input.xaig; &if -h" 2>&1 | head -45
else
  echo "  未找到 input.xaig"
fi

echo
echo "=== &dch -h / &sweep -h / &scorr -h / &dc2 -h（其余步骤的选项）==="
for c in "&dch" "&sweep" "&scorr" "&dc2" "&resub" "&nf"; do
  echo "--- $c ---"
  if [ -n "${XAIG:-}" ] && [ -f "$XAIG/input.xaig" ]; then
    yosys-abc -c "&read $XAIG/input.xaig; $c -h" 2>&1 | head -12 | sed 's/^/  /'
  fi
done
