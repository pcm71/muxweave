#!/usr/bin/env python3
"""list_modules.py —— 列出 JSON 里所有模块及其单元数（排查顶层模块名）"""
import collections
import json
import sys

d = json.load(open(sys.argv[1], encoding="utf-8"))
for name, m in d["modules"].items():
    cells = m.get("cells", {})
    types = collections.Counter(v["type"] for v in cells.values())
    top = dict(types.most_common(4))
    print(f"  {name:<34} 单元={len(cells):<6} {top}")
