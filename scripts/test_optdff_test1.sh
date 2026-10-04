#!/usr/bin/env bash
# test_optdff_test1.sh —— test1 专攻：让"保持"由触发器使能承担，而不是压在 LUT 里
#
# 依据（最终网表实测）：192 个 dffeas 的 ena 连的是 **全局** !reset，
#   而 i0..i7、q0..q7 这 16 个寄存器（192 位）**只在 START 加载、其余状态保持**。
#   ⇒ "保持"只能压在 D 逻辑里做成反馈选择器（每位约 1 个 LUT4）。
#   若改用**每位各自的使能**（!reset && state==START），这些 LUT 就能省掉。
#
# 本脚本在 abc9 之前插入各种"让使能浮现"的处理，看 LUT 是否下降。
# 注意：测量必须走完整流程到 map_cells 之后再 stat（中途 stat 会得到空设计）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/optdff_test1
mkdir -p "$D"
S=configs/abc_scripts/nkl/n_win.abc

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}

run() { # $1=case $2=前置 pass $3=标签
  timeout 300 yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
$2
abc9 -lut 4 -script $S
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$3.json stat -json
" > "$D/$1_$3.log" 2>&1
  [ $? -eq 124 ] && { echo "TIMEOUT"; return; }
  logic_of "$D/$1_$3.json"
}

echo "=== test1：在 abc9 之前尝试让触发器使能浮现（格式 逻辑/DFF）==="
printf '  %-30s %s\n' "前置处理" "test1"
echo "  ----------------------------------------"
printf '  %-30s %s\n' "（无）" "$(run test1 '' base)"
printf '  %-30s %s\n' "opt_dff" "$(run test1 'opt_dff' dff)"
printf '  %-30s %s\n' "opt_dff -sat" "$(run test1 'opt_dff -sat' dffsat)"
printf '  %-30s %s\n' "opt -full" "$(run test1 'opt -full' optfull)"
printf '  %-30s %s\n' "opt -full; opt_dff" "$(run test1 'opt -full; opt_dff' full_dff)"
printf '  %-30s %s\n' "opt_clean; opt_dff -sat; opt_clean" "$(run test1 'opt_clean; opt_dff -sat; opt_clean' c_dff_c)"
printf '  %-30s %s\n' "pmuxtree; opt_dff" "$(run test1 'opt_muxtree; opt_dff' muxtree_dff)"
printf '  %-30s %s\n' "wreduce; opt_dff" "$(run test1 'wreduce; opt_dff' wreduce_dff)"

echo
echo "=== 顺带记录 test2/3/4 在 opt_dff 下的表现（避免顾此失彼）==="
for c in test2 test3 test4; do
  printf '  %-8s 无=%s  opt_dff=%s\n' "$c" "$(run $c '' base)" "$(run $c 'opt_dff' dff)"
done
