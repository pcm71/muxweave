#!/usr/bin/env bash
# diag_determinism.sh —— 判断 abc9 的命名是否本身就不确定
#   A) 同一个二进制跑两次，比较产物哈希
#   B) 若同一二进制两次也不同 ⇒ 差异来自 abc9 自身，不是我们的 pass
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
D="$P/runs/final_verify/determinism"
mkdir -p "$D"
cd "$P" || exit 1

gen() { # $1=二进制 $2=输出
  "$1" -q -p "
read_verilog benchmarks/official/test1.v
hierarchy -top test1
synth_intel -family cycloneiv -top test1
write_verilog -noattr $2
" > "${2%.v}.log" 2>&1
}

echo "=== A) 同一个二进制（基线）跑两次 ==="
gen "$HOME/.local/bin/yosys-baseline" "$D/base_run1.v"
gen "$HOME/.local/bin/yosys-baseline" "$D/base_run2.v"
h1=$(sha256sum "$D/base_run1.v" | cut -c1-16)
h2=$(sha256sum "$D/base_run2.v" | cut -c1-16)
echo "  run1=$h1"
echo "  run2=$h2"
[ "$h1" = "$h2" ] && echo "  ⇒ 同二进制两次**完全相同**（确定性）" || echo "  ⇒ 同二进制两次**不同**（abc9 本身非确定）"

echo
echo "=== B) 同一二进制两次的差异行数 ==="
echo "  $(diff "$D/base_run1.v" "$D/base_run2.v" | grep -c '^[<>]' || true) 行"

echo
echo "=== C) 优化版 vs 基线（各自 run1）差异行数 ==="
gen "$HOME/.local/bin/yosys-pmux" "$D/pmux_run1.v"
echo "  $(diff "$D/base_run1.v" "$D/pmux_run1.v" | grep -c '^[<>]' || true) 行"

echo
echo "=== 结论 ==="
if [ "$h1" != "$h2" ]; then
  echo "  abc9 自身命名不确定 ⇒ 产物哈希**不能**用来判定等价性（必须用 SAT/归纳）"
else
  echo "  同二进制确定 ⇒ 优化版与基线的差异需进一步定位"
fi
