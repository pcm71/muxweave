#!/usr/bin/env python3
"""probe_lut_merge.py —— 测量"abc9 之后做 LUT 级合并"能省多少

背景：
  * 官方 4 用例上，abc9 给出 288/20/13/36；而经典 abc + lutpack 能把 test4 做到 24
    ⇒ ABC 本身能做到更好，只是 abc9 的 GIA 域没有 `lutpack` 这类 LUT 打包能力。
  * 因此**在 abc9 之后由我们自己的 pass 做 LUT 级合并**是一个尚未验证的合法杠杆
    （仍是 abc9 映射，只是后处理；符合答疑 C34"其他方法能优化也可以"）。

原理（保守下界）：
  LUT4 的输出若喂给另一个 LUT4，且两者**合并后的支撑集 ≤ 4 个输入**，
  则目标 LUT 可以直接用 4 输入 LUT 实现整个复合函数 ⇒ 生产者可删、少一个 LUT。
  这不需要做布尔运算即可判定（支撑集大小是充分条件）。

本脚本：
  1) 跑官方流程到 map_luts 之后、abc9 之后，导出 $lut 网表为 JSON
  2) 统计可合并的级联对数（贪心，生产者无其他扇出时才算净收益）
  3) 输出当前 LUT 数、可省数量、以及省完后的比例
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from collections import defaultdict

P = "/mnt/c/Users/LEGION/Desktop/PMUX/muxweave"
os.chdir(P)
# yosys 装在 ~/.local/bin，非交互 shell 里不在 PATH 上
os.environ["PATH"] = os.path.expanduser("~/.local/bin") + os.pathsep + os.environ.get("PATH", "")
CASES = sys.argv[1:] or ["test1", "test2", "test3", "test4"]
D = "runs/lut_merge"
os.makedirs(D, exist_ok=True)


def gen(case: str) -> str:
    """跑到 abc9 之后（map_cells 之前），导出 JSON。"""
    out = f"{D}/{case}.json"
    p = f"""
read_verilog benchmarks/official/{case}.v
hierarchy -top {case}
synth_intel -family cycloneiv -top {case} -run begin:map_luts
abc9 -lut 4 -W 300
clean
opt -fast
write_json {out}
"""
    r = subprocess.run(["yosys", "-q", "-p", p], capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  {case}: 生成失败\n{r.stderr[-300:]}")
        return ""
    return out


def analyze(case: str, path: str) -> None:
    d = json.load(open(path, encoding="utf-8"))
    mods = d["modules"]
    # 顶层模块名就是用例名；若被改名则取单元数最多的那个（排除库单元）
    if case in mods:
        modname = case
    else:
        modname = max(mods, key=lambda k: len(mods[k]["cells"]))
    mod = mods[modname]
    cells = mod["cells"]

    # 收集 $lut 单元：输出位ID -> (输入位ID集合,)
    # 注意：Yosys JSON 的 connections 里是**整数位 ID**（如 "A":[7,3]），不是字符串信号名，
    #       这些 ID 在模块内唯一，正好用作连通性标识。
    luts = {}
    for name, c in cells.items():
        if c["type"] != "$lut":
            continue
        ins = set()
        out = None
        for port, bits in c["connections"].items():
            if port == "Y":
                out = bits[0] if bits else None
            else:
                ins |= set(bits)
        if out is None:
            continue
        luts[name] = dict(out=out, ins=ins)

    # 建 信号 -> 生产者 LUT 映射
    prod = {v["out"]: k for k, v in luts.items()}
    # 统计每个 LUT 输出的扇出（被多少 LUT 使用）
    fanout = defaultdict(int)
    for k, v in luts.items():
        for s in v["ins"]:
            if s in prod:
                fanout[s] += 1

    total = len(luts)

    # 贪心找可合并对：消费者 C 的某个输入来自生产者 P，且 (P.ins ∪ C.ins \ {P.out}) ≤ 4
    merged_out = set()   # 被合并掉的生产者输出
    used_consumer = set()
    pairs = []
    for cname, c in luts.items():
        if cname in used_consumer:
            continue
        for s in sorted(c["ins"]):
            if s not in prod:
                continue
            pname = prod[s]
            if pname == cname or pname in merged_out:
                continue
            union = (c["ins"] - {s}) | luts[pname]["ins"]
            if len(union) <= 4:
                # 只有当生产者没有其他扇出时才是净收益（否则生产者还得留着）
                if fanout[s] == 1:
                    merged_out.add(pname)
                    used_consumer.add(cname)
                    pairs.append((pname, cname, len(union)))
                break

    saved = len(merged_out)
    if not total:
        # 打印实际单元类型，便于排查阶段是否取错
        import collections
        c = collections.Counter(v["type"] for v in cells.values())
        print(f"  {case:<7} 无 $lut 单元；模块 {modname} 的单元类型：{dict(c.most_common(6))}")
        return
    print(f"  {case:<7} LUT 总数={total:<5} 可直接合并={saved:<4} "
          f"合并后={total - saved:<5} 潜在缩减={saved / total * 100:.1f}%")


print("=== abc9 之后做 LUT 级合并的空间（支撑集 ≤4 的级联合并，保守下界）===")
print()
for case in CASES:
    j = gen(case)
    if j:
        try:
            analyze(case, j)
        except Exception as e:
            print(f"  {case}: 分析失败 {e}")
print()
print("说明：这是**保守下界**（只算支撑集合并后 ≤4 的单生产者-单消费者级联，且生产者无其他扇出）。")
print("      真实可省数 ≥ 此值；完整 LUT 打包还可以做多级重写与函数级等价类合并。")
