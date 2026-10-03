#!/usr/bin/env bash
# diag_miter3.sh —— 用"已知错误配对"筛选出真正有效的等价性检查方法
#
# 纪律：检查器必须先在**已知不等价**的配对上判出"不等价"，才有资格用于判定"等价"。
# 已知错误配对 = 原始 test4 RTL  vs  改了一位常数的 test4 RTL（已确认第 48 行确有差异）。
# 对三种方法分别测试；能检出差异的才可用。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/netlist_official
L=formal/miter/logs
mkdir -p "$L"
A=benchmarks/official/test4.v
B=$D/test4_mutated.v

echo "待检出的已知差异：第 48 行 6'b100111 -> 6'b100110（datain==0 时 dataout 不同）"
echo

echo "########## 方法 A：miter -equiv -flatten + sat -seq 5 ##########"
yosys -q -p "
read_verilog $A
hierarchy -top test4
design -stash g
design -reset
read_verilog $B
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > "$L/A.log" 2>&1
echo "  rc=$?  $([ $? -ne 0 ] && echo '✓ 检出差异' || echo '✗ 漏检')"
grep -oE "SAT proof finished - [a-z ]+|ERROR.*" "$L/A.log" | head -2 | sed 's/^/    /'

echo
echo "########## 方法 B：miter -equiv 后显式 flatten，再 sat -seq 5 ##########"
yosys -q -p "
read_verilog $A
hierarchy -top test4
design -stash g
design -reset
read_verilog $B
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > "$L/B.log" 2>&1
rc=$?
echo "  rc=$rc  $([ $rc -ne 0 ] && echo '✓ 检出差异' || echo '✗ 漏检')"
grep -oE "SAT proof finished - [a-z ]+|ERROR.*|Imported [0-9]+ cells" "$L/B.log" | head -3 | sed 's/^/    /'

echo
echo "########## 方法 C：equiv_make + equiv_simple + equiv_status（equiv_opt 内部流程）##########"
yosys -q -p "
read_verilog $A
hierarchy -top test4
proc
design -stash g
design -reset
read_verilog $B
hierarchy -top test4
proc
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
equiv_make gold gate equiv
hierarchy -top equiv
equiv_simple
equiv_status -assert
" > "$L/C.log" 2>&1
rc=$?
echo "  rc=$rc  $([ $rc -ne 0 ] && echo '✓ 检出差异' || echo '✗ 漏检')"
grep -oE "Found [0-9]+ unproven|Equivalence successfully proven|ERROR.*" "$L/C.log" | head -2 | sed 's/^/    /'
