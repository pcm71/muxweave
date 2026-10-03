#!/usr/bin/env bash
# diag_eqy_memory_rule.sh —— 查清 EQY 为何跳过"含 memory"的 partition
# 只读排查：在 EQY 源码里定位那条 skip 判定与相关策略条件
set -uo pipefail
EQY="$HOME/src/eqy"
echo "=== 1) 定位 skip 判定的源码位置 ==="
grep -rn "as it contains memory\|contains memory" "$EQY" --include=*.py 2>/dev/null | head -10
echo
echo "=== 2) 该判定附近的策略适用条件 ==="
F=$(grep -rln "as it contains memory" "$EQY" --include=*.py 2>/dev/null | head -1)
echo "命中文件: ${F:-未找到}"
if [ -n "${F:-}" ]; then
  grep -n -B12 -A6 "as it contains memory" "$F" | head -40
fi
echo
echo "=== 3) EQY 的策略定义（strategy 相关） ==="
grep -rn "class EqyStrategy\|strategies\[" "$EQY" --include=*.py 2>/dev/null | head -10
echo
echo "=== 4) EQY 内置策略清单 ==="
grep -rn "use sby\|use sat\|use abc\|use aig\|'sat'\|\"sat\"" "$EQY"/*.py 2>/dev/null | head -20
