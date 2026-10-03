#!/usr/bin/env bash
# wsl_eqy_official2.sh —— 用 EQY 标准用法给官方 4 个 case 出形式等价证据
#
# 第 1 版失败的原因（重要经验）：
#   把"官方 abc9 映射的网表"与"自研映射的网表"直接给 EQY 比较时，
#   两个映射产生的**内部信号名完全不同**，EQY 按名字匹配 → 几乎所有 partition 都匹配不上，
#   于是连 test2（纯组合、本来等价）也报 15/15 失败。这不是不等价，是设置错误。
#
# 本版改用 EQY 的标准用法：
#   [gold] = 原始 RTL（名字来自源码）
#   [gate] = 综合后的网表（端口/FF 名字同样来自源码 ⇒ 可匹配）
#   EQY 以匹配到的 FF 为割点，逐个 SAT 证明组合锥。
#
# 内置对照组（关键）：
#   对照组 gate = 官方 abc9 映射的网表 —— **它必须通过**，否则说明设置仍有问题，
#   此时目标组的结论不可信。只有"对照组通过 + 目标组通过"才构成有效证据。
#
#   bash scripts/wsl_eqy_official2.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
EQDIR="formal/eqy_official"
mkdir -p "$EQDIR/logs" runs/netlist_official

gen() { # $1=verilog $2=top $3=映射命令 $4=输出文件
  yosys -q -p "
read_verilog $1
hierarchy -top $2
synth_intel -family cycloneiv -top $2 -run begin:map_ffs
$3
clean
opt -fast
write_verilog -noattr $4
" > "${4%.v}.genlog" 2>&1
}

run_eqy() { # $1=配置名 $2=top $3=gold源(rtl) $4=gate网表
  local name="$1" top="$2" goldsrc="$3" gatenet="$4"
  local cfg="$EQDIR/${name}.eqy" log="$EQDIR/logs/${name}.log"
  cat > "$cfg" <<EOF
# 自动生成：gold = 原始 RTL；gate = 综合网表
[options]
splitnets off

[gold]
read_verilog $goldsrc
prep -top $top

[gate]
read_verilog $gatenet
prep -top $top

[strategy simple]
use sat
depth 5
EOF
  rm -rf "./${top}_eqy" 2>/dev/null
  timeout 300 eqy "$cfg" > "$log" 2>&1
  local rc=$?
  rm -rf "./${top}_eqy" 2>/dev/null
  echo $rc
}

printf '%-8s %-24s %-24s %s\n' "用例" "对照组(官方abc9)" "目标组(pmux_opt)" "判定"
echo "--------------------------------------------------------------------------------"
ok=0; total=0
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  total=$((total+1))
  ctrl="runs/netlist_official/${top}_ctrl_abc9.v"
  targ="runs/netlist_official/${top}_target.v"

  gen "$v" "$top" "abc9 -lut 4 -W 300" "$ctrl" || { echo "$top 对照组网表生成失败"; continue; }
  gen "$v" "$top" "pmux_opt" "$targ" || { echo "$top 目标组网表生成失败"; continue; }

  rc_ctrl=$(run_eqy "ctrl_${top}" "$top" "$v" "$ctrl")
  rc_targ=$(run_eqy "target_${top}" "$top" "$v" "$targ")

  c_txt=$([ "$rc_ctrl" = "0" ] && echo PASS || echo "FAIL(rc=$rc_ctrl)")
  t_txt=$([ "$rc_targ" = "0" ] && echo PASS || echo "FAIL(rc=$rc_targ)")
  if [ "$rc_ctrl" = "0" ] && [ "$rc_targ" = "0" ]; then
    verdict="✓ 有效证据"; ok=$((ok+1))
  elif [ "$rc_ctrl" != "0" ]; then
    verdict="✗ 对照组未通过 → 设置问题"
  else
    verdict="✗ 目标组未通过"
  fi
  printf '%-8s %-24s %-24s %s\n' "$top" "$c_txt" "$t_txt" "$verdict"
  [ "$rc_targ" != "0" ] && grep -E "Failed to prove equivalence for|ERROR" "$EQDIR/logs/target_${top}.log" | head -2 | sed 's/^/      /'
done

echo
echo "=== 汇总：有效证据 $ok / $total ==="
if [ "$ok" -eq "$total" ]; then
  cat <<'EOF'
结论：官方 4 个 case 中，自研 pmux_opt 的综合网表与原始 RTL 经 EQY 证明等价；
      且对照组（官方 abc9 映射）同样通过，证明该验证设置本身有效。
EOF
else
  echo "存在未通过项 —— 先看对照组的结论：若对照组失败，说明设置仍有问题，目标组结论不可信。"
fi
