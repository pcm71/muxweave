#!/usr/bin/env python3
"""measure_run.py —— 可靠的单进程耗时/内存测量工具。

为什么需要它：
    `scripts/run_case.py` 里的 `getrusage(RUSAGE_CHILDREN).ru_maxrss` 是
    **所有已回收子进程的最大 RSS 高水位**，不是"本次运行的峰值"。
    同一 Python 进程里第二次测量会读到历史最大值，导致内存开销被系统性高估。

本工具的设计：
    * 每次测量都在**全新的 Python 进程**里执行（由调用方保证），
      因此 RUSAGE_CHILDREN 只统计这一个子进程，ru_maxrss 就是该子进程的峰值。
    * CPU 时间取 RUSAGE_CHILDREN 的前后差值（user+sys），即该子进程自身的 CPU。
    * 同时给出墙钟时间，便于交叉核对。

用法:
    python3 measure_run.py -- <命令> [参数...]
输出（JSON 一行）:
    {"rc":0,"wall":0.123,"cpu_user":0.1,"cpu_sys":0.02,"cpu_total":0.12,"maxrss_kb":34567}
"""
from __future__ import annotations

import argparse
import json
import resource
import subprocess
import sys
import time


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", nargs=argparse.REMAINDER)
    ap.add_argument("--log", default=None, help="子进程输出写到该文件（默认丢弃）")
    args = ap.parse_args()

    cmd = args.cmd
    if cmd and cmd[0] == "--":
        cmd = cmd[1:]
    if not cmd:
        print("没有要执行的命令", file=sys.stderr)
        return 2

    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    t0 = time.monotonic()
    if args.log:
        with open(args.log, "w", encoding="utf-8") as fh:
            proc = subprocess.run(cmd, stdout=fh, stderr=subprocess.STDOUT, check=False)
    else:
        proc = subprocess.run(cmd, stdout=subprocess.DEVNULL,
                              stderr=subprocess.DEVNULL, check=False)
    wall = time.monotonic() - t0
    after = resource.getrusage(resource.RUSAGE_CHILDREN)

    out = {
        "rc": proc.returncode,
        "wall": round(wall, 4),
        "cpu_user": round(after.ru_utime - before.ru_utime, 4),
        "cpu_sys": round(after.ru_stime - before.ru_stime, 4),
        "cpu_total": round((after.ru_utime + after.ru_stime)
                           - (before.ru_utime + before.ru_stime), 4),
        # 全新进程里只跑过这一个子进程 ⇒ 该值就是它的峰值 RSS
        "maxrss_kb": after.ru_maxrss,
    }
    print(json.dumps(out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
