#!/usr/bin/env bash
# dump_rrr_usage.sh —— 查 GIA `&rrr` 的参数表（它把 test3 从 13 降到 11，但 test1 超时）
set -uo pipefail
ABC=~/src/yosys/abc/src/base/abci/abc.c
for cmd in "&rrr" "&srm" "&scl" "&unate" "&posplit"; do
  echo "=== usage: $cmd ==="
  START=$(grep -n "usage: $cmd" "$ABC" | head -1 | cut -d: -f1)
  if [ -n "${START:-}" ]; then
    sed -n "${START},$((START+16))p" "$ABC" | grep -oE '"[^"]*"' | sed 's/^"//;s/"$//' | head -16 | sed 's/^/  /'
  else
    echo "  （源码里没有 'usage: $cmd' 字样）"
  fi
  echo
done
