#!/usr/bin/env bash
# probe_abc_options.sh —— 直接问 ABC 要 if / &if / lutpack / mfs2 的准确选项
# 目的：扩大候选池需要精确的参数空间，不能靠猜（上一轮 -script 写法猜错，白跑 56 次）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs
OUT=runs/abc_options.txt
ABC_BIN=$(command -v yosys-abc || echo "$HOME/.local/bin/yosys-abc")
echo "ABC 可执行文件：$ABC_BIN"

{
  echo "===== ABC 版本 ====="
  "$ABC_BIN" -c "version" 2>&1 | head -3
  # 注意：ABC 的 `help <cmd>` 只打印总帮助，取某个命令的选项要用 `<cmd> -h`
  for cmd in "if" "&if" "lutpack" "mfs2" "dch" "&dch" "resub" "&resub" "&nf" "&dc2" "fx" "map"; do
    echo
    echo "===== $cmd -h ====="
    "$ABC_BIN" -c "$cmd -h" 2>&1 | head -30
  done
} > "$OUT" 2>&1

echo "已写出 $OUT（$(wc -l < "$OUT") 行）"
echo
sed -n '1,80p' "$OUT"
