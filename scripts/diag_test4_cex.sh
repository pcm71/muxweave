#!/usr/bin/env bash
# diag_test4_cex.sh —— 取 test4「官方 vs 自研」的反例，判断差异是真实的还是 don't-care 伪影
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/netlist_official
L=formal/miter/logs
mkdir -p "$L"

echo "=== 逐周期定位：差异最早在第几个周期出现 ==="
for n in 1 2 3; do
  yosys -q -p "
read_verilog $D/test4_ctrl_abc9.v
hierarchy -top test4
design -stash g
design -reset
read_verilog $D/test4_target.v
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq $n -set-init-zero miter
" > "$L/cex_seq$n.log" 2>&1
  rc=$?
  printf '  -seq %s : rc=%s %s\n' "$n" "$rc" "$([ $rc -ne 0 ] && echo '检出反例' || echo '通过')"
done

echo
echo "=== 取 -seq 3 的反例模型（输入/输出取值）==="
yosys -q -p "
read_verilog $D/test4_ctrl_abc9.v
hierarchy -top test4
design -stash g
design -reset
read_verilog $D/test4_target.v
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -prove-asserts -seq 3 -set-init-zero -show-inputs -show-outputs miter
" > "$L/cex_model.log" 2>&1
echo "  rc=$?"
echo "--- 模型片段（只看输入与 assert 相关）---"
grep -nE "assert|=== |model|Input|Output|\\\\test4" "$L/cex_model.log" | head -25 | sed 's/^/  /'

echo
echo "=== 关键问题：两份网表在「datain 全 32 种取值」下的 dataout 是否相同 ==="
echo "  （若相同，差异来自 don't-care；若不同，是真功能差异）"
for f in test4_ctrl_abc9 test4_target; do
  yosys -q -p "
read_verilog $D/$f.v
hierarchy -top test4
proc
memory
opt -full
write_verilog -noattr $L/$f.eval.v
" > /dev/null 2>&1
  printf '  %-22s 已导出（行数 %s）\n' "$f" "$(wc -l < $L/$f.eval.v 2>/dev/null)"
done
