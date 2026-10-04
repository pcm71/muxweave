#!/usr/bin/env python3
"""analyze_test1_ff.py —— 查 test1 最终网表里的触发器有没有用上 ena/sclr

背景：Cyclone IV 的 LCELL 自带时钟使能(ena)与同步/异步清零。
      test1 里 i0..i7、q0..q7 共 16 个 12 位寄存器**只在 START 状态加载、其余状态保持**
      （RTL 是 case(state) 里没赋值 ⇒ 保持）。
      若"保持"交给 FF 的 ena 承担，那么每位省掉一个反馈 mux（1 个 LUT4）——
      16×12 = 192 位，潜在收益巨大。
本脚本统计最终网表里 dffeas 的端口使用情况。
"""
from __future__ import annotations

import collections
import json
import os
import subprocess

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
os.environ["PATH"] = os.path.expanduser("~/.local/bin") + os.pathsep + os.environ.get("PATH", "")
D = "runs/test1_ff"
os.makedirs(D, exist_ok=True)

out = f"{D}/test1.json"
r = subprocess.run(["yosys", "-q", "-p", f"""
read_verilog benchmarks/official/test1.v
hierarchy -top test1
synth_intel -family cycloneiv -top test1
write_json {out}
"""], capture_output=True, text=True)
if r.returncode != 0:
    print("综合失败:", r.stderr[-300:])
    raise SystemExit(1)

d = json.load(open(out, encoding="utf-8"))
mod = d["modules"]["test1"]
cells = mod["cells"]

types = collections.Counter(c["type"] for c in cells.values())
print("单元类型:", dict(types.most_common(8)))
print()

ffs = {k: v for k, v in cells.items() if "dffeas" in v["type"]}
print(f"dffeas 数量: {len(ffs)}")
portuse = collections.Counter()
for c in ffs.values():
    for p, bits in c["connections"].items():
        # 端口被"真正连上"= 有非零、非常量 0 的位
        if any(b not in (0, "0", "x", "z") for b in bits):
            portuse[p] += 1
print("端口使用统计（连了非 0 常量的触发器数）:")
for p, n in portuse.most_common():
    print(f"  {p:<8} {n}")

# 看几个样本
print()
for i, (k, c) in enumerate(list(ffs.items())[:3]):
    print(f"样本{i}: {k}")
    print(f"  参数={c.get('parameters', {})}")
    print(f"  端口={ {p: b[:4] for p, b in c['connections'].items()} }")

# LUT 数
luts = [c for c in cells.values() if c["type"] == "$lut" or "lcell_comb" in c["type"]]
print(f"\nLUT/组合单元数: {len(luts)}")
