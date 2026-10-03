#!/usr/bin/env bash
# check_script_syntax.sh —— 对改过的 shell/python 脚本做语法检查
set -uo pipefail
cd /mnt/c/Users/LEGION/Desktop/PMUX/muxweave || exit 1
echo "=== Shell 语法检查（bash -n）==="
for f in scripts/wsl_abc9_search.sh scripts/wsl_candidate_envelope.sh \
         scripts/wsl_integrate_pass.sh scripts/wsl_large_eval.sh \
         scripts/wsl_official_eval.sh scripts/fix_residual_wording.py; do
  case "$f" in
    *.sh) bash -n "$f" && echo "  OK   $f" || echo "  FAIL $f" ;;
    *.py) python3 -m py_compile "$f" && echo "  OK   $f" || echo "  FAIL $f" ;;
  esac
done
echo
echo "=== 抽查改后文案是否已生效 ==="
grep -h "赛题技术指标" scripts/wsl_abc9_search.sh scripts/wsl_large_eval.sh scripts/wsl_official_eval.sh 2>/dev/null | head -4 | sed 's/^/  /'
echo
echo "=== 抽查 plugin 注释 ==="
sed -n '1,12p' plugin/pmux_opt.cc | sed 's/^/  /'
