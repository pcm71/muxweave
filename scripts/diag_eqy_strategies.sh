#!/usr/bin/env bash
# diag_eqy_strategies.sh —— 列出 EQY 的全部策略类及其 partition_supported 条件
set -uo pipefail
EQY="$HOME/src/eqy/src/eqy.py"
echo "=== 1) 全部策略类 ==="
grep -n "^class Eqy.*Strategy" "$EQY"
echo
echo "=== 2) strategy_types 映射（.eqy 里 'use <type>' 的合法取值）==="
grep -n -A12 "strategy_types = " "$EQY" | head -20
echo
echo "=== 3) 每个策略的 partition_supported 覆盖 ==="
grep -n -A6 "def partition_supported" "$EQY"
echo
echo "=== 4) 'memory' 属性在哪里被打上 ==="
grep -n "attributes.add\|attributes =\|'memory'\|\"memory\"" "$EQY" | head -20
