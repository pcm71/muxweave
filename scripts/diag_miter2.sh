#!/usr/bin/env bash
# diag_miter2.sh —— 进一步定位：变体文件是否真改了？miter 建成了什么？
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/netlist_official
mkdir -p formal/miter/logs

echo "=== 1) 原始 vs 变体 的第 48 行（去掉行尾 CR 后比较）==="
echo "--- 原始 ---"; sed -n '48p' benchmarks/official/test4.v | tr -d '\r'
echo "--- 变体 ---"; sed -n '48p' $D/test4_mutated.v | tr -d '\r'

echo
echo "=== 2) 去掉行尾 CR 后再 diff（应只有 1 行差异）==="
diff <(tr -d '\r' < benchmarks/official/test4.v) <(tr -d '\r' < $D/test4_mutated.v)

echo
echo "=== 3) RTL 层 miter 的完整输出（不静默，看 miter 报了什么）==="
yosys -p "
read_verilog benchmarks/official/test4.v
hierarchy -top test4
design -stash g
design -reset
read_verilog $D/test4_mutated.v
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
stat
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" 2>&1 | grep -E "miter|Warning|Number of cells|\\\$assert|\\\$dff|\\\$dffe|\\\$eq|SAT|proof|Executing SAT|Import" | head -30 | sed 's/^/  /'
