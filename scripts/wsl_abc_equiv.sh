#!/usr/bin/env bash
# wsl_abc_equiv.sh —— 换 ABC 映射器后的等价性验证（合规必须项）
#
# 做法：在 EQY 的 [gold]/[gate] 里各自跑完整综合流程，只把 abc 那一步换成不同实现，
#       停止在 LUT 阶段（map_luts 之后、map_cells 之前），然后由 EQY 证明两者等价。
#
# 为什么停在 LUT 阶段：
#   ① LUT 阶段的单元是标准内部单元，EQY/SAT 原生支持；map_cells 之后是 cycloneiv_lcell_comb，
#      需要额外加载器件库模型才能证明。
#   ② map_cells 之后的流程两侧完全相同（同样命令、同样顺序），语义保持 ⇒ LUT 阶段等价即可推出最终等价。
#
# 纪律：题目要求"所有测试用例优化前后网表通过形式等价检查"，换映射器属于流程变更，
#       虽不改变语义，仍必须逐用例给出 PASS 证据。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
EQDIR="formal/abc_equiv"
LOGDIR="$EQDIR/logs"
mkdir -p "$EQDIR" "$LOGDIR"

CASES="benchmarks/unit/u01_mux2_wide.v benchmarks/unit/u02_pmux4_shared_fields.v \
benchmarks/unit/u03_pmux4_const_and_default.v benchmarks/unit/u04_pmux8_narrow_onehot.v \
benchmarks/unit/u05_negative_no_mux.v benchmarks/mixed/m01_decode_mask_pmux.v \
benchmarks/mixed/m02_regfile_readback.v benchmarks/mixed/m03_registered_pmux.v"

pass=0; fail=0
for v in $CASES; do
  top=$(basename "$v" .v)
  cfg="$EQDIR/equiv_${top}.eqy"
  log="$LOGDIR/equiv_${top}.log"

  cat > "$cfg" <<EOF
# 自动生成：验证"换 ABC 映射器"前后等价（gold=官方 abc9，gate=经典 abc）
# 只改 abc 那一步，其余流程两侧完全一致；停在 LUT 阶段（见脚本注释）。
[options]
splitnets off

[gold]
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run begin:map_luts
abc9 -lut 4 -W 300
clean
opt -fast
autoname
clean
prep -top $top

[gate]
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run begin:map_luts
abc -lut 4
clean
opt -fast
autoname
clean
prep -top $top

[strategy simple]
use sat
depth 5
EOF

  rm -rf "./equiv_${top}"
  eqy "$cfg" > "$log" 2>&1
  rc=$?
  if [ $rc -eq 0 ]; then
    pass=$((pass+1)); verdict="PASS"
  else
    fail=$((fail+1)); verdict="FAIL"
  fi
  printf '  %-30s rc=%-3s %s\n' "$top" "$rc" "$verdict"
  grep -E "DONE \(|Successfully proved|Failed to prove|ERROR" "$log" | tail -2 | sed 's/^/      /'
  rm -rf "./equiv_${top}"
done

echo
echo "=== 等价性汇总：PASS $pass / FAIL $fail ==="
if [ "$fail" -eq 0 ]; then
  cat <<'EOF'
结论：把官方 `abc9 -lut 4 -W 300` 换成 `abc -lut 4` 后，全部用例在 LUT 阶段与官方流程等价。

说明：LUT 阶段之后的流程（map_cells → check）两侧命令完全相同，
      语义保持 ⇒ 最终 cycloneiv 网表同样等价。
EOF
else
  echo "存在未通过用例 —— 必须先定位，不能把该映射变体用于成绩数据。"
fi
