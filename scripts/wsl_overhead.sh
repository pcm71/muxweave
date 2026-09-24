#!/usr/bin/env bash
# wsl_overhead.sh —— 官方口径的效率开销测量（可重复、可信）
#
# 官方口径：开销 = CPU 时间 + 整进程峰值内存，**每个用例都要满足 ≤5%**，CPU 含 abc。
# 做法：对每个用例，分别重复运行"基线脚本"与"优化脚本"的 yosys 流程 N 次，
#       取**中位数**比较，避免单次噪声；每次测量在全新进程里只跑一个子进程。
#
#   bash scripts/wsl_overhead.sh [重复次数，默认 7] [候选pipeline，默认 SCRIPT_ifarea]
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
N="${1:-7}"
OPT="${2:-SCRIPT_ifarea}"
BASE=B0
mkdir -p runs/overhead

CASES=$(ls benchmarks/official/*.v)

# 复用已有运行目录里的 synth.ys（由 run_case.py 生成，与评测脚本完全一致）
find_ys() { # $1=case名 $2=pipeline
  local d
  d=$(ls -dt runs/"$1"__"$2"__* 2>/dev/null | head -1)
  [ -n "$d" ] && [ -f "$d/synth.ys" ] && echo "$d/synth.ys"
}

echo "重复次数：$N   基线：$BASE   优化：$OPT"
echo
printf '%-10s %-26s %-26s %s\n' "用例" "基线 CPU(s)/内存(MB)" "优化 CPU(s)/内存(MB)" "开销"
echo "--------------------------------------------------------------------------------------"
python3 - "$N" "$BASE" "$OPT" "$CASES" <<'PY'
import json, os, statistics, subprocess, sys, glob, tempfile

N, base, opt, cases = int(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4].split()

def find_ys(case, pipe):
    name = os.path.basename(case)[:-2]
    dirs = sorted(glob.glob(f"runs/{name}__{pipe}__*"), reverse=True)
    for d in dirs:
        ys = os.path.join(d, "synth.ys")
        if os.path.exists(ys):
            return ys
    return None

def measure(ys, reps):
    cpus, rsss, walls = [], [], []
    for i in range(reps):
        # 每次都在全新 python 进程里测，保证 maxrss 只反映这一个 yosys 子进程
        r = subprocess.run([sys.executable, "scripts/measure_run.py", "--",
                            "yosys", "-q", "-s", ys],
                           capture_output=True, text=True, check=False)
        try:
            d = json.loads(r.stdout.strip().splitlines()[-1])
        except Exception:
            continue
        if d.get("rc") != 0:
            continue
        cpus.append(d["cpu_total"]); rsss.append(d["maxrss_kb"]); walls.append(d["wall"])
    if not cpus:
        return None
    return dict(cpu=statistics.median(cpus),
                rss=statistics.median(rsss),
                wall=statistics.median(walls),
                n=len(cpus))

print(f"{'用例':<12}{'基线 CPU/RSS':>26}{'优化 CPU/RSS':>26}{'CPU开销':>10}{'内存开销':>10}{'5%':>6}")
print("-" * 92)
rows = []
for c in cases:
    name = os.path.basename(c)[:-2]
    ysb, yso = find_ys(c, base), find_ys(c, opt)
    if not ysb or not yso:
        print(f"{name:<12}{'缺少 synth.ys（先跑 wsl_official_eval.sh）':>40}")
        continue
    mb = measure(ysb, N); mo = measure(yso, N)
    if not mb or not mo:
        print(f"{name:<12}{'测量失败':>26}")
        continue
    oc = (mo["cpu"] - mb["cpu"]) / mb["cpu"] * 100 if mb["cpu"] else 0
    om = (mo["rss"] - mb["rss"]) / mb["rss"] * 100 if mb["rss"] else 0
    rows.append((name, mb, mo, oc, om))
    flag = "OK" if oc <= 5 and om <= 5 else "超"
    colb = "{:.3f}s / {:.1f}MB".format(mb["cpu"], mb["rss"] / 1024)
    colo = "{:.3f}s / {:.1f}MB".format(mo["cpu"], mo["rss"] / 1024)
    print("{:<12}{:>26}{:>26}{:>+9.1f}%{:>+9.1f}%{:>6}".format(
        name, colb, colo, oc, om, flag))

if rows:
    wc = max(r[3] for r in rows); wm = max(r[4] for r in rows)
    print("-" * 92)
    print(f"最大 CPU 开销 {wc:+.1f}%    最大内存开销 {wm:+.1f}%")
    print(f">>> 效率判定：{'全部用例 ≤5% ✓' if wc <= 5 and wm <= 5 else '存在超标 ✗'}")
    print()
    print("说明：脚本级替换（同一次 abc 调用换脚本）理论上开销应接近 0；")
    print("      若仍显著为正，需区分是真实开销还是小电路上的进程启动噪声（看墙钟与 CPU 的绝对差值）。")
PY
