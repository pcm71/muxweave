#!/usr/bin/env bash
# tune_dch_after_rrr.sh —— 细扫 &rrr 之后那一步 &dch 的参数，并试叠加 compress3rs
#
# 已知：&rrr -T 1 -X 2; &dch -f -r; &if -a -F 16 -v ⇒ 288/15/9/29 = 22.55%
#       &compress3rs 单独作为中间步可让 test1 到 287
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/dch_tune
S=configs/abc_scripts/dchtune
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; { echo "&rrr -T 1 -X 2"; printf '%s\n' "$@"; echo "&if -a -F 16 -v"; } > "$S/$n.abc"; }
mk t0_fr      "&dch -f -r"
mk t1_f       "&dch -f"
mk t2_r       "&dch -r"
mk t3_plain   "&dch"
mk t4_frW16   "&dch -f -r -W 16"
mk t5_frC5000 "&dch -f -r -C 5000"
mk t6_frS50000 "&dch -f -r -S 50000"
mk t7_frs     "&dch -f -r -s"
mk t8_frt     "&dch -f -r -t"
mk t9_frp     "&dch -f -r -p"
mk ta_comp    "&compress3rs" "&dch -f -r"
mk tb_dch_comp "&dch -f -r" "&compress3rs"
mk tc_comp_only "&compress3rs"

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

echo "=== &dch 参数细扫 + compress3rs 叠加（基线 288/25/13/36）==="
printf '  %-18s %-8s %-8s %-8s %-8s %s\n' "配置" "test1" "test2" "test3" "test4" "平均"
echo "  -------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-18s' "${tag#t?_}"
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
