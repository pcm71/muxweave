#!/usr/bin/env bash
# wsl_variant_equiv.sh —— 逐个脚本变体做"有效检查器"下的等价性验证（以官方 abc9 为基准）
#
# 背景：已验证 test4 上 pmux_opt（主脚本 c_min_mfs2_lutpack）与官方 abc9 网表**不等价**，
#       且反例显示 dataout 被改坏（step1 datain=27 时 gold=43、gate=0）。
# 目的：定位是哪个脚本步骤破坏了功能（重点怀疑 mfs2 —— 它是 don't-care 驱动优化，
#       若 don't-care 建模不当会改变功能）。
#
# 检查器：miter 后**显式 flatten** + sat（该方法已用"改一位常数"的负对照验证有效）
#
#   bash scripts/wsl_variant_equiv.sh [用例名，默认 test4]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
TOP="${1:-test4}"
D=runs/variant_equiv
L=formal/miter/logs
mkdir -p "$D" "$L"

# 待测脚本（覆盖最终配置用到的与备选的）
SCRIPTS="configs/abc_scripts/c_min.abc \
configs/abc_scripts/c_min_lutpack.abc \
configs/abc_scripts/c_min_mfs2_lutpack.abc \
configs/abc_scripts/c_full.abc \
configs/abc_scripts/c_no_mfs2.abc \
configs/abc_scripts/if_area.abc \
configs/abc_scripts/baseline_lut4.abc"

gen() { # $1=映射命令 $2=输出
  yosys -q -p "
read_verilog benchmarks/official/${TOP}.v
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
$1
clean
opt -fast
write_verilog -noattr $2
" > "${2%.v}.genlog" 2>&1
}

# 基准：官方 abc9
BASE=$D/${TOP}_base.v
gen "abc9 -lut 4 -W 300" "$BASE" || { echo "基准生成失败"; exit 1; }
echo "基准（官方 abc9）已生成：$BASE"
echo
printf '%-26s %-10s %s\n' "脚本" "等价性" "说明"
echo "------------------------------------------------------------------"

for s in $SCRIPTS; do
  tag=$(basename "$s" .abc)
  net=$D/${TOP}_${tag}.v
  gen "abc -lut 4 -script $s" "$net" || { printf '%-26s %-10s\n' "$tag" "生成失败"; continue; }

  log="$L/vareq_${TOP}_${tag}.log"
  yosys -q -p "
read_verilog $BASE
hierarchy -top $TOP
design -stash g
design -reset
read_verilog $net
hierarchy -top $TOP
design -stash e
design -copy-from g -as gold $TOP
design -copy-from e -as gate $TOP
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > "$log" 2>&1
  rc=$?
  if [ $rc -eq 0 ]; then verdict="✅ 等价"; note=""
  else verdict="❌ 不等价"; note=$(grep -c "model found: FAIL" "$log" >/dev/null 2>&1 && echo "sat 找到反例" || echo "见日志"); fi
  printf '%-26s %-10s %s\n' "$tag" "$verdict" "$note"
done

echo
echo "=== 说明 ==="
echo "  ✅ 等价 = 与官方 abc9 网表在 -seq 5 有界范围内无差异"
echo "  ❌ 不等价 = 该脚本改变了电路功能，绝不能用于成绩数据"
