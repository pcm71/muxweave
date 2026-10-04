#!/usr/bin/env bash
# check_eqy_opts.sh —— 查 EQY 的可用选项，并确认 ilang 网表内容
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1

echo "=== ilang 文件规模与单元类型 ==="
ls -la runs/eqy_ilang/*.il 2>/dev/null | sed 's/^/  /'
echo "  --- test4 里的 cell 行样例 ---"
grep -m5 "^  cell " runs/eqy_ilang/test4_postabc.il 2>/dev/null | sed 's/^/    /'
echo "  --- 单元类型统计 ---"
grep -oE "^  cell \\\\?\\\$?[A-Za-z0-9_]+" runs/eqy_ilang/test4_postabc.il 2>/dev/null | awk '{print $2}' | sort | uniq -c | sort -rn | head -6 | sed 's/^/    /'

echo
echo "=== EQY 帮助（选项）==="
eqy --help 2>&1 | head -40 | sed 's/^/  /'
