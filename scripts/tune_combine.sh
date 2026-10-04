#!/usr/bin/env bash
# tune_combine.sh —— 把已发现的增益叠加：新脚本 + LUT 成本模型 + 其它微调
#
# 已知：
#   * 脚本 `&dch -f -r; &if -a -v`（去掉官方脚本的 &scorr/&sweep/&dc2/&ps）⇒ 16.25%
#   * `-luts 2,2,2,1` 在前述脚本下曾使 test3 13→12
# 本脚本测试叠加效果，并核对 DFF。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/tune_combine
S=configs/abc_scripts/tune
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk c0_base   "&dch -f -r" "&if -a -v"
mk c1_twice  "&dch -f -r" "&dch -f -r" "&if -a -v"
mk c2_ifa2   "&dch -f -r" "&if -a -v" "&if -a -v"
mk c3_sweep  "&dch -f -r" "&sweep" "&if -a -v"
mk c4_ifaK   "&dch -f -r" "&if -K 4 -a -v"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}

run() { # $1=case $2=脚本名 $3=额外 abc9 参数 $4=标签
  yosys -q -p "
read_verilog benchmarks/official/$1.v
hierarchy -top $1
synth_intel -family cycloneiv -top $1 -run begin:map_luts
abc9 -lut 4 $3 -script $S/$2.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $1 -run map_cells:check
tee -o $D/$1_$4.json stat -json
" > "$D/$1_$4.log" 2>&1
  stat_of "$D/$1_$4.json"
}

avg() {
  python3 - "$D" "$1" <<'PY'
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
}

echo "=== 叠加实验（格式 逻辑/DFF）==="
printf '  %-34s %-11s %-11s %-11s %-11s %s\n' "配置" "test1" "test2" "test3" "test4" "平均缩减"
echo "  -----------------------------------------------------------------------------------------"
for spec in "c0_base||&dch -f -r; &if -a（当前最好）" \
            "c0_base|-luts 2,2,2,1|+ 成本模型 -luts 2,2,2,1" \
            "c3_sweep||加 &sweep" \
            "c1_twice||&dch 跑两遍" \
            "c2_ifa2||&if 跑两遍" \
            "c4_ifaK||&if -K 4 -a"; do
  IFS='|' read -r tag extra label <<< "$spec"
  printf '  %-34s' "$label"
  for case in test1 test2 test3 test4; do printf '%-11s' "$(run "$case" "$tag" "$extra" "${tag}_$(echo "$extra" | tr ' ,:' '___')")"; done
  avg "$D" "${tag}_$(echo "$extra" | tr ' ,:' '___')"
done
