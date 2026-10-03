#!/usr/bin/env python3
"""extract_task_pdf.py —— 用 pypdf 提取赛题原文 PDF 全文
用法: python extract_task_pdf.py <in.pdf> <out.txt>
"""
import sys

from pypdf import PdfReader

src, dst = sys.argv[1], sys.argv[2]
r = PdfReader(src)
with open(dst, "w", encoding="utf-8") as f:
    for i, p in enumerate(r.pages):
        f.write(f"\n===== 第 {i + 1} 页 =====\n")
        f.write((p.extract_text() or "") + "\n")
print(f"已提取 {len(r.pages)} 页 → {dst}")
