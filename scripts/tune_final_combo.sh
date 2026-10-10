#!/usr/bin/env bash
# tune_final_combo.sh —— 最后一轮组合微调
#
# 已知最好：&rrr -T 10 -X 2; &dch -f -r; &compress3rs; &if -a -F 16 -v ⇒ 287/15/9/29 = 22.64%
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/final_combo
S=configs/abc_scripts/finalcombo
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; { echo "&rrr -T 10 -X 2"; printf '%s\n' "$@"; echo "&if -a -F 16 -v"; } > "$S/$n.abc"; }
mk f0_cur     "&dch -f -r" "&compress3rs"
mk f1_dch2    "&dch -f -r" "&compress3rs" "&dch -f -r"
mk f2_comp2   "&dch -f -r" "&compress3rs" "&compress3rs"
mk f3_comp_dch "&compress3rs" "&dch -f -r"
mk f4_rrr_comp "&compress3rs" "&dch -f -r" "&compress3rs"
mk f5_comp_rrr "&compress3rs" "&rrr -T 1 -X 2" "&dch -f -r" "&compress3rs"
mk f6_dch_comp_dch "&dch -f -r" "&compress3rs" "&dch -f -r" "&compress3rs"

# -F 再确认（配合 compress3rs）
mk g0_F8   "&dch -f -r" "&compress3rs" ; sed -i 's/&if -a -F 16 -v/&if -a -F 8 -v/' "$S/g0_F8.abc"
mk g1_F32  "&dch -f -r" "&compress3rs" ; sed -i 's/&if -a -F 16 -v/&if -a -F 32 -v/' "$S/g1_F32.abc"
mk g2_F64  "&dch -f -r" "&compress3rs" ; sed -i 's/&if -a -F 16 -v/&if -a -F 64 -v/' "$S/g2_F64.abc"

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
  timeout 150 yosys -q -p "
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

echo "=== 最终组合微调（基线 288/25/13/36）==="
printf '  %-22s %-8s %-8s %-8s %-8s %s\n' "配置" "test1" "test2" "test3" "test4" "平均"
echo "  -------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-22s' "${tag}"
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
