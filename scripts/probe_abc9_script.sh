#!/usr/bin/env bash
# probe_abc9_script.sh —— 挖出 abc9 实际生成的 ABC 脚本（新版 & 命令）
#
# 动机：官方流程用的是 abc9，它的默认脚本是
#   &scorr; &sweep; &dc2; &dch -f -r; &ps; &if {W} {D} {R} -v; &mfs
# 我们之前只调过 abc（旧版）的脚本，从没调过 abc9 的。
# 目标：看清 {W}{D}{R} 的替换结果与 &if 的可用选项，
#       以便做"同样用 abc9（便宜）但脚本更偏面积"的变体，同时满足面积与 ≤5% 开销。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs
OUT=runs/abc9_script_probe.txt

yosys -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2 -run begin:map_luts
abc9 -lut 4 -W 300 -showtmp -nocleanup
" > runs/abc9_showtmp.log 2>&1

{
  echo "########## abc9 生成的临时目录与脚本 ##########"
  echo
  echo "=== -showtmp / read_lut 相关行 ==="
  grep -iE "showtmp|/tmp/|read_lut|abc\.script" runs/abc9_showtmp.log | head -10
  echo
  for d in $(ls -dt /tmp/yosys-abc-* 2>/dev/null | head -3); do
    echo "=== 临时目录 $d ==="
    ls -la "$d"
    echo
    for f in "$d"/*; do
      [ -f "$f" ] || continue
      echo "--- $(basename "$f") ---"
      cat "$f"
      echo
    done
  done
  echo
  echo "=== Yosys 发给 ABC 的命令序列（ABC: 行）==="
  grep -E "^ABC: " runs/abc9_showtmp.log | head -30
} > "$OUT" 2>&1

echo "已写出 $OUT（$(wc -l < "$OUT") 行）"
echo
sed -n '1,70p' "$OUT"
