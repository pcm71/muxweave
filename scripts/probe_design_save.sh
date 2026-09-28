#!/usr/bin/env bash
# probe_design_save.sh —— 确认 Yosys `design -save/-load` 的语义
#
# 用途：pmux_opt 要在同一个进程里试跑多个映射候选并恢复未映射状态，
#       必须确切知道 -save 是否可重名、-load 是否消耗存档、以及能否在循环里"恢复→再备份"。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs
OUT=runs/design_save_probe.txt

{
  echo "=========== help design 原文 ==========="
  yosys -p "help design" 2>&1 | sed -n '1,80p'
  echo
  echo "=========== 语义测试：循环内 恢复→备份→改网表 ==========="
  yosys -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
proc
design -save pre
abc9 -lut 4 -W 300
tee -o runs/ds_cand0.json stat -json
design -save cand0
design -load pre
abc -lut 4 -script configs/abc_scripts/c_full.abc
tee -o runs/ds_cand1.json stat -json
design -save cand1
design -load pre
abc -lut 4 -script configs/abc_scripts/c_min.abc
tee -o runs/ds_cand2.json stat -json
design -save cand2
design -load cand1
stat
" 2>&1 | tail -30
} > "$OUT" 2>&1

echo "已写出 $OUT"
echo
sed -n '/help design 原文/,/语义测试/p' "$OUT" | head -60
echo "..."
sed -n '/语义测试/,$p' "$OUT" | tail -25
echo
echo "=== 三个候选的单元数 ==="
for f in runs/ds_cand0.json runs/ds_cand1.json runs/ds_cand2.json; do
  [ -f "$f" ] && python3 -c "
import json;d=json.load(open('$f'));print('  $f ->', d['design']['num_cells'], 'cells')"
done
