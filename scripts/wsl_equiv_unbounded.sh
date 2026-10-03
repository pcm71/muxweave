#!/usr/bin/env bash
# wsl_equiv_unbounded.sh —— 把等价性证据从"有界"升级为"无界归纳"
#
# 与 wsl_equiv_final.sh 的区别：每种模式各跑一次并分别判定
#   模式 A：sat -seq N        → "前 N 个周期无差异"（有界证据）
#   模式 B：sat -tempinduct   → 时序归纳（无界证明）
# 判定三态（PASS / FAIL / ERROR），绝不把 ERROR 当反例。
#
# 前置校验（缺一不可）：
#   ① 自检  ：base vs base            → 两种模式都须 PASS
#   ② 负对照：base vs RTL 变异的网表   → 至少一种模式须报反例
#
#   bash scripts/wsl_equiv_unbounded.sh <用例> <有界周期数> [超时秒数，默认 600]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
TOP="${1:?用法: wsl_equiv_unbounded.sh <用例> <有界周期数> [超时]}"
DEPTH="${2:?缺少有界周期数}"
TMO="${3:-600}"
D=runs/equiv_unbounded
L=formal/equiv_unbounded
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

# 单个模式的检查：输出 PASS / FAIL / ERROR
one_mode() { # $1=gold $2=gate $3=模式参数 $4=日志
  timeout "$TMO" yosys -q -p "
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
sat -verify -prove-asserts $3 -set-init-zero miter
" > "$4" 2>&1
  local rc=$?
  if [ $rc -eq 0 ]; then echo PASS
  elif [ $rc -eq 124 ]; then echo TIMEOUT
  elif grep -qE "model found: FAIL|proof did fail|SAT proof finished - no solution|unproven" "$4"; then echo FAIL
  else echo ERROR; fi
}

both() { # $1=gold $2=gate $3=标签 -> "有界=.. 归纳=.."
  local a b
  a=$(one_mode "$1" "$2" "-seq $DEPTH" "$L/${TOP}_$3.seq.log")
  b=$(one_mode "$1" "$2" "-tempinduct" "$L/${TOP}_$3.ind.log")
  echo "$a|$b"
}

echo "用例=$TOP  有界周期=$DEPTH  单模式超时=${TMO}s"
echo

BASE=$D/${TOP}_base.v
gen "benchmarks/official/${TOP}.v" "abc9 -lut 4 -W 300" "$BASE" || { echo "基准生成失败"; exit 1; }

# 负对照：变异 RTL（必须先屏蔽注释，否则可能改到注释里的常量 —— test2 就踩过：
# 它注释里有 `// dataa <= {5'b00001};`，变异命中注释 ⇒ 功能无变化 ⇒ 负对照失效）
MUT=$D/${TOP}_rtlmut.v
python3 - "benchmarks/official/${TOP}.v" "$MUT" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
orig = open(src, encoding="utf-8").read()

# 构造"等长但注释被抹成空格"的副本，用于定位可改写的常量位置
def mask_comments(text):
    out = []
    for line in text.split("\n"):
        idx = line.find("//")
        if idx >= 0:
            out.append(line[:idx] + " " * (len(line) - idx))
        else:
            out.append(line)
    return "\n".join(out)

code = mask_comments(orig)

def mutate_const(text, code_text):
    """策略 A：翻转代码区里第一个多位常量的最低位。"""
    for pat in (r"(\d+)'b([01]{2,})", r"(\d+)'d(\d+)"):
        m = re.search(pat, code_text)
        if not m:
            continue
        if "'b" in m.group(0):
            bits = m.group(2); new = bits[:-1] + ("1" if bits[-1] == "0" else "0")
            print(f"  负对照变异（常量）：{m.group(1)}'b{bits} -> {m.group(1)}'b{new}")
            return text[:m.start(2)] + new + text[m.end(2):]
        v = int(m.group(2)) ^ 1
        print(f"  负对照变异（常量）：{m.group(1)}'d{m.group(2)} -> {m.group(1)}'d{v}")
        return text[:m.start(2)] + str(v) + text[m.end(2):]
    return None

def mutate_assign(text, code_text):
    """策略 B（结构性）：把第 2 个赋值的右值改成第 1 个的右值，制造可观测差异。
    用于 RTL 里没有常量的情况（如 test2 只有 case(1'b1) + 若干 datax 选择）。"""
    ms = list(re.finditer(r"(\w+\s*=\s*)([A-Za-z_]\w*(?:\[[^\]]*\])?)(\s*;)", code_text))
    if len(ms) >= 2:
        first_rhs = ms[0].group(2)
        m = ms[1]
        if first_rhs != m.group(2):
            print(f"  负对照变异（结构）：第 2 个赋值右值 {m.group(2)} -> {first_rhs}")
            return text[:m.start(2)] + first_rhs + text[m.end(2):]
    return None

t = mutate_const(orig, code) or mutate_assign(orig, code)
if t is None:
    raise SystemExit("未能构造出可观测的负对照变异")
open(dst, "w", encoding="utf-8").write(t)
PY
NEGBASE=$D/${TOP}_negbase.v
gen "$MUT" "abc9 -lut 4 -W 300" "$NEGBASE" || { echo "负对照网表生成失败"; exit 1; }

echo
echo "########## 前置校验 ##########"
S=$(both "$BASE" "$BASE" "selfcheck")
S1=${S%%|*}; S2=${S##*|}
printf '  ① 自检      有界=%-8s 归纳=%-8s %s\n' "$S1" "$S2" \
  "$([ "$S1" = PASS ] && [ "$S2" = PASS ] && echo '✓' || echo '✗ 检查器不可用，终止')"

N=$(both "$BASE" "$NEGBASE" "neg")
N1=${N%%|*}; N2=${N##*|}
printf '  ② 负对照    有界=%-8s 归纳=%-8s %s\n' "$N1" "$N2" \
  "$([ "$N1" = FAIL ] || [ "$N2" = FAIL ] && echo '✓ 有鉴别力' || echo '✗ 无鉴别力，终止')"

if [ "$S1" != PASS ] || [ "$S2" != PASS ] || { [ "$N1" != FAIL ] && [ "$N2" != FAIL ]; }; then
  echo
  echo ">>> 前置校验未通过，不做任何结论。"
  exit 1
fi

echo
echo "########## 待测：官方 abc9 vs 各脚本（有界 + 无界归纳）##########"
printf '  %-24s %-9s %-11s %s\n' "脚本" "有界" "无界归纳" "面积(逻辑单元)"
echo "  ----------------------------------------------------------------------"
for s in configs/abc_scripts/baseline_lut4.abc \
         configs/abc_scripts/c_min.abc \
         configs/abc_scripts/c_min_lutpack.abc \
         configs/abc_scripts/c_min_mfs2_lutpack.abc \
         configs/abc_scripts/c_full.abc \
         configs/abc_scripts/if_area.abc; do
  tag=$(basename "$s" .abc)
  net=$D/${TOP}_${tag}.v
  gen "benchmarks/official/${TOP}.v" "abc -lut 4 -script $s" "$net" || { printf '  %-24s 生成失败\n' "$tag"; continue; }
  R=$(both "$BASE" "$net" "$tag")
  R1=${R%%|*}; R2=${R##*|}
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
  printf '  %-24s %-9s %-11s %s\n' "$tag" "$R1" "$R2" "$cells"
done

echo
echo ">>> 判定口径：有界=PASS 表示前 $DEPTH 周期无差异；无界归纳=PASS 表示已做时序归纳证明。"
