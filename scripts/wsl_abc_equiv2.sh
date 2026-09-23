#!/usr/bin/env bash
# wsl_abc_equiv2.sh —— 换 ABC 映射器的等价性验证（第 2 版：改用 Yosys 内建 miter+sat）
#
# 第 1 版用 EQY，两段流程写在 [gold]/[gate] 里，报：
#   "Unmatched module exists in gold that does not exist in gate"
# 原因是 abc9 在流程中会创建/删除内部辅助模块，两侧模块集合不一致（EQY combine 阶段报错，
# 不是证明失败）。EQY 更适合"两个独立源文件"的比较。
#
# 本版改用 Yosys 内建流程：同一个进程里跑两遍（官方 abc9 / 变体 abc），
# 分别 design -stash，再 miter -equiv + sat 证明等价。全部用内部单元，不经过 Verilog 往返。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
OUTDIR="formal/abc_equiv"
LOGDIR="$OUTDIR/logs"
mkdir -p "$OUTDIR" "$LOGDIR"

# 变体由参数决定，默认 classic
VARIANT="${1:-abc -lut 4}"
LABEL="${2:-classic}"

CASES="benchmarks/unit/u01_mux2_wide.v benchmarks/unit/u02_pmux4_shared_fields.v \
benchmarks/unit/u03_pmux4_const_and_default.v benchmarks/unit/u04_pmux8_narrow_onehot.v \
benchmarks/unit/u05_negative_no_mux.v benchmarks/mixed/m01_decode_mask_pmux.v \
benchmarks/mixed/m02_regfile_readback.v benchmarks/mixed/m03_registered_pmux.v"

pass=0; fail=0; unk=0
for v in $CASES; do
  top=$(basename "$v" .v)
  log="$LOGDIR/equiv2_${LABEL}_${top}.log"

  yosys -q -p "
    read_verilog $v; hierarchy -top $top;
    synth_intel -family cycloneiv -top $top -run begin:map_luts;
    abc9 -lut 4 -W 300; clean; opt -fast; autoname; clean;
    design -stash gold;
    design -reset;
    read_verilog $v; hierarchy -top $top;
    synth_intel -family cycloneiv -top $top -run begin:map_luts;
    $VARIANT; clean; opt -fast; autoname; clean;
    design -stash gate;
    design -copy-from gold -as gold $top;
    design -copy-from gate -as gate $top;
    equiv_make gold gate equiv;
    hierarchy -top equiv;
    equiv_simple -undef;
    equiv_status -assert
  " > "$log" 2>&1
  rc=$?

  if [ $rc -eq 0 ]; then
    pass=$((pass+1)); verdict="PASS"
  elif grep -qE "No more equivalence" "$log"; then
    fail=$((fail+1)); verdict="FAIL(有反例)"
  else
    unk=$((unk+1)); verdict="ERROR/UNKNOWN"
  fi
  printf '  %-30s rc=%-3s %s\n' "$top" "$rc" "$verdict"
  grep -E "Equivalence successfully proven|No more equivalence|ERROR|Unproven" "$log" | tail -2 | sed 's/^/      /'
done

echo
echo "=== 变体 [$LABEL] 等价性汇总：PASS $pass / FAIL $fail / UNKNOWN或错误 $unk ==="
if [ "$fail" -eq 0 ] && [ "$unk" -eq 0 ]; then
  cat <<EOF
结论：变体「$VARIANT」在全部 8 个用例上与官方流程等价（miter+sat 证明通过）。

说明：比较发生在 LUT 阶段（map_luts 之后）。其后的 map_cells → check 两侧命令完全相同，
      语义保持 ⇒ 最终 cycloneiv 网表同样等价。
EOF
else
  echo "存在未通过/未证明的用例 —— 该变体不得用于成绩数据，需先定位。"
  echo "排查：先看 $LOGDIR 里对应日志是反例、超时还是脚本错误。"
fi
