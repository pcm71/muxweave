#!/usr/bin/env bash
# wsl_equiv_final2.sh —— 等价性检查（负对照改用"可观测的 RTL 变异"）
#
# 为什么改：上一版把负对照做成"翻转网表里某个 LUT 常量"，
#   在 test3 上翻转的位对应不可达输入组合 ⇒ 功能无变化 ⇒ 负对照 PASS ⇒ 检查器无法被验证。
#   本版改为**变异 RTL 的 case 匹配模式**（改 `8'bxxxxxxxx` 模式的一位），
#   匹配边界一定变化 ⇒ 必然可观测 ⇒ 负对照一定能被判出差异。
#
#   bash scripts/wsl_equiv_final2.sh [用例] [周期数]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
TOP="${1:-test3}"
DEPTH="${2:-5}"
D=runs/equiv_final
L=formal/equiv_final
mkdir -p "$D" "$L"

gen() { # $1=verilog $2=映射命令 $3=输出
  yosys -q -p "
read_verilog $1
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_ffs
$2
clean
opt -fast
write_verilog -noattr $3
" > "${3%.v}.genlog" 2>&1
}

eqcheck() { # $1=gold $2=gate $3=标签
  local log="$L/${TOP}_$3.log"
  yosys -q -p "
read_verilog $1
hierarchy -top $TOP
proc
async2sync
opt -fast
design -stash g
design -reset
read_verilog $2
hierarchy -top $TOP
proc
async2sync
opt -fast
design -stash e
design -copy-from g -as gold $TOP
design -copy-from e -as gate $TOP
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq $DEPTH -set-init-zero miter
" > "$log" 2>&1
  local rc=$?
  if [ $rc -eq 0 ]; then echo PASS
  elif grep -qE "model found: FAIL|proof did fail|SAT proof finished - no solution" "$log"; then echo FAIL
  else echo ERROR; fi
}

echo "用例=$TOP  周期=$DEPTH"

# 负对照：变异 RTL 的 case 匹配模式（8'bxxxxxxxx 或 N'dN 常量）
MUT=$D/${TOP}_rtlmut.v
python3 - "benchmarks/official/${TOP}.v" "$MUT" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
t = open(src, encoding="utf-8").read()
# 优先改 `8'bxxxxxxxx` / `4'bxxxx` 形式的模式；退化为任意 N'bxxxx / N'dN
for pat in (r"(\d+)'b([01]{2,})", r"(\d+)'d(\d+)"):
    m = re.search(pat, t)
    if not m:
        continue
    if "'b" in m.group(0):
        bits = m.group(2)
        new = bits[:-1] + ("1" if bits[-1] == "0" else "0")
        t = t[:m.start(2)] + new + t[m.end(2):]
        print(f"  变异 RTL：{m.group(1)}'b{bits} -> {m.group(1)}'b{new}")
    else:
        v = int(m.group(2)) ^ 1
        t = t[:m.start(2)] + str(v) + t[m.end(2):]
        print(f"  变异 RTL：{m.group(1)}'d{m.group(2)} -> {m.group(1)}'d{v}")
    break
else:
    raise SystemExit("未找到可变异常量")
open(dst, "w", encoding="utf-8").write(t)
PY

BASE=$D/${TOP}_base.v
NEGBASE=$D/${TOP}_negbase.v
gen "benchmarks/official/${TOP}.v" "abc9 -lut 4 -W 300" "$BASE" || exit 1
gen "$MUT" "abc9 -lut 4 -W 300" "$NEGBASE"    || exit 1

echo
R1=$(eqcheck "$BASE" "$BASE" "selfcheck")
printf '  ① 自检（base vs base，须 PASS）：%s %s\n' "$R1" "$([ "$R1" = PASS ] && echo ✓ || echo ✗)"
R2=$(eqcheck "$BASE" "$NEGBASE" "neg_rtlmut")
printf '  ② 负对照（base vs RTL变异网表，须 FAIL）：%s %s\n' "$R2" "$([ "$R2" = FAIL ] && echo ✓ || echo ✗)"

if [ "$R1" != PASS ] || [ "$R2" != FAIL ]; then
  echo
  echo ">>> 前置校验未通过：检查器对此用例不可信，终止。"
  exit 1
fi

echo
printf '  ③ 待测（官方 abc9 vs 各脚本）\n'
printf '  %-24s %-8s %s\n' "脚本" "等价性" "面积(逻辑单元)"
echo "  ------------------------------------------------------------"
for s in configs/abc_scripts/baseline_lut4.abc \
         configs/abc_scripts/c_min.abc \
         configs/abc_scripts/c_min_lutpack.abc \
         configs/abc_scripts/c_min_mfs2_lutpack.abc \
         configs/abc_scripts/c_full.abc \
         configs/abc_scripts/if_area.abc; do
  tag=$(basename "$s" .abc)
  net=$D/${TOP}_${tag}.v
  gen "benchmarks/official/${TOP}.v" "abc -lut 4 -script $s" "$net" || { printf '  %-24s 生成失败\n' "$tag"; continue; }
  R=$(eqcheck "$BASE" "$net" "$tag")
  cells=$(yosys -q -p "
read_verilog benchmarks/official/${TOP}.v
hierarchy -top $TOP
synth_intel -family cycloneiv -top $TOP -run begin:map_luts
abc -lut 4 -script $s
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $TOP -run map_cells:check
tee -o $D/${TOP}_${tag}_stat.json stat -json
" > /dev/null 2>&1; python3 -c "
import json
try:
    d=json.load(open('$D/${TOP}_${tag}_stat.json')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(x in k.lower() for x in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')")
  printf '  %-24s %-8s %s\n' "$tag" "$R" "$cells"
done
