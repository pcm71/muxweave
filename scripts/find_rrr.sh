#!/usr/bin/env bash
# find_rrr.sh —— 找 &rrr 的定义与实现
set -uo pipefail
ABC=~/src/yosys/abc/src
echo "=== 命令注册 ==="
grep -rn '"&rrr"' "$ABC/base/abci/abc.c" 2>/dev/null | head -3 | sed 's/^/  /'
echo
echo "=== 实现函数 ==="
grep -rn "Abc_CommandAbc9Rrr\|CommandRrr" "$ABC/base/abci/abc.c" 2>/dev/null | head -5 | sed 's/^/  /'
echo
echo "=== 该函数里的 Abc_Print 说明行 ==="
F=$(grep -n "int Abc_CommandAbc9Rrr" "$ABC/base/abci/abc.c" 2>/dev/null | head -1 | cut -d: -f1)
if [ -n "${F:-}" ]; then
  sed -n "${F},$((F+90))p" "$ABC/base/abci/abc.c" | grep -E "Abc_Print|Rrr|nIter|pPars" | head -25 | sed 's/^/  /'
else
  echo "  未找到实现函数"
fi
