#!/usr/bin/env python3
"""probe_widths.py —— 对比 abc9 与经典映射输出的 LUT 位宽分布，并核对可合并对数

关键背景：Cyclone IV 的 LCELL 里，2 输入 LUT 和 4 输入 LUT **同样占 1 个单元**。
所以"把两个窄 LUT 合成一个宽 LUT"（合并后支撑集 ≤4）能**净省单元**，
这正是经典 `lutpack` 在 test2 上做到 25→15 的原理。

本脚本对 test2/test4 比较：
  A. abc9 默认输出     的位宽分布
  B. abc9 + -a 脚本    的位宽分布
  C. 经典纯映射        的位宽分布
再对 A 统计"级联合并对"（放宽 fanout 限制，分别统计净收益与潜在收益）。
"""
from __future__ import annotations

import collections
import json
import os
import subprocess

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
os.environ["PATH"] = os.path.expanduser("~/.local/bin") + os.pathsep + os.environ.get("PATH", "")
D = "runs/widths"
os.makedirs(D, exist_ok=True)

CFG = {
    "abc9默认": "abc9 -lut 4 -W 300",
    "abc9面积": "abc9 -lut 4 -script configs/abc_scripts/a9_a_F5.abc",
    "经典纯映射": "abc -lut 4 -script configs/abc_scripts/diag/d0_map.abc",
    "经典+lutpack": "abc -lut 4 -script configs/abc_scripts/diag/d2_lutpack.abc",
}


def gen(case: str, cmd: str, tag: str) -> str:
    out = f"{D}/{case}_{tag}.json"
    p = f"""
read_verilog benchmarks/official/{case}.v
hierarchy -top {case}
synth_intel -family cycloneiv -top {case} -run begin:map_luts
{cmd}
clean
opt -fast
write_json {out}
"""
    subprocess.run(["yosys", "-q", "-p", p], capture_output=True, text=True)
    return out


def w_of(c) -> int:
    w = c.get("parameters", {}).get("WIDTH")
    try:
        return int(w)
    except Exception:
        return -1


def load_luts(path: str, case: str):
    d = json.load(open(path, encoding="utf-8"))
    mod = d["modules"][case]
    out = {}
    for name, c in mod["cells"].items():
        if c["type"] != "$lut":
            continue
        ins, y = set(), None
        for port, bits in c["connections"].items():
            if port == "Y":
                y = bits[0] if bits else None
            else:
                ins |= set(bits)
        if y is None:
            continue
        out[name] = dict(ins=ins, out=y, w=w_of(c))
    return out


def merge_stats(luts):
    """统计级联合并：生产者输出喂给消费者，合并后支撑集 ≤4"""
    prod = {v["out"]: k for k, v in luts.items()}
    fanout = collections.Counter()
    for v in luts.values():
        for s in v["ins"]:
            if s in prod:
                fanout[s] += 1
    net = 0            # 生产者无其他扇出 ⇒ 净省
    pot = 0            # 生产者有其它扇出 ⇒ 合并也省不了（需复制），列为潜在
    for cn, cv in luts.items():
        for s in cv["ins"]:
            pn = prod.get(s)
            if pn is None or pn == cn:
                continue
            union = (cv["ins"] - {s}) | luts[pn]["ins"]
            if len(union) <= 4:
                if fanout[s] == 1:
                    net += 1
                else:
                    pot += 1
                break
    return net, pot


for case in ["test2", "test4", "test3", "test1"]:
    print(f"=== {case} ===")
    for tag, cmd in CFG.items():
        p = gen(case, cmd, tag)
        try:
            luts = load_luts(p, case)
        except Exception as e:
            print(f"  {tag:<12} 解析失败 {e}")
            continue
        dist = collections.Counter(v["w"] for v in luts.values())
        net, pot = merge_stats(luts)
        print(f"  {tag:<12} LUT={len(luts):<5} 位宽分布={dict(sorted(dist.items()))}  "
              f"可净合并={net} 潜在={pot}")
    print()
