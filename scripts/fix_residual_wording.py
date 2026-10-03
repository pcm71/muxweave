#!/usr/bin/env python3
"""fix_residual_wording.py —— 清理上一轮勘误残留的错误口径文案

规则：
  * 每条替换都先断言 old 在文件中**恰好出现一次**，否则跳过并报警（避免误改）
  * 只改说明文字/注释，不改任何代码逻辑
用法: python3 scripts/fix_residual_wording.py [--apply]
不加 --apply 时为 dry-run，只报告将改动什么。
"""
from __future__ import annotations

import sys

APPLY = "--apply" in sys.argv

R = [
    # ---- A. 脚本里的面积判定文案 ----
    ("scripts/wsl_abc9_search.sh",
     'echo "  目标：≥10%（题目硬指标）；仅用 abc9，未更换映射器"',
     'echo "  赛题技术指标：≥10%；评分细则：有缩减即得基础分 20 分，≥20% 满分（无优化效果才 0 分）"\n'
     'echo "  仅用 abc9，未更换映射器"'),

    ("scripts/wsl_candidate_envelope.sh",
     'print(f"  逐用例平均缩减率：{mean_red*100:.2f}%     （≥10% 达标，≥20% 满分）")',
     'print(f"  逐用例平均缩减率：{mean_red*100:.2f}%     （技术指标 ≥10%；细则 ≥20% 满分）")'),
    ("scripts/wsl_candidate_envelope.sh",
     'print("  ✅ 逐用例平均 ≥10% —— 达到题目硬指标")',
     'print("  ✅ 逐用例平均 ≥10% —— 达到赛题技术指标")'),
    ("scripts/wsl_candidate_envelope.sh",
     'print(f"  ❌ 逐用例平均 {mean_red*100:.2f}% < 10% —— 仍未达硬指标，需继续扩大候选或找新抓手")',
     'print(f"  ⚠️ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达赛题技术指标'
     '（评分细则：有缩减即得基础分 20 分，无优化效果才 0 分），可继续扩大候选")'),

    ("scripts/wsl_integrate_pass.sh",
     "print(f\"  >>> 判定：{'✅ ≥20%，面积项可望满分' if avg >= 20 else ('✅ ≥10% 达标' if avg >= 10 else '❌ <10% 未达标')}\")",
     "print(f\"  >>> 判定：{'✅ ≥20%，按评分细则该项满分' if avg >= 20 else ('✅ ≥10%，达到赛题技术指标' if avg >= 10 else '⚠️ <10%，未达技术指标（细则：有缩减即得基础分 20 分，无优化效果才 0 分）')}\")"),

    ("scripts/wsl_large_eval.sh",
     "# 对照的硬指标（官方指南）：\n"
     "#   面积  ：相比原始 Yosys 默认流程，单元总数缩减 ≥10%（20% 以上该项满分）",
     "# 对照的赛题技术指标（赛题原文第 7 页）：\n"
     "#   面积  ：相比原始 Yosys 默认流程，单元总数缩减 ≥10%（技术指标）\n"
     "#           评分细则：有缩减即得基础分 20 分，≥20% 满分，无优化效果才 0 分"),
    ("scripts/wsl_large_eval.sh",
     'print("  === 面积门槛判定（≥10% 达标，≥20% 满分）===")',
     'print("  === 面积判定（技术指标 ≥10%；评分细则 ≥20% 满分）===")'),
    ("scripts/wsl_large_eval.sh",
     'print("  ✅ 逐用例平均 ≥10% —— 达到题目硬指标")',
     'print("  ✅ 逐用例平均 ≥10% —— 达到赛题技术指标")'),
    ("scripts/wsl_large_eval.sh",
     'print(f"  ❌ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达硬指标，需要继续找抓手")',
     'print(f"  ⚠️ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达赛题技术指标'
     '（细则仍有基础分 20 分），可继续找抓手")'),

    ("scripts/wsl_official_eval.sh",
     'elif mean_red >= 0.10: verdict = "✅ ≥10% —— 达到题目硬指标"\n'
     'else:                  verdict = f"❌ {mean_red*100:.2f}% < 10% —— 未达硬指标"',
     'elif mean_red >= 0.10: verdict = "✅ ≥10% —— 达到赛题技术指标"\n'
     'else:                  verdict = f"⚠️ {mean_red*100:.2f}% < 10% —— 未达技术指标（按细则仍有基础分 20 分）"'),

    ("scripts/official_report.py",
     '        L.append(f"- ✅ 逐用例平均 {mean_red*100:.2f}% ≥ 10% —— 达到题目硬指标")',
     '        L.append(f"- ✅ 逐用例平均 {mean_red*100:.2f}% ≥ 10% —— 达到赛题技术指标")'),
    ("scripts/official_report.py",
     '        L.append(f"- ❌ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达硬指标")',
     '        L.append(f"- ⚠️ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达赛题技术指标'
     '（评分细则：有缩减即得基础分 20 分，无优化效果才 0 分）")'),

    # ---- B. 代码注释里引用的作废成绩 ----
    ("plugin/pmux_opt.cc",
     " *      逻辑单元逐用例平均缩减 20.25%（单脚本）～24.10%（候选取优），且 DFF 不变。",
     " *      现行合规方案（纯 abc9）逐用例平均缩减 5.00%（test2 25→20，其余用例不变），DFF 不变。\n"
     " *      历史方案（把 abc9 换成经典 abc）的 20.25%～24.10% 因违反答疑 C53-1\n"
     " *      「请都用 yosys 自带的 abc9 运行，这个需要统一」已作废。"),
    ("plugin/yosys-0.69-pmux.patch",
     "+ *      逻辑单元逐用例平均缩减 20.25%（单脚本）～24.10%（候选取优），且 DFF 不变。",
     "+ *      现行合规方案（纯 abc9）逐用例平均缩减 5.00%（test2 25→20，其余用例不变），DFF 不变。\n"
     "+ *      历史方案（把 abc9 换成经典 abc）的 20.25%～24.10% 因违反答疑 C53-1 已作废。"),

    # ---- C. 遗漏的 Tcl 旧措辞 ----
    ("docs/week2_abc_lever.md",
     "我们仍需保留自研 pass（题目硬性要求自定义 Tcl 命令 + 分析能力），",
     "我们仍需保留自研 pass（赛题原文写「新增自定义 Tcl 命令」，但答疑 C41-3 已明确**不需要 Tcl 接口**，"
     "本项目按答疑执行；保留 pass 是为了分析能力与可复现性），"),
    ("docs/week1_checklist.md",
     "## 第 2～3 天 —— pass 编入主程序 + Tcl 可调用（本周唯一硬关卡）",
     "## 第 2～3 天 —— pass 编入主程序（本周唯一硬关卡；按答疑 C41-3 不要求 Tcl 接口）"),
    ("docs/week1_checklist.md",
     "- [ ] 从 Tcl 脚本调用成功（Yosys 内 `tcl` 或 `-c` 入口）—— **A + C**",
     "- [ ] ~~从 Tcl 脚本调用成功~~（答疑 C41-3 已明确**不需要 Tcl 接口**，此项取消）"),
    ("docs/week2_scale_eval.md",
     "3. **把候选选择算法固化进自研 pass**（题目要求自定义 Tcl 命令）：",
     "3. **把候选选择算法固化进自研 pass**（赛题原文写「新增自定义 Tcl 命令」，"
     "答疑 C41-3 已明确不需要 Tcl 接口）："),

    # ---- D. 标题与作废数字标注 ----
    ("docs/official_case_results.md",
     "# 官方 4 个 case 实测结果（面积达标，效率存在结构性冲突）",
     "# 官方 4 个 case 实测结果（**数字已作废，见下方声明**）"),
    ("benchmarks/large/MANIFEST.md",
     "| **平均** | | | | **7.28%**（含 unit/mixed 的 12 用例口径） | | | | |",
     "| **平均** | | | | **7.28%**（含 unit/mixed 的 12 用例口径）**（作废数字，见文末声明）** | | | | |"),
]

DECL = """
---

> **⚠️ 作废声明（2026-10-04）**：上表中的面积成绩（如 **7.28%**）来自"把 `abc9` 换成经典 `abc`"的方案，
> 违反最新答疑 **C53-1**（"请都用 yosys 自带的 abc9 运行，这个需要统一"），**已作废**，
> 仅作技术过程记录保留。**现行合规成绩为逐用例平均 5.00%**（纯 abc9）。
> 口径依据见 [`docs/requirements_authoritative.md`](../docs/requirements_authoritative.md)。
"""


def main() -> int:
    ok = miss = 0
    for path, old, new in R:
        try:
            t = open(path, encoding="utf-8").read()
        except FileNotFoundError:
            print(f"✗ 文件不存在: {path}")
            miss += 1
            continue
        n = t.count(old)
        if n != 1:
            print(f"✗ 跳过（出现 {n} 次，期望 1 次）: {path}\n    目标: {old[:70]}")
            miss += 1
            continue
        if APPLY:
            open(path, "w", encoding="utf-8").write(t.replace(old, new))
        print(f"✓ {'已改' if APPLY else '将改'}: {path}\n    {old[:64]}…")
        ok += 1

    # 给 large/MANIFEST.md 追加作废声明（仅当尚未包含）
    p = "benchmarks/large/MANIFEST.md"
    t = open(p, encoding="utf-8").read()
    if "作废声明" not in t:
        if APPLY:
            open(p, "a", encoding="utf-8").write(DECL)
        print(f"✓ {'已追加' if APPLY else '将追加'}作废声明: {p}")
        ok += 1
    else:
        print(f"· 已有作废声明，跳过: {p}")

    print(f"\n合计：成功 {ok} 条，跳过 {miss} 条")
    if not APPLY:
        print("（dry-run；加 --apply 才会写入）")
    return 0


if __name__ == "__main__":
    sys.exit(main())
