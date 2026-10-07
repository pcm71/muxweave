#!/usr/bin/env bash
# tune_F_more.sh —— 继续加大 &if 的 -F（面积流恢复轮数），配合 &rrr -T 1 -X 2
#
# 已知最好：&rrr -T 1 -X 2; &dch -p -f -r; &if -a -F 16 -v ⇒ 288/15/9/30 = 21.86%
# -F 越大，面积恢复迭代越多（可能更小、也可能过犹不及），本脚本扫一遍并核对耗时/DFF。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/tuneF
S=configs/abc_scripts/tuneF
mkdir -p "$D" "$S"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}
run() { # $1=case $2=脚本 $3=标签
  local t0=$(date +%s)
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
tee -o $D/$1_$3.json stat -json
" > "$D/$1_$3.log" 2>&1
  [ $? -eq 124 ] && { echo "TO"; return; }
  echo "$(stat_of "$D/$1_$3.json")/$(($(date +%s)-t0))s"
}

echo "=== -F 扫描（格式 逻辑/DFF/耗时；基线 288/25/13/36）==="
printf '  %-10s %-16s %-16s %-16s %-16s %s\n' "-F" "test1" "test2" "test3" "test4" "平均"
echo "  --------------------------------------------------------------------------------------------"
for F in 8 16 24 32 48 64 96; do
  printf '%s\n' "&rrr -T 1 -X 2" "&dch -p -f -r" "&if -a -F $F -v" > "$S/F$F.abc"
  printf '  %-10s' "$F"
  for case in test1 test2 test3 test4; do printf '%-16s' "$(run "$case" "F$F" "F$F")"; done
  python3 - "$D" "F$F" <<'PY'
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
