#!/usr/bin/env bash
# wsl_build_baseline.sh —— 编译出"真基线二进制"，用于官方口径的效率对比
#
# 官方口径（Q&A 09.11 / 09.20）：
#   "加优化算法编译的程序与原始代码编译的程序在同一个环境下运行进行比较"
#   ⇒ 必须拿**同一源码树、仅不启用我们的优化调用**编译出的二进制做基线，
#     而不是用"分段脚手架"凑一个近似基线。
#
# 做法（全程可回退，关键步骤都做校验）：
#   1. 把当前（优化版）构建产物另存为 yosys-pmux
#   2. 用 synth_intel.cc.orig 还原 → 编译 → 另存为 yosys-baseline
#   3. 重新打补丁（调用 wsl_integrate_pass.sh 的幂等逻辑）→ 编译 → 恢复优化版
#   4. 校验两个二进制的差异：基线不调用 pmux_opt，优化版调用
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
Y="$HOME/src/yosys"
BIN="$P/runs/binaries"
mkdir -p "$BIN"
cd "$Y" || exit 1

echo "=== 0) 前置检查 ==="
[ -f techlibs/intel/synth_intel.cc.orig ] || { echo "✗ 缺少 .orig 备份，终止"; exit 1; }
grep -q "pmux_opt" techlibs/intel/synth_intel.cc && echo "  ✓ 当前源码为优化版（含 pmux_opt 调用）" || { echo "✗ 当前源码不含 pmux_opt"; exit 1; }
[ -f build/yosys ] || { echo "✗ 未找到 build/yosys"; exit 1; }

echo
echo "=== 1) 另存当前（优化版）构建产物 ==="
cp build/yosys "$BIN/yosys-pmux"
chmod +x "$BIN/yosys-pmux"
"$BIN/yosys-pmux" -V | head -1 | sed 's/^/  /'
echo "  已存: $BIN/yosys-pmux"

echo
echo "=== 2) 还原为原始 synth_intel.cc 并编译基线 ==="
cp techlibs/intel/synth_intel.cc techlibs/intel/synth_intel.cc.pmux-backup
cp techlibs/intel/synth_intel.cc.orig techlibs/intel/synth_intel.cc
grep -c "pmux_opt" techlibs/intel/synth_intel.cc | sed 's/^/  还原后源码中 pmux_opt 出现次数: /'
cmake --build build -j5 2>&1 | tail -2
cp build/yosys "$BIN/yosys-baseline"
chmod +x "$BIN/yosys-baseline"
echo "  已存: $BIN/yosys-baseline"

echo
echo "=== 3) 恢复优化版并重新编译 ==="
cp techlibs/intel/synth_intel.cc.pmux-backup techlibs/intel/synth_intel.cc
grep -c "pmux_opt" techlibs/intel/synth_intel.cc | sed 's/^/  恢复后源码中 pmux_opt 出现次数: /'
cmake --build build -j5 2>&1 | tail -2
cp build/yosys "$BIN/yosys-pmux"
cmake --install build 2>&1 | tail -1

echo
echo "=== 4) 校验两个二进制行为差异（关键）==="
cd "$P" || exit 1
for b in yosys-baseline yosys-pmux; do
  echo "--- $b ---"
  "$BIN/$b" -q -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2
tee -o runs/binaries/${b}_test2.json stat -json
" > "runs/binaries/${b}_test2.log" 2>&1
  calls=$(grep -c "pmux_opt" "runs/binaries/${b}_test2.log" 2>/dev/null || echo 0)
  cells=$(python3 -c "
import json
try:
    d=json.load(open('runs/binaries/${b}_test2.json')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(x in k.lower() for x in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')")
  printf '  调用 pmux_opt 次数=%s   逻辑单元=%s\n' "$calls" "$cells"
done
echo
echo "预期：baseline 调用 0 次、逻辑单元 25（官方基线）；pmux 调用 >0 次、逻辑单元 15"
echo
echo "回退方式：若需撤销，把 $Y/techlibs/intel/synth_intel.cc.pmux-backup 复制回 synth_intel.cc 重编即可；"
echo "          原始备份在 $Y/techlibs/intel/synth_intel.cc.orig"
