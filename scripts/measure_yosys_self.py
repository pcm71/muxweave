#!/usr/bin/env python3
"""measure_yosys_self.py —— 按官方口径测量（答疑 C54-2：峰值内存**只看 yosys.exe**）

与 measure_run.py 的区别：
  measure_run.py 用 RUSAGE_CHILDREN.ru_maxrss —— 在 Linux 上会把**已回收子进程**的峰值
  传播上来（abc 子进程的峰值也会算进去），属于"整进程树"口径，**偏保守**。
  本脚本改为**轮询 /proc/<pid>/status 的 VmHWM**：VmHWM 是该进程**自身**的峰值驻留内存，
  **不含子进程**，正是 C54-2 要求的口径。

用法:
    python3 scripts/measure_yosys_self.py <重复次数> -- <命令...>
输出（stdout 最后一行 JSON）:
    {"rc":.., "maxrss_self_kb":.., "cpu_total":.., "wall":.., "samples":..}
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import time


def read_vmhwm(pid: int) -> int:
    """读该进程自身的峰值驻留内存（KB）；进程已退出返回 0。"""
    try:
        with open(f"/proc/{pid}/status", "r") as f:
            for line in f:
                if line.startswith("VmHWM:"):
                    return int(line.split()[1])
    except (FileNotFoundError, ProcessLookupError):
        return 0
    return 0


def measure(cmd: list[str]) -> dict:
    t0 = time.time()
    p = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    pid = p.pid
    peak = 0
    samples = 0
    # VmHWM 单调递增，密集采样取最大值即可逼近最终值
    while True:
        rc = p.poll()
        v = read_vmhwm(pid)
        if v:
            peak = max(peak, v)
            samples += 1
        if rc is not None:
            break
        time.sleep(0.003)
    pid_, status, ru = os.wait4(p.pid, 0) if False else (0, 0, None)
    wall = time.time() - t0
    cpu = (ru.ru_utime + ru.ru_stime) if ru else float("nan")
    return dict(rc=p.returncode, maxrss_self_kb=peak, samples=samples,
                wall=wall, cpu_total=cpu)


def main() -> int:
    if "--" not in sys.argv:
        print("用法: measure_yosys_self.py <重复次数> -- <命令...>", file=sys.stderr)
        return 2
    i = sys.argv.index("--")
    reps = int(sys.argv[1]) if i > 1 else 1
    cmd = sys.argv[i + 1:]
    runs = [measure(cmd) for _ in range(reps)]
    ok = [r for r in runs if r["rc"] == 0]
    print(json.dumps(ok[-1] if ok else runs[-1], ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
