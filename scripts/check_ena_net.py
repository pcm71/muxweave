#!/usr/bin/env python3
"""check_ena_net.py —— 查 test1 里 222 个 dffeas 共用的 ena 位(765)到底是什么

若它是常量 1（VCC），说明"保持"没有交给 FF 使能，而是仍由 LUT 实现 —— 那是一大块机会。
"""
from __future__ import annotations

import collections
import json
import os

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
d = json.load(open("runs/test1_ff/test1.json", encoding="utf-8"))
mod = d["modules"]["test1"]

# 找 VCC / GND 单元的输出去向
print("=== VCC/GND 等常量源 ===")
for name, c in mod["cells"].items():
    if c["type"] in ("VCC", "GND") or "$const" in c["type"]:
        print(f"  {name}: {c['type']} -> { {p: b[:3] for p, b in c['connections'].items()} }")

# netnames: 哪个名字对应位 765
print("\n=== 位 765 属于哪些网络名 ===")
hits = []
for nname, n in mod.get("netnames", {}).items():
    bits = n.get("bits", [])
    if 765 in bits:
        hits.append((nname, n.get("hide_name"), bits[:8]))
for h in hits[:10]:
    print(f"  {h[0]}  hide={h[1]} bits={h[2]}")

print("\n=== 端口位（顶层端口占用的位号）===")
for p, v in mod.get("ports", {}).items():
    print(f"  {p}: {v['bits'][:6]}")

# 统计 dffeas 里 ena/d/clrn 的取值分布
print("\n=== dffeas 端口取值分布 ===")
cnt = collections.defaultdict(collections.Counter)
for c in mod["cells"].values():
    if "dffeas" not in c["type"]:
        continue
    for p in ("ena", "clrn", "prn", "sclr", "d"):
        b = c["connections"].get(p)
        if b:
            cnt[p][str(b[0])[:12]] += 1
for p in ("ena", "clrn", "prn", "sclr"):
    top = cnt[p].most_common(4)
    print(f"  {p}: {top}")
