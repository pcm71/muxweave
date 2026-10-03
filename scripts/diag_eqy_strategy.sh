#!/usr/bin/env bash
# diag_eqy_strategy.sh —— 查清 EQY 的策略配置要求与 test3/test4 的失败原因
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
L=formal/eqy_official/logs

echo "=== 1) eqy 的帮助（前 60 行）==="
eqy --help 2>&1 | head -60
echo
echo "=== 2) test4 控制组日志：报错前后 ==="
grep -n -B4 -A4 "No configured strategy" "$L/ctrl_test4.log" 2>/dev/null | head -30
echo
echo "=== 3) test4 控制组日志：策略与 partition 相关信息 ==="
grep -nE "partition|strateg|Partition|latch|\\\$dlatch|\\\$_DLATCH" "$L/ctrl_test4.log" 2>/dev/null | head -25
echo
echo "=== 4) test3 控制组日志：未证明的 partition 与原因 ==="
grep -nE "Failed to prove equivalence of partition|Warning: Failed|unproven|Unproven" "$L/ctrl_test3.log" 2>/dev/null | head -10
echo
echo "=== 5) test1 控制组日志：成功的证据长什么样（对照）==="
grep -nE "Successfully proved|DONE|partition|strateg" "$L/ctrl_test1.log" 2>/dev/null | head -12
