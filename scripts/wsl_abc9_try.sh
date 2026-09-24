#!/usr/bin/env bash
# wsl_abc9_try.sh —— 快速试 abc9 脚本变体（不进 pipelines.json，便于快速迭代）
#
# 用法: bash scripts/wsl_abc9_try.sh [脚本文件1 脚本文件2 ...]
#       不带参数则跑内置的一组变体。
#
# 背景：官方 abc9 的默认脚本是
#   &scorr; &sweep; &dc2; &dch -f -r; &ps; &if {W} {D} {R} -v; &mfs
# 其中 `&mfs` 在本版本**每次都报错失效**。而经典 abc 脚本里对应位置有
# `mfs2`（don't-care 优化）与 `lutpack -S 1`（LUT 打包）—— 这两步在 abc9 流程里是**缺失**的。
# 本脚本验证：把这两步补进 abc9 流程（经 &put / &get -n 切换 ABC 域）能否把面积收益找回来，
# 同时保持 abc9 的低开销。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs/abc9try

# 用法: MAPPER=abc9 bash scripts/wsl_abc9_try.sh [脚本文件...]   （默认 abc9）
#       MAPPER=abc  bash scripts/wsl_abc9_try.sh [脚本文件...]   （经典 abc，用于隔离各步骤的收益/成本）
MAPPER="${MAPPER:-abc9}"
SCRIPTS="$*"
[ -n "$SCRIPTS" ] || SCRIPTS="configs/abc_scripts/abc9_stock.abc configs/abc_scripts/abc9_area.abc configs/abc_scripts/abc9_mfs2.abc configs/abc_scripts/abc9_lutpack.abc configs/abc_scripts/abc9_mfs2_lutpack.abc configs/abc_scripts/abc9_area_mfs2.abc configs/abc_scripts/abc9_fraig.abc"

CASES=$(ls benchmarks/official/*.v)

echo "映射器：$MAPPER"
echo "脚本变体："
for s in $SCRIPTS; do echo "  - $s"; done
echo
printf '%-34s' "用例"
for s in $SCRIPTS; do printf '%14s' "$(basename "$s" .abc)"; done
printf '%10s\n' "B0参考"

# 先取 B0 参考值
declare -A B0
for v in $CASES; do
  name=$(basename "$v" .v)
  d="runs/abc9try/b0_${name}"
  mkdir -p "$d"
  yosys -q -p "read_verilog $v; hierarchy -top $name; synth_intel -family cycloneiv -top $name; tee -o $d/stat.json stat -json" > "$d/log" 2>&1
  B0[$name]=$(python3 -c "
import json,sys
d=json.load(open('$d/stat.json'))
print(d['design']['num_cells'])" 2>/dev/null || echo "?")
done

for v in $CASES; do
  name=$(basename "$v" .v)
  printf '%-34s' "$name"
  for s in $SCRIPTS; do
    tag=$(basename "$s" .abc)
    d="runs/abc9try/${tag}_${name}"
    mkdir -p "$d"
    yosys -q -p "
read_verilog $v
hierarchy -top $name
synth_intel -family cycloneiv -top $name -run begin:map_luts
$MAPPER -lut 4 -script $s
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $name -run map_cells:check
tee -o $d/stat.json stat -json
" > "$d/log" 2>&1
    val=$(python3 -c "
import json
try:
    d=json.load(open('$d/stat.json'))
    print(d['design']['num_cells'])
except Exception:
    print('FAIL')" 2>/dev/null || echo "FAIL")
    printf '%14s' "$val"
  done
  printf '%10s\n' "${B0[$name]}"
done

echo
echo "注：B0 列为官方基线参考值；其余列为各 abc9 脚本变体。数值越小越好。"
