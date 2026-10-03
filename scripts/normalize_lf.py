#!/usr/bin/env python3
"""normalize_lf.py —— 把指定文件的 CRLF 换行统一为 LF（原地）

原因：Windows 上 Python 的 open(path,"w") 默认会把 \n 写成 \r\n，
      导致 shell 脚本在 WSL 里报 `$'do\r'` 语法错误。
本脚本以二进制方式读入、把 b"\\r\\n" 替换为 b"\\n"，不改其他内容。
"""
from __future__ import annotations

import sys

FILES = [
    "scripts/wsl_abc9_search.sh",
    "scripts/wsl_candidate_envelope.sh",
    "scripts/wsl_large_eval.sh",
    "scripts/wsl_official_eval.sh",
    "scripts/wsl_integrate_pass.sh",
    "scripts/official_report.py",
    "plugin/pmux_opt.cc",
    "plugin/yosys-0.69-pmux.patch",
    "docs/official_case_results.md",
    "docs/week2_abc_lever.md",
    "docs/week1_checklist.md",
    "docs/week2_scale_eval.md",
    "benchmarks/large/MANIFEST.md",
]

total = 0
for p in FILES:
    try:
        b = open(p, "rb").read()
    except FileNotFoundError:
        print(f"✗ 不存在: {p}")
        continue
    n = b.count(b"\r\n")
    if n == 0:
        print(f"· 已是 LF: {p}")
        continue
    open(p, "wb").write(b.replace(b"\r\n", b"\n"))
    print(f"✓ 已转 LF: {p}（替换 {n} 处）")
    total += n
print(f"\n合计替换 {total} 处 CRLF → LF")
