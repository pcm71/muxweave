#!/usr/bin/env python3
"""fix_gitignore.py —— 修好 .gitignore 第 37 行的 GBK 乱码，并统一为 LF"""
from pathlib import Path

p = Path("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/.gitignore")
txt = p.read_text(encoding="utf-8")

# 该行原为 GBK 编码的"提交物打包产物（体积大，不入库）"，解码失败后成了 U+FFFD 乱码
lines = txt.split("\n")
fixed = []
for ln in lines:
    if "\ufffd" in ln:
        fixed.append("# 提交物打包产物（体积大，不入库）")
        print(f"  修正乱码行: {ln!r} -> '# 提交物打包产物（体积大，不入库）'")
    else:
        fixed.append(ln)

# 统一 LF（原文件混有 CRLF）
out = "\n".join(l.rstrip("\r") for l in fixed)
if not out.endswith("\n"):
    out += "\n"
p.write_text(out, encoding="utf-8", newline="\n")

# 复核
b = p.read_bytes()
assert b"\r" not in b, "仍有 CR 字符"
b.decode("utf-8")
print("  ✓ 复核：合法 UTF-8、无 CR、行尾统一 LF")
print()
print("=== .gitignore 全文 ===")
for i, ln in enumerate(p.read_text(encoding="utf-8").split("\n"), 1):
    if ln.strip():
        print(f"  {i:2d}  {ln}")
