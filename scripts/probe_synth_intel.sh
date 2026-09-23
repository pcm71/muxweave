#!/usr/bin/env bash
# probe_synth_intel.sh —— 提取 synth_intel 内部实际执行的 pass 序列
# 目的：解释实验中"B1（叠加 opt/opt_reduce/opt_merge/opt_muxtree/opt_share）与 B0 结果完全相同"的原因。
# 结论写进 runs/synth_intel_flow.txt
export PATH="$HOME/.local/bin:$PATH"
OUT=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/runs/synth_intel_flow.txt
Y="$HOME/src/yosys"
mkdir -p "$(dirname "$OUT")"
{
  echo "############ synth_intel 内部流程探查 ############"
  echo
  echo "=== 1) 源码文件位置 ==="
  find "$Y/techlibs" -name "synth_intel*" 2>/dev/null
  echo
  F=$(find "$Y/techlibs" -name "synth_intel.cc" | head -1)
  echo "=== 2) 源码里调用的 pass（$F）==="
  grep -nE 'run\("' "$F" 2>/dev/null | sed 's/^/  /' | head -60
  echo
  echo "=== 3) 其中的优化相关 pass ==="
  grep -oE 'run\("[a-z_0-9]+' "$F" 2>/dev/null | sed 's/run("//' | sort -u | sed 's/^/  /'
  echo
  echo "=== 4) yosys 自报的 synth_intel 说明（含 -run 流程）==="
  yosys -p "help synth_intel" 2>&1 | sed -n '1,120p'
} > "$OUT" 2>&1
echo "已写出 $OUT ($(wc -l < "$OUT") 行)"
