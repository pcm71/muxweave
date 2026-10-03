#!/usr/bin/env bash
# diag_test4_cex2.sh —— 取反例模型（不静默，才能看到输入/输出取值）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/netlist_official
L=formal/miter/logs
mkdir -p "$L"

yosys -p "
read_verilog $D/test4_ctrl_abc9.v
hierarchy -top test4
design -stash g
design -reset
read_verilog $D/test4_target.v
hierarchy -top test4
design -stash e
design -copy-from g -as gold test4
design -copy-from e -as gate test4
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -prove-asserts -seq 2 -set-init-zero -show-inputs -show-outputs miter
" > "$L/cex2.log" 2>&1
rc=$?
echo "rc=$rc"
echo "=== 日志中 %%% 提示 / 模型段落 ==="
awk '/SAT solving finished|Solving problem|Model|model|%%%|assert|Input|Output/{print}' "$L/cex2.log" | head -40
echo
echo "=== 日志尾部 45 行（模型在这里）==="
tail -45 "$L/cex2.log"
