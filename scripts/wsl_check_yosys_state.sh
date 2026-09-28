#!/usr/bin/env bash
# check_yosys_src_state.sh —— 确认 WSL 里 Yosys 源码树与自研 pass 的现状
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
Y="$HOME/src/yosys"
echo "=== 已安装 yosys ==="
command -v yosys && yosys -V
echo
echo "=== 自研 pass 是否已编进主程序 ==="
yosys -p "help pmux_analyze" 2>&1 | grep -E "^    pmux_analyze|Not a valid" | head -2
yosys -p "help pmux_opt" 2>&1 | grep -E "^    pmux_opt|Not a valid" | head -2
echo
echo "=== 源码树 ==="
cd "$Y" || { echo "源码树不存在: $Y"; exit 1; }
git -C "$Y" status --short | head -20
echo "--- 已修改文件数: $(git -C "$Y" status --short | wc -l) ---"
echo
echo "=== passes 目录下的自研文件 ==="
ls -la "$Y/passes/pmux" 2>/dev/null || ls -la "$Y/passes" | grep -i pmux
echo
echo "=== passes/CMakeLists.txt 里的 pmux 注册 ==="
grep -n "pmux" "$Y"/passes/CMakeLists.txt "$Y"/passes/*/CMakeLists.txt 2>/dev/null | head -10
echo
echo "=== synth_intel.cc 里 abc9 那一行 ==="
grep -n "abc9\|map_luts\|map_cells" "$Y/techlibs/intel/synth_intel.cc" | head -20
echo
echo "=== 构建目录状态 ==="
ls -d "$Y/build" 2>/dev/null && du -sh "$Y/build" 2>/dev/null
