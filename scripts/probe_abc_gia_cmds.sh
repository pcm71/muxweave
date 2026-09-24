#!/usr/bin/env bash
# probe_abc_gia_cmds.sh —— 列出 ABC 在 GIA 域（& 命令）可用的全部命令
#
# 动机：官方 abc9 脚本走的是新版 GIA 域（&scorr/&sweep/&dc2/&dch/&if/&mfs）。
#       其中 &mfs 每次都失败，而经典脚本里的 mfs2/lutpack 是旧域命令。
#       要判断"能否在 GIA 域内补回等价优化"，必须先知道 GIA 域有哪些命令。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
ABC_BIN=$(command -v yosys-abc)
OUT=runs/abc_gia_cmds.txt
{
  echo "===== ABC 全部命令（help 首页，按组）====="
  "$ABC_BIN" -c "help" 2>&1 | head -120
  echo
  echo "===== 只筛 & 开头的命令（GIA 域）====="
  "$ABC_BIN" -c "help" 2>&1 | tr ' ' '\n' | grep -oE "^&[a-z_0-9]+" | sort -u
  echo
  echo "===== 与面积/化简相关的命令（新旧域都列）====="
  "$ABC_BIN" -c "help" 2>&1 | tr ' ' '\n' | grep -oE "^&?(mfs|mfs2|lutpack|dc2|fraig|sweep|scorr|resub|rewrite|refactor|balance|dch|nf|if|ps|put|get|write|read|verify)$" | sort -u
} > "$OUT" 2>&1
echo "已写出 $OUT"
echo
sed -n '/===== 只筛/,$p' "$OUT" | head -60
