#!/usr/bin/env python3
"""dump_docx.py —— 无依赖提取 .docx 文本（zipfile + XML）
用法: python3 dump_docx.py <file.docx> [out.txt]
"""
import re
import sys
import zipfile

src = sys.argv[1]
out = sys.argv[2] if len(sys.argv) > 2 else None
z = zipfile.ZipFile(src)
xml = z.read("word/document.xml").decode("utf-8", "ignore")
# 段落与换行
xml = xml.replace("</w:p>", "\n").replace("<w:br/>", "\n").replace("<w:tab/>", "\t")
text = re.sub(r"<[^>]+>", "", xml)
text = (text.replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">")
            .replace("&quot;", '"').replace("&apos;", "'"))
lines = [l.rstrip() for l in text.split("\n")]
text = "\n".join(lines)
if out:
    open(out, "w", encoding="utf-8").write(text)
    print(f"已写出 {out}（{len(lines)} 段）")
else:
    print(text)
