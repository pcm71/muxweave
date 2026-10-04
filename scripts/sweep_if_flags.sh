#!/usr/bin/env bash
# sweep_if_flags.sh —— 扫 &if 的完整参数空间（从未试过的那一批）
#
# 参数表来源：ABC 源码 abc.c:45934（`usage: &if [-KCFAGRTXYZM num] [-DEW float] [-SJ str] [-qarlepmsdbgxyofuijkztnchvw]`）
# 基准脚本：`&dch -p -f -r` + `&if -a -v` ⇒ 287/15/13/27（16.34%）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/if_flags
S=configs/abc_scripts/ifflags
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; { echo "&dch -p -f -r"; printf '%s\n' "$@"; } > "$S/$n.abc"; }
mk f0_base   "&if -a -v"
mk f1_q      "&if -a -q -v"
mk f2_e      "&if -a -e -v"
mk f3_r      "&if -a -r -v"
mk f4_p      "&if -a -p -v"
mk f5_M0     "&if -a -M 0 -v"
mk f6_M1     "&if -a -M 1 -v"
mk f7_Y1     "&if -a -Y 1 -v"
mk f8_G0     "&if -a -G 0 -v"
mk f9_qe     "&if -a -q -e -v"
mk fa_qer    "&if -a -q -e -r -v"
mk fb_qerpM0 "&if -a -q -e -r -p -M 0 -v"
mk fc_i      "&if -a -i -v"
mk fd_n      "&if -a -n -v"
mk fe_d      "&if -a -d -v"
mk ff_b      "&if -a -b -v"
mk fg_E      "&if -a -E 0.1 -v"
mk fh_qerpn  "&if -a -q -e -r -p -n -v"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}

run() {
  timeout 240 yosys -q -p "
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

echo "=== &if 参数扫描（格式 逻辑/DFF；基线 288/25/13/36）==="
printf '  %-14s %-10s %-10s %-10s %-10s %s\n' "变体" "test1" "test2" "test3" "test4" "平均缩减"
echo "  -------------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-14s' "$tag"
  for case in test1 test2 test3 test4; do printf '%-10s' "$(run "$case" "$tag")"; done
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
