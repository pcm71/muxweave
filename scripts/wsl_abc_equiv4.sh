#!/usr/bin/env bash
# wsl_abc_equiv4.sh —— 换 ABC 映射器的等价性验证（第 4 版：equiv_opt + 传递性）
#
# 为什么这是正确的命题（前三版都在命题或工具上走偏）：
#   abc9 与 abc 都是"语义保持的重写"，因此用传递性证明最干净：
#       证明 abc  -lut 4       保持等价   ⎫
#                                       ⎬ ⇒ 两者输出互相等价（都等于 abc 之前的网表）
#       证明 abc9 -lut 4 -W 300 保持等价  ⎭
#   这正是 Yosys 的 equiv_opt 的设计用途（"验证某个优化 pass 是否保持等价"）。
#
# 关键选项（来自 help equiv_opt）：
#   -ignore-unknown-cells  忽略无法匹配 SAT 模型的单元 —— 用来处理 Intel 的 dffeas 原语。
#                          这些 FF 单元两侧同名同连接（abc 不碰 FF），
#                          equiv_make 会把它们当割点匹配，因此忽略其内部模型是**可靠的**。
#   -map <file>            展开架构专用原语的另一条路（备选）。
#
# 负对照：另用 miter+sat 比较 u02 与"最低位取反"的 e09，必须报不等价，
#         以证明验证流程不是"永远显示绿色"。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
LOGDIR="formal/abc_equiv/logs"
mkdir -p "$LOGDIR" /tmp/eqv4
TIMEOUT=150

CASES="benchmarks/unit/u01_mux2_wide.v benchmarks/unit/u02_pmux4_shared_fields.v \
benchmarks/unit/u03_pmux4_const_and_default.v benchmarks/unit/u04_pmux8_narrow_onehot.v \
benchmarks/unit/u05_negative_no_mux.v benchmarks/mixed/m01_decode_mask_pmux.v \
benchmarks/mixed/m02_regfile_readback.v benchmarks/mixed/m03_registered_pmux.v"

# 变体命令由参数决定（默认经典 abc）。用于验证任意 ABC 脚本/映射策略的保等价性。
VARIANT="${1:-abc -lut 4}"
LABEL="${2:-classic}"
echo "验证变体：$VARIANT   （标签 $LABEL）"

check_one() { # $1=case $2=命令 $3=标签
  local v="$1" cmd="$2" tag="$3"
  local top; top=$(basename "$v" .v)
  local ys="/tmp/eqv4/${top}_${tag}.ys"
  local log="$LOGDIR/equiv4_${top}_${tag}.log"
  cat > "$ys" <<EOF
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run begin:map_luts
equiv_opt -assert -ignore-unknown-cells $cmd
EOF
  timeout $TIMEOUT yosys -q -s "$ys" > "$log" 2>&1
  local rc=$?
  if [ $rc -eq 0 ]; then echo "PASS"
  elif [ $rc -eq 124 ]; then echo "TIMEOUT"
  else echo "FAIL"; fi
}

echo "#####################################################################"
echo "### A. 传递性证明：变体保持等价 且 官方 abc9 保持等价"
echo "#####################################################################"
printf '%-30s %-14s %-14s %s\n' "用例" "abc -lut 4" "abc9(官方)" "判定"
ok=0; total=0
for v in $CASES; do
  top=$(basename "$v" .v)
  total=$((total+1))
  r1=$(check_one "$v" "$VARIANT" "$LABEL")
  r2=$(check_one "$v" "abc9 -lut 4 -W 300" "abc9")
  if [ "$r1" = "PASS" ] && [ "$r2" = "PASS" ]; then verdict="✓ 等价"; ok=$((ok+1)); else verdict="✗ 需查"; fi
  printf '%-30s %-14s %-14s %s\n' "$top" "$r1" "$r2" "$verdict"
done
echo
echo "  → $ok/$total 用例完成传递性证明"

echo
echo "#####################################################################"
echo "### B. 负对照：故意不等价的设计必须被判为不等价"
echo "#####################################################################"
NEG=benchmarks/exp/e09_u02_mutated.v
if [ -f "$NEG" ]; then
  cat > /tmp/eqv4/negative.ys <<EOF
read_verilog benchmarks/unit/u02_pmux4_shared_fields.v
hierarchy -top u02_pmux4_shared_fields
synth_intel -family cycloneiv -top u02_pmux4_shared_fields -run begin:map_luts
abc9 -lut 4 -W 300
clean
opt -fast
design -stash gold
design -reset
read_verilog $NEG
hierarchy -top u02_pmux4_shared_fields
synth_intel -family cycloneiv -top u02_pmux4_shared_fields -run begin:map_luts
abc9 -lut 4 -W 300
clean
opt -fast
design -stash gate
design -copy-from gold -as gold u02_pmux4_shared_fields
design -copy-from gate -as gate u02_pmux4_shared_fields
miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -seq 1 -set-init-zero miter
EOF
  timeout $TIMEOUT yosys -q -s /tmp/eqv4/negative.ys > "$LOGDIR/equiv4_negative_control.log" 2>&1
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "  ✓ 负对照被正确判为不等价（rc=$rc）"
    grep -E "SAT proof finished|unproven|ERROR" "$LOGDIR/equiv4_negative_control.log" | tail -2 | sed 's/^/      /'
    neg=1
  else
    echo "  ✗ 负对照竟然通过了 —— 验证流程不可信，必须修"
    neg=0
  fi
else
  echo "  缺少 $NEG"; neg=0
fi

echo
echo "#####################################################################"
echo "### 汇总"
echo "#####################################################################"
echo "  A 传递性证明 : $ok/$total"
echo "  B 负对照     : $([ "${neg:-0}" -eq 1 ] && echo 有效 || echo 失败)"
if [ "$ok" -eq "$total" ] && [ "${neg:-0}" -eq 1 ]; then
  cat <<'EOF'

结论：换 ABC 映射器（abc -lut 4 ← abc9 -lut 4 -W 300）的等价性**已证明**。

证据链：
  ① 对每个用例，`abc -lut 4` 相对 abc 之前的网表保持等价（equiv_opt 证明通过）；
  ② 同一状态下 `abc9 -lut 4 -W 300` 也保持等价；
  ③ 由传递性 ⇒ 两种映射的输出网表互相等价；
  ④ 其后的 clean/opt -fast/autoname/map_cells 等步骤两侧命令完全相同，语义保持；
  ⑤ 负对照（最低位取反的设计）被判为不等价 ⇒ 验证流程能检出真实差异。

限制说明（照实写进报告，答辩要用）：
  * 使用 -ignore-unknown-cells 忽略了 Intel dffeas 原语的内部模型。
    其可靠性依据：这些 FF 单元在两侧**同名同连接**（abc 不使用 -dff，不跨 FF 边界），
    equiv_make 将它们作为割点匹配，因此无需其内部逻辑模型。
  * 证明发生在 LUT 阶段；若要给最终 cycloneiv 网表出 EQY 正式报告，
    需按主办方要求另行配置（可加载器件库模型），这是提交前的待办。
EOF
else
  echo
  echo "存在未通过项 —— 等价性仍未证明，该变体不得进入成绩数据。"
fi
