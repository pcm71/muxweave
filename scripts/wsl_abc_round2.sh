#!/usr/bin/env bash
# wsl_abc_round2.sh —— 第 2 轮 ABC：先做等价性验证，再扫 ABC 脚本变体
#
#   bash scripts/wsl_abc_round2.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1

echo "################################################################"
echo "### 第 1 步：换映射器的等价性验证（合规必须）"
echo "################################################################"
bash scripts/wsl_abc_equiv.sh

echo
echo "################################################################"
echo "### 第 2 步：ABC 脚本变体扫描"
echo "################################################################"
# 复用电池脚本的框架，换 pipeline 列表
PIPELINES="B0 ABC_classic ABC_noret ABC_dc2aig ABC_if_area ABC_lutpack2 ABC_nf ABC_and ABC9_noW"
CASES=$(ls benchmarks/unit/u0*.v benchmarks/mixed/m0*.v 2>/dev/null)

for p in $PIPELINES; do rm -rf runs/*__${p}__* 2>/dev/null; done

total=0; fail=0
for pipe in $PIPELINES; do
  echo
  echo "##################### $pipe #####################"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/abc2_${pipe}_${name}.log" 2>&1; then
      printf '  %-30s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/abc2_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1))
      printf '  %-30s FAIL\n' "$name"
      grep -E "ERROR|Error" "runs/abc2_${pipe}_${name}.log" | head -2 | sed 's/^/      /'
      tail -3 "runs/abc2_${pipe}_${name}.log" | sed 's/^/      /'
    fi
  done
done
echo
echo "=== 共 $total 次运行，失败 $fail ==="

echo
python3 - "$PIPELINES" <<'PY'
import json, glob, sys
pipes = sys.argv[1].split()
latest = {}
for p in glob.glob("runs/*/result.json"):
    try:
        d = json.load(open(p, encoding="utf-8"))
    except Exception:
        continue
    if d.get("fake") or d.get("pipeline") not in pipes:
        continue
    k = (d["input"], d["pipeline"])
    if k not in latest or d["run_id"] > latest[k]["run_id"]:
        latest[k] = d
cases = sorted({k[0] for k in latest})
short = [p.replace("ABC_", "").replace("ABC9_", "abc9-") for p in pipes]
print(f"{'用例':<34}" + "".join(f"{s[:11]:>12}" for s in short))
totals = {p: 0 for p in pipes}
for c in cases:
    line = f"{c:<34}"
    for p in pipes:
        v = latest.get((c, p), {}).get("base_logic_cells")
        totals[p] += v or 0
        line += f"{str(v):>12}"
    print(line)
print("-" * (34 + 12*len(pipes)))
base = totals["B0"]
line = f"{'合计':<34}"
for p in pipes:
    d = base - totals[p]
    tag = "" if d == 0 else (f" 省{d}" if d > 0 else f" 多{-d}")
    line += f"{str(totals[p]) + tag:>12}"
print(line)
print()
print("=== 判定（基准 B0 = %d）===" % base)
best = None
for p in pipes:
    if p == "B0":
        continue
    if totals[p] == 0:
        print(f"    {p:<14} 【无效】全部失败（选项/脚本语法不被支持）")
        continue
    d = base - totals[p]
    if d > 0:
        print(f"  ★ {p:<14} 省 {d} 个（{100*d/base:.1f}%）")
        if best is None or totals[p] < totals[best]:
            best = p
    elif d == 0:
        print(f"    {p:<14} 持平")
    else:
        print(f"    {p:<14} 多 {-d} 个")
if best:
    print(f"\n>>> 本轮最优：{best}（{totals[best]}，比 B0 省 {base-totals[best]}）")
PY
