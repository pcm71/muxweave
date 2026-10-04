#!/usr/bin/env bash
# diag_36_vs_24.sh —— 根因诊断：为什么 abc9 给 36 个 LUT，经典 abc 给 24 个？
#
# 做法：把经典流程拆成"逐步叠加"的脚本，看每一步各贡献多少，从而定位差距来源。
#   步骤拆解（经典域）：
#     strash            结构哈希（去重）
#     dch -f            结构选择（等价合并）
#     if                技术映射到 LUT4
#     mfs2              **don't-care 重综合**  ← 疑似关键（abc9 的 &mfs 100% 失效）
#     lutpack -S 1      **LUT 打包/合并**      ← 疑似关键（abc9 的 GIA 域没有）
#
# 注意：本脚本用经典 abc 只是为了**诊断找出差距来源**，不是候选方案（换映射器违反 C53-1）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/diag_36_24
S=configs/abc_scripts/diag
mkdir -p "$D" "$S"

# 生成逐步叠加的经典脚本（注意：第一个参数是文件名，不能写进内容）
mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk d0_map          "strash" "dch -f" "if"
mk d1_mfs2         "strash" "dch -f" "if" "mfs2"
mk d2_lutpack      "strash" "dch -f" "if" "lutpack -S 1"
mk d3_mfs2_lutpack "strash" "dch -f" "if" "mfs2" "lutpack -S 1"

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

seg() { # $1=case $2=映射命令 $3=标签
  yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
$2
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$3.json stat -json
" > "$D/$1_$3.log" 2>&1
  logic_of "$D/$1_$3.json"
}

for case in test4 test3 test2 test1; do
  echo "=== $case ==="
  printf '  %-34s %s\n' "abc9 默认（官方路径）"      "$(seg $case 'abc9 -lut 4 -W 300' abc9)"
  printf '  %-34s %s\n' "abc9 + 面积脚本 -a -F 5"    "$(seg $case 'abc9 -lut 4 -script configs/abc_scripts/a9_a_F5.abc' abc9a)"
  printf '  %-34s %s\n' "经典: strash/dch/if"        "$(seg $case "abc -lut 4 -script $S/d0_map.abc" d0)"
  printf '  %-34s %s\n' "经典: + mfs2（don't-care）" "$(seg $case "abc -lut 4 -script $S/d1_mfs2.abc" d1)"
  printf '  %-34s %s\n' "经典: + lutpack（打包）"    "$(seg $case "abc -lut 4 -script $S/d2_lutpack.abc" d2)"
  printf '  %-34s %s\n' "经典: + mfs2 + lutpack"     "$(seg $case "abc -lut 4 -script $S/d3_mfs2_lutpack.abc" d3)"
  echo
done

echo "=== 归因读法 ==="
echo "  经典 d0 → d1 的差 = mfs2（don't-care 化简）的贡献 ⇒ 对应路线 B"
echo "  经典 d0 → d2 的差 = lutpack（LUT 打包）的贡献      ⇒ 对应路线 A"
echo "  abc9 与 经典 d0 的差 = 映射器/算法本身的差"
