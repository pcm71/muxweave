#!/usr/bin/env bash
# recover_test4.sh —— 在单脚本内"修复" &rrr 对 test4 的损害，同时保住 test3 的收益
#
# 现状：`&rrr -T 1; &dch -p -f -r; &if -a -v` ⇒ 288/15/11/30（18.01%）
#       纯面积脚本 `&dch -p -f -r; &if -a -v` ⇒ 288/15/13/27（16.34%）
# 目标：test3 保持 11 且 test4 回到 27（单脚本，不动用多候选，避免 +24% 内存）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/recover4
S=configs/abc_scripts/recover4
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk c0_cur      "&rrr -T 1" "&dch -p -f -r" "&if -a -v"
# 在 rrr 之后加各类"修复"步骤
mk c1_sweep    "&rrr -T 1" "&dch -p -f -r" "&sweep" "&if -a -v"
mk c2_fraig    "&rrr -T 1" "&dch -p -f -r" "&fraig" "&if -a -v"
mk c3_dc2      "&rrr -T 1" "&dch -p -f -r" "&dc2" "&if -a -v"
mk c4_ifa_C32  "&rrr -T 1" "&dch -p -f -r" "&if -a -C 32 -v"
mk c5_ifa_A4   "&rrr -T 1" "&dch -p -f -r" "&if -a -A 4 -v"
mk c6_ifa_F8   "&rrr -T 1" "&dch -p -f -r" "&if -a -F 8 -v"
# 调 &rrr 自身参数（-X 优化流 / -Z 分区类型 / -N 作业数）
mk c7_rrrX1    "&rrr -T 1 -X 1" "&dch -p -f -r" "&if -a -v"
mk c8_rrrX2    "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -v"
mk c9_rrrZ1    "&rrr -T 1 -Z 1" "&dch -p -f -r" "&if -a -v"
mk ca_rrrN1    "&rrr -T 1 -N 1 -J 1" "&dch -p -f -r" "&if -a -v"
mk cb_rrrW16   "&rrr -T 1 -W 16" "&dch -p -f -r" "&if -a -v"
# 顺序变体
mk cc_dch_rrr  "&dch -p -f -r" "&rrr -T 1" "&dch -p -f -r" "&if -a -v"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}
run() {
  timeout 200 yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -lut 4 -script $S/$2.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$2.json stat -json
" > "$D/$1_$2.log" 2>&1
  [ $? -eq 124 ] && { echo "TO"; return; }
  stat_of "$D/$1_$2.json"
}

echo "=== 修复 test4 的尝试（基线 288/25/13/36；当前单脚本 288/15/11/30）==="
printf '  %-26s %-8s %-8s %-8s %-8s %s\n' "脚本" "test1" "test2" "test3" "test4" "平均"
echo "  -------------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-26s' "${tag#c?_}"
  for case in test1 test2 test3 test4; do printf '%-8s' "$(run "$case" "$tag")"; done
  python3 - "$D" "$tag" <<'PY'
import json, sys
D, tag = sys.argv[1], sys.argv[2]
base = {"test1": 288, "test2": 25, "test3": 13, "test4": 36}
s = 0.0
for c, b in base.items():
    try:
        d = json.load(open(f"{D}/{c}_{tag}.json", encoding="utf-8"))
        nbt = d["design"]["num_cells_by_type"]
        seq = sum(v for k, v in nbt.items() if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
        s += (b - (d["design"]["num_cells"] - seq)) / b
    except Exception:
        pass
print(f"{s/4*100:6.2f}%")
PY
done
