#!/usr/bin/env bash
# check_candidates.sh —— 确认已安装 yosys 里的候选池（新加的 &rrr 候选是否生效）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd /mnt/c/Users/LEGION/Desktop/PMUX/muxweave || exit 1
yosys -p "
read_verilog benchmarks/official/test3.v
hierarchy -top test3
synth_intel -family cycloneiv -top test3
" 2>&1 | grep -E "pmux_opt" | head -10
echo "--- 结果 ---"
yosys -q -p "
read_verilog benchmarks/official/test3.v
hierarchy -top test3
synth_intel -family cycloneiv -top test3
tee -o /tmp/t3.json stat -json
" > /dev/null 2>&1
python3 -c "
import json
d=json.load(open('/tmp/t3.json')); nbt=d['design']['num_cells_by_type']
seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
print('test3 逻辑单元 =', d['design']['num_cells']-seq, '（期望 11）')"
