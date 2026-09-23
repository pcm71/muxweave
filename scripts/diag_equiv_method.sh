#!/usr/bin/env bash
# diag_equiv_method.sh —— 对时序用例（默认 m02）逐个试等价性验证方法，每种方法带超时
# 目的：找出真正可行的方法，并看清卡在哪一步（综合 vs SAT）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p /tmp/eqv runs

CASE="${1:-benchmarks/mixed/m02_regfile_readback.v}"
TOP=$(basename "$CASE" .v)
VT="abc -lut 4"
echo "用例: $CASE (top=$TOP)   变体: $VT"
echo

# ---------- 阶段 1：只做综合，测耗时 ----------
echo "=== 阶段 1：两侧综合耗时（不比较）==="
cat > /tmp/eqv/synth_${TOP}.ys <<EOF
read_verilog $CASE
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
abc9 -lut 4 -W 300
clean
opt -fast
stat
EOF
/usr/bin/time -f "  gold(abc9) 综合+stat: %e 秒" yosys -s /tmp/eqv/synth_${TOP}.ys > /tmp/eqv/s1.log 2>/tmp/eqv/s1.time
cat /tmp/eqv/s1.time
grep -E "Number of cells|^\s+[0-9]+ cells" /tmp/eqv/s1.log | tail -2 | sed 's/^/  /'

cat > /tmp/eqv/synth2_${TOP}.ys <<EOF
read_verilog $CASE
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
$VT
clean
opt -fast
stat
EOF
/usr/bin/time -f "  gate(abc)  综合+stat: %e 秒" yosys -s /tmp/eqv/synth2_${TOP}.ys > /tmp/eqv/s2.log 2>/tmp/eqv/s2.time
cat /tmp/eqv/s2.time
echo "  两侧单元数："
grep -E "^\s+[0-9]+ cells" /tmp/eqv/s1.log | tail -1 | sed 's/^/    gold /'
grep -E "^\s+[0-9]+ cells" /tmp/eqv/s2.log | tail -1 | sed 's/^/    gate /'

# ---------- 阶段 2：三种比较方法，各带 90 秒超时 ----------
run_method() { # $1=方法名 $2=比较命令段
  local name="$1" cmds="$2"
  echo
  echo "=== 方法：$name（超时 90s）==="
  cat > /tmp/eqv/m_${TOP}.ys <<EOF
read_verilog $CASE
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
abc9 -lut 4 -W 300
clean
opt -fast
design -stash gold
design -reset
read_verilog $CASE
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
$VT
clean
opt -fast
design -stash gate
design -copy-from gold -as gold $TOP
design -copy-from gate -as gate $TOP
$cmds
EOF
  timeout 90 yosys -q -s /tmp/eqv/m_${TOP}.ys > /tmp/eqv/m_${TOP}_${name}.log 2>&1
  local rc=$?
  if [ $rc -eq 124 ]; then
    echo "  【超时】90 秒未完成"
  elif [ $rc -eq 0 ]; then
    echo "  【通过】rc=0"
  else
    echo "  【未通过】rc=$rc"
  fi
  grep -E "SAT proof finished|Equivalence successfully proven|unproven|No more equivalence|ERROR" \
    /tmp/eqv/m_${TOP}_${name}.log | tail -3 | sed 's/^/    /'
  cp /tmp/eqv/m_${TOP}_${name}.log "runs/diag_equiv_${TOP}_${name}.log" 2>/dev/null || true
}

run_method "equiv_make" "equiv_make gold gate equiv
hierarchy -top equiv
equiv_simple
equiv_status -assert"

run_method "sat_seq1" "miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -seq 1 -set-init-zero miter"

run_method "sat_tempinduct" "miter -equiv -flatten -make_outputs -make_assert gold gate miter
hierarchy -top miter
sat -verify -prove-asserts -tempinduct -set-init-zero miter"

echo
echo "=== 诊断结论 ==="
echo "  哪个方法 rc=0 且无 unproven，就是可用方法；超时的说明规模太大需要换策略。"
