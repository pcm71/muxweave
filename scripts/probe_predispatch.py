#!/usr/bin/env python3
"""probe_predispatch.py —— 量 4 个用例在 abc9 之前的规模，用于设计"按规模分派脚本"的判据

动机：&rrr 几乎不占内存（±2%），但耗时随规模上升（test1 32s）；而它只在 test3 上有收益。
      若能**按规模分派**（小电路走 rrr 脚本、大电路走面积脚本），就不需要多候选机制，
      从而既拿到 test3 的 13→11，又不付出 +23% 的内存代价。
"""
from __future__ import annotations

import collections
import json
import os
import subprocess

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
os.environ["PATH"] = os.path.expanduser("~/.local/bin") + os.pathsep + os.environ.get("PATH", "")
D = "runs/predispatch"
os.makedirs(D, exist_ok=True)

print("=== abc9 之前（begin:map_luts）的设计规模 ===")
print(f"  {'用例':<8}{'总单元':<10}{'$pmux':<8}{'$mux':<8}{'$lut':<8}{'其他组合':<10}{'DFF':<6}")
for case in ["test3", "test2", "test4", "test1"]:
    out = f"{D}/{case}.json"
    subprocess.run(["yosys", "-q", "-p", f"""
read_verilog benchmarks/official/{case}.v
hierarchy -top {case}
synth_intel -family cycloneiv -top {case} -run begin:map_luts
write_json {out}
"""], capture_output=True, text=True)
    d = json.load(open(out, encoding="utf-8"))
    mods = d["modules"]
    m = mods.get(case) or max(mods.values(), key=lambda x: len(x.get("cells", {})))
    cnt = collections.Counter(v["type"] for v in m.get("cells", {}).values())
    tot = sum(cnt.values())
    comb = tot - sum(v for k, v in cnt.items() if "dff" in k.lower() or "latch" in k.lower())
    dff = sum(v for k, v in cnt.items() if "dff" in k.lower() or "latch" in k.lower())
    print(f"  {case:<8}{tot:<10}{cnt.get('$pmux', 0):<8}{cnt.get('$mux', 0):<8}"
          f"{cnt.get('$lut', 0):<8}{comb:<10}{dff:<6}")
print()
print("说明：用于判断是否存在一个**干净的分派阈值**（例如'组合单元数 < N 时走 rrr 脚本'）。")
