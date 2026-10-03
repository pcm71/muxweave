#!/usr/bin/env bash
# wsl_official_eval.sh —— 官方 4 个 case 专项评测（这是真正决定成绩的数据）
#
# 官方口径（据 Q&A 09.20 / 09.23）：
#   面积：缩减率 = (优化前逻辑单元数 − 优化后) / 优化前逻辑单元数，**按每个用例的平均算**，主看逻辑单元
#   DFF ：不做硬性要求，但不应多于优化前
#   效率：开销 = CPU 时间 + 整进程峰值内存，**每个用例都要满足**（≤5% 得满分），**CPU 时间包含 abc**
#
#   bash scripts/wsl_official_eval.sh [候选池]
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs reports

BASELINE=B0
CANDIDATES="${1:-B0 ABC_classic SCRIPT_ifarea SCRIPT_dc2 SCRIPT_ifarea_A6 SCRIPT_mfs2_aggr}"
CASES=$(ls benchmarks/official/*.v 2>/dev/null)
[ -n "$CASES" ] || { echo "benchmarks/official 下没有用例"; exit 2; }

echo "官方用例：$CASES"
echo "候选池  ：$CANDIDATES"
echo
for p in $CANDIDATES; do rm -rf runs/*__${p}__* 2>/dev/null; done

total=0; fail=0
for pipe in $CANDIDATES; do
  echo "### $pipe"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/off_${pipe}_${name}.log" 2>&1; then
      printf '  %-8s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/off_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1)); printf '  %-8s FAIL\n' "$name"
      grep -E "ERROR" "runs/off_${pipe}_${name}.log" | head -2 | sed 's/^/      /'
    fi
  done
done
echo
echo "=== 共 $total 次运行，失败 $fail ==="
echo

python3 - "$BASELINE" "$CANDIDATES" <<'PY'
import json, glob, sys, statistics
base_id, cands = sys.argv[1], sys.argv[2].split()
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
short = {c: c.replace("SCRIPT_", "").replace("ABC_", "") for c in cands}

print("=" * 108)
print("一、逐用例逻辑单元对比")
print("=" * 108)
hdr = f"{'用例':<40}" + "".join(f"{short[c][:11]:>12}" for c in cands) + f"{'最优':>8}{'缩减':>9}"
print(hdr); print("-" * len(hdr))
rows = []
for c in cases:
    b = latest.get((c, base_id), {}).get("base_logic_cells")
    vals = {cd: latest.get((c, cd), {}).get("base_logic_cells") for cd in cands}
    ok = {k: v for k, v in vals.items() if v}
    if b is None or not ok:
        continue
    best_c = min(ok, key=lambda k: ok[k]); best_v = ok[best_c]
    red = (b - best_v) / b if b else 0.0
    dff_b = latest.get((c, base_id), {}).get("dff_base")
    dff_v = latest.get((c, best_c), {}).get("dff_base")
    rows.append(dict(case=c, b=b, best=best_v, red=red, winner=best_c,
                     dff_b=dff_b, dff_v=dff_v,
                     cpu_b=latest.get((c, base_id), {}).get("cpu_time"),
                     cpu_v=latest.get((c, best_c), {}).get("cpu_time"),
                     mem_b=latest.get((c, base_id), {}).get("peak_process_tree_memory_kb"),
                     mem_v=latest.get((c, best_c), {}).get("peak_process_tree_memory_kb")))
    line = f"{c:<40}" + "".join(f"{str(vals[cd]):>12}" for cd in cands)
    line += f"{best_v:>8}{red*100:>8.1f}%"
    print(line)
print("-" * len(hdr))
tb = sum(r["b"] for r in rows); tv = sum(r["best"] for r in rows)
print(f"{'合计':<40}" + "".join(f"{sum(latest.get((r['case'], cd), {}).get('base_logic_cells') or 0 for r in rows):>12}" for cd in cands)
      + f"{tv:>8}{(tb-tv)/tb*100:>8.1f}%")

print()
print("=" * 108)
print("二、官方计分口径：逐用例平均缩减率")
print("=" * 108)
mean_red = statistics.fmean(r["red"] for r in rows)
for r in rows:
    print(f"  {r['case']:<40} {r['b']:>5} → {r['best']:>5}   {r['red']*100:>6.1f}%   (胜出: {short[r['winner']]})")
print(f"  {'平均':<40} {tb:>5} → {tv:>5}   {mean_red*100:>6.2f}%")
print()
if mean_red >= 0.20:   verdict = "✅ ≥20% —— 优化效果项可望满分"
elif mean_red >= 0.10: verdict = "✅ ≥10% —— 达到赛题技术指标"
else:                  verdict = f"⚠️ {mean_red*100:.2f}% < 10% —— 未达技术指标（按细则仍有基础分 20 分）"
print(f"  >>> {verdict}")

print()
print("=" * 108)
print("三、效率开销（官方口径：每个用例都要满足；CPU 含 abc；内存为整进程峰值）")
print("=" * 108)
print(f"{'用例':<40}{'CPU基/优(s)':>18}{'开销':>9}{'内存基/优(MB)':>20}{'开销':>9}{'5%判定':>10}")
worst_cpu = worst_mem = 0.0
for r in rows:
    cb, cv = r["cpu_b"], r["cpu_v"]
    mb, mv = r["mem_b"], r["mem_v"]
    if None in (cb, cv, mb, mv) or not cb or not mb:
        print(f"{r['case']:<40}{'—':>18}{'—':>9}{'—':>20}{'—':>9}{'数据缺失':>10}")
        continue
    oc = (cv - cb) / cb * 100; om = (mv - mb) / mb * 100
    worst_cpu = max(worst_cpu, oc); worst_mem = max(worst_mem, om)
    ok = "✓ 达标" if (oc <= 5 and om <= 5) else "✗ 超标"
    print(f"{r['case']:<40}{f'{cb:.3f}/{cv:.3f}':>18}{oc:>+8.1f}%{f'{mb/1024:.1f}/{mv/1024:.1f}':>20}{om:>+8.1f}%{ok:>10}")
print()
print(f"  最大 CPU 开销：{worst_cpu:+.1f}%     最大内存开销：{worst_mem:+.1f}%")
print(f"  >>> 效率判定：{'✅ 全部用例 ≤5%' if worst_cpu <= 5 and worst_mem <= 5 else '❌ 存在超标用例（5% 门槛未满足）'}")

print()
print("=" * 108)
print("四、DFF 约束（不应多于优化前）")
print("=" * 108)
bad = [r for r in rows if (r["dff_v"] or 0) > (r["dff_b"] or 0)]
for r in rows:
    flag = "✓" if (r["dff_v"] or 0) <= (r["dff_b"] or 0) else "✗"
    print(f"  {flag} {r['case']:<40} 优化前 {r['dff_b']} → 优化后 {r['dff_v']}")
print(f"  >>> {'✅ 全部满足' if not bad else f'❌ {len(bad)} 个用例 DFF 增加'}")
PY
