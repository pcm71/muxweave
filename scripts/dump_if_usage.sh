#!/usr/bin/env bash
# dump_if_usage.sh —— 打印 &if 每个参数的说明文字
set -uo pipefail
ABC=~/src/yosys/abc/src/base/abci/abc.c
[ -f "$ABC" ] || { echo "找不到 $ABC"; exit 1; }

# 从 usage 行开始，取后续的说明打印语句
START=$(grep -n 'usage: &if' "$ABC" | head -1 | cut -d: -f1)
echo "usage 行号: $START"
echo
sed -n "${START},$((START+80))p" "$ABC" \
  | grep -oE 'Abc_Print\( *-2, " *-[A-Za-z].*' \
  | sed 's/Abc_Print( *-2, "//' | sed 's/");$//' | head -60
