#!/usr/bin/env bash
# extract_dffeas_model.sh —— 从 Intel 单元库中只抽出 dffeas 的行为模型
#
# 目的：EQY 的 gate 端需要 \dffeas 的行为定义才能被 SAT 建模；
#       但整份 cells_sim.v 含大量无关模块，会让 EQY 报
#       "Unmatched module exists in gate that does not exist in gold"。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
DD=$(yosys-config --datdir 2>/dev/null)
SRC="$DD/intel/cycloneiv/cells_sim.v"
OUT=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/runs/eqy_ilang/dffeas_model.v
[ -f "$SRC" ] || { echo "找不到 $SRC"; exit 1; }

python3 - "$SRC" "$OUT" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
t = open(src, encoding="utf-8", errors="ignore").read()
m = re.search(r"module\s+dffeas\b.*?\nendmodule", t, re.S)
if not m:
    print("未找到 dffeas 模块"); sys.exit(1)
body = m.group(0)
open(dst, "w", encoding="utf-8").write(body + "\n")
print(f"已抽出 dffeas 模型 → {dst}（{len(body.splitlines())} 行）")
PY
echo
echo "=== 模型头部 ==="
head -20 "$OUT" | sed 's/^/  /'
