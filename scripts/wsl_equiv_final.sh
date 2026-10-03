#!/usr/bin/env bash
# wsl_equiv_final.sh —— 修正后的等价性检查（含自检与负对照，两者都通过才出结论）
#
# 上一版的错误与修正：
#   错误：write_verilog 输出的网表里是 `always @(posedge clk ...)` **进程**，
#         直接 miter 等于比较含 $proc 的模块 → **同一文件对自己都判 FAIL**（已实测），
#         因此之前所有"不等价"结论全部作废。
#   修正：读入后先 `proc`（必要时 `memory`/`opt`）把进程变成通用 FF，再做 miter + sat。
#
# 三级验证（缺一不可）：
#   ① 自检：base vs base（同一文件）—— 必须 PASS，否则检查器无效
#   ② 负对照：base vs 改了一位常量的 base —— 必须 FAIL，否则检查器无鉴别力
#   ③ 待测：base（官方 abc9） vs 各脚本变体 —— 才有资格解读
#
#   bash scripts/wsl_equiv_final.sh [用例名，默认 test4] [每个变体的检查周期数，默认 5]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
TOP="${1:-test4}"
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

eqcheck() { # $1=gold.v $2=gate.v $3=标签  -> 输出 PASS / FAIL / ERROR
  local log="$L/${TOP}_$3.log"
  # 必须先 async2sync：网表含异步复位触发器（$adff），
  # 不转换的话 sat 会直接报 "No SAT model available for async FF cell"（这是 ERROR，不是反例！）。
  # 早期版本把 rc≠0 一律当 FAIL，导致把 ERROR 误读成"不等价"。
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

echo "用例=$TOP  检查周期=$DEPTH"
echo
echo "=== 生成基准网表（官方 abc9）==="
BASE=$D/${TOP}_base.v
gen "benchmarks/official/${TOP}.v" "abc9 -lut 4 -W 300" "$BASE" || { echo "基准生成失败"; exit 1; }
echo "  ✓ $BASE"

echo
echo "########## ① 自检：base vs base（必须 PASS）##########"
R1=$(eqcheck "$BASE" "$BASE" "selfcheck")
printf '  结果：%s  %s\n' "$R1" "$([ "$R1" = PASS ] && echo '✓ 检查器基本可用' || echo '✗ 检查器仍无效，后续结论不可用')"

echo
echo "########## ② 负对照：base vs 改一位常量的 base（必须 FAIL）##########"
NEG=$D/${TOP}_neg1bit.v
python3 - "$BASE" "$NEG" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
t = open(src, encoding="utf-8").read()
# 在第一条形如 `assign _NN_ = 16'hXXXX >> { ... };` 的语句里，把常量最低位翻转
m = re.search(r"(assign\s+\S+\s*=\s*)(\d+)'h([0-9a-fA-F]+)", t)
if not m:
    raise SystemExit("未找到可改写的常量")
val = int(m.group(3), 16) ^ 1
t = t[:m.start(3)] + format(val, "x") + t[m.end(3):]
open(dst, "w", encoding="utf-8").write(t)
print(f"  负对照：{m.group(2)}'h{m.group(3)} -> {m.group(2)}'h{format(val,'x')}")
PY
R2=$(eqcheck "$BASE" "$NEG" "neg_1bit")
printf '  结果：%s  %s\n' "$R2" "$([ "$R2" = FAIL ] && echo '✓ 检查器有鉴别力' || echo '✗ 无鉴别力，后续结论不可用')"

if [ "$R1" != PASS ] || [ "$R2" != FAIL ]; then
  echo
  echo ">>> 前置校验未通过，终止：检查器不可信，不能据此判定任何变体。"
  exit 1
fi

echo
echo "########## ③ 待测：官方 abc9 vs 各脚本变体 ##########"
printf '  %-24s %-8s %s\n' "脚本" "等价性" "面积（逻辑单元）"
echo "  ------------------------------------------------------------------"
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
  # 面积（逻辑单元 = 总单元 - 时序单元），用官方流程量
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
    d = json.load(open('$D/${TOP}_${tag}_stat.json'))
    nbt = d['design']['num_cells_by_type']
    seq = sum(v for k, v in nbt.items() if any(x in k.lower() for x in ('dff','latch','dffeas')))
    print(d['design']['num_cells'] - seq)
except Exception:
    print('?')")
  printf '  %-24s %-8s %s\n' "$tag" "$R" "$cells"
done

echo
echo ">>> 只有 ① PASS 且 ② FAIL 时，③ 的结论才有效。"
