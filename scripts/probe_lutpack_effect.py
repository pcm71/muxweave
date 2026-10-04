#!/usr/bin/env python3
"""probe_lutpack_effect.py —— 查清经典 lutpack 到底做了什么（为什么 test2 25→15）

对 test2：
  1) 经典流程 strash/dch/if（不加 lutpack）→ 导出 $lut 网络，看 LUT 位宽分布
  2) 经典流程 + lutpack -S 1              → 同样导出，看位宽分布
  若第 2 步出现 >4 输入的 LUT，则 15 这个数字可能是"未正确映射"的假象；
  若全是 ≤4 输入，则 lutpack 真的找到了更优映射，需要弄清机制。
"""
from __future__ import annotations

import collections
import json
import os
import subprocess

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
os.environ["PATH"] = os.path.expanduser("~/.local/bin") + os.pathsep + os.environ.get("PATH", "")
D = "runs/lutpack_probe"
os.makedirs(D, exist_ok=True)

SCRIPTS = {
    "plain": "configs/abc_scripts/diag/d0_map.abc",
    "lutpack": "configs/abc_scripts/diag/d2_lutpack.abc",
}


def run(case: str, script: str, tag: str) -> str:
    out = f"{D}/{case}_{tag}.json"
    p = f"""
read_verilog benchmarks/official/{case}.v
hierarchy -top {case}
synth_intel -family cycloneiv -top {case} -run begin:map_luts
abc -lut 4 -script {script}
clean
opt -fast
write_json {out}
"""
    r = subprocess.run(["yosys", "-q", "-p", p], capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  {tag}: 失败 {r.stderr[-200:]}")
    return out


def stats(path: str, case: str) -> None:
    d = json.load(open(path, encoding="utf-8"))
    mod = d["modules"][case]
    luts = [c for c in mod["cells"].values() if c["type"] == "$lut"]
    widths = collections.Counter()
    for c in luts:
        w = c.get("parameters", {}).get("WIDTH")
        widths[w] += 1
    print(f"    $lut 数={len(luts)}   WIDTH 分布={dict(widths)}")


for case in ["test2", "test4"]:
    print(f"=== {case} ===")
    for tag, s in SCRIPTS.items():
        print(f"  [{tag}]")
        p = run(case, s, tag)
        try:
            stats(p, case)
        except Exception as e:
            print(f"    解析失败: {e}")
    print()
