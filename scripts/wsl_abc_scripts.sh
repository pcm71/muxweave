#!/usr/bin/env bash
# wsl_abc_scripts.sh —— 真正的 ABC 脚本文件扫描
#
# 背景（上一轮失败的真实原因）：
#   内联写法 `-script "+strash,&get,-n,..."` 只把**逗号换成空格**，
#   结果整串被当成**一行**发给 ABC：
#       ABC: + strash &get -n &fraig -x &put scorr dc2 ...     ← 全挤一行，等于没执行
#   而默认脚本是**一行一条命令**：
#       ABC: + strash
#       ABC: + &get -n
#       ...
#   所以必须用**脚本文件**。已实测：用 -script <file> 时 Yosys 仍会照常发送
#   `read_lut <lutdefs.txt>`，LUT 库不会丢。
#
# 自洽性检查：用默认脚本原文（baseline_lut4.abc）跑出来的结果必须与 `abc -lut 4` 的 263 一致。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs

# 用法：bash scripts/wsl_abc_scripts.sh [pipeline 列表（空格分隔）]
#   不带参数时跑默认列表；带参数时只跑指定的 pipeline，便于分批迭代。
DEFAULT_PIPELINES="B0 ABC_classic SCRIPT_baseline SCRIPT_dc2 SCRIPT_ifarea SCRIPT_nfresub SCRIPT_lutpack2 SCRIPT_nodretime"
PIPELINES="${1:-$DEFAULT_PIPELINES}"
CASES=$(ls benchmarks/unit/u0*.v benchmarks/mixed/m0*.v benchmarks/large/l*.v 2>/dev/null)

echo "pipeline 列表：$PIPELINES"

for p in $PIPELINES; do rm -rf runs/*__${p}__* 2>/dev/null; done

total=0; fail=0
for pipe in $PIPELINES; do
  echo
  echo "##################### $pipe #####################"
  for v in $CASES; do
    name=$(basename "$v" .v)
    total=$((total+1))
    if python3 scripts/run_case.py --case "$v" --top "$name" --pipeline "$pipe" \
         > "runs/scr_${pipe}_${name}.log" 2>&1; then
      printf '  %-30s ' "$name"
      grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/scr_${pipe}_${name}.log" | head -1
    else
      fail=$((fail+1))
      printf '  %-30s FAIL\n' "$name"
      grep -E "ERROR" "runs/scr_${pipe}_${name}.log" | head -2 | sed 's/^/      /'
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
short = [p.replace("SCRIPT_", "scr:").replace("ABC_", "") for p in pipes]
print(f"{'用例':<34}" + "".join(f"{s[:12]:>13}" for s in short))
totals = {p: 0 for p in pipes}
for c in cases:
    line = f"{c:<34}"
    for p in pipes:
        v = latest.get((c, p), {}).get("base_logic_cells")
        totals[p] += v or 0
        line += f"{str(v):>13}"
    print(line)
print("-" * (34 + 13*len(pipes)))
base = totals["B0"]
line = f"{'合计':<34}"
for p in pipes:
    d = base - totals[p]
    tag = "" if d == 0 else (f" 省{d}" if d > 0 else f" 多{-d}")
    line += f"{str(totals[p]) + tag:>13}"
print(line)
print()
print("=== 自洽性检查 ===")
if "SCRIPT_baseline" not in totals:
    print("  （本次未跑 SCRIPT_baseline，跳过自洽性检查）")
elif totals.get("SCRIPT_baseline") == totals.get("ABC_classic"):
    print(f"  ✓ SCRIPT_baseline（默认脚本写成文件）= {totals['SCRIPT_baseline']} = ABC_classic → 脚本文件机制正确")
else:
    print(f"  ✗ SCRIPT_baseline={totals.get('SCRIPT_baseline')} 与 ABC_classic={totals.get('ABC_classic')} 不一致 → 需排查")
print()
print("=== 判定（基准 B0 = %d）===" % base)
best, bestv = None, base
for p in pipes:
    if p in ("B0",):
        continue
    if totals[p] == 0:
        print(f"    {p:<20} 【无效】全部失败")
        continue
    d = base - totals[p]
    if d > 0:
        print(f"  ★ {p:<20} 省 {d} 个（{100*d/base:.1f}%）")
        if totals[p] < bestv:
            best, bestv = p, totals[p]
    elif d == 0:
        print(f"    {p:<20} 持平")
    else:
        print(f"    {p:<20} 多 {-d} 个")
if best:
    print(f"\n>>> 最优：{best}（{bestv}，省 {base-bestv}）")
PY
