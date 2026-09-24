#!/usr/bin/env bash
# probe_abc_script.sh —— 看清 Yosys 到底给 ABC 传了什么脚本与 LUT 库
#
# 目的：上一轮我用 `-script "+命令串"` 做变体时全部劣化 500 个单元，
#       判断是 -script 绕过了 -lut 的 LUT 库生成机制。本脚本用 -showtmp -nocleanup
#       把临时脚本与 LUT 库文件挖出来，据此才能写出**正确的**自定义脚本。
#
#   bash scripts/probe_abc_script.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
OUT=runs/abc_temp_probe.txt
mkdir -p runs

echo "=== 用 -showtmp -nocleanup 跑一次 abc -lut 4 ==="
yosys -p "
read_verilog benchmarks/unit/u02_pmux4_shared_fields.v
hierarchy -top u02_pmux4_shared_fields
synth_intel -family cycloneiv -top u02_pmux4_shared_fields -run begin:map_luts
abc -lut 4 -showtmp -nocleanup
" > runs/abc_showtmp.log 2>&1
echo "  日志：runs/abc_showtmp.log（$(wc -l < runs/abc_showtmp.log) 行）"

# 从日志里找临时目录
TMPDIR_ABC=$(grep -oE "/tmp/[^ ]*yosys-abc[^ ]*|/tmp/yosys-abc-[^ ]*" runs/abc_showtmp.log | head -1)
echo "  临时目录：${TMPDIR_ABC:-未找到}"

{
  echo "############ ABC 脚本机制探查 ############"
  echo
  echo "=== 1) -showtmp 打印的临时目录 ==="
  grep -iE "temp|showtmp|/tmp/" runs/abc_showtmp.log | head -10
  echo
  if [ -n "${TMPDIR_ABC:-}" ] && [ -d "$TMPDIR_ABC" ]; then
    echo "=== 2) 临时目录内容 ==="
    ls -la "$TMPDIR_ABC"
    echo
    for f in "$TMPDIR_ABC"/*; do
      [ -f "$f" ] || continue
      echo "=== 文件: $(basename "$f") （前 40 行）==="
      head -40 "$f"
      echo
    done
  else
    echo "=== 2) 未取到临时目录，改为搜索所有 yosys-abc 临时目录 ==="
    ls -d /tmp/yosys-abc-* 2>/dev/null | head -5
    for d in $(ls -d /tmp/yosys-abc-* 2>/dev/null | head -2); do
      echo "--- $d ---"
      ls -la "$d" | head -20
      for f in "$d"/*; do
        [ -f "$f" ] || continue
        echo "=== $(basename "$f") ==="
        head -30 "$f"
        echo
      done
    done
  fi
  echo
  echo "=== 3) abc 帮助里与 -script/-lut 相关的原文 ==="
  yosys -p "help abc" 2>&1 | sed -n '/-script/,/^-dff/p' | head -40
} > "$OUT" 2>&1

echo "  已写出 $OUT"
echo
echo "=== 摘要 ==="
sed -n '1,60p' "$OUT"
