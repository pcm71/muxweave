#!/usr/bin/env bash
# diag_abc9_mfs2.sh —— 定位 abc9_mfs2.abc 的解析错误（看清生成的 abc.script）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs
rm -rf _tmp_yosys-abc-* 2>/dev/null

yosys -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2 -run begin:map_luts
abc9 -lut 4 -script configs/abc_scripts/abc9_mfs2.abc -showtmp -nocleanup
" > runs/abc9_mfs2_diag.log 2>&1

echo "=== 错误信息 ==="
grep -nE "ERROR|Error|cannot interpret" runs/abc9_mfs2_diag.log | head -5
echo
D=$(ls -d _tmp_yosys-abc-* 2>/dev/null | head -1)
echo "=== 生成目录: ${D:-未找到} ==="
if [ -n "${D:-}" ] && [ -f "$D/abc.script" ]; then
  echo "--- abc.script（带行号，第 45-60 行重点看）---"
  cat -n "$D/abc.script"
fi
echo
echo "=== 对比：正常工作的 abc9_area.abc 生成的脚本（只看命令区）==="
rm -rf _tmp_yosys-abc-* 2>/dev/null
yosys -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2 -run begin:map_luts
abc9 -lut 4 -script configs/abc_scripts/abc9_area.abc -showtmp -nocleanup
" > runs/abc9_area_diag.log 2>&1
D2=$(ls -d _tmp_yosys-abc-* 2>/dev/null | head -1)
if [ -n "${D2:-}" ] && [ -f "$D2/abc.script" ]; then
  grep -nE "^&|^mfs|^lut|^read|^strash|^dch|^if|^scorr|^dc2" "$D2/abc.script" | head -20
fi
