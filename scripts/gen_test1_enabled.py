#!/usr/bin/env python3
"""gen_test1_enabled.py —— 生成 test1 的"显式使能"变体，验证使能化的收益上限

原理：原 RTL 用 `case(state)` 且多数分支不给 i0..i7/q0..q7 赋值 ⇒ 语义是"保持"，
      Yosys 把它展开成 16 路 $pmux（含反馈），opt_dff 认不出，于是保持逻辑压在 LUT 里。
      本变体把这 16 个寄存器的"只在 START 加载"改写成**显式条件加载**：
          if (state == START) begin i0 <= ...; ... end
      Yosys 对 `if (cond) q <= d;`（无 else）会生成带 EN 的 $dffe ⇒ 保持逻辑变零 LUT。

若变体的 LUT 数显著低于 288，则说明"反馈 mux → 使能化"这个变换值得写进自研 pass。
"""
from __future__ import annotations

import os
import re

os.chdir("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave")
src = open("benchmarks/official/test1.v", encoding="utf-8").read()

# 把 START 分支里对 i*/q* 的赋值抽出来，改成独立的 if(state==START) 块
start_block = re.search(r"START:begin(.*?)end\s*\n\s*CYCLE1:begin", src, re.S)
assert start_block, "未找到 START 分支"
body = start_block.group(1)

load_lines = [l.strip() for l in body.splitlines()
              if re.match(r"^(i[0-7]|q[0-7])\s*<=", l.strip())]
assert len(load_lines) == 16, f"抽出 {len(load_lines)} 行，期望 16"

early = "    // —— 由脚本注入：只在 START 加载的寄存器改用显式条件（生成带 EN 的 FF）——\n"
early += "    if (state == START) begin\n"
early += "".join(f"      {l}\n" for l in load_lines)
early += "    end\n"

new = src.replace("end else begin\t\n\t\tcase (state)",
                  "end else begin\n" + early + "\t\tcase (state)", 1)
assert new != src, "注入点未匹配"

# 同时把原 START 分支里这些行删掉（避免重复赋值）
def strip_loads(m):
    inner = m.group(1)
    kept = [l for l in inner.splitlines()
            if not re.match(r"^(i[0-7]|q[0-7])\s*<=", l.strip())]
    return "START:begin" + "\n".join(kept) + "end\n\t\t  CYCLE1:begin"
new = re.sub(r"START:begin(.*?)end\s*\n\s*CYCLE1:begin", strip_loads, new, count=1, flags=re.S)

os.makedirs("runs/test1_en", exist_ok=True)
open("runs/test1_en/test1_en.v", "w", encoding="utf-8").write(new)
print("已生成 runs/test1_en/test1_en.v")
print("注入的显式使能寄存器数:", len(load_lines))
