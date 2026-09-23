#!/usr/bin/env bash
# wsl_pass_battery.sh —— "已有能力电池"：逐个测试 Yosys 自带结构化 pass 能否比 B0 省单元
#
# 背景：已验证「跨位分组 + 共享选择」在 synth_intel 后端下收益为 0；
#       而 B1（opt + opt_reduce -fine/opt_merge/opt_muxtree/opt_share）与 B0 完全等价。
# 目的：用穷举法定位"官方后端到底还有没有没吃掉的优化空间"，
#       为第 2 周调整算法抓手提供证据（方案第 2 周去留判据 / 第 19 节退路）。
#
# 判据：任何 P_* 的合计逻辑单元 < B0，就说明那条路线有空间，值得深挖。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs reports

PIPELINES="B0 P_pmux2shiftx P_muxpack P_share P_opt_reduce_fine P_muxtree P_wreduce P_pmx2s_muxpack"
CASES=$(ls benchmarks/unit/u0*.v benchmarks/mixed/m0*.v 2>/dev/null)

echo "=== 清空这些 pipeline 的旧结果 ==="
for p in $PIPELINES; do rm -rf runs/*__${p}__* 2>/dev/null; done

total=0; fail=0
for pipe in $PIPELINES; do
  echo
  echo "##################### $pipe #####################"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/bat_${pipe}_${name}.log" 2>&1; then
      printf '  %-30s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/bat_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1))
      printf '  %-30s FAIL\n' "$name"
      tail -4 "runs/bat_${pipe}_${name}.log" | sed 's/^/      /'
    fi
  done
done
echo
echo "=== 共 $total 次运行，失败 $fail ==="

echo
echo "=== 汇总对比（相对 B0）==="
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
print(f"{'用例':<36}" + "".join(f"{p[:13]:>14}" for p in pipes))
totals = {p: 0 for p in pipes}
for c in cases:
    line = f"{c:<36}"
    for p in pipes:
        v = latest.get((c, p), {}).get("base_logic_cells")
        totals[p] += v or 0
        line += f"{str(v):>14}"
    print(line)
print("-" * (36 + 14*len(pipes)))
line = f"{'合计':<36}"
base = totals["B0"]
for p in pipes:
    diff = base - totals[p]
    mark = "" if diff == 0 else (f" 省{diff}" if diff > 0 else f" 多{-diff}")
    line += f"{str(totals[p]) + mark:>14}"
    _ = mark
print(line)
print()
print("=== 逐 pipeline 判定 ===")
for p in pipes:
    if p == "B0":
        continue
    d = base - totals[p]
    if d > 0:
        print(f"  ★ {p:<20} 比 B0 省 {d} 个单元  → 有空间，值得深挖")
    elif d == 0:
        print(f"    {p:<20} 与 B0 持平  → 该能力已被官方后端覆盖")
    else:
        print(f"    {p:<20} 比 B0 多 {-d} 个  → 劣化，排除")
PY
