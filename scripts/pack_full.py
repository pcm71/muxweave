#!/usr/bin/env python3
"""pack_full.py —— 打「完整包」：含 .git 历史与 runs/ 证据，且路径分隔符必须为标准 '/'。

为什么不用 PowerShell 的 Compress-Archive：它写出的 zip 用 '\\' 作分隔符，
在 Linux/WSL 上解压可能产生带反斜杠的文件名或建不出目录。
zipfile 始终写标准 '/'。
"""
import sys
import zipfile
from pathlib import Path

SRC = Path(sys.argv[1])          # 要打包的目录（会以 muxweave/ 为顶层前缀）
OUT = Path(sys.argv[2])
PREFIX = "muxweave"

if OUT.exists():
    OUT.unlink()

n = 0
with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as z:
    for p in sorted(SRC.rglob("*")):
        if not p.is_file():
            continue
        arc = f"{PREFIX}/{p.relative_to(SRC).as_posix()}"
        z.write(p, arc)
        n += 1

print(f"写入 {n} 个文件 -> {OUT}  ({OUT.stat().st_size/1024:.1f} KB)")

# 自检：不允许出现反斜杠分隔符
with zipfile.ZipFile(OUT) as z:
    bad = [x for x in z.namelist() if "\\" in x]
    print(f"含反斜杠的条目: {len(bad)}  {'(应为 0)' if not bad else bad[:3]}")
    if bad:
        sys.exit(1)
    checks = {
        ".git/HEAD": f"{PREFIX}/.git/HEAD",
        "runs/ 证据": f"{PREFIX}/runs/build_yosys.log",
        "week1 报告": f"{PREFIX}/docs/week1_report.md",
        "setup.sh": f"{PREFIX}/setup.sh",
    }
    names = set(z.namelist())
    for label, want in checks.items():
        print(f"  {'[OK]' if want in names else '[MISS]'} {label}: {want}")
    # 顶层结构
    tops = sorted({x.split('/')[0] for x in names})
    print("顶层条目:", tops)
