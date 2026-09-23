#!/usr/bin/env bash
# wsl_abc_battery.sh —— ABC 脚本杠杆实验
#
# 背景：跨位分组/共享、删默认路径、全部相关自带 pass 都已验证为 0 增益。
#       主办方明确允许"调整 abc 脚本"，而本项目观测到的最大杠杆恰恰就是 ABC
#       （0.68 → 0.69 的 9.5% → 24.6% 完全来自 ABC 变化）。
# 做法：用 synth_intel 的 -run 分段标签替换官方那一步 `abc9 -lut 4 -W 300`。
#
# 判据：任何 ABC_* 的合计逻辑单元 < B0（284），即说明 ABC 脚本有可挖空间。
#       特别关注 ABC_baseline 是否等于 284 —— 它是本组实验的自洽性检查。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs

echo "=== abc9 / abc 的可用选项（留档）==="
{ yosys -p "help abc9"; echo; echo "-----"; echo; yosys -p "help abc"; } > runs/help_abc.txt 2>&1
grep -E "^\s+-(lut|W|D|fast|script|constr|showtmp|dff|keepff|cache)" runs/help_abc.txt | head -20 | sed 's/^/  /'

PIPELINES="B0 ABC_baseline ABC_classic ABC_w100 ABC_w1000 ABC_fast ABC_delay"
CASES=$(ls benchmarks/unit/u0*.v benchmarks/mixed/m0*.v 2>/dev/null)

echo
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
         > "runs/abc_${pipe}_${name}.log" 2>&1; then
      printf '  %-30s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/abc_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1))
      printf '  %-30s FAIL\n' "$name"
      tail -6 "runs/abc_${pipe}_${name}.log" | sed 's/^/      /'
    fi
  done
done
echo
echo "=== 共 $total 次运行，失败 $fail ==="

echo
echo "=== ABC 变体汇总（相对 B0 = 284）==="
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
print(f"{'用例':<36}" + "".join(f"{p.replace('ABC_',''):>12}" for p in pipes))
totals = {p: 0 for p in pipes}
for c in cases:
    line = f"{c:<36}"
    for p in pipes:
        v = latest.get((c, p), {}).get("base_logic_cells")
        totals[p] += v or 0
        line += f"{str(v):>12}"
    print(line)
print("-" * (36 + 12*len(pipes)))
base = totals["B0"]
line = f"{'合计':<36}"
for p in pipes:
    d = base - totals[p]
    tag = "" if d == 0 else (f" 省{d}" if d > 0 else f" 多{-d}")
    line += f"{str(totals[p]) + tag:>12}"
print(line)
print()
print("=== 判定 ===")
for p in pipes:
    if p == "B0":
        continue
    if totals[p] == 0:
        print(f"    {p:<16} 【无效】全部运行失败（多为选项不被该版本支持）—— 不计入结论")
        continue
    d = base - totals[p]
    if d > 0:
        print(f"  ★ {p:<16} 比 B0 省 {d} 个 → ABC 脚本有可挖空间")
    elif d == 0:
        print(f"    {p:<16} 与 B0 持平")
    else:
        print(f"    {p:<16} 比 B0 多 {-d} 个 → 劣化")
PY
