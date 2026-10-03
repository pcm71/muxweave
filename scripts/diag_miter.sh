#!/usr/bin/env bash
# diag_miter.sh —— 定位 miter 检查为何漏检负对照
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/netlist_official
mkdir -p formal/miter/logs
TOP=test4

echo "=== 1) 负对照 RTL 是否真的不同 ==="
diff <(tr -d ' \t' < benchmarks/official/${TOP}.v) <(tr -d ' \t' < $D/${TOP}_mutated.v) | head -6
echo "  （上面应显示恰好一行差异）"

echo
echo "=== 2) 三份网表是否互不相同 ==="
for f in ${TOP}_ctrl_abc9 ${TOP}_target ${TOP}_neg; do
  printf '  %-22s 行数=%-5s sha=%s\n' "$f" "$(wc -l < $D/$f.v)" "$(sha256sum $D/$f.v | cut -c1-16)"
done

echo
echo "=== 3) 在 RTL 层（未综合）做 miter：原始 vs 负对照，必须报反例 ==="
yosys -q -p "
read_verilog benchmarks/official/${TOP}.v
hierarchy -top $TOP
design -stash g
design -reset
read_verilog $D/${TOP}_mutated.v
hierarchy -top $TOP
design -stash e
design -copy-from g -as gold $TOP
design -copy-from e -as gate $TOP
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > formal/miter/logs/diag_rtl.log 2>&1
echo "  rc=$? （非 0 表示检出差异，符合预期）"
grep -oE "SAT proof finished - [a-z ]+|ERROR.*" formal/miter/logs/diag_rtl.log | head -3 | sed 's/^/    /'

echo
echo "=== 4) 在网表层做同样的 miter（官方 vs 负对照网表）==="
yosys -q -p "
read_verilog $D/${TOP}_ctrl_abc9.v
hierarchy -top $TOP
design -stash g
design -reset
read_verilog $D/${TOP}_neg.v
hierarchy -top $TOP
design -stash e
design -copy-from g -as gold $TOP
design -copy-from e -as gate $TOP
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > formal/miter/logs/diag_net.log 2>&1
echo "  rc=$? （应非 0；若为 0 说明网表层 miter 漏检）"
grep -oE "SAT proof finished - [a-z ]+|ERROR.*" formal/miter/logs/diag_net.log | head -3 | sed 's/^/    /'

echo
echo "=== 5) miter 里的 FF 是否被合并（看 FF 数量）==="
yosys -q -p "
read_verilog $D/${TOP}_ctrl_abc9.v
hierarchy -top $TOP
design -stash g
design -reset
read_verilog $D/${TOP}_neg.v
hierarchy -top $TOP
design -stash e
design -copy-from g -as gold $TOP
design -copy-from e -as gate $TOP
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
stat
" 2>&1 | grep -E "Number of cells|\\\$dff|\\\$dffe|\\\$mux|\\\$eq" | head -8 | sed 's/^/  /'
