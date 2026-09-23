#!/usr/bin/env bash
# wsl_stage2.sh —— 第 1 周剩余流程一条流水线（构建完成后执行）
#
#   bash scripts/wsl_stage2.sh
#
# 阶段：
#   1) 把自研 pass 编入 Yosys 主程序（硬关卡）
#   2) EQY 正误最小例（错误例必须 FAIL、正确例必须 PASS）
#   3) 5 个基础用例跑 B0 基线，采集逻辑单元/DFF/CPU 时间/进程峰值
#   4) 汇总报告
# 每个阶段独立记为 PASS/FAIL，最后打印总表；阶段 1 失败则后续跳过。
set -uo pipefail

PROJ=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
cd "$PROJ" || exit 1
mkdir -p runs reports

S1=SKIP; S2=SKIP; S3=SKIP; S4=SKIP

stage() { echo; echo "##################### $* #####################"; }

# ---------------- 阶段 1：pass 编入主程序 ----------------
stage "阶段 1/4：把 pmux_analyze / pmux_opt 编入 Yosys 主程序"
if bash scripts/install_into_yosys.sh > runs/stage1_install.log 2>&1; then
  S1=PASS
  echo "  PASS —— 见 runs/stage1_install.log 与 runs/REQ10_integration_evidence.md"
  grep -E "\[OK\]|yosys -V|编译耗时" runs/stage1_install.log | head -8
else
  S1=FAIL
  echo "  FAIL —— 尾部日志："
  tail -25 runs/stage1_install.log
fi

if [ "$S1" = "PASS" ]; then
  # ---------------- 阶段 2：形式验证最小例 ----------------
  stage "阶段 2/4：EQY 正误最小例（错误例必须 FAIL、正确例必须 PASS）"
  if bash formal/mini/run_formal_mini.sh > runs/stage2_formal.log 2>&1; then
    S2=PASS
    echo "  PASS"
    grep -E "判定=|结果：" runs/stage2_formal.log | head -6
  else
    S2=FAIL
    echo "  FAIL —— 尾部日志："
    tail -25 runs/stage2_formal.log
  fi

  # ---------------- 阶段 3：5 个基础用例 B0 ----------------
  stage "阶段 3/4：5 个基础用例跑 B0 基线"
  S3=PASS
  for v in benchmarks/unit/u0*.v; do
    name=$(basename "$v" .v)
    echo "  --- $name ---"
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline B0 \
         > "runs/stage3_${name}.log" 2>&1; then
      grep -E "逻辑单元|CPU 时间|进程峰值|PMUX" "runs/stage3_${name}.log" | sed 's/^/    /'
    else
      S3=FAIL
      echo "    FAIL —— 尾部日志："
      tail -12 "runs/stage3_${name}.log" | sed 's/^/    /'
    fi
  done

  # ---------------- 阶段 4：汇总报告 ----------------
  stage "阶段 4/4：生成汇总报告"
  if python3 scripts/report.py --runs runs --out reports > runs/stage4_report.log 2>&1; then
    S4=PASS
    echo "  PASS —— reports/summary.md"
    sed -n '1,20p' reports/summary.md 2>/dev/null | sed 's/^/    /'
  else
    S4=FAIL
    echo "  FAIL —— 尾部日志："
    tail -15 runs/stage4_report.log
  fi
fi

stage "总表"
cat <<EOF
  阶段1 pass 编入主程序 : $S1
  阶段2 EQY 正误最小例  : $S2
  阶段3 5 个基础用例 B0 : $S3
  阶段4 汇总报告        : $S4
EOF
echo
echo "产物："
ls -1 runs/*.log runs/*.md 2>/dev/null | head -20
echo "报告：reports/summary.md"
