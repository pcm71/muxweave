#!/usr/bin/env bash
# try_no_timing.sh —— 路线 B+D：去掉 -W 时序管理器
#
# 依据（从 abc9 生成的 abc.script 实测）：
#   * `-W 300` 会挂上 **timing manager**；abc9 的 `&mfs` 正因它而报
#     "Timing manager is given but there is no GIA of boxes" 而**每次都失败**；
#   * 同一管理器也让 `&if` 变成**延迟优先**映射（日志里 Del = 602.00），
#     产出大量窄 LUT —— 而 Cyclone IV 里窄/宽 LUT 成本相同。
# ⇒ 去掉 -W 后：映射应更偏面积，且 `&mfs`（don't-care 重综合）可能开始工作。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/no_timing
S=configs/abc_scripts/notm
mkdir -p "$D" "$S"

PREFIX='&scorr
&sweep
&dc2
&dch -f -r
&ps'
mk() { local n="$1"; shift; { echo "$PREFIX"; printf '%s\n' "$@"; } > "$S/$n.abc"; }

mk n1_noW_if       "&if -v"
mk n2_noW_ifa      "&if -a -v"
mk n3_noW_ifa_mfs  "&if -a -v" "&mfs"
mk n4_noW_ifa_mfsd "&if -a -v" "&mfsd"
mk n5_W_if_mfs     "&if -W 300 -a -v" "&mfs"      # 对照：带 -W 时 &mfs 应失败

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

run() { # $1=case $2=abc9 额外参数 $3=脚本 $4=标签
  yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -lut 4 $2 -script $3
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$4.json stat -json
" > "$D/$1_$4.log" 2>&1
  logic_of "$D/$1_$4.json"
}

echo "=== 去掉/保留 -W 的效果（LUT 逻辑单元）==="
printf '  %-34s %6s %6s %6s %6s\n' "配置" "test1" "test2" "test3" "test4"
echo "  ------------------------------------------------------------------"
printf '  %-34s %6s %6s %6s %6s\n' "abc9 官方（带 -W 300，无脚本）" \
  "$(run test1 '' '' o1)" "$(run test2 '' '' o1)" "$(run test3 '' '' o1)" "$(run test4 '' '' o1)"

for spec in "n1_noW_if|abc9 无 -W + &if -v" \
            "n2_noW_ifa|abc9 无 -W + &if -a -v" \
            "n3_noW_ifa_mfs|abc9 无 -W + &if -a + &mfs" \
            "n4_noW_ifa_mfsd|abc9 无 -W + &if -a + &mfsd" \
            "n5_W_if_mfs|abc9 带 -W + &if -a + &mfs"; do
  tag="${spec%%|*}"; label="${spec##*|}"
  printf '  %-34s' "$label"
  for case in test1 test2 test3 test4; do
    printf '%6s' "$(run $case "" "$S/$tag.abc" "$tag")"
  done
  echo
done

echo
echo "=== 检查 &mfs 是否真的跑起来了（看日志里是否仍报 no GIA of boxes）==="
for tag in n3_noW_ifa_mfs n5_W_if_mfs; do
  if grep -q "no GIA of boxes" "$D/test4_$tag.log" 2>/dev/null; then
    echo "  $tag: ✗ 仍报 no GIA of boxes"
  else
    echo "  $tag: ✓ 未见该报错（&mfs 可能已生效）"
  fi
done
