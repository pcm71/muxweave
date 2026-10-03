#!/usr/bin/env bash
# wsl_abc9_search.sh —— 在"必须用 abc9"约束下搜索 abc9 脚本空间（官方 4 个 case）
#
# 面积口径：LUT 逻辑单元（= 总单元 − 时序单元）。
# 基线：官方 synth_intel（内部就是 abc9 -lut 4 -W 300）的 LUT 逻辑单元数。
#
#   bash scripts/wsl_abc9_search.sh [变体文件...]（默认 configs/abc_scripts/a9_*.abc）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/abc9_search
mkdir -p "$D"

SCRIPTS="$*"
[ -n "$SCRIPTS" ] || SCRIPTS=$(ls configs/abc_scripts/a9_*.abc 2>/dev/null)
[ -n "$SCRIPTS" ] || { echo "没有找到变体脚本（先跑 gen_abc9_variants.sh）"; exit 1; }
CASES=$(ls benchmarks/official/*.v)

logic_of() { # $1=json -> 打印 LUT 逻辑单元
  python3 -c "
import json,sys
try:
    d=json.load(open('$1'))
    nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception:
    print('?')"
}

run_flow() { # $1=verilog $2=top $3=abc9 额外参数(脚本) $4=输出json
  yosys -q -p "
read_verilog $1
hierarchy -top $2
synth_intel -family cycloneiv -top $2 -run begin:map_luts
abc9 -lut 4 -W 300 $3
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $2 -run map_cells:check
tee -o $4 stat -json
" > "${4%.json}.log" 2>&1
}

echo "=== 基线：**真基线二进制**跑官方 synth_intel（内部 abc9 -lut 4 -W 300）==="
# 关键：必须用 yosys-baseline（不含 pmux_opt 调用）。
# 用已安装的优化版 yosys 测"基线"会把我们自己的优化算进基线，导致所有变体显示为负收益。
BASEBIN="$HOME/.local/bin/yosys-baseline"
[ -x "$BASEBIN" ] || { echo "缺少真基线二进制 $BASEBIN（先跑 wsl_build_baseline.sh）"; exit 1; }
declare -A BASE
for v in $CASES; do
  top=$(basename "$v" .v)
  "$BASEBIN" -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
tee -o $D/base_$top.json stat -json
" > "$D/base_$top.log" 2>&1
  BASE[$top]=$(logic_of "$D/base_$top.json")
  printf '  %-8s LUT=%s\n' "$top" "${BASE[$top]}"
done

echo
echo "=== 各 abc9 脚本变体（面积口径，LUT 逻辑单元）==="
printf '  %-20s' "变体"
for v in $CASES; do printf '%10s' "$(basename "$v" .v)"; done
printf '%10s\n' "平均缩减"

declare -A BEST_TOTAL
for s in $SCRIPTS; do
  tag=$(basename "$s" .abc)
  printf '  %-20s' "$tag"
  sum=0; cnt=0
  for v in $CASES; do
    top=$(basename "$v" .v)
    run_flow "$v" "$top" "-script $s" "$D/${tag}_$top.json"
    n=$(logic_of "$D/${tag}_$top.json")
    printf '%10s' "$n"
    if [ "$n" != "?" ] && [ -n "${BASE[$top]}" ] && [ "${BASE[$top]}" != "?" ]; then
      sum=$(python3 -c "print($sum + (${BASE[$top]} - $n)/${BASE[$top]})")
      cnt=$((cnt+1))
    fi
  done
  if [ $cnt -gt 0 ]; then
    avg=$(python3 -c "print(f'{$sum/$cnt*100:.2f}%')")
  else avg="?"; fi
  printf '%10s\n' "$avg"
done

echo
echo "=== 说明 ==="
echo "  基线 = 官方 synth_intel 的 LUT 逻辑单元；平均缩减 = 逐用例缩减率的算术平均（官方口径）"
echo "  赛题技术指标：≥10%；评分细则：有缩减即得基础分 20 分，≥20% 满分（无优化效果才 0 分）"
echo "  仅用 abc9，未更换映射器"
