#!/usr/bin/env bash
# diag_selfcheck.sh —— 决定性对照：同一份网表 vs 它自己，必须 PASS
#
# 若"自己 vs 自己"都 FAIL，说明该检查器对"综合后网表对"根本不成立，
# 之前所有 ❌ 结论都作废（是检查器的问题，不是优化的问题）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/variant_equiv
L=formal/miter/logs
mkdir -p "$L"

yp() { # $1=gold $2=gate $3=标签
  yosys -q -p "
read_verilog $1
hierarchy -top test4
design -stash g
design -reset
read_verilog $2
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > "$L/self_$3.log" 2>&1
  local rc=$?
  printf '  %-34s rc=%s  %s\n' "$3" "$rc" "$([ $rc -eq 0 ] && echo 'PASS ✓' || echo 'FAIL ✗')"
}

echo "=== 对照 1：同一文件 vs 自己（必须 PASS）==="
yp "$D/test4_base.v" "$D/test4_base.v" "base_vs_base"

echo
echo "=== 对照 2：同命令生成的两份网表（内容应完全相同）==="
yosys -q -p "
read_verilog benchmarks/official/test4.v
hierarchy -top test4
synth_intel -family cycloneiv -top test4 -run begin:map_ffs
abc9 -lut 4 -W 300
clean
opt -fast
write_verilog -noattr $D/test4_base2.v
" > /dev/null 2>&1
yp "$D/test4_base.v" "$D/test4_base2.v" "base_vs_base2"

echo
echo "=== 对照 3：两份网表内容是否逐字节相同 ==="
if diff -q "$D/test4_base.v" "$D/test4_base2.v" > /dev/null 2>&1; then
  echo "  完全相同 ✓（此时若对照 2 仍 FAIL，则确定是检查器问题）"
else
  echo "  存在差异（说明同命令多次生成的结果不稳定）："
  diff "$D/test4_base.v" "$D/test4_base2.v" | head -10 | sed 's/^/    /'
fi

echo
echo "=== 对照 4：官方 abc9 网表 vs 经典 abc 官方默认脚本网表（baseline_lut4）==="
yp "$D/test4_base.v" "$D/test4_baseline_lut4.v" "abc9_vs_classic_default"

echo
echo "=== 对照 5：把两份网表的 dataout 触发器写法并列出来 ==="
echo "--- base（abc9）---"
grep -n -A3 "always @(posedge clk" "$D/test4_base.v" | head -16 | sed 's/^/  /'
echo "--- classic baseline_lut4 ---"
grep -n -A3 "always @(posedge clk" "$D/test4_baseline_lut4.v" | head -16 | sed 's/^/  /'
