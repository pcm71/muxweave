#!/usr/bin/env bash
# tune_rrr_x_f.sh —— 围绕刚发现的两个杠杆继续调：&rrr 的 -X（优化流）与 &if 的 -F（面积流恢复轮数）
#
# 已知：
#   &rrr -T 1;              &dch -p -f -r; &if -a -v      ⇒ 288/15/11/30 = 18.01%
#   &rrr -T 1;              &dch -p -f -r; &if -a -F 8 -v ⇒ 288/15/10/30 = 19.94%
#   &rrr -T 1 -X 2;         &dch -p -f -r; &if -a -v      ⇒ 288/15/ 9/32 = 20.47%
# 目标：找出 test3 最低、同时 test4 尽量回到 27 的单脚本组合。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/tune_xf
S=configs/abc_scripts/tunexf
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk x0_base    "&rrr -T 1" "&dch -p -f -r" "&if -a -v"
mk x1_X2F8    "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -F 8 -v"
mk x2_X3F8    "&rrr -T 1 -X 3" "&dch -p -f -r" "&if -a -F 8 -v"
mk x3_X4F8    "&rrr -T 1 -X 4" "&dch -p -f -r" "&if -a -F 8 -v"
mk x4_X2F16   "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -F 16 -v"
mk x5_X2F4    "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -F 4 -v"
mk x6_X2Z1F8  "&rrr -T 1 -X 2 -Z 1" "&dch -p -f -r" "&if -a -F 8 -v"
mk x7_F8A4    "&rrr -T 1" "&dch -p -f -r" "&if -a -F 8 -A 4 -v"
mk x8_F8C32   "&rrr -T 1" "&dch -p -f -r" "&if -a -F 8 -C 32 -v"
mk x9_X2F8A4  "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -F 8 -A 4 -v"
mk xa_T2X2F8  "&rrr -T 2 -X 2" "&dch -p -f -r" "&if -a -F 8 -v"
mk xb_X2twice "&rrr -T 1 -X 2" "&dch -p -f -r" "&rrr -T 1 -X 2" "&if -a -F 8 -v"

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

echo "=== -X / -F 组合扫描（基线 288/25/13/36）==="
printf '  %-22s %-8s %-8s %-8s %-8s %s\n' "脚本" "test1" "test2" "test3" "test4" "平均"
echo "  -------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-22s' "$tag"
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
