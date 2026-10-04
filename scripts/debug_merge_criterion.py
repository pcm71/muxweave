#!/usr/bin/env python3
"""debug_merge_criterion.py —— 用一个"已知 lutpack 能省 26 个"的样本
（经典纯映射的 test1：312 → lutpack 后 286）来验证我的合并判据是否正确。
若在它上面也找不到可合并对，说明判据/解析有 bug。
"""
from __future__ import annotations

import collections
import json
import os
import subprocess

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
os.environ["PATH"] = os.path.expanduser("~/.local/bin") + os.pathsep + os.environ.get("PATH", "")
D = "runs/debug_merge"
os.makedirs(D, exist_ok=True)


def gen(case, cmd, tag):
    out = f"{D}/{case}_{tag}.json"
    subprocess.run(["yosys", "-q", "-p", f"""
read_verilog benchmarks/official/{case}.v
hierarchy -top {case}
synth_intel -family cycloneiv -top {case} -run begin:map_luts
{cmd}
clean
opt -fast
write_json {out}
"""], capture_output=True, text=True)
    return out


def load(path, case):
    d = json.load(open(path, encoding="utf-8"))
    mod = d["modules"][case]
    luts = {}
    for name, c in mod["cells"].items():
        if c["type"] != "$lut":
            continue
        ins, y = set(), None
        for port, bits in c["connections"].items():
            if port == "Y":
                y = bits[0] if bits else None
            else:
                ins |= set(bits)
        if y is not None:
            luts[name] = dict(ins=ins, out=y)
    return luts


def analyze(luts, label):
    prod = {v["out"]: k for k, v in luts.items()}
    fanout = collections.Counter()
    for v in luts.values():
        for s in v["ins"]:
            if s in prod:
                fanout[s] += 1
    cand = collections.Counter()   # union 大小分布
    net = 0
    for cn, cv in luts.items():
        for s in cv["ins"]:
            pn = prod.get(s)
            if pn is None or pn == cn:
                continue
            union = (cv["ins"] - {s}) | luts[pn]["ins"]
            cand[len(union)] += 1
            if len(union) <= 4 and fanout[s] == 1:
                net += 1
    print(f"  {label}: LUT={len(luts)}  级联候选(按合并后支撑集大小)={dict(sorted(cand.items()))}")
    print(f"       净可合并(支撑≤4 且生产者扇出=1) = {net}")
    # 抽样看几个 LUT
    for i, (k, v) in enumerate(list(luts.items())[:3]):
        print(f"       样本{i}: {k} ins={len(v['ins'])} out={v['out']}")
    # 统计：有多少 LUT 的输入里含其他 LUT 的输出
    consumers = sum(1 for v in luts.values() if any(s in prod for s in v["ins"]))
    print(f"       输入中含其它 LUT 输出的 LUT 数 = {consumers}/{len(luts)}")
    return cand


print("=== 经典纯映射 test1（已知 lutpack 可省 26 个）===")
p = gen("test1", "abc -lut 4 -script configs/abc_scripts/diag/d0_map.abc", "plain")
analyze(load(p, "test1"), "经典纯映射 test1")

print()
print("=== abc9 默认 test1 ===")
p = gen("test1", "abc9 -lut 4 -W 300", "abc9")
analyze(load(p, "test1"), "abc9 test1")
