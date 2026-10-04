#!/usr/bin/env bash
# try_single_script_rrr.sh —— 试"单脚本"组合：先 &rrr 再 &dch，看能否免掉多候选机制
#
# 动机：双候选可得 20.18%，但 design -save 带来 +24% 内存（超过细则 15% 红线）。
#       若存在**单脚本**组合能同时保住 test3 的 13→11 且不伤其他用例，就能零内存代价拿到大部分收益。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/single_rrr
S=configs/abc_scripts/singlerrr
mkdir -p "$D" "$S"

printf '%s\n' "&dch -p -f -r" "&if -a -v"                          > "$S/s0_area.abc"
printf '%s\n' "&rrr -T 1" "&dch -p -f -r" "&if -a -v"              > "$S/s1_rrr_dch.abc"
printf '%s\n' "&rrr -T 2" "&dch -p -f -r" "&if -a -v"              > "$S/s2_rrr2_dch.abc"
printf '%s\n' "&rrr -T 1" "&dch -p -f -r" "&rrr -T 1" "&if -a -v"  > "$S/s3_rrr2x.abc"
printf '%s\n' "&dch -p -f -r" "&rrr -T 1" "&dch -p -f -r" "&if -a -v" > "$S/s4_dch_rrr_dch.abc"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}
run() { # $1=case $2=脚本
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

echo "=== 单脚本组合（基线 288/25/13/36；双候选 287/15/11/27）==="
printf '  %-22s %-8s %-8s %-8s %-8s %s\n' "脚本" "test1" "test2" "test3" "test4" "平均"
echo "  ---------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-22s' "${tag#s?_}"
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
