#!/usr/bin/env bash
# wsl_integrate_pass.sh —— 把自研 pass 集成进 synth_intel.cc 并重新编译安装
#
# 依据 Q&A 09.23 的硬要求：
#   "脚本中直接用 synth_intel 这个组合命令集，优化版应在 synth_intel.cc 中加入你的优化 pass 调用"
#
# 本脚本：
#   1. 把仓库里的 plugin/pmux_opt.cc 同步到 Yosys 源码树 passes/pmux/
#   2. 把 synth_intel.cc 的 map_luts 标签里那行 `abc9 -lut 4 -W 300` 换成 `pmux_opt`
#      （保留 -dff 传递；改动前自动备份为 synth_intel.cc.orig，可重复执行）
#   3. 增量编译 + 安装到 ~/.local
#   4. 打印改动 diff 与验证结果
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
Y="$HOME/src/yosys"
cd "$Y" || exit 1

echo "=== 1) 同步 pass 源码 ==="
cp "$P/plugin/pmux_opt.cc" "$Y/passes/pmux/pmux_opt.cc"
cp "$P/plugin/pmux_analyze.cc" "$Y/passes/pmux/pmux_analyze.cc"
ls -la "$Y/passes/pmux/"

echo
echo "=== 2) 打补丁到 synth_intel.cc ==="
echo "--- 改动前的相关行 ---"
grep -n "abc9 -lut 4 -W 300\|map_luts\|pmux_opt" "$Y/techlibs/intel/synth_intel.cc"
python3 - <<'PY'
import shutil, pathlib
f = pathlib.Path.home() / "src/yosys/techlibs/intel/synth_intel.cc"
orig = f.with_suffix(".cc.orig")
if not orig.exists():
    shutil.copy(f, orig)
    print("已备份原始文件 ->", orig)
else:
    # 幂等：从备份重新开始，避免重复打补丁
    if "pmux_opt" in f.read_text(encoding="utf-8"):
        print("检测到已打过补丁，先从备份恢复再重打")
    shutil.copy(orig, f)

src = f.read_text(encoding="utf-8")
inserted = replaced = 0
out = []
for ln in src.split("\n"):
    # ① map_luts 阶段：把官方 abc9 调用换成自研 pass
    if "abc9 -lut 4 -W 300" in ln and "run(" in ln:
        indent = ln[:len(ln) - len(ln.lstrip())]
        out.append(indent + 'run("pmux_opt" + string(dff ? " -dff" : ""));'
                   + "   // 自研 pass：PMUX 感知的映射策略选择")
        replaced += 1
        continue
    # ② coarse 阶段：在 techmap 消除 mux 之前先做一次 PMUX 结构识别
    if "techmap -map +/cmp2lut.v" in ln and "run(" in ln and inserted == 0:
        indent = ln[:len(ln) - len(ln.lstrip())]
        out.append(indent + 'run("pmux_opt -analyze-only");'
                   + "   // 自研 pass：在 mux 被 techmap 消除前识别 PMUX 结构")
        inserted += 1
    out.append(ln)

if replaced != 1:
    raise SystemExit(f"预期替换 abc9 调用 1 处，实际 {replaced} 处 —— 请人工检查 synth_intel.cc")
if inserted != 1:
    raise SystemExit(f"预期插入 analyze-only 调用 1 处，实际 {inserted} 处 —— 请人工检查 synth_intel.cc")
f.write_text("\n".join(out), encoding="utf-8")
print(f"已替换 {replaced} 处 abc9 调用，已插入 {inserted} 处 -analyze-only 调用")
PY
echo "--- 改动后 ---"
grep -n "pmux_opt\|abc9 -lut 4" "$Y/techlibs/intel/synth_intel.cc"
echo "--- diff ---"
diff -u "$Y/techlibs/intel/synth_intel.cc.orig" "$Y/techlibs/intel/synth_intel.cc" | head -30

echo
echo "=== 3) 增量编译并安装 ==="
cmake --build build -j5 2>&1 | tail -5
cmake --install build 2>&1 | tail -3

echo
echo "=== 4) 验证：用官方标准命令 synth_intel 跑 4 个官方 case ==="
cd "$P" || exit 1
mkdir -p runs/integrated
rm -f .pmux_opt_*.abc 2>/dev/null

python3 - <<'PY'
import json, os, subprocess, glob

EXPECT_B0 = {"test1": 288, "test2": 25, "test3": 13, "test4": 36}
rows = []
for v in sorted(glob.glob("benchmarks/official/*.v")):
    top = os.path.basename(v)[:-2]
    stat = f"runs/integrated/{top}_stat.json"
    log = f"runs/integrated/{top}.log"
    with open(log, "w", encoding="utf-8") as fh:
        rc = subprocess.run(["yosys", "-q", "-p",
                             f"read_verilog {v}; hierarchy -top {top}; "
                             f"synth_intel -family cycloneiv -top {top}; "
                             f"tee -o {stat} stat -json"],
                            stdout=fh, stderr=subprocess.STDOUT).returncode
    if rc != 0:
        print(f"  {top:<8} FAIL (rc={rc})"); continue
    d = json.load(open(stat, encoding="utf-8"))
    nbt = d["design"]["num_cells_by_type"]
    dff = sum(v2 for k, v2 in nbt.items()
              if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
    logic = d["design"]["num_cells"] - dff
    b0 = EXPECT_B0.get(top)
    red = (b0 - logic) / b0 * 100 if b0 else 0
    rows.append((top, b0, logic, red, dff))
    print(f"  {top:<8} 基线={b0:<5} 优化后={logic:<5} 缩减={red:>6.1f}%  DFF={dff}")

if rows:
    import statistics
    avg = statistics.fmean(r[3] for r in rows)
    print()
    print(f"  >>> 逐用例平均缩减率：{avg:.2f}%   （官方口径，逻辑单元）")
    print(f"  >>> 判定：{'✅ ≥20%，面积项可望满分' if avg >= 20 else ('✅ ≥10% 达标' if avg >= 10 else '❌ <10% 未达标')}")
    bad = [r for r in rows if r[4] and r[1] and r[4] > 0]
PY

echo
echo "=== 5) 确认临时脚本已清理 ==="
ls -la .pmux_opt_*.abc 2>/dev/null && echo "  ✗ 仍有残留" || echo "  ✓ 无残留"

echo
echo "=== 6) synth_intel.cc 最终改动 ==="
diff -u "$Y/techlibs/intel/synth_intel.cc.orig" "$Y/techlibs/intel/synth_intel.cc" | head -40
