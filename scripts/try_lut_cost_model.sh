#!/usr/bin/env bash
# try_lut_cost_model.sh —— 路线 C：用 LUT 成本模型逼 ABC 少用窄 LUT
#
# 依据（刚实测）：Cyclone IV 里 W2/W3/W4 LUT **成本相同**（都占 1 个 LCELL），
#   但 abc9 在 test2 上产出 15×W3 + 5×W4 —— 本可合并成 10×W4。
#   原因是 ABC 默认按"最优延迟"映射，倾向用窄 LUT。
#   ⇒ 用 `-luts` 显式指定各宽度成本，把窄 LUT 定贵、宽 LUT 定便宜。
#
# 同时尝试：`-lut w1:w2` 形式（宽度 ≤w1 成本恒定）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/lut_cost
mkdir -p "$D"

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

run() { # $1=case $2=abc9 参数 $3=标签
  yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -script configs/abc_scripts/a9_a_F5.abc $2
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$3.json stat -json
" > "$D/$1_$3.log" 2>&1
  logic_of "$D/$1_$3.json"
}

echo "=== 路线 C：LUT 成本模型实验（逐用例 LUT 逻辑单元）==="
printf '  %-30s %6s %6s %6s %6s\n' "配置" "test1" "test2" "test3" "test4"
echo "  ------------------------------------------------------------------"
declare -a CONFIGS=(
  "-lut 4|-lut 4（官方，基准）"
  "-luts 2,2,2,1|-luts 2,2,2,1（窄贵宽便宜）"
  "-luts 4,4,4,1|-luts 4,4,4,1（更强偏好宽）"
  "-luts 1,2,3,1|-luts 1,2,3,1（递增成本）"
  "-lut 2:4|-lut 2:4（≤2 定成本，更大翻倍）"
  "-lut 1:4|-lut 1:4（≤1 定成本）"
)
for c in "${CONFIGS[@]}"; do
  args="${c%%|*}"; label="${c##*|}"
  printf '  %-30s' "$label"
  for case in test1 test2 test3 test4; do
    printf '%6s' "$(run $case "$args" "$(echo "$args" | tr ' ,:-' '____')")"
  done
  echo
done

echo
echo "=== 附：从 test2（无触发器 ⇒ 无 box）取 &if 的完整参数表 ==="
rm -rf _tmp_yosys-abc-* 2>/dev/null
yosys -q -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2 -run begin:map_luts
abc9 -lut 4 -W 300 -showtmp -nocleanup
" > /dev/null 2>&1
XAIG=$(ls -d _tmp_yosys-abc-* 2>/dev/null | head -1)
if [ -n "${XAIG:-}" ] && [ -f "$XAIG/input.xaig" ]; then
  yosys-abc -c "&read $XAIG/input.xaig; &if -h" 2>&1 | head -40 | sed 's/^/  /'
else
  echo "  未取到 input.xaig"
fi
