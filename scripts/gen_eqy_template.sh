#!/usr/bin/env bash
# gen_eqy_template.sh —— 用 EQY 自带功能生成标准配置模板，看它推荐哪些策略
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p formal/eqy_official
T=formal/eqy_official/template.eqy
rm -f "$T"
eqy --init-config-file "$T" test4 benchmarks/official/test4.v runs/netlist_official/test4_target.v 2>&1 | tail -3
echo
echo "=== 模板内容 ==="
cat "$T" 2>/dev/null || echo "(未生成)"
