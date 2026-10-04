#!/usr/bin/env python3
"""轻量静态校验：Verilog 结构配对 + JSON 可解析 + 关键文件存在性。

这不是编译器，只是 catching typo 级别的检查：
  - module/endmodule、begin/end、case/endcase、function/endfunction、task/endtask 配对
  - 括号配对
  - JSON 文件可解析
真正的可综合性必须由 Yosys 确认（第 1 周在 WSL/Linux 上做）。
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
fail = 0

PAIRS = [("module", "endmodule"), ("begin", "end"), ("case", "endcase"),
         ("function", "endfunction"), ("task", "endtask")]


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    text = re.sub(r"//[^\n]*", " ", text)
    return text


def count_word(text: str, word: str) -> int:
    return len(re.findall(r"\b" + word + r"\b", text))


print("== Verilog 结构配对 ==")
# 跳过构建产物目录：dist/ 是"按 C55 打包的提交物"，里面含整套 Yosys share/ 库文件
# （数千个第三方 .v），既不是本项目源码，也不该用本项目的规则去校验。
SKIP_DIRS = {"dist", ".git", "runs", "_tmp"}
for vf in sorted(ROOT.glob("**/*.v")):
    if any(part in SKIP_DIRS for part in vf.relative_to(ROOT).parts):
        continue
    src = strip_comments(vf.read_text(encoding="utf-8", errors="replace"))
    problems = []
    for a, b in PAIRS:
        na, nb = count_word(src, a), count_word(src, b)
        if a == "begin":
            # begin 可带标签(: name)，且 end 也用于 endcase/endmodule 之外，需特殊处理
            nb = len(re.findall(r"\bend\b", src))
            na = len(re.findall(r"\bbegin\b", src))
        if na != nb:
            problems.append(f"{a}={na} vs {b}={nb}")
    if src.count("(") != src.count(")"):
        problems.append(f"()={src.count('(')}/{src.count(')')}")
    if problems:
        print(f"  [FAIL] {vf.relative_to(ROOT)}: " + "; ".join(problems))
        fail += 1
    else:
        mods = count_word(src, "module")
        print(f"  [OK  ] {vf.relative_to(ROOT)} (module x{mods})")

print("== JSON 可解析 ==")
for jf in sorted(ROOT.glob("configs/*.json")) + sorted(ROOT.glob("benchmarks/**/*.json")):
    try:
        json.loads(jf.read_text(encoding="utf-8"))
        print(f"  [OK  ] {jf.relative_to(ROOT)}")
    except Exception as exc:
        print(f"  [FAIL] {jf.relative_to(ROOT)}: {exc}")
        fail += 1

print("== EQY 配置必备小节 ==")
for ef in sorted(ROOT.glob("formal/**/*.eqy")):
    txt = ef.read_text(encoding="utf-8")
    missing = [s for s in ("[gold]", "[gate]", "[strategy") if s not in txt]
    if missing:
        print(f"  [FAIL] {ef.relative_to(ROOT)}: 缺少 {missing}")
        fail += 1
    else:
        print(f"  [OK  ] {ef.relative_to(ROOT)}")

print("== 必备文件 ==")
required = ["README.md", "VERSION_LOCK.md", "THIRD_PARTY.md", "configs/pipelines.json",
            "configs/b0_synth_intel_cycloneiv.ys", "scripts/run_case.py", "scripts/report.py",
            "scripts/check_env.sh", "scripts/bootstrap_yosys.sh", "scripts/build_eqy.sh",
            "scripts/measure_cmd.sh", "plugin/pmux_analyze.cc", "plugin/pmux_opt.cc",
            "plugin/INTEGRATION.md", "formal/mini/run_formal_mini.sh", "docs/week1_checklist.md",
            "benchmarks/unit/MANIFEST.md"]
for rel in required:
    p = ROOT / rel
    if p.is_file() and p.stat().st_size > 0:
        print(f"  [OK  ] {rel} ({p.stat().st_size} B)")
    else:
        print(f"  [FAIL] {rel} 缺失或为空")
        fail += 1

print()
print(f"结果：{'全部通过' if fail == 0 else str(fail) + ' 项失败'}")
sys.exit(1 if fail else 0)
