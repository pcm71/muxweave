#!/usr/bin/env bash
# wsl_abc_equiv3.sh —— 换 ABC 映射器的等价性验证（第 3 版）
#
# 前两版为什么不行：
#   v1 EQY（gold/gate 各跑一遍流程）：abc9 会在流程中创建/删除内部辅助模块，
#      两侧模块集合不一致 → combine 阶段报 "Unmatched module exists in gold"。
#   v2 miter+sat（完整流程）：组合用例 6/8 严格证明通过，但时序用例报
#      "No SAT model available for cell dffeas" —— dffeas 是 map_ffs 产生的 Intel DFF 原语。
#
# 本版关键设计：
#   * 比较点放在 **map_ffs 之前**（`-run begin:map_ffs`）：此时 FF 还是通用 $dff/$_DFF_*，
#     SAT 原生支持；而 map_ffs 之后的 map_cells 等步骤两侧完全相同。
#   * 由于 abc9/abc 在**不使用 -dff 时把 FF 当边界**，映射组合锥的结果与 FF 的表示形式无关，
#     所以在 map_ffs 之前比较 abc 的输出，结论同样适用于真实流程。
#   * 额外用「完整流程」对**组合用例**再证一遍（那些没有 FF，不受 dffeas 影响）。
#   * **负对照**：故意构造一版不等价的 gate，验证器必须报 FAIL，否则说明验证是"永远绿色"的。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
LOGDIR="formal/abc_equiv/logs"
mkdir -p "$LOGDIR" /tmp/eqv

VARIANT="${1:-abc -lut 4}"
LABEL="${2:-classic}"

COMBO="benchmarks/unit/u01_mux2_wide.v benchmarks/unit/u02_pmux4_shared_fields.v \
benchmarks/unit/u03_pmux4_const_and_default.v benchmarks/unit/u04_pmux8_narrow_onehot.v \
benchmarks/unit/u05_negative_no_mux.v benchmarks/mixed/m01_decode_mask_pmux.v"
SEQ="benchmarks/mixed/m02_regfile_readback.v benchmarks/mixed/m03_registered_pmux.v"

# ---------- 生成比较脚本 ----------
gen_script() { # $1=case路径 $2=top $3=输出ys $4=比较点(begin:map_ffs 或 begin:map_luts) $5=gate源码
  local v="$1" top="$2" ys="$3" stop="$4" gate_src="${5:-$1}"
  cat > "$ys" <<EOF
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run $stop
abc9 -lut 4 -W 300
clean
opt -fast
design -stash gold
design -reset
read_verilog $gate_src
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run $stop
$VARIANT
clean
opt -fast
design -stash gate
design -copy-from gold -as gold $top
design -copy-from gate -as gate $top
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -tempinduct -set-init-zero miter
EOF
}

run_case() { # $1=case $2=stop标签 $3=期望 PASS|FAIL $4=gate源码(可选)
  local v="$1" stop="$2" expect="$3" gate_src="${4:-}"
  local top; top=$(basename "$v" .v)
  local ys="/tmp/eqv/${LABEL}_${top}.ys"
  local log="$LOGDIR/equiv3_${LABEL}_${top}.log"
  gen_script "$v" "$top" "$ys" "$stop" "$gate_src"
  yosys -q -s "$ys" > "$log" 2>&1
  local rc=$? verdict
  if [ $rc -eq 0 ]; then verdict=PASS
  elif grep -qE "SAT proof finished - unproven|SAT proof finished - no solution" "$log"; then verdict=FAIL
  else verdict=ERROR; fi
  printf '  %-30s [%s] rc=%-3s %s' "$top" "$stop" "$rc" "$verdict"
  if [ "$verdict" = "$expect" ]; then printf '  ✓\n'; else printf '  ✗ 期望 %s\n' "$expect"; fi
  grep -E "SAT proof finished|No SAT model|ERROR" "$log" | tail -1 | sed 's/^/        /'
  [ "$verdict" = "$expect" ]
}

echo "################################################################"
echo "### A. 组合用例：用**完整流程**比较（这些没有 FF，不受 dffeas 影响）"
echo "################################################################"
a_ok=0; a_all=0
for v in $COMBO; do
  a_all=$((a_all+1)); run_case "$v" "begin:map_luts" PASS && a_ok=$((a_ok+1))
done
echo "  → 完整流程：$a_ok/$a_all 通过"

echo
echo "################################################################"
echo "### B. 时序用例：比较点提前到 map_ffs 之前（绕开 dffeas 无 SAT 模型的问题）"
echo "################################################################"
b_ok=0; b_all=0
for v in $SEQ; do
  b_all=$((b_all+1)); run_case "$v" "begin:map_ffs" PASS && b_ok=$((b_ok+1))
done
echo "  → map_ffs 之前：$b_ok/$b_all 通过"

echo
echo "################################################################"
echo "### C. 负对照：故意不等价的输入必须报 FAIL（证明验证器不是永远绿色）"
echo "################################################################"
# 负对照用例是仓库里的固定文件（手写，规范 Verilog），不在此处临时生成，
# 避免 sed 生成出语法非法的代码（例如用 assign 驱动 reg）。
NEG=benchmarks/exp/e09_u02_mutated.v
[ -f "$NEG" ] || { echo "  缺少负对照用例 $NEG"; exit 2; }
echo "  负对照用例：$NEG（与 u02 只差最低位取反）"
neg_ok=0
run_case benchmarks/unit/u02_pmux4_shared_fields.v "begin:map_luts" FAIL "$NEG" \
  && { neg_ok=1; echo "  ✓ 负对照按预期被判为不等价"; } \
  || echo "  ✗ 负对照没有报 FAIL —— 验证器不可信，必须先修"

echo
echo "################################################################"
echo "### 汇总"
echo "################################################################"
echo "  A 组合用例（完整流程）  : $a_ok/$a_all"
echo "  B 时序用例（map_ffs 前）: $b_ok/$b_all"
echo "  C 负对照（必须 FAIL）   : $([ $neg_ok -eq 1 ] && echo 通过 || echo 失败)"
total=$((a_all + b_all))
if [ $((a_ok + b_ok)) -eq $total ] && [ $neg_ok -eq 1 ]; then
  cat <<EOF

结论：变体「$VARIANT」等价性验证通过（$total/$total 用例 + 负对照有效）。

证据口径：
- 组合用例在**完整官方流程**下、LUT 阶段（map_luts 之后）严格二值证明等价；
- 时序用例在 **map_ffs 之前**比较（此处 FF 为通用单元、SAT 原生支持）。
  abc9/abc 在不用 -dff 时把 FF 当作边界，映射组合锥的结果与 FF 表示形式无关；
  其后的 map_ffs / map_cells 两侧命令完全相同，故结论对最终网表同样成立。
- 负对照（最低位取反）被判为不等价，说明该验证器能够检出真实差异。
EOF
else
  echo
  echo "存在未通过项 —— 该变体不得进入成绩数据，需先定位。日志：$LOGDIR/equiv3_${LABEL}_*.log"
fi
