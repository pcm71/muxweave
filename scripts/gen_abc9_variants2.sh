#!/usr/bin/env bash
# gen_abc9_variants2.sh —— 第二批 abc9 变体：延迟松弛 / 更多割 / 换用 &nf 映射器
#
# 依据（刚探测到的选项）：
#   &if / &nf 都有 `-R num : the delay relaxation ratio (num >= 0) [default = 0]`
#   —— 官方默认脚本给的是 "best possible delay"，即最紧延迟；放宽延迟通常可以换面积。
#   另外 &nf 的 `-C` 默认 16（&if 是 8）、`-F` 默认 4，都还没试过。
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
  printf '  %-24s : %s\n' "$1" "$(tr '\n' ' ' < "$1")"
}

echo "=== 第二批：延迟松弛与映射器参数 ==="
emit a9_a_R1.abc     "&if -W 300 -a -R 1 -v"
emit a9_a_R10.abc    "&if -W 300 -a -R 10 -v"
emit a9_a_R100.abc   "&if -W 300 -a -R 100 -v"
emit a9_a_CF.abc     "&if -W 300 -a -C 32 -F 10 -v"
emit a9_a_A8_R10.abc "&if -W 300 -a -A 8 -R 10 -v"
emit a9_nf4a.abc     "&nf -K 4 -a"
emit a9_nf4.abc      "&nf -K 4"
emit a9_nf4A8.abc    "&nf -K 4 -a -A 8"
echo
echo "共 $(ls a9_*.abc 2>/dev/null | wc -l) 个 a9_* 变体"
