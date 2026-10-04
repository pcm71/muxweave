#!/usr/bin/env bash
# tune_around_dch.sh —— 围绕"&dch -f -r + &if -a"这个突破点继续调优
#
# 已实测：去掉官方脚本的 &scorr/&sweep/&dc2/&ps 四步、只留 `&dch -f -r; &if -a -v`，
#         逐用例平均从 4.31% 跃升到 16.25%（test2 25→15、test4 36→27）。
# 本脚本在其邻域搜索更好的组合，并**同时记录 DFF 数**（C53-3 要求其他单元不得增加）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/tune_dch
S=configs/abc_scripts/tune
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk t0_dch_ifa      "&dch -f -r" "&if -a -v"
mk t1_dch_ifa_F5   "&dch -f -r" "&if -a -F 5 -v"
mk t2_dch_ifa_A8   "&dch -f -r" "&if -a -A 8 -v"
mk t3_dch_if       "&dch -f -r" "&if -v"
mk t4_dch_only_ifa "&dch" "&if -a -v"
mk t5_dchR_ifa     "&dch -r" "&if -a -v"
mk t6_dchf_ifa     "&dch -f" "&if -a -v"
mk t7_dch_ifa_C32  "&dch -f -r" "&if -a -C 32 -v"
mk t8_ifa_only2    "&if -a -v"
mk t9_dch_dc2_ifa  "&dch -f -r" "&dc2" "&if -a -v"

stat_of() { # 输出 "逻辑/DFF"
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
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
  stat_of "$D/$1_$2.json"
}

echo "=== 邻域搜索（格式 逻辑单元/DFF）==="
printf '  %-28s %-11s %-11s %-11s %-11s %s\n' "脚本" "test1" "test2" "test3" "test4" "平均缩减"
echo "  --------------------------------------------------------------------------------------"
for spec in "t0_dch_ifa|&dch -f -r; &if -a" \
            "t1_dch_ifa_F5|&dch -f -r; &if -a -F 5" \
            "t2_dch_ifa_A8|&dch -f -r; &if -a -A 8" \
            "t3_dch_if|&dch -f -r; &if（非面积向）" \
            "t4_dch_only_ifa|&dch; &if -a" \
            "t5_dchR_ifa|&dch -r; &if -a" \
            "t6_dchf_ifa|&dch -f; &if -a" \
            "t7_dch_ifa_C32|&dch -f -r; &if -a -C 32" \
            "t8_ifa_only2|仅 &if -a" \
            "t9_dch_dc2_ifa|&dch -f -r; &dc2; &if -a"; do
  tag="${spec%%|*}"; label="${spec##*|}"
  printf '  %-28s' "$label"
  for case in test1 test2 test3 test4; do printf '%-11s' "$(run "$case" "$tag")"; done
  python3 - "$D" "$tag" <<'PY'
import json, sys
D, tag = sys.argv[1], sys.argv[2]
base = {"test1": 288, "test2": 25, "test3": 13, "test4": 36}
s = n = 0
for c, b in base.items():
    try:
        d = json.load(open(f"{D}/{c}_{tag}.json", encoding="utf-8"))
        nbt = d["design"]["num_cells_by_type"]
        seq = sum(v for k, v in nbt.items() if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
        s += (b - (d["design"]["num_cells"] - seq)) / b
        n += 1
    except Exception:
        pass
print(f"{s/max(n,1)*100:6.2f}%")
PY
done
