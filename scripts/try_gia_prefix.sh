#!/usr/bin/env bash
# try_gia_prefix.sh —— 路线 D：检查 abc9 默认脚本的"前缀"是否反而让映射变差
#
# 思路：abc9 默认脚本是
#     &scorr; &sweep; &dc2; &dch -f -r; &ps; &if {W} {D} {R} -v; &mfs
#   我们一直沿用这 5 步前缀。但经典流程只用 `strash; dch -f` 就得到 test4=27（abc9=36）。
#   若 GIA 的 `&dc2`/`&dch` 把网络重写成不利于 LUT4 映射的形状，去掉前缀反而更好。
# ⇒ 本实验枚举前缀子集，找出对面积最有利的组合。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/gia_prefix
S=configs/abc_scripts/prefix
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk p0_if         "&if -a -v"
mk p1_sweep_if   "&sweep" "&if -a -v"
mk p2_dc2_if     "&dc2" "&if -a -v"
mk p3_dch_if     "&dch -f -r" "&if -a -v"
mk p4_ps_if      "&ps" "&if -a -v"
mk p5_full       "&scorr" "&sweep" "&dc2" "&dch -f -r" "&ps" "&if -a -v"
mk p6_fraig_if   "&fraig" "&if -a -v"
mk p7_dc2_dch_if "&dc2" "&dch -f -r" "&if -a -v"

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

run() {
  yosys -q -p "
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
  logic_of "$D/$1_$2.json"
}

echo "=== abc9 前缀对面积的影响（LUT 逻辑单元）==="
printf '  %-32s %6s %6s %6s %6s   %s\n' "脚本" "test1" "test2" "test3" "test4" "平均缩减"
echo "  -------------------------------------------------------------------------------"
for spec in "p0_if|仅 &if -a" \
            "p1_sweep_if|&sweep + &if -a" \
            "p2_dc2_if|&dc2 + &if -a" \
            "p3_dch_if|&dch -f -r + &if -a" \
            "p4_ps_if|&ps + &if -a" \
            "p5_full|完整前缀 + &if -a（现用）" \
            "p6_fraig_if|&fraig + &if -a" \
            "p7_dc2_dch_if|&dc2 + &dch + &if -a"; do
  tag="${spec%%|*}"; label="${spec##*|}"
  printf '  %-32s' "$label"
  tot=0
  for case in test1 test2 test3 test4; do
    n=$(run "$case" "$tag")
    printf '%6s' "$n"
  done
  # 平均缩减率（基线 288/25/13/36）
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
        n = d["design"]["num_cells"] - seq
        s += (b - n) / b
    except Exception:
        pass
print(f"   {s/4*100:6.2f}%")
PY
done
