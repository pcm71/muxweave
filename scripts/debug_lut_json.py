#!/usr/bin/env python3
"""debug_lut_json.py —— 查 abc9 之后 $lut 单元在 JSON 里的真实结构"""
import collections
import json
import os

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
d = json.load(open("runs/lut_merge/test2.json", encoding="utf-8"))
print("module keys:", list(d["modules"].keys()))
m = d["modules"]["test2"]
cells = m["cells"]
print("模块 test2 单元数:", len(cells))
c = collections.Counter(v["type"] for v in cells.values())
print("类型统计:", dict(c))

lutname = next(k for k, v in cells.items() if v["type"] == "$lut")
cell = cells[lutname]
print("\n第一个 $lut 单元:", lutname)
print("connections:", json.dumps(cell["connections"], ensure_ascii=False)[:500])
print("parameters:", list(cell.get("parameters", {}).keys()))

# 顶层连线格式
print("\nports 示例:", json.dumps(m.get("ports", {}), ensure_ascii=False)[:300])
