#!/usr/bin/env bash
# wsl_verify_integration.sh —— 集成后的两项验证
#   A) 确认 -analyze-only 真的识别到 PMUX 结构（非静默运行看日志）
#   B) 用 equiv_opt 传递性证明"集成 pmux_opt 后的网表 ≡ 官方 abc9 的网表"
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs/integrated

echo "################################################################"
echo "### A) PMUX 识别与映射决策（非静默）"
echo "################################################################"
for name in test1 test2; do
  echo "--- $name ---"
  yosys -p "
read_verilog benchmarks/official/$name.v
hierarchy -top $name
synth_intel -family cycloneiv -top $name
" 2>&1 | grep -E "pmux_opt|Executing ABC" | head -10 | sed 's/^/  /'
  echo
done

echo "################################################################"
echo "### B) 等价性：pmux_opt 与官方 abc9 都保持等价（传递性）"
echo "################################################################"
export CASES_OVERRIDE="benchmarks/official/test1.v benchmarks/official/test2.v benchmarks/official/test3.v benchmarks/official/test4.v"
bash scripts/wsl_abc_equiv4.sh "pmux_opt" pmuxopt
