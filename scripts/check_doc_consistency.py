#!/usr/bin/env python3
"""check_doc_consistency.py —— 检查说明文档里的成绩数字是否与当前事实一致

事实（唯一依据，来自实测）：
  当前面积 = 22.64%（287/15/9/29，基线 288/25/13/36）
  内存 max +1.0%（机器空闲、9 次中位数、两轮复核；此前 +11.5% 系测量污染）、
  耗时 ≤12s、DFF 不变、等价性 miter 4/4 + EQY 2/4
  历史轨迹：5.00% → 16.25% → 16.34% → 18.01% → 21.86% → 22.64%
  已作废（违反 C53-1）：20.26% / 22.03% / 24.10% / 7.28%

判定规则：
  * 出现 22.64% 且上下文是"当前/现行" → ✓
  * 出现旧数字但上下文含"历史/曾/早期/作废/→" → ○ 可接受（历史记录）
  * 出现旧数字且上下文是"当前/现行成绩/上限" → ✗ 错误（必须改）
"""
from __future__ import annotations

import os
import re
import sys
from pathlib import Path

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
ROOT = Path(".")
SKIP = {"docs/qa", "dist", ".git", "runs", "reports"}

OLD = ["5.00%", "16.25%", "16.34%", "18.01%", "21.86%", "20.26%", "22.03%", "24.10%", "7.28%"]
CUR = "22.64%"
HIST = ("历史", "曾", "早期", "作废", "→", "阶段", "原本", "之前", "上一版", "轨迹", "推翻", "旧", "当时")
NOW = ("当前", "现行", "现在", "上限", "最好成绩", "本版")

bad, ok, hist = [], [], []
for p in sorted(ROOT.rglob("*.md")):
    s = str(p).replace("\\", "/")
    if any(s.startswith(k) for k in SKIP):
        continue
    try:
        lines = p.read_text(encoding="utf-8", errors="replace").split("\n")
    except Exception:
        continue
    for i, ln in enumerate(lines, 1):
        if not any(o in ln for o in OLD):
            continue
        rec = f"{s}:{i}  {ln.strip()[:88]}"
        # 同一行里同时出现"历史标记"和"当前值"的，是"当时 X → 现行 22.64%"这种正确对照，不算错。
        if CUR in ln and any(h in ln for h in HIST):
            hist.append(rec)
        elif any(h in ln for h in HIST):
            hist.append(rec)
        elif any(n in ln for n in NOW):
            bad.append(rec)
        else:
            ok.append(rec)

print(f"=== ✗ 错误（旧数字被当作当前成绩）：{len(bad)} 处 ===")
for r in bad:
    print("  " + r)
print()
print(f"=== ○ 历史记录（可接受）：{len(hist)} 处 ===")
for r in hist[:12]:
    print("  " + r)
if len(hist) > 12:
    print(f"  …另有 {len(hist) - 12} 处")
print()
print(f"=== · 其他提及（需人工看一眼）：{len(ok)} 处 ===")
for r in ok[:12]:
    print("  " + r)
if len(ok) > 12:
    print(f"  …另有 {len(ok) - 12} 处")

# 当前成绩是否在主要文档里出现
print()
print("=== 主要文档是否已含 22.64% ===")
for f in ["README.md", "docs/official_submission.md", "docs/plan_v3.md",
          "docs/week_report_official.md", "docs/official_case_results.md",
          "docs/integration_and_equivalence_status.md", "docs/abc9_constraint_findings.md"]:
    p = Path(f)
    if p.exists():
        has = CUR in p.read_text(encoding="utf-8", errors="replace")
        print(f"  {'✓' if has else '✗'} {f}")
    else:
        print(f"  - {f}（不存在）")
sys.exit(1 if bad else 0)
