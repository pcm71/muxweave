#!/usr/bin/env python3
"""exp_summary.py —— 跨 pipeline 对比实验结果（插入点实验与后续所有 A/B 实验都用它）

    python3 scripts/exp_summary.py --runs runs --baseline B0

读取 runs/*/result.json（同一 input+pipeline 取最新一次），输出：
  1. 逐用例 × 各 pipeline 的逻辑单元数矩阵 + 相对基线的缩减率
  2. 各 pipeline 的汇总（总逻辑单元、逐用例平均缩减率、CPU 时间、峰值内存）
  3. 一致性检查（同一 pipeline 的 DFF 是否超出基线、是否有失败运行）
"""
from __future__ import annotations

import argparse
import json
import statistics
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PIPELINE_ORDER = ["B0", "B1", "O_INSERT_A", "O_INSERT_B"]


def load(runs_dir: Path) -> list[dict]:
    out = []
    for p in sorted(runs_dir.glob("*/result.json")):
        try:
            d = json.loads(p.read_text(encoding="utf-8"))
            if d.get("fake"):
                continue
            out.append(d)
        except Exception as exc:
            print(f"跳过 {p}: {exc}", file=sys.stderr)
    return out


def latest(results: list[dict]) -> dict[tuple[str, str], dict]:
    best: dict[tuple[str, str], dict] = {}
    for r in results:
        k = (r.get("input", "?"), r.get("pipeline", "?"))
        if k not in best or r.get("run_id", "") > best[k].get("run_id", ""):
            best[k] = r
    return best


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--runs", default=str(ROOT / "runs"))
    ap.add_argument("--baseline", default="B0")
    ap.add_argument("--out", default=None, help="可选：把 markdown 写到文件")
    args = ap.parse_args()

    data = latest(load(Path(args.runs)))
    cases = sorted({k[0] for k in data})
    pipes = [p for p in PIPELINE_ORDER if any(k[1] == p for k in data)]
    extra = sorted({k[1] for k in data} - set(PIPELINE_ORDER))
    pipes += extra
    if not pipes:
        print("没有可用结果", file=sys.stderr)
        return 2

    L: list[str] = []
    L.append("# 插入点/pipeline 对比实验\n")
    L.append(f"- 基线：`{args.baseline}`　对比项：{', '.join('`'+p+'`' for p in pipes if p != args.baseline)}")
    L.append(f"- 用例数：{len(cases)}")
    L.append("")

    # ---- 逐用例逻辑单元矩阵 ----
    L.append("## 1. 逐用例逻辑单元数\n")
    L.append("| 用例 | " + " | ".join(pipes) + " | 相对基线最大差异 |")
    L.append("|---" * (len(pipes) + 2) + "|")
    reductions: dict[str, list[float]] = {p: [] for p in pipes}
    for c in cases:
        row = [c]
        base = data.get((c, args.baseline), {}).get("base_logic_cells")
        vals = []
        for p in pipes:
            v = data.get((c, p), {}).get("base_logic_cells")
            vals.append(v)
            row.append("—" if v is None else str(v))
            if base and v is not None and v != base:
                reductions[p].append((base - v) / base)
        diffs = [abs(v - base) for v in vals if (v is not None and base)]
        row.append("0" if not diffs or max(diffs) == 0 else f"{max(diffs)} cell")
        L.append("| " + " | ".join(row) + " |")
    L.append("")

    # ---- pipeline 汇总 ----
    L.append("## 2. 各 pipeline 汇总\n")
    L.append("| pipeline | 总逻辑单元 | 平均相对基线缩减率 | 中位 CPU 时间 | 最大峰值内存 | 失败运行 | DFF 超标 |")
    L.append("|---|---|---|---|---|---|---|")
    for p in pipes:
        rows = [data[(c, p)] for c in cases if (c, p) in data]
        if not rows:
            continue
        tot = sum(r.get("base_logic_cells") or 0 for r in rows)
        mine = reductions[p]
        mean_red = f"{statistics.fmean(mine)*100:.2f}%" if mine else "0.00%"
        cpus = [r["cpu_time"] for r in rows if r.get("cpu_time") is not None]
        mems = [r["peak_process_tree_memory_kb"] for r in rows if r.get("peak_process_tree_memory_kb")]
        fails = sum(1 for r in rows if r.get("returncode") != 0)
        dffbad = 0
        for r in rows:
            b = data.get((r["input"], args.baseline), {})
            if (r.get("dff_base") or 0) > (b.get("dff_base") or 0):
                dffbad += 1
        L.append(f"| `{p}` | {tot} | {mean_red} | "
                 f"{statistics.median(cpus):.3f} s | {max(mems)/1024:.1f} MB | {fails} | {dffbad} |"
                 if cpus and mems else f"| `{p}` | {tot} | {mean_red} | — | — | {fails} | {dffbad} |")
    L.append("")

    # ---- PMUX 识别一致性 ----
    L.append("## 3. PMUX 识别一致性（应与 pipeline 无关）\n")
    L.append("| 用例 | $pmux | W | K | 复用位/跨位共享 | 机会 |")
    L.append("|---|---|---|---|---|---|")
    for c in cases:
        r = data.get((c, args.baseline)) or data.get((c, pipes[0]))
        if not r:
            continue
        reuse = r.get("bits_with_reuse")
        shared = r.get("shared_pattern_bits")
        opp = "none" if not reuse else ("high" if reuse >= (r.get("max_width") or 0) / 2 else "medium")
        L.append(f"| {c} | {r.get('pmux_count')} | {r.get('max_width')} | {r.get('max_choices')} | "
                 f"{reuse}/{shared} | {opp} |")
    L.append("")

    # ---- 结论提示 ----
    L.append("## 4. 怎么读这张表\n")
    L.append("- **本实验中 `pmux_opt` 是第 1 周骨架版（只统计机会、不改网表，`fallback=true`）**，")
    L.append("  所以 `O_INSERT_A/B` 与包含相同前后 pass 的基线应当**完全一致**；若出现差异，说明")
    L.append("  分析 pass 意外改动了网表 —— 那是必须立刻定位的缺陷。")
    L.append("- `B1` 才是关键对照：它代表「已有 pass 加强流程」。B1 相对 B0 的缩减，就是**现有能力已经吃掉的空间**；")
    L.append("  将来自研规则必须在 **B1 之上**仍有增量，才算作品贡献（方案第 2 周去留判据）。")
    L.append("- 逐用例平均缩减率按主办方口径计算（先逐用例求 `(base-opt)/base` 再取平均）。")

    md = "\n".join(L) + "\n"
    print(md)
    if args.out:
        Path(args.out).write_text(md, encoding="utf-8")
        print(f"\n已写出 {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
