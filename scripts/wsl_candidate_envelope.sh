#!/usr/bin/env bash
# wsl_candidate_envelope.sh —— 候选池 + 逐用例取最优（方案第 8 节「有限候选与映射反馈」）
#
# 为什么必须这么做（实测驱动，不是设计偏好）：
#   调优脚本 if -a 在 l03 上省 13.1%，却在 l04_scale_bank 上**劣化 44%**（497 → 713）。
#   单一策略必然在部分电路上吃亏，而题目按**逐用例平均**计分，
#   所以正确做法是：生成有限候选 → 逐个实测 → 保留该用例上最优的那个。
#   取 min 的性质保证了**不会比官方基线差**（B0 本身就在候选池里）。
#
#   bash scripts/wsl_candidate_envelope.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs reports

# 候选池：C0 官方基线本身也是候选（保证零劣化）
CANDIDATES="${CANDIDATES:-B0 ABC_classic SCRIPT_ifarea SCRIPT_andif_area SCRIPT_ifarea_lutpack2 SCRIPT_dc2}"
CASES=$(ls benchmarks/unit/u0*.v benchmarks/mixed/m0*.v benchmarks/large/l*.v 2>/dev/null)

echo "候选池：$CANDIDATES"
echo "用例数：$(echo "$CASES" | wc -l)"
echo
for p in $CANDIDATES; do rm -rf runs/*__${p}__* 2>/dev/null; done

total=0; fail=0
for pipe in $CANDIDATES; do
  echo "### $pipe"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/cand_${pipe}_${name}.log" 2>&1; then
      printf '  %-26s ' "$name"
      grep -oE "逻辑单元 : [0-9]+" "runs/cand_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1)); printf '  %-26s FAIL\n' "$name"
    fi
  done
done
echo
echo "=== 共 $total 次运行，失败 $fail ==="
echo

python3 - "$CANDIDATES" <<'PY'
import json, glob, sys, statistics
cands = sys.argv[1].split()
latest = {}
for p in glob.glob("runs/*/result.json"):
    try:
        d = json.load(open(p, encoding="utf-8"))
    except Exception:
        continue
    if d.get("fake") or d.get("pipeline") not in cands:
        continue
    k = (d["input"], d["pipeline"])
    if k not in latest or d["run_id"] > latest[k]["run_id"]:
        latest[k] = d
cases = sorted({k[0] for k in latest})

base = "B0"
short = {c: c.replace("SCRIPT_", "scr:").replace("ABC_", "") for c in cands}
hdr = f"{'用例':<34}" + "".join(f"{short[c][:11]:>12}" for c in cands) + f"{'最优':>8}{'缩减':>8}"
print(hdr)
print("-" * len(hdr))

rows = []
for c in cases:
    b = latest.get((c, base), {}).get("base_logic_cells")
    vals = {}
    for cd in cands:
        v = latest.get((c, cd), {}).get("base_logic_cells")
        vals[cd] = v
    ok = {k: v for k, v in vals.items() if v}
    if b is None or not ok:
        continue
    best_c = min(ok, key=lambda k: ok[k])
    best_v = ok[best_c]
    red = (b - best_v) / b if b else 0.0
    rows.append(dict(case=c, base=b, best=best_v, red=red, winner=best_c, vals=vals))
    line = f"{c:<34}" + "".join(f"{str(vals[cd]):>12}" for cd in cands)
    line += f"{str(best_v):>8}{red*100:>7.1f}%"
    print(line)

print("-" * len(hdr))
tb = sum(r["base"] for r in rows); tv = sum(r["best"] for r in rows)
mean_red = statistics.fmean(r["red"] for r in rows)
print(f"{'合计':<34}" + "".join(f"{sum(r['vals'][cd] or 0 for r in rows):>12}" for cd in cands)
      + f"{tv:>8}{(tb-tv)/tb*100:>7.1f}%")
print()
print("=== 各用例的胜出候选 ===")
from collections import Counter
cnt = Counter(r["winner"] for r in rows)
for cd, n in cnt.most_common():
    print(f"  {cd:<22} {n} 个用例")
print()
print("=== 关键指标（官方口径）===")
print(f"  逐用例平均缩减率：{mean_red*100:.2f}%     （≥10% 达标，≥20% 满分）")
print(f"  合计缩减率（参考） ：{(tb-tv)/tb*100:.2f}%")
print(f"  最差用例           ：{min(r['red'] for r in rows)*100:.1f}%（取最优后应 ≥0）")
print(f"  最好用例           ：{max(r['red'] for r in rows)*100:.1f}%")
neg = [r for r in rows if r["red"] < -1e-9]
print(f"  劣化用例数         ：{len(neg)}  {'✓ 零劣化（取 min 的必然性质）' if not neg else '✗ 异常'}")
print()
print("=== 面积门槛判定 ===")
if mean_red >= 0.20:
    print("  ✅ 逐用例平均 ≥20% —— 优化效果项可望满分")
elif mean_red >= 0.10:
    print("  ✅ 逐用例平均 ≥10% —— 达到题目硬指标")
else:
    print(f"  ❌ 逐用例平均 {mean_red*100:.2f}% < 10% —— 仍未达硬指标，需继续扩大候选或找新抓手")
print()
print("注：候选池含官方基线 B0 本身 ⇒ 取 min 后**不可能比基线差**，这一点由结构保证，不依赖运气。")
PY
