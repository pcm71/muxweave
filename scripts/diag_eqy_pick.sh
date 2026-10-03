#!/usr/bin/env bash
# diag_eqy_pick.sh —— 看清 EQY 的策略选择顺序与 SBY 可用性
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
EQY="$HOME/src/eqy/src/eqy.py"
echo "=== 1) 策略选择循环（1080-1110）==="
sed -n '1078,1112p' "$EQY"
echo
echo "=== 2) partition attributes 来源（1035-1055）==="
sed -n '1035,1055p' "$EQY"
echo
echo "=== 3) SBY 是否可用 ==="
for t in sby yosys-smtbmc yosys-abc; do
  p=$(command -v "$t" 2>/dev/null || echo "未找到")
  echo "  $t: $p"
done
echo
echo "=== 4) EQY 的 help/示例里是否提到多策略 ==="
grep -rn "strategy" "$HOME/src/eqy/docs"/*.rst "$HOME/src/eqy/docs"/*.md 2>/dev/null | head -12
