#!/usr/bin/env bash
# wsl_eqy_fix_init.sh —— 尝试用"统一初态语义"闭环 test4（并验证 test3）
#
# 根因：EQY 的 simple 策略执行 `sat -tempinduct -set-init-undef ...`，
#       即把初态视为未定义；而 synth_intel 内部有 setundef -undriven -zero，
#       网表初态被确定化 ⇒ 与 RTL 比较时产生伪反例（连官方 abc9 映射也过不了）。
# 做法：在 [gold]/[gate] 两侧都加 setundef -zero -init，把初态对齐为确定值。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
EQDIR="formal/eqy_official"
mkdir -p "$EQDIR/logs"

run_pair() { # $1=case名 $2=网表 $3=标签 $4=额外命令
  local top="$1" net="$2" tag="$3" extra="$4"
  local cfg="$EQDIR/fix_${tag}.eqy" log="$EQDIR/logs/fix_${tag}.log"
  cat > "$cfg" <<EOF
[options]
splitnets off

[gold]
read_verilog benchmarks/official/${top}.v
prep -top ${top}
${extra}

[gate]
read_verilog ${net}
prep -top ${top}
${extra}

[strategy simple]
use sat
depth 5
EOF
  rm -rf "./${top}_eqy" 2>/dev/null
  timeout 300 eqy "$cfg" > "$log" 2>&1
  local rc=$?
  rm -rf "./${top}_eqy" 2>/dev/null
  if [ $rc -eq 0 ]; then echo "PASS"; else
    echo "FAIL(rc=$rc)"; grep -E "Failed to prove equivalence for|No configured strategy|ERROR" "$log" | head -1 | sed 's/^/        /'
  fi
}

echo "=== 对照：两侧都加 setundef -zero -init（统一初态）==="
printf '%-8s %-28s %-28s\n' "用例" "对照组(官方abc9网表)" "目标组(pmux_opt网表)"
echo "----------------------------------------------------------------------"
for top in test3 test4; do
  ctrl="runs/netlist_official/${top}_ctrl_abc9.v"
  targ="runs/netlist_official/${top}_target.v"
  [ -f "$ctrl" ] || { echo "$top 缺网表，跳过"; continue; }
  c=$(run_pair "$top" "$ctrl" "${top}_ctrl_fix" "setundef -zero -init")
  t=$(run_pair "$top" "$targ" "${top}_targ_fix" "setundef -zero -init")
  printf '%-8s %-28s %-28s\n' "$top" "$c" "$t"
done

echo
echo "=== 若仍失败，试 -set-init 另一种写法：只用 setundef -zero（不指定 -init）==="
for top in test4; do
  c=$(run_pair "$top" "runs/netlist_official/${top}_ctrl_abc9.v" "${top}_ctrl_fix2" "setundef -zero")
  t=$(run_pair "$top" "runs/netlist_official/${top}_target.v" "${top}_targ_fix2" "setundef -zero")
  printf '%-8s %-28s %-28s\n' "$top" "$c" "$t"
done
