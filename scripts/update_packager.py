#!/usr/bin/env python3
"""update_packager.py —— 把打包脚本里的旧配置更新为当前配置"""
from pathlib import Path

p = Path("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/scripts/make_submission_package.sh")
t = p.read_text(encoding="utf-8")
orig = t

REPL = [
    # 1) 包内验证的期望值（旧：16.34% 配置的 287/15/13/27）
    ('test1) exp=287 ;; test2) exp=15 ;; test3) exp=13 ;; test4) exp=27 ;; *) exp=? ;;',
     'test1) exp=287 ;; test2) exp=15 ;; test3) exp=9 ;; test4) exp=29 ;; *) exp=? ;;'),
    # 2) 现行脚本来源（四段式）
    ('cp configs/abc_scripts/nkl/n_win.abc "$PKG/abc_scripts/area_script.abc"',
     'cp configs/abc_scripts/verify_shipped/shipped.abc "$PKG/abc_scripts/area_script.abc"'),
    ('echo "  ✓ area_script.abc（pass 内 SCRIPT_AREA，逐字一致）"',
     'echo "  ✓ area_script.abc（pass 内 SCRIPT_AREA，四段式，逐字一致）"'),
    # 3) 说明与结果摘要
    ('验证它能复现 16.34%。', '验证它能复现 22.64%。'),
    ('echo "- 面积：逐用例平均 **16.34%**（287/15/13/27，基线 288/25/13/36）"',
     'echo "- 面积：逐用例平均 **22.64%**（287/15/9/29，基线 288/25/13/36）"'),
    ('echo "- 内存开销：+11.3%（C54-2 口径，只看 yosys.exe）；CPU 按 C54-1 不计分"',
     'echo "- 内存开销：最大 **+1.0%**（C54-2 口径，只看 yosys.exe，不超过 5% 满分线）；CPU 按 C54-1 不计分"'),
    # 4) 证据材料增加两份新文档
    ('for f in docs/official_submission.md docs/equivalence_matrix.md docs/requirements_authoritative.md; do',
     'for f in docs/official_submission.md docs/equivalence_matrix.md docs/requirements_authoritative.md docs/work_summary.md docs/roadmap.md; do'),
]

for old, new in REPL:
    if old in t:
        t = t.replace(old, new)
        print(f"  ✓ 替换: {old[:60]}…")
    else:
        print(f"  ! 未命中（可能已改）: {old[:60]}…")

if t != orig:
    p.write_text(t, encoding="utf-8", newline="\n")
    print("\n已写回")
else:
    print("\n无变化")

print("\n=== 关键行复核 ===")
for i, ln in enumerate(p.read_text(encoding="utf-8").split("\n"), 1):
    if any(k in ln for k in ("exp=", "area_script.abc", "面积：逐用例", "内存开销：", "for f in docs/", "复现 2")):
        print(f"  {i}: {ln.strip()}")
