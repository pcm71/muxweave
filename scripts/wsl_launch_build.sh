#!/usr/bin/env bash
# wsl_launch_build.sh —— 工具链预检 + 后台启动 Yosys/EQY 构建
# 用法（在 Windows 侧调用，避免引号嵌套问题）：
#   wsl -e bash /mnt/c/Users/LEGION/Desktop/PMUX/muxweave/scripts/wsl_launch_build.sh
set -uo pipefail
cd /mnt/c/Users/LEGION/Desktop/PMUX/muxweave || exit 1
mkdir -p runs

echo "=== 工具链预检 ==="
missing=0
for t in cmake g++ bison flex python3 make git; do
  if command -v "$t" >/dev/null 2>&1; then
    printf '%-8s OK   %s\n' "$t" "$(command -v "$t")"
  else
    printf '%-8s MISSING\n' "$t"; missing=1
  fi
done
command -v cmake >/dev/null 2>&1 && cmake --version | head -1
command -v g++   >/dev/null 2>&1 && g++ --version | head -1
command -v bison >/dev/null 2>&1 && bison --version | head -1
if [ -e /usr/include/tcl.h ]; then echo "tcl.h    OK"; else echo "tcl.h    MISSING（Tcl 命令会不可用，建议装 tcl-dev）"; fi
[ -e /usr/include/zlib.h ] && echo "zlib.h   OK" || echo "zlib.h   MISSING"
[ -e /usr/include/ffi.h ] && echo "ffi.h    OK" || echo "ffi.h    MISSING"

if [ "$missing" -ne 0 ]; then
  echo
  echo "!!! 工具链不完整，未启动构建。请先运行："
  echo "    sudo apt update && sudo apt install -y cmake ninja-build build-essential clang lld bison flex gawk git make python3 pkg-config libffi-dev libfl-dev libreadline-dev tcl-dev zlib1g-dev graphviz xdot"
  exit 9
fi

echo
echo "=== 启动后台构建（日志 runs/build_yosys.log）==="
nohup bash scripts/wsl_build_yosys.sh > runs/build_yosys.log 2>&1 &
BUILD_PID=$!
echo "PID=$BUILD_PID"
sleep 10
echo "=== 日志开头 ==="
head -40 runs/build_yosys.log
echo
echo "=== 查看进度： tail -f /mnt/c/Users/LEGION/Desktop/PMUX/muxweave/runs/build_yosys.log ==="
