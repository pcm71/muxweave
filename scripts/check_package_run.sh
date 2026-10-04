#!/usr/bin/env bash
# check_package_run.sh —— 排查包内二进制为何跑不起来
set -uo pipefail
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
PKG="$P/dist/pmux-submission-$(date +%Y%m%d)"
cd "$PKG" || { echo "找不到 $PKG"; exit 1; }

echo "=== 包内结构 ==="
find . -maxdepth 2 -type d | sort | sed 's/^/  /'
echo
echo "=== 直接运行包内 yosys ==="
./bin/yosys -V 2>&1 | head -3 | sed 's/^/  /'
echo
echo "=== 跑 test4（看真实报错）==="
./bin/yosys -p "
read_verilog evidence/test4.v
hierarchy -top test4
synth_intel -family cycloneiv -top test4
stat
" 2>&1 | tail -12 | sed 's/^/  /'
