#!/usr/bin/env bash
# gen_abc9_delay_variants.sh —— 第三批 abc9 变体：**延迟目标 -D**（面积的关键潜在杠杆）
#
# 依据 `help abc9`：
#   -D <picoseconds>  set delay target. {D} 在默认脚本中被替换为该选项，**未给定时为空串
#                     （表示 best possible delay）**
#   ⇒ 官方 `abc9 -lut 4 -W 300` 不带 -D ⇒ **默认按"最优延迟"映射，而非按面积**。
#   ⇒ 给一个**宽松的延迟目标**应能换来面积（`&if -D float` 即"delay constraint for the mapping"）。
#
# 全部仍是 abc9（合规），只调 abc9 自己的脚本参数。
set -uo pipefail
D="$(cd "$(dirname "$0")/.." && pwd)/configs/abc_scripts"
cd "$D" || exit 1

PREFIX='&scorr
&sweep
&dc2
&dch -f -r
&ps'
emit() {
  { echo "$PREFIX"; echo "$2"; } > "$1"
  printf '  %-22s : %s\n' "$1" "$(tail -1 "$1")"
}

echo "=== 第三批：延迟目标 -D（宽松 ⇒ 换面积）==="
emit a9_a_F5_D100.abc   "&if -W 300 -a -F 5 -D 100 -v"
emit a9_a_F5_D1000.abc  "&if -W 300 -a -F 5 -D 1000 -v"
emit a9_a_F5_D10000.abc "&if -W 300 -a -F 5 -D 10000 -v"
emit a9_a_F5_D1e5.abc   "&if -W 300 -a -F 5 -D 100000 -v"
emit a9_a_F5_D1e6.abc   "&if -W 300 -a -F 5 -D 1000000 -v"
echo
echo "=== 对照：不用 -a（仅靠 -D 松弛）==="
emit a9_F5_D10000.abc   "&if -W 300 -F 5 -D 10000 -v"
emit a9_D10000.abc      "&if -W 300 -D 10000 -v"
echo
echo "共 $(ls a9_*.abc | wc -l) 个 a9_* 变体"
