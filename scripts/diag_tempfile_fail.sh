#!/usr/bin/env bash
# diag_tempfile_fail.sh —— 复现临时文件候选策略导致的失败
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd /mnt/c/Users/LEGION/Desktop/PMUX/muxweave || exit 1
for c in test1 test3 test4; do
  echo "=== $c ==="
  yosys -p "
read_verilog benchmarks/official/$c.v
hierarchy -top $c
synth_intel -family cycloneiv -top $c
stat -json
" 2>&1 | grep -E "ERROR|Error:|pmux_opt:" | tail -6 | sed 's/^/  /'
done
