#!/usr/bin/env bash
# wsl_large_eval.sh —— 真实规模用例评测：B0 基线 vs 调优 ABC 脚本，并对照题目门槛
#
# 对照的赛题技术指标（赛题原文第 7 页）：
#   面积  ：相比原始 Yosys 默认流程，单元总数缩减 ≥10%（技术指标）
#           评分细则：有缩减即得基础分 20 分，≥20% 满分，无优化效果才 0 分
#   算法性能：节点规模 ≤1000 的电路，完整优化耗时 ≤60s，内存峰值 ≤2GB
#   口径  ：缩减率**按每个用例的平均**算，主看逻辑单元；DFF 不得多于优化前
#
#   bash scripts/wsl_large_eval.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs reports reports/large

BASELINE=B0
VARIANT=SCRIPT_ifarea
CASES=$(ls benchmarks/large/l*.v 2>/dev/null)
[ -n "$CASES" ] || { echo "benchmarks/large 下没有用例"; exit 2; }

echo "=== 清理旧结果 ==="
for p in $BASELINE $VARIANT; do rm -rf runs/*__${p}__* 2>/dev/null; done

total=0; fail=0
for pipe in $BASELINE $VARIANT; do
  echo
  echo "##################### $pipe #####################"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/lg_${pipe}_${name}.log" 2>&1; then
      printf '  %-24s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/lg_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1)); printf '  %-24s FAIL\n' "$name"
      grep -E "ERROR" "runs/lg_${pipe}_${name}.log" | head -2 | sed 's/^/      /'
    fi
  done
done
echo
echo "=== 共 $total 次运行，失败 $fail ==="

echo
echo "=== 结果与门槛对照 ==="
python3 - "$BASELINE" "$VARIANT" <<'PY'
import json, glob, sys
base_id, var_id = sys.argv[1], sys.argv[2]
latest = {}
for p in glob.glob("runs/*/result.json"):
    try:
        d = json.load(open(p, encoding="utf-8"))
    except Exception:
        continue
    if d.get("fake") or d.get("pipeline") not in (base_id, var_id):
        continue
    k = (d["input"], d["pipeline"])
    if k not in latest or d["run_id"] > latest[k]["run_id"]:
        latest[k] = d
cases = sorted({k[0] for k in latest})
rows = []
print(f"{'用例':<36}{'B0':>6}{'if-a':>6}{'缩减':>9}{'DFF基/变':>12}{'CPU(s)':>9}{'峰值(MB)':>10}")
for c in cases:
    b = latest.get((c, base_id), {})
    v = latest.get((c, var_id), {})
    bc, vc = b.get("base_logic_cells"), v.get("base_logic_cells")
    if bc is None or vc is None:
        print(f"{c:<36}{str(bc):>6}{str(vc):>6}{'—':>9}{'—':>12}{'—':>9}{'—':>10}")
        continue
    red = (bc - vc) / bc if bc else 0.0
    dff_b, dff_v = b.get("dff_base"), v.get("dff_base")
    cpu = v.get("cpu_time")
    mem = v.get("peak_process_tree_memory_kb")
    rows.append(dict(case=c, bc=bc, vc=vc, red=red, dff_b=dff_b, dff_v=dff_v, cpu=cpu, mem=mem))
    print(f"{c:<36}{bc:>6}{vc:>6}{red*100:>8.1f}%{str(dff_b)+'/'+str(dff_v):>12}"
          f"{(f'{cpu:.2f}' if cpu else '—'):>9}{(f'{mem/1024:.1f}' if mem else '—'):>10}")

if rows:
    import statistics
    mean_red = statistics.fmean(r["red"] for r in rows)      # 官方口径：逐用例平均
    tb = sum(r["bc"] for r in rows); tv = sum(r["vc"] for r in rows)
    wred = (tb - tv) / tb if tb else 0
    cpus = [r["cpu"] for r in rows if r["cpu"] is not None]
    mems = [r["mem"] for r in rows if r["mem"] is not None]
    dff_bad = sum(1 for r in rows if (r["dff_v"] or 0) > (r["dff_b"] or 0))
    print()
    print(f"  合计逻辑单元：B0={tb}  变体={tv}")
    print(f"  ★ 逐用例平均缩减率（官方口径）：{mean_red*100:.2f}%")
    print(f"    加权缩减率（仅参考）        ：{wred*100:.2f}%")
    print(f"    最差/最好用例               ：{min(r['red'] for r in rows)*100:.1f}% / {max(r['red'] for r in rows)*100:.1f}%")
    if cpus:
        print(f"  最大 CPU 时间（门槛 60s）     ：{max(cpus):.2f} s  → {'达标' if max(cpus)<=60 else '未达标'}")
    if mems:
        print(f"  最大整进程峰值内存（门槛 2GB）：{max(mems)/1024:.1f} MB  → {'达标' if max(mems)<=2*1024*1024 else '未达标'}")
    print(f"  DFF 超标用例数（不得多于优化前）：{dff_bad}")
    print()
    print("  === 面积判定（技术指标 ≥10%；评分细则 ≥20% 满分）===")
    if mean_red >= 0.20:
        print("  ✅ 逐用例平均 ≥20% —— 优化效果项可望满分")
    elif mean_red >= 0.10:
        print("  ✅ 逐用例平均 ≥10% —— 达到赛题技术指标")
    else:
        print(f"  ⚠️ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达赛题技术指标（细则仍有基础分 20 分），可继续找抓手")
PY

echo
echo "=== 生成报告 ==="
python3 scripts/exp_summary.py --runs runs --baseline "$BASELINE" \
  --out reports/large/summary_large.md > /dev/null 2>&1 \
  && echo "  reports/large/summary_large.md" || echo "  （exp_summary 跳过：pipeline 名不在其预设列表内，属正常）"
