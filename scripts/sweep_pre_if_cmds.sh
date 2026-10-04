#!/usr/bin/env bash
# sweep_pre_if_cmds.sh —— 扫"映射前"的 GIA 重综合/分解命令（此前只试过 &dch 系列）
#
# 背景：突破来自"逐条替换官方脚本的每一步"。官方脚本前 5 步里，
#       &scorr/&sweep/&dc2/&ps 都有害，只有 &dch -f -r 有价值（配 &if -a 得 16.34%）。
#       但"映射前还能放什么"只试过 &dch 变体。GIA 域还有大量重综合/分解命令从未试过，
#       其中 &bidec / &fx / &dsd / &exorcism / &esop / &srm 等会**重构 AIG 形状**，
#       对 test1 的 16 选 1 大 mux 结构可能有效。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/pre_if
S=configs/abc_scripts/preif
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; { printf '%s\n' "$@"; echo "&if -a -v"; } > "$S/$n.abc"; }

# 基准（当前最优）：&dch -p -f -r  +  &if -a
mk pre_base "&dch -p -f -r"
# 分解类（可能改变 AIG 形状）
for c in "&bidec" "&fx" "&dsd" "&exorcism" "&esop" "&srm" "&srm2" "&synch2" \
         "&resyn3" "&compress3rs" "&cfraig" "&rewire" "&rrr" "&scl" "&st" "&struct" \
         "&trim" "&topand" "&unate" "&mprove" "&reduce" "&reshape" "&pipe" "&unpipe" \
         "&posplit" "&blut" "&wlut" "&choice" "&extract" "&speedup"; do
  tag=$(echo "$c" | tr -d '&')
  mk "pre_$tag" "&dch -p -f -r" "$c"
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

echo "=== 映射前的 GIA 命令扫描（基线 288/25/13/36；当前最优 287/15/13/27）==="
printf '  %-16s %-9s %-9s %-9s %-9s %s\n' "命令" "test1" "test2" "test3" "test4" "平均"
echo "  -----------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  printf '  %-16s' "${tag#pre_}"
  for case in test1 test2 test3 test4; do printf '%-9s' "$(run "$case" "$tag")"; done
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
