#!/usr/bin/env bash
# wsl_stage3.sh —— 修复后重跑：装 EQY → 形式验证 → 基线用例 → 报告
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs

echo "=== 清理上一轮无效运行目录（stat.json 缺失导致指标为 None 的那批）==="
rm -rf runs/u0*__B0__* runs/u0*__O_* 2>/dev/null
echo "  已清理"

echo
echo "=== A) 构建并安装 EQY（PREFIX=~/.local，无需 sudo）==="
if bash scripts/build_eqy.sh > runs/stageA_eqy.log 2>&1; then
  echo "  EQY: PASS"
  grep -E "EQY 可用|插件目录|EQY commit|EQY 路径" runs/stageA_eqy.log | sed 's/^/    /'
else
  echo "  EQY: FAIL —— 日志尾部："
  tail -25 runs/stageA_eqy.log | sed 's/^/    /'
fi

echo
echo "=== B) 重跑阶段 2~4（形式验证 / 基线用例 / 报告）==="
bash scripts/wsl_stage2.sh
