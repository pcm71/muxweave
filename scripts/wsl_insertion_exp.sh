#!/usr/bin/env bash
# wsl_insertion_exp.sh —— 插入点实验：B0 / B1 / O_INSERT_A / O_INSERT_B × 全部用例
#
#   bash scripts/wsl_insertion_exp.sh
#
# 目的（主办方 9.20 答复："在 synth_intel 组合命令集中调试来确定 pass 执行位置，结果最优即可"）：
#   * B0  = 官方统一流程（proc → synth_intel）
#   * B1  = 加强基线（proc → opt → opt_reduce -fine/opt_merge/opt_muxtree/opt_share → synth_intel）
#           → 用来量化"已有 pass 已经吃掉了多少空间"，这是第 2 周去留判断的关键对照
#   * A/B = 把自研 pass 放在不同位置；本周 pass 是骨架版（不改网表），
#           因此 A/B 必须与"去掉自研 pass 的同序列"一致 —— 若不一致即为缺陷
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs reports

echo "=== 清理旧结果（避免混淆；证据可重生成）==="
rm -rf runs/u0*__* runs/m0*__* 2>/dev/null
echo "  已清理"

PIPELINES="B0 B1 O_INSERT_A O_INSERT_B"
CASES=$(ls benchmarks/unit/u0*.v benchmarks/mixed/m0*.v 2>/dev/null)

total=0; ok=0; fail=0
for pipe in $PIPELINES; do
  echo
  echo "##################### pipeline $pipe #####################"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/exp_${pipe}_${name}.log" 2>&1; then
      ok=$((ok+1))
      printf '  %-32s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/exp_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1))
      printf '  %-32s FAIL\n' "$name"
      tail -6 "runs/exp_${pipe}_${name}.log" | sed 's/^/      /'
    fi
  done
done

echo
echo "=== 运行统计：共 $total 次，成功 $ok，失败 $fail ==="

echo
echo "=== 生成对比报告 ==="
python3 scripts/exp_summary.py --runs runs --baseline B0 --out reports/exp_insertion_point.md 2>&1 | tail -60

echo
echo "=== 也给出 report.py 视角（B0 vs B1）==="
python3 scripts/report.py --runs runs --baseline B0 --candidate B1 --out reports/cmp_B0_vs_B1 > /dev/null 2>&1 \
  && echo "  reports/cmp_B0_vs_B1/summary.md" || echo "  (B1 对照生成失败)"

echo
echo "=== 产物 ==="
ls -1 reports/exp_insertion_point.md reports/cmp_B0_vs_B1/summary.md 2>/dev/null
