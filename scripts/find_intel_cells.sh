#!/usr/bin/env bash
# find_intel_cells.sh —— 找 Intel 单元模型文件（EQY 验证需要）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
echo "=== yosys 数据目录 ==="
yosys-config --datdir 2>/dev/null | sed 's/^/  /'
DD=$(yosys-config --datdir 2>/dev/null)
echo
echo "=== intel 目录内容 ==="
ls "$DD/intel" 2>/dev/null | sed 's/^/  /'
echo
echo "=== 含 dffeas 定义的文件 ==="
grep -rl "module dffeas" "$DD" 2>/dev/null | head -5 | sed 's/^/  /'
echo
echo "=== 源码树里的 Intel 单元模型 ==="
ls ~/src/yosys/techlibs/intel/*.v 2>/dev/null | sed 's/^/  /'
grep -l "module dffeas" ~/src/yosys/techlibs/intel/*.v 2>/dev/null | sed 's/^/  含 dffeas: /'
