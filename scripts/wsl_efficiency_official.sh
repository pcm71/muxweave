#!/usr/bin/env bash
# wsl_efficiency_official.sh —— 按官方最新口径重测效率
#
# 口径依据：
#   C54-2「峰值工作内存，**只看 yosys.exe**」  ⇒ 用 measure_yosys_self.py（轮询 /proc/<pid>/status 的 VmHWM，
#                                                  只反映 yosys 进程自身，不含 abc 子进程）
#   C54-1「编译耗时并不作为评分选项」          ⇒ 耗时仅备查
#   C37-2「case 都规模不大…若原版超过则优化版超过也允许」 ⇒ 阈值 60s/2GB 相对宽松
#   赛题第7页 技术指标：≤1000 节点，耗时 ≤60s，内存峰值 ≤2GB
#
# 面积口径仍为 LUT 逻辑单元；基线用 yosys-baseline（原始代码编译）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/eff_official
mkdir -p "$D"
REPS=5

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

measure() { # $1=二进制 $2=用例 $3=top -> 输出 JSON
  python3 scripts/measure_yosys_self.py 1 -- "$1" -q -p "
read_verilog $2
hierarchy -top $3
synth_intel -family cycloneiv -top $3
tee -o $D/${3}_$(basename $1).json stat -json
"
}

echo "口径：面积=LUT 逻辑单元；内存=**只看 yosys.exe**（C54-2）；耗时仅备查（C54-1）"
echo
printf '  %-8s %-12s %-12s %-10s %-14s %-14s %s\n' "用例" "LUT基线" "LUT优化后" "缩减" "内存基线(KB)" "内存优化后" "内存开销"
echo "  ----------------------------------------------------------------------------------------------------"

sum_red=0; cnt=0; max_mem=0; max_lut_mem=""
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  # 各跑 REPS 次，取中位数
  bmem=(); omem=(); bcpu=(); ocpu=()
  for i in $(seq "$REPS"); do
    j=$(measure "$HOME/.local/bin/yosys-baseline" "$v" "$top")
    bmem+=($(echo "$j" | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])"))
    bcpu+=($(echo "$j" | python3 -c "import json,sys; print(json.load(sys.stdin)['cpu_total'])"))
    j=$(measure "$HOME/.local/bin/yosys-pmux" "$v" "$top")
    omem+=($(echo "$j" | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])"))
    ocpu+=($(echo "$j" | python3 -c "import json,sys; print(json.load(sys.stdin)['cpu_total'])"))
    mv "$D/${top}_yosys-pmux.json" "$D/${top}_opt.json" 2>/dev/null || true
  done
  med() { printf '%s\n' "$@" | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}'; }
  b=$(med "${bmem[@]}"); o=$(med "${omem[@]}")
  bl=$(logic_of "$D/${top}_yosys-baseline.json"); ol=$(logic_of "$D/${top}_opt.json")
  red=$(python3 -c "print(f'{($bl-$ol)/$bl*100:.2f}%')" 2>/dev/null || echo "?")
  mem_over=$(python3 -c "print(f'{($o-$b)/$b*100:+.1f}%')" 2>/dev/null || echo "?")
  printf '  %-8s %-12s %-12s %-10s %-14s %-14s %s\n' "$top" "$bl" "$ol" "$red" "$b" "$o" "$mem_over"
  sum_red=$(python3 -c "print($sum_red + ($bl-$ol)/$bl)"); cnt=$((cnt+1))
  bigger=$(python3 -c "print(1 if $o-$b > $max_mem else 0)")
  if [ "$bigger" = "1" ]; then max_mem=$(python3 -c "print($o-$b)"); max_lut_mem="$top $mem_over"; fi
done

echo "  ----------------------------------------------------------------------------------------------------"
python3 -c "print(f'  逐用例平均缩减率：{$sum_red/$cnt*100:.2f}%')"
echo "  最大内存开销：$max_lut_mem"
echo
echo "=== 判定（内存口径，C54-2）==="
echo "  赛题阈值：峰值 ≤2GB（本机实测为数十 MB，距离阈值极远）"
echo "  效率项细则：「不超过所有指标的 5% 则得满分；超限 15% 以上本项不得分」"
