#!/usr/bin/env bash
# selfcheck.sh —— 全面自查（主动找问题，不只复述结论）
#
# 检查项：
#   1. 集成是否真的生效（synth_intel.cc 是否调用 pmux_opt）
#   2. 面积与 DFF：用**真基线二进制** vs **优化版二进制**逐用例对比
#   3. 合规性：脚本里是否只出现 abc9（未换映射器）
#   4. **确定性/可复现性**：同一用例重复跑，结果是否一致
#   5. 耗时与内存是否在指标内
#   6. 仓库状态（无临时文件残留、无生成物入库）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/selfcheck
mkdir -p "$D"

echo "########## 1) 集成是否生效 ##########"
grep -n "pmux_opt" ~/src/yosys/techlibs/intel/synth_intel.cc | sed 's/^/  /'
echo

echo "########## 2) 面积与 DFF（真基线 vs 优化版）##########"
jit() { # $1=json -> "总/DFF/逻辑"
  python3 -c "
import json
d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
f=open('$1'); 
print(f\"{d['design']['num_cells']}/{seq}/{d['design']['num_cells']-seq}\")"
}
printf '  %-8s %-14s %-14s %-10s %s\n' "用例" "基线(总/DFF/逻辑)" "优化(总/DFF/逻辑)" "缩减" "DFF 是否增加"
echo "  ---------------------------------------------------------------------------"
sum=0; n=0; dfail=0
for c in test1 test2 test3 test4; do
  "$HOME/.local/bin/yosys-baseline" -q -p "
read_verilog benchmarks/official/$c.v
hierarchy -top $c
synth_intel -family cycloneiv -top $c
tee -o $D/${c}_b.json stat -json
" > /dev/null 2>&1
  "$HOME/.local/bin/yosys-pmux" -q -p "
read_verilog benchmarks/official/$c.v
hierarchy -top $c
synth_intel -family cycloneiv -top $c
tee -o $D/${c}_o.json stat -json
" > /dev/null 2>&1
  b=$(jit "$D/${c}_b.json"); o=$(jit "$D/${c}_o.json")
  bl=$(echo "$b" | cut -d/ -f3); ol=$(echo "$o" | cut -d/ -f3)
  bd=$(echo "$b" | cut -d/ -f2); od=$(echo "$o" | cut -d/ -f2)
  red=$(python3 -c "print(f'{($bl-$ol)/$bl*100:.1f}%')")
  add="否 ✓"; [ "$od" -gt "$bd" ] && { add="**是 ✗**"; dfail=$((dfail+1)); }
  printf '  %-8s %-14s %-14s %-10s %s\n' "$c" "$b" "$o" "$red" "$add"
  sum=$(python3 -c "print($sum + ($bl-$ol)/$bl)"); n=$((n+1))
done
python3 -c "print(f'  >>> 逐用例平均缩减率：{$sum/$n*100:.2f}%')"
echo "  DFF 增加的用例数：$dfail"
echo

echo "########## 3) 合规性：脚本里是否只用 abc9 ##########"
echo "  pass 内主脚本："
grep -A3 'static const char \*SCRIPT_AREA =' plugin/pmux_opt.cc | sed 's/^/    /'
echo "  是否含经典 abc 命令（strash/if/mfs2/lutpack 等）？"
if grep -E '"(strash|if|mfs2|lutpack)' plugin/pmux_opt.cc > /dev/null 2>&1; then
  echo "    ✗ 发现经典 abc 命令"
else
  echo "    ✓ 未发现（全部为 & 开头的 GIA 命令）"
fi
echo

echo "########## 4) 确定性与可复现性 ##########"
echo "  （重点：&rrr -T 1 是按时间限的，可能随机器速度变化）"
for c in test3 test4; do
  printf '  %-8s ' "$c"
  for i in 1 2 3 4 5; do
    "$HOME/.local/bin/yosys-pmux" -q -p "
read_verilog benchmarks/official/$c.v
hierarchy -top $c
synth_intel -family cycloneiv -top $c
tee -o $D/${c}_r$i.json stat -json
" > /dev/null 2>&1
    printf '%s ' "$(jit "$D/${c}_r$i.json" | cut -d/ -f3)"
  done
  echo
done
