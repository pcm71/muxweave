#!/usr/bin/env bash
# wsl_miter_check.sh —— 用 miter + sat 闭环 test4 的等价性（带负对照）
#
# 为什么走这条路：
#   EQY 的 sat 策略会跳过"含 memory 属性"的 partition（EqySatStrategy.partition_supported），
#   而唯一不跳过的 sby 策略需要 SBY，本机未安装（sby: 未找到）。
#   因此在 map_ffs 之前（FF 仍是通用 $_DFF_*/$_DFFE_*，Yosys 的 sat 原生支持）
#   直接对两份网表建 miter 并用时序归纳证明。
#
# 设计（含对照）：
#   正向：官方 abc9 网表  vs  自研 pmux_opt 网表        -> 期望 PASS
#   负对照：官方 abc9 网表 vs  "改了一位常数"的变体网表  -> 期望 FAIL（证明检查器能查出差异）
#
#   bash scripts/wsl_miter_check.sh [用例名，默认 test4]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
TOP="${1:-test4}"
D=runs/netlist_official
EQD=formal/miter
mkdir -p "$D" "$EQD/logs"

# 造一个"改一位常数"的负对照变体（只用于验证检查器有效，不参与成绩）
MUT=$D/${TOP}_mutated.v
python3 - "$P/benchmarks/official/${TOP}.v" "$MUT" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
t = open(src, encoding="utf-8").read()
# 在第一个 case 分支那一行里，把任意 6 位常量的最低位翻转，制造一处真实功能差异。
# 注意 test4 的写法是 `5'd0: {dataout,...} <= {6'b100111,1'b0,...};`
#   —— 常量前还有拼接，所以不能在 `5'd0:` 后面直接找 `{6'b`，要允许中间有其它字符。
m = re.search(r"5'd0:[^\n]*?(6'b)([01]{6})", t)
if not m:
    # 退化写法：整个文件里第一个 6 位常量
    m = re.search(r"(6'b)([01]{6})", t)
if not m:
    raise SystemExit("未找到可改写的常量，负对照生成失败")
old = m.group(2)
new = old[:-1] + ("1" if old[-1] == "0" else "0")
t = t[:m.start(2)] + new + t[m.end(2):]
open(dst, "w", encoding="utf-8").write(t)
print(f"负对照：6'b{old} -> 6'b{new}")
PY

gen() { # $1=verilog $2=映射命令 $3=输出
  yosys -q -p "
read_verilog $1
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
$2
clean
opt -fast
write_verilog -noattr $3
" > "${3%.v}.genlog" 2>&1 || { echo "  生成失败：$3"; tail -3 "${3%.v}.genlog"; return 1; }
}

echo "=== 生成三份网表（map_ffs 之前，FF 为通用类型）==="
gen "benchmarks/official/${TOP}.v" "abc9 -lut 4 -W 300" "$D/${TOP}_ctrl_abc9.v" && echo "  ✓ 官方 abc9 网表"
gen "benchmarks/official/${TOP}.v" "pmux_opt"           "$D/${TOP}_target.v"    && echo "  ✓ 自研 pmux_opt 网表"
gen "$MUT"                          "abc9 -lut 4 -W 300" "$D/${TOP}_neg.v"       && echo "  ✓ 负对照网表（改一位常数）"

check() { # $1=gold网表 $2=gate网表 $3=标签 $4=期望 PASS|FAIL
  local gold="$1" gate="$2" tag="$3" expect="$4"
  local log="$EQD/logs/${tag}.log"
  # 关键：`miter -equiv -flatten` 的 -flatten **不会真正内联**（实测 SAT 只 import 7 个 cell，
  # 等于在证一个空性质 → 假阳性，连"改了一位常数"的负对照都能 PASS）。
  # 必须 **miter 之后再显式 `flatten miter`**，SAT 才能看到完整比较电路。
  # 这一点是用"已知错误配对"筛出来的（scripts/diag_miter3.sh）。
  #
  # 两种模式都跑：
  #   ① -seq 5      有界检查前 5 个周期（时序电路差异常在第 1 周期后才显现）
  #   ② -tempinduct 时序归纳（无界证明）
  local ok_seq ok_ind
  run_sat() { # $1=附加模式参数 $2=日志
    yosys -q -p "
read_verilog $gold
hierarchy -top $TOP
design -stash g
design -reset
read_verilog $gate
hierarchy -top $TOP
design -stash e
design -copy-from g -as gold $TOP
design -copy-from e -as gate $TOP
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts $1 -set-init-zero miter
" > "$2" 2>&1
    return $?
  }

  run_sat "-seq 5" "$log.seq";      [ $? -eq 0 ] && ok_seq=1 || ok_seq=0
  run_sat "-tempinduct" "$log.ind"; [ $? -eq 0 ] && ok_ind=1 || ok_ind=0

  local verdict
  if [ $ok_seq -eq 1 ] && [ $ok_ind -eq 1 ]; then verdict=PASS
  else verdict=FAIL; fi
  printf '  %-14s 期望 %-4s 实际 %-6s %s  (有界:%s 归纳:%s)\n' "$tag" "$expect" "$verdict" \
    "$([ "$verdict" = "$expect" ] && echo '✓' || echo '✗')" \
    "$([ $ok_seq -eq 1 ] && echo 通过 || echo '反例')" \
    "$([ $ok_ind -eq 1 ] && echo 通过 || echo '反例')"
}

echo
echo "=== 等价性检查 ==="
check "$D/${TOP}_ctrl_abc9.v" "$D/${TOP}_target.v" "official_vs_ours" PASS
check "$D/${TOP}_ctrl_abc9.v" "$D/${TOP}_neg.v"    "negative_control" FAIL
