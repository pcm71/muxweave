#!/usr/bin/env bash
# wsl_refresh_binaries.sh —— 改完 pass 后重建并刷新两个二进制
#   yosys-baseline：原始 synth_intel（不调用 pmux_opt），若不存在则用 wsl_build_baseline.sh 生成
#   yosys-pmux    ：当前构建产物（调用 pmux_opt）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
Y="$HOME/src/yosys"
BIN="$P/runs/binaries"
mkdir -p "$BIN"

cd "$Y" || exit 1
echo "=== 编译 ==="
cmake --build build -j5 2>&1 | tail -2
[ -f build/yosys ] || { echo "✗ 编译失败"; exit 1; }

echo
echo "=== 刷新优化版二进制 ==="
cp build/yosys "$BIN/yosys-pmux";  chmod +x "$BIN/yosys-pmux"
cp build/yosys "$HOME/.local/bin/yosys-pmux"; chmod +x "$HOME/.local/bin/yosys-pmux"
cmake --install build 2>&1 | tail -1
echo "  ✓ $BIN/yosys-pmux 与 ~/.local/bin/yosys-pmux 已更新"

echo
echo "=== 确保基线二进制存在（与已安装 yosys 同级，才能解析 share 目录）==="
if [ ! -f "$HOME/.local/bin/yosys-baseline" ]; then
  echo "  基线不存在，调用 wsl_build_baseline.sh 生成"
  bash "$P/scripts/wsl_build_baseline.sh" > /dev/null 2>&1 || { echo "  ✗ 基线生成失败"; exit 1; }
fi
ls -la "$HOME/.local/bin/yosys-baseline" | sed 's/^/  /'

echo
echo "=== 快速校验：test1 现在应走 abc9（护栏生效）==="
cd "$P" || exit 1
~/.local/bin/yosys-pmux -p "
read_verilog benchmarks/official/test1.v
hierarchy -top test1
synth_intel -family cycloneiv -top test1
" 2>&1 | grep -E "pmux_opt:|Executing ABC|abc9" | head -8 | sed 's/^/  /'
