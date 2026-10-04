#!/usr/bin/env bash
# dump_if_usage2.sh —— 直接打印 &if 的 usage 段落
set -uo pipefail
ABC=~/src/yosys/abc/src/base/abci/abc.c
START=$(grep -n 'usage: &if' "$ABC" | head -1 | cut -d: -f1)
echo "=== &if usage 段（第 $START 行起 60 行）==="
sed -n "${START},$((START+60))p" "$ABC" | sed 's/^/  /'
