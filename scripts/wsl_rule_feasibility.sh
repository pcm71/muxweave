#!/usr/bin/env bash
# wsl_rule_feasibility.sh —— 主规则可行性预实验
#
# 目的：在写 C++ 之前，用 Verilog 手工改写验证"跨位分组/删默认路径"这两个杠杆
#       在 synth_intel（内部含 opt -fine -full + abc9 -lut 4）之后**到底有没有收益**。
#
# 判据：若 e02/e03 的逻辑单元数 **严格小于** e01，则说明有空间，值得写成 C++ 规则；
#       若相等或更大，则这条路线在 B0 后端下没有收益，应转向其他抓手（方案第 19 节退路）。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs

echo "##################### 1) 综合对比（pipeline B0）#####################"
rm -rf runs/e0*__B0__* 2>/dev/null
for v in benchmarks/exp/e0*.v; do
  name=$(basename "$v" .v)
  if python3 scripts/run_case.py --case "$v" --top dut --pipeline B0 \
       > "runs/feas_${name}.log" 2>&1; then
    printf '  %-22s ' "$name"
    grep -oE "逻辑单元 : [0-9]+   DFF: [0-9]+" "runs/feas_${name}.log" | head -1
  else
    printf '  %-22s FAIL\n' "$name"
    tail -5 "runs/feas_${name}.log" | sed 's/^/      /'
  fi
done

echo
echo "=== 对比小结（逻辑单元）==="
python3 - <<'PY'
import json, glob, collections
latest = {}
for p in glob.glob("runs/e0*__B0__*/result.json"):
    d = json.load(open(p, encoding="utf-8"))
    k = (d["input"], d["pipeline"])
    if k not in latest or d["run_id"] > latest[k]["run_id"]:
        latest[k] = d
rows = sorted(latest.values(), key=lambda d: d["input"])
print(f"{'用例':<34}{'逻辑单元':>8}{'DFF':>6}")
for d in rows:
    print(f"{d['input']:<34}{str(d['base_logic_cells']):>8}{str(d['dff_base']):>6}")

def get(stem):
    for d in rows:
        if stem in d["input"]:
            return d
    return None
pairs = [("e01_u02_base", "e02_u02_grouped"), ("e01_u02_base", "e03_u02_decoded"),
         ("e04_m03_base", "e05_m03_grouped"), ("e06_k8_base", "e07_k8_grouped")]
print()
print("=== 改写是否省单元 ===")
for a, b in pairs:
    da, db = get(a), get(b)
    if not da or not db:
        print(f"  {a} -> {b}: 数据缺失")
        continue
    ca, cb = da["base_logic_cells"], db["base_logic_cells"]
    verdict = f"省 {ca-cb} 个 ({100*(ca-cb)/ca:.1f}%)" if cb < ca else ("持平" if cb == ca else f"反而多 {cb-ca} 个")
    print(f"  {a:<20} {ca:>4}  ->  {b:<20} {cb:>4}   {verdict}")
PY

echo
echo "##################### 2) 等价性验证（EQY）#####################"
fails=0
for cfg in formal/exp/*.eqy; do
  name=$(basename "$cfg" .eqy)
  rm -rf "./$name"
  log="formal/exp/logs_${name}.log"
  mkdir -p formal/exp
  eqy "$cfg" >"$log" 2>&1
  rc=$?
  verdict=$([ $rc -eq 0 ] && echo PASS || echo FAIL)
  printf '  %-16s rc=%-3s %s\n' "$name" "$rc" "$verdict"
  grep -E "DONE \(|Successfully proved|Failed to prove|ERROR" "$log" | tail -2 | sed 's/^/      /'
  [ "$verdict" = "PASS" ] || fails=$((fails+1))
  rm -rf "./$name"
done

echo
echo "=== 等价性：$([ $fails -eq 0 ] && echo '全部 PASS' || echo "$fails 项未通过") ==="
