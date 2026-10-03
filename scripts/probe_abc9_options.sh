#!/usr/bin/env bash
# probe_abc9_options.sh —— 查 abc9 顶层选项含义（尤其 -W / -D / -l / -p / -x / -b）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs
OUT=runs/help_abc9.txt

yosys -p "help abc9" > "$OUT" 2>&1
echo "=== abc9 选项表 ==="
sed -n '1,80p' "$OUT"
