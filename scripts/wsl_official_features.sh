#!/usr/bin/env bash
# wsl_official_features.sh —— 提取官方 4 个 case 的 PMUX 结构特征
#
# 目的：设计"特征 → 映射策略"的判据，必须有数据支撑，不能拍脑袋。
# 特征来自自研 pmux_analyze（只读分析 pass），另外补充 DFF/逻辑规模等统计。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs/feat

for v in benchmarks/official/*.v; do
  name=$(basename "$v" .v)
  d="runs/feat/$name"
  mkdir -p "$d"

  # 1) 结构特征（proc 之后、综合之前）
  yosys -q -p "
read_verilog $v
hierarchy -top $name
proc
pmux_analyze -table -json $d/analyze.json
tee -o $d/stat_pre.json stat -json
" > "$d/log_analyze" 2>&1

  # 2) 综合后的规模
  yosys -q -p "
read_verilog $v
hierarchy -top $name
synth_intel -family cycloneiv -top $name
tee -o $d/stat_post.json stat -json
" > "$d/log_post" 2>&1
done

python3 - <<'PY'
import json, glob, os
rows = []
for d in sorted(glob.glob("runs/feat/*/")):
    name = os.path.basename(d.rstrip("/"))
    a = p = {}
    try:
        a = json.load(open(os.path.join(d, "analyze.json"), encoding="utf-8"))
    except Exception:
        pass
    try:
        pre = json.load(open(os.path.join(d, "stat_pre.json"), encoding="utf-8"))
        post = json.load(open(os.path.join(d, "stat_post.json"), encoding="utf-8"))
        p = {"pre": pre, "post": post}
    except Exception:
        pass
    rows.append((name, a, p))

def num(d, *keys, default=None):
    cur = d
    for k in keys:
        if not isinstance(cur, dict) or k not in cur:
            return default
        cur = cur[k]
    return cur

print("=" * 100)
print("官方 4 个 case 的 PMUX / 规模特征（用于设计映射策略选择判据）")
print("=" * 100)
hdr = (f"{'case':<8}{'pmux':>6}{'mux':>6}{'bits共享':>9}{'共享位总':>9}{'共享模式位':>11}"
       f"{'maxW':>6}{'maxK':>6}{'pre单元':>9}{'post逻辑':>9}{'DFF':>6}")
print(hdr); print("-" * len(hdr))
for name, a, p in rows:
    pre_cells = num(p, "pre", "design", "num_cells")
    post_cells = num(p, "post", "design", "num_cells")
    dff = None
    nbt = num(p, "post", "num_cells_by_type", default={}) or {}
    dff = sum(v for k, v in nbt.items()
              if any(t in k.lower() for t in ("dff", "dffeas", "ff", "dlatch")))
    logic = (post_cells - dff) if (post_cells is not None and dff is not None) else None
    print(f"{name:<8}{str(a.get('pmux_cells')):>6}{str(a.get('mux_cells')):>6}"
          f"{str(a.get('bits_with_reuse_total')):>9}{str(a.get('shared_pattern_bits')):>9}"
          f"{str(a.get('cells_with_reuse')):>11}{str(a.get('max_width')):>6}"
          f"{str(a.get('max_choices')):>6}{str(pre_cells):>9}{str(logic):>9}{str(dff):>6}")

print()
print("=== 各 case 的完整 analyze.json ===")
for name, a, _ in rows:
    print(f"--- {name}: {json.dumps(a, ensure_ascii=False)}")
print()
print("=== 各 case 综合后按类型的单元数（前 8 类）===")
for name, _, p in rows:
    nbt = num(p, "post", "num_cells_by_type", default={}) or {}
    top = sorted(nbt.items(), key=lambda kv: -kv[1])[:8]
    print(f"--- {name}: " + ", ".join(f"{k}={v}" for k, v in top))
PY
