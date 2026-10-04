#!/usr/bin/env bash
# fix_dffeas_for_sat.sh —— 让 SAT 能处理 Intel 原语（dffeas / $lut）
#
# 问题：在 `begin:map_luts` 之后取网表，触发器已是 Intel 原语 `dffeas`，
#       sat 报 "No SAT model available for cell ... (dffeas)"。
# 方案：用 techmap 把 cells_sim.v 里的行为定义套回去，还原成通用触发器后再做 miter+sat。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
L=formal/verify_new
mkdir -p "$L"

echo "=== 查 cells_sim.v 里有没有 dffeas 定义 ==="
for f in "$HOME/src/yosys/techlibs/intel/cells_sim.v" "$HOME/.local/share/yosys/intel/cells_sim.v"; do
  [ -f "$f" ] && { echo "  ✓ $f"; grep -c "^module dffeas" "$f" | sed 's/^/    dffeas 定义数: /'; }
done

echo
echo "=== 试：techmap 还原后用 miter+sat 做 test4 自检（同文件比自身，应 PASS）==="
yosys -p "
read_verilog runs/verify_new/test4_gold.v
hierarchy -top test4
proc
async2sync
techmap -map +/intel/cells_sim.v
opt -fast
design -stash g
design -reset
read_verilog runs/verify_new/test4_gold.v
hierarchy -top test4
proc
async2sync
techmap -map +/intel/cells_sim.v
opt -fast
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq 5 -set-init-zero miter
" > "$L/fix_test.log" 2>&1
echo "  rc=$?"
grep -E "No SAT model|SAT proof finished|ERROR" "$L/fix_test.log" | tail -3 | sed 's/^/  /'
