#!/usr/bin/env bash
# sweep_after_rrr.sh —— 固定 &rrr 在前，扫描其后的 GIA 命令（找能救回 test4/test1 的那一步）
#
# 现状：&rrr -T 1 -X 2; &dch -p -f -r; &if -a -F 16 -v ⇒ 288/15/9/30 = 21.86%
# 缺口：test4 纯面积脚本能到 27（现 30）；test1 纯面积脚本能到 287（现 288）。
# 方法：保持前后不变，只把中间那一步换掉，逐个试。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/after_rrr
S=configs/abc_scripts/afterrrr
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; { echo "&rrr -T 1 -X 2"; printf '%s\n' "$@"; echo "&if -a -F 16 -v"; } > "$S/$n.abc"; }
mk a0_dch    "&dch -p -f -r"
for c in "&dch -f -r" "&dch -p" "&dch -r" "&sweep" "&fraig" "&dc2" "&ps" "&scorr" \
         "&resub" "&srm" "&scl" "&unate" "&posplit" "&reshape" "&reduce" "&st" \
         "&syn3" "&compress3rs" "&resyn3" "&cfraig" "&trim" "&mprove" "&bidec"; do
  tag=$(echo "$c" | tr -d '&' | tr ' ' '_')
  mk "a_$tag" "$c"
done

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

echo "=== &rrr 之后那一步的扫描（基线 288/25/13/36；当前 288/15/9/30）==="
printf '  %-16s %-8s %-8s %-8s %-8s %s\n' "中间步骤" "test1" "test2" "test3" "test4" "平均"
echo "  ---------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-16s' "${tag#a_}"
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
