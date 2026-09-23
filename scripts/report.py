#!/usr/bin/env python3
"""report.py —— 汇总 runs/*/result.json，生成逐用例表与缩减率汇总。

口径（主办方已确认）：
  * 缩减率**按每个用例分别计算再取算术平均** —— 这是主成绩，记为「平均（官方口径）」。
  * 加权口径 (ΣN_base − ΣN_opt)/ΣN_base 只作**参考并列展示**，两种汇总不得混为一列。
  * 主指标是**逻辑单元**；DFF 单列，且不得多于优化前（violation 会被标红列出）。
  * 非 PASS 的验证状态一律不计入成绩。

用法：
  python3 scripts/report.py --runs runs --out reports
  python3 scripts/report.py --baseline B0 --candidate O_INSERT_A
  python3 scripts/report.py --selftest
"""
from __future__ import annotations

import argparse
import csv
import json
import shutil
import statistics
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent


def load_results(runs_dir: Path) -> list[dict]:
    out = []
    for p in sorted(runs_dir.glob("*/result.json")):
        try:
            with open(p, "r", encoding="utf-8") as f:
                d = json.load(f)
            d["_path"] = str(p.relative_to(runs_dir.parent))
            out.append(d)
        except Exception as exc:
            print(f"跳过 {p}：{exc}", file=sys.stderr)
    return out


def split_fake(results: list[dict]) -> tuple[list[dict], int]:
    """冒烟模式（fake=true）的产物绝不进入成绩，只做计数提示。"""
    real = [r for r in results if not r.get("fake")]
    return real, len(results) - len(real)


def pick(results: list[dict], pipeline: str) -> dict[str, dict]:
    """同一 input 取最新一次运行（run_id 末尾是时间戳，字典序即时序）。"""
    latest = {}
    for r in results:
        if r.get("pipeline") != pipeline:
            continue
        key = r.get("input", "?")
        if key not in latest or r.get("run_id", "") > latest[key].get("run_id", ""):
            latest[key] = r
    return latest


def reduction(base: float, opt: float) -> float | None:
    if base in (None, 0) or opt is None:
        return None
    return (base - opt) / base


def build_report(results: list[dict], baseline_id: str, candidate_id: str) -> tuple[str, list[dict]]:
    base = pick(results, baseline_id)
    cand = pick(results, candidate_id) if candidate_id != baseline_id else {}

    rows = []
    for key in sorted(base):
        b = base[key]
        c = cand.get(key)
        b_logic = b.get("base_logic_cells")
        c_logic = c.get("base_logic_cells") if c else None
        dff_b, dff_c = b.get("dff_base"), (c.get("dff_base") if c else None)
        r = reduction(b_logic, c_logic) if c else None
        rows.append({
            "input": key,
            "baseline": baseline_id,
            "candidate": candidate_id if c else "",
            "pmux_count": b.get("pmux_count"),
            "mux_count": b.get("mux_count"),
            "max_width": b.get("max_width"),
            "max_choices": b.get("max_choices"),
            "bits_with_reuse": b.get("bits_with_reuse"),
            "shared_pattern_bits": b.get("shared_pattern_bits"),
            "base_logic": b_logic,
            "opt_logic": c_logic,
            "reduction": r,
            "dff_base": dff_b,
            "dff_opt": dff_c,
            "dff_violation": (dff_c is not None and dff_b is not None and dff_c > dff_b),
            "cpu_time": b.get("cpu_time"),
            "peak_mem_kb": b.get("peak_process_tree_memory_kb"),
            "formal_status": (c or b).get("formal_status", "NOT_RUN"),
            "formal_not_pass": (c or b).get("formal_status") not in ("PASS", "NOT_RUN"),
            "run_dir": b.get("_path"),
        })

    rs = [x["reduction"] for x in rows if x["reduction"] is not None]
    summary = {
        "cases_total": len(rows),
        "cases_with_candidate": sum(1 for x in rows if x["reduction"] is not None),
        "mean_reduction_official": statistics.fmean(rs) if rs else None,
        "median_reduction": statistics.median(rs) if rs else None,
        "worst_reduction": min(rs) if rs else None,
        "best_reduction": max(rs) if rs else None,
    }
    sb = sum(x["base_logic"] for x in rows if x["opt_logic"] is not None and x["base_logic"])
    so = sum(x["opt_logic"] for x in rows if x["opt_logic"] is not None and x["base_logic"])
    summary["weighted_reduction_reference"] = ((sb - so) / sb) if sb else None
    summary["dff_violations"] = sum(1 for x in rows if x["dff_violation"])
    summary["formal_not_pass"] = sum(1 for x in rows if x["formal_not_pass"])

    def pct(v):
        return "—" if v is None else f"{v*100:.2f}%"

    L = []
    L.append("# 实验汇总（自动生成，请勿手改）\n")
    L.append(f"- 基线：`{baseline_id}`　候选：`{candidate_id or '（未提供候选，仅基线）'}`")
    L.append(f"- 用例数：{summary['cases_total']}（含候选对照 {summary['cases_with_candidate']}）")
    L.append(f"- **平均缩减率（官方口径，逐用例平均）**：{pct(summary['mean_reduction_official'])}")
    L.append(f"- 中位数 / 最差 / 最好：{pct(summary['median_reduction'])} / "
             f"{pct(summary['worst_reduction'])} / {pct(summary['best_reduction'])}")
    L.append(f"- 加权缩减率（**仅参考**，不得与上面混列）：{pct(summary['weighted_reduction_reference'])}")
    L.append(f"- DFF 违规用例数（优化后 DFF 多于优化前）：{summary['dff_violations']}")
    L.append(f"- 验证非 PASS / 非未运行的用例数：{summary['formal_not_pass']}")
    L.append("")
    L.append("## 逐用例\n")
    L.append("| 用例 | $pmux | $mux | W | K | 复用位/跨位共享 | 基线逻辑单元 | 候选逻辑单元 | 缩减率 | DFF(基/候) | 验证 | 运行目录 |")
    L.append("|---|---|---|---|---|---|---|---|---|---|---|---|")
    for x in rows:
        L.append("| {input} | {pmux_count} | {mux_count} | {max_width} | {max_choices} | {shared} | "
                 "{base_logic} | {opt} | {red} | {db}/{dc}{viol} | {fs} | `{run_dir}` |".format(
                     input=x["input"], pmux_count=x["pmux_count"], mux_count=x["mux_count"],
                     max_width=x["max_width"], max_choices=x["max_choices"],
                     shared="{}/{}".format(x["bits_with_reuse"], x["shared_pattern_bits"]),
                     base_logic=x["base_logic"], opt=x["opt_logic"] if x["opt_logic"] is not None else "—",
                     red=pct(x["reduction"]),
                     db=x["dff_base"], dc=x["dff_opt"] if x["dff_opt"] is not None else "—",
                     viol=" ⚠" if x["dff_violation"] else "",
                     fs=x["formal_status"], run_dir=x["run_dir"]))
    L.append("")
    L.append("## 口径提醒\n")
    L.append("- 平均(r_i) 与 (ΣN_base−ΣN_opt)/ΣN_base **不等价**；评分用前者，后者仅供对照。")
    L.append("- 「复用位」= 至少两个分支取同一数据源的位（真正的机会来源）；"
             "「跨位共享」= 这种含复用的模式被多个位共用。两者都为 0 表示该 cell 没有可优化空间。")
    L.append("- 一个 32 位 `$and` 与一个 1 位门都记 1 个 cell，raw cell 数不能直接说明面积，需看分类型明细。")
    L.append("- 时间按 CPU 时间、内存按整进程峰值；本表 CPU/内存列来自基线运行。")
    L.append("- 非 PASS 的用例不得计入成绩，即使缩减率好看。")
    return "\n".join(L) + "\n", rows


def write_csv(rows: list[dict], path: Path) -> None:
    if not rows:
        return
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)


def do_report(args) -> int:
    runs_dir = Path(args.runs).resolve()
    if not runs_dir.is_dir():
        print(f"运行目录不存在：{runs_dir}", file=sys.stderr)
        return 2
    results = load_results(runs_dir)
    if not results:
        print(f"{runs_dir} 下没有 result.json；先跑 scripts/run_case.py", file=sys.stderr)
        return 2

    results, n_fake = split_fake(results)
    if n_fake:
        print(f"注意：已排除 {n_fake} 个 fake=true 的冒烟运行（不进入成绩）。", file=sys.stderr)
    if not results:
        print("排除冒烟运行后没有真实数据；请用真实 yosys 跑 run_case.py。", file=sys.stderr)
        return 2

    md, rows = build_report(results, args.baseline, args.candidate)
    out = Path(args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)
    (out / "summary.md").write_text(md, encoding="utf-8")
    write_csv(rows, out / "summary.csv")
    print(md)
    print(f"已写出：{out/'summary.md'} 与 {out/'summary.csv'}")
    return 0


def do_selftest() -> int:
    def mk(run_id, input_name, pipeline, logic, dff, pmux=1):
        return {
            "run_id": run_id, "input": input_name, "pipeline": pipeline,
            "base_logic_cells": logic, "dff_base": dff, "pmux_count": pmux, "mux_count": 0,
            "max_width": 8, "max_choices": 4, "shared_pattern_bits": 4,
            "cpu_time": 1.0, "peak_process_tree_memory_kb": 1024,
            "formal_status": "NOT_RUN", "_path": f"runs/{run_id}/result.json",
        }

    results = [
        mk("a__B0__t1", "a.v", "B0", 100, 10),
        mk("a__O__t2", "a.v", "O_INSERT_A", 90, 11),   # 10% 缩减，但 DFF 增加 → 应报违规
        mk("b__B0__t3", "b.v", "B0", 200, 20),
        mk("b__O__t4", "b.v", "O_INSERT_A", 200, 20),  # 0% 缩减
    ]
    md, rows = build_report(results, "B0", "O_INSERT_A")

    mean = statistics.fmean([0.10, 0.00])
    weighted = (300 - 290) / 300
    checks = [
        ("用例数", len(rows), 2),
        ("平均缩减率 = mean(0.10,0.00)", round(statistics.fmean(
            [r["reduction"] for r in rows if r["reduction"] is not None]), 10), round(mean, 10)),
        ("加权缩减率与平均不同", round(weighted, 6) != round(mean, 6), True),
        ("DFF 违规被识别", sum(1 for r in rows if r["dff_violation"]), 1),
        ("汇总含官方口径字样", "官方口径" in md, True),
    ]
    bad = 0
    for name, got, want in checks:
        ok = got == want
        bad += 0 if ok else 1
        print(f"  [{'OK  ' if ok else 'FAIL'}] {name}: got={got!r} want={want!r}")
    if bad:
        print(f"自检失败：{bad} 项不符")
        return 1
    print("自检通过：逐用例平均与加权口径被区分计算，DFF 违规可被标出。")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--runs", default=str(ROOT / "runs"))
    ap.add_argument("--out", default=str(ROOT / "reports"))
    ap.add_argument("--baseline", default="B0")
    ap.add_argument("--candidate", default="O_INSERT_A")
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    return do_selftest() if args.selftest else do_report(args)


if __name__ == "__main__":
    sys.exit(main())
