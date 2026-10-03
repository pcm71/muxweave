#!/usr/bin/env python3
"""official_report.py —— 生成官方 4 个 case 的逐用例提交报告。

口径（依据官方 Q&A）：
  面积：缩减率 = (优化前逻辑单元数 − 优化后) / 优化前逻辑单元数，**按每个用例的平均算**，主看逻辑单元
  DFF ：不做硬性要求，但不应多于优化前
  效率：开销 = CPU 时间 + 整进程峰值内存，**每个用例都要满足**（≤5% 得满分），**CPU 时间含 abc**
  基线：加优化算法编译的程序 与 原始代码编译的程序 在**同一环境**下比较
        ⇒ 用 runs/binaries/yosys-baseline 与 yosys-pmux 两个真实二进制

用法（在 WSL 中执行）:
    python3 scripts/official_report.py [重复次数，默认 7]
输出:
    reports/official_submission.md   人读报告
    reports/official_results.json    机器可读结果
"""
from __future__ import annotations

import glob
import json
import os
import statistics
import subprocess
import sys
from datetime import datetime, timezone

REPS = int(sys.argv[1]) if len(sys.argv) > 1 else 7
BIN_DIR = os.path.expanduser("~/.local/bin")
BINS = [("baseline（原始代码编译）", f"{BIN_DIR}/yosys-baseline"),
        ("pmux_opt（优化版编译）",  f"{BIN_DIR}/yosys-pmux")]
CASES = sorted(glob.glob("benchmarks/official/*.v"))
OUT_MD = "docs/official_submission.md"
OUT_JSON = "docs/official_results.json"

# 等价性结论来自 scripts/wsl_equiv_unbounded.sh（含自检+负对照的前置校验）
EQUIV = {
    "test1": "PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL）",
    "test2": "PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL）",
    "test3": "PASS（有界 -seq 12 + 无界归纳；自检 PASS / 负对照 FAIL）",
    "test4": "PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL）",
}
EQUIV_SCRIPT = "scripts/wsl_equiv_unbounded.sh"
EQUIV_DOC = "docs/equivalence_matrix.md"


def measure(binary: str, case: str, top: str, reps: int):
    """用 measure_run.py 重复测量（每次全新进程，ru_maxrss 只反映该 yosys 子进程）。"""
    stat_path = f"runs/official_report/{top}.json"
    os.makedirs("runs/official_report", exist_ok=True)
    cpus, rsss, walls = [], [], []
    for _ in range(reps):
        cmd = [sys.executable, "scripts/measure_run.py", "--", binary, "-q", "-p",
               f"read_verilog {case}; hierarchy -top {top}; "
               f"synth_intel -family cycloneiv -top {top}; "
               f"tee -o {stat_path} stat -json"]
        r = subprocess.run(cmd, capture_output=True, text=True, check=False)
        try:
            d = json.loads(r.stdout.strip().splitlines()[-1])
        except Exception:
            continue
        if d.get("rc") != 0:
            continue
        cpus.append(d["cpu_total"]); rsss.append(d["maxrss_kb"]); walls.append(d["wall"])
    if not cpus:
        return None
    try:
        s = json.load(open(stat_path, encoding="utf-8"))
        nbt = s["design"]["num_cells_by_type"]
        dff = sum(v for k, v in nbt.items()
                  if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
        total = s["design"]["num_cells"]
        logic = total - dff
    except Exception:
        logic = dff = None
    return dict(cpu=statistics.median(cpus), rss=statistics.median(rsss),
                wall=statistics.median(walls), logic=logic, dff=dff, n=len(cpus))


def main() -> int:
    rows = []
    for case in CASES:
        top = os.path.basename(case)[:-2]
        m = {}
        for label, binary in BINS:
            if not os.path.exists(binary):
                print(f"缺少二进制 {binary}", file=sys.stderr)
                return 2
            m[label] = measure(binary, case, top, REPS)
        b = m[BINS[0][0]]; o = m[BINS[1][0]]
        if not b or not o or b["logic"] is None or o["logic"] is None:
            print(f"{top}: 测量失败", file=sys.stderr)
            continue
        rows.append(dict(
            case=top,
            base_logic=b["logic"], opt_logic=o["logic"],
            base_dff=b["dff"], opt_dff=o["dff"],
            reduction=(b["logic"] - o["logic"]) / b["logic"] if b["logic"] else 0.0,
            base_cpu=b["cpu"], opt_cpu=o["cpu"],
            base_rss=b["rss"], opt_rss=o["rss"],
            cpu_overhead=(o["cpu"] - b["cpu"]) / b["cpu"] * 100 if b["cpu"] else 0.0,
            rss_overhead=(o["rss"] - b["rss"]) / b["rss"] * 100 if b["rss"] else 0.0,
            equiv=EQUIV.get(top, "未验证"),
        ))

    if not rows:
        print("没有任何可用结果", file=sys.stderr)
        return 1

    mean_red = statistics.fmean(r["reduction"] for r in rows)
    tb = sum(r["base_logic"] for r in rows); to = sum(r["opt_logic"] for r in rows)
    worst_cpu = max(r["cpu_overhead"] for r in rows)
    worst_rss = max(r["rss_overhead"] for r in rows)
    dff_bad = [r["case"] for r in rows if (r["opt_dff"] or 0) > (r["base_dff"] or 0)]

    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    os.makedirs("docs", exist_ok=True)
    json.dump(dict(generated=stamp, reps=REPS, cases=rows,
                   mean_reduction=mean_red,
                   total_base=tb, total_opt=to,
                   worst_cpu_overhead=worst_cpu, worst_rss_overhead=worst_rss,
                   dff_violations=dff_bad),
              open(OUT_JSON, "w", encoding="utf-8"), ensure_ascii=False, indent=2)

    L = []
    L.append("# 官方 4 个 case 逐用例提交报告\n")
    L.append(f"生成时间：{stamp}　重复测量：每项 {REPS} 次取中位数\n")
    L.append("## 一、口径与基线\n")
    L.append("| 项 | 依据 |")
    L.append("|---|---|")
    L.append("| 面积 | `(优化前逻辑单元数 − 优化后) / 优化前逻辑单元数`，**按每个用例的平均算**，主看逻辑单元 |")
    L.append("| DFF | 不做硬性要求，但**不应多于优化前** |")
    L.append("| 效率 | 开销 = CPU 时间 + 整进程峰值内存，**每个用例都要满足**，CPU 时间含 abc |")
    L.append("| 基线 | 「加优化算法编译的程序」vs「原始代码编译的程序」在**同一环境**比较 ⇒ 两个真实二进制 |")
    L.append("")
    L.append("两个二进制（同一源码树，唯一差别是 `techlibs/intel/synth_intel.cc` 是否调用 `pmux_opt`）：")
    L.append("")
    L.append("```text")
    L.append("runs/binaries/yosys-baseline   原始代码编译（synth_intel 直接调用 abc9 -lut 4 -W 300）")
    L.append("runs/binaries/yosys-pmux       优化版编译（synth_intel 调用自研 pass pmux_opt）")
    L.append("```")
    L.append("")
    L.append("## 二、逐用例结果\n")
    L.append("| 用例 | 逻辑单元(优化前) | 逻辑单元(优化后) | **缩减率** | DFF(前→后) | CPU 开销 | 内存开销 | 等价性 |")
    L.append("|---|---|---|---|---|---|---|---|")
    for r in rows:
        L.append("| {case} | {bl} | **{ol}** | **{red:.1f}%** | {bd}→{od} | {co:+.1f}% | {ro:+.1f}% | {eq} |".format(
            case=r["case"], bl=r["base_logic"], ol=r["opt_logic"], red=r["reduction"] * 100,
            bd=r["base_dff"], od=r["opt_dff"], co=r["cpu_overhead"], ro=r["rss_overhead"],
            eq=r["equiv"]))
    L.append("| **逐用例平均（官方口径）** | {tb} | **{to}** | **{mr:.2f}%** | — | — | — | — |".format(
        tb=tb, to=to, mr=mean_red * 100))
    L.append("")
    L.append("### 面积判定")
    L.append("")
    if mean_red >= 0.20:
        L.append(f"- ✅ **逐用例平均 {mean_red*100:.2f}% ≥ 20%** —— 达到评分表「20% 以上该项满分」")
    elif mean_red >= 0.10:
        L.append(f"- ✅ 逐用例平均 {mean_red*100:.2f}% ≥ 10% —— 达到题目硬指标")
    else:
        L.append(f"- ❌ 逐用例平均 {mean_red*100:.2f}% < 10% —— 未达硬指标")
    L.append(f"- DFF 约束：{'✅ 全部用例均未增加' if not dff_bad else '❌ 增加于 ' + ', '.join(dff_bad)}")
    L.append("")
    L.append("### 效率判定（官方口径：每个用例都要 ≤5%）")
    L.append("")
    L.append(f"- 最大 CPU 开销：**{worst_cpu:+.1f}%**")
    L.append(f"- 最大内存开销：**{worst_rss:+.1f}%**")
    L.append(f"- >>> **{'✅ 全部用例 ≤5%' if worst_cpu <= 5 and worst_rss <= 5 else '❌ 存在超标用例（5% 门槛未满足）'}**")
    L.append("")
    L.append("> 说明：经典 `abc` 映射器的内存开销是结构性的（脚本从 12 步砍到 7 步后 CPU 开销可降到约 +13%，")
    L.append("> 内存仍约 +30%）。若主办方确认效率项按超出比例重罚，则应改用纯 `abc9` 方案（面积约 5%）。")
    L.append("")
    L.append("## 三、等价性\n")
    L.append(f"方法：`{EQUIV_SCRIPT}`（miter + sat，含 `proc` / `async2sync` / 显式 `flatten miter`）。")
    L.append(f"完整矩阵与踩坑记录见 [`{EQUIV_DOC}`](../{EQUIV_DOC})。\n")
    L.append("| 用例 | 结论 |")
    L.append("|---|---|")
    for r in rows:
        L.append(f"| {r['case']} | {r['equiv']} |")
    L.append("")
    L.append("> 每个用例的检查器都先通过**自检**（同一网表比自身必须 PASS）与**负对照**")
    L.append("> （人为引入可观测差异必须 FAIL）双重校验，结论才有效。")
    L.append("> 该方法是**无界时序归纳**；EQY 在 test4 上因 partition 含 memory 而无法验证（且同样影响官方基线），")
    L.append("> 本方法不依赖 SBY，可覆盖该场景。")
    L.append("")
    L.append("## 四、复现\n")
    L.append("```bash")
    L.append("bash scripts/wsl_build_baseline.sh      # 编译出原始/优化两个二进制")
    L.append("bash scripts/wsl_verify_binaries.sh     # 校验两者行为差异")
    L.append(f"python3 scripts/official_report.py {REPS}    # 生成本报告")
    L.append("bash scripts/wsl_equiv_unbounded.sh <用例> <周期>   # 等价性（含自检+负对照）")
    L.append("```")

    open(OUT_MD, "w", encoding="utf-8").write("\n".join(L) + "\n")
    print(f"已写出 {OUT_MD} 与 {OUT_JSON}")
    print(f"  逐用例平均缩减率：{mean_red*100:.2f}%")
    print(f"  最大 CPU 开销 {worst_cpu:+.1f}%   最大内存开销 {worst_rss:+.1f}%")
    print(f"  DFF 超标用例：{dff_bad if dff_bad else '无'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
