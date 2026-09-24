#!/usr/bin/env bash
# wsl_overhead_script.sh —— 直接测量"某映射器 + 某脚本"相对官方 B0 的开销
#
# 与 wsl_overhead.sh 的区别：不依赖 pipelines.json / run_case.py 的运行目录，
# 直接为每个官方 case 现场生成 .ys 并用 measure_run.py 重复测量（每次全新进程）。
#
# 用法: bash scripts/wsl_overhead_script.sh <abc|abc9> <脚本文件> [重复次数]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
MAPPER="${1:?用法: wsl_overhead_script.sh <abc|abc9> <脚本文件> [重复次数]}"
SCRIPT="${2:?缺少脚本文件}"
N="${3:-7}"
mkdir -p runs/overhead

echo "映射器：$MAPPER   脚本：$SCRIPT   重复：$N"
echo

python3 - "$MAPPER" "$SCRIPT" "$N" <<'PY'
import json, os, statistics, subprocess, sys, glob

mapper, script, n = sys.argv[1], sys.argv[2], int(sys.argv[3])
cases = sorted(glob.glob("benchmarks/official/*.v"))

def build_ys(case, top, path, use_variant):
    if use_variant:
        body = f"""read_verilog {case}
hierarchy -top {top}
synth_intel -family cycloneiv -top {top} -run begin:map_luts
{mapper} -lut 4 -script {script}
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top {top} -run map_cells:check
"""
    else:
        body = f"""read_verilog {case}
hierarchy -top {top}
synth_intel -family cycloneiv -top {top}
"""
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(body)

def measure(ys, reps):
    cpus, rsss = [], []
    for _ in range(reps):
        r = subprocess.run([sys.executable, "scripts/measure_run.py", "--",
                            "yosys", "-q", "-s", ys],
                           capture_output=True, text=True, check=False)
        try:
            d = json.loads(r.stdout.strip().splitlines()[-1])
        except Exception:
            continue
        if d.get("rc") != 0:
            continue
        cpus.append(d["cpu_total"]); rsss.append(d["maxrss_kb"])
    if not cpus:
        return None
    return statistics.median(cpus), statistics.median(rsss)

print("{:<12}{:>22}{:>22}{:>11}{:>11}{:>6}".format(
    "用例", "基线 CPU/RSS", "变体 CPU/RSS", "CPU开销", "内存开销", "5%"))
print("-" * 86)
rows = []
for c in cases:
    top = os.path.basename(c)[:-2]
    ysb, ysv = f"runs/overhead/_b_{top}.ys", f"runs/overhead/_v_{top}.ys"
    build_ys(c, top, ysb, False)
    build_ys(c, top, ysv, True)
    mb = measure(ysb, n); mv = measure(ysv, n)
    if not mb or not mv:
        print("{:<12}{:>22}".format(top, "测量失败")); continue
    oc = (mv[0] - mb[0]) / mb[0] * 100 if mb[0] else 0
    om = (mv[1] - mb[1]) / mb[1] * 100 if mb[1] else 0
    rows.append((top, oc, om))
    flag = "OK" if oc <= 5 and om <= 5 else "超"
    print("{:<12}{:>22}{:>22}{:>+10.1f}%{:>+10.1f}%{:>6}".format(
        top,
        "{:.3f}s / {:.1f}MB".format(mb[0], mb[1] / 1024),
        "{:.3f}s / {:.1f}MB".format(mv[0], mv[1] / 1024),
        oc, om, flag))

if rows:
    wc = max(r[1] for r in rows); wm = max(r[2] for r in rows)
    print("-" * 86)
    print("最大 CPU 开销 {:+.1f}%    最大内存开销 {:+.1f}%".format(wc, wm))
    print(">>> {}".format("全部用例 ≤5% ✓" if wc <= 5 and wm <= 5 else "存在超标 ✗"))
PY
