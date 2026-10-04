#!/usr/bin/env bash
# sweep_routes_FGHI.sh —— 新一批路线：GIA 标准序列 / MUX 专用命令 / &dch 参数 / LUT 打包
#
# 基准（当前最好）：`&dch -f -r; &if -a -v` ⇒ 288/15/13/27，逐用例平均 16.25%
# 每条变体都同时记录 DFF（C53-3 要求其他单元不得增加）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/sweep_fghi
S=configs/abc_scripts/fghi
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }

# 路线 F：GIA 标准优化序列 / 其它重综合命令
mk f1_syn2    "&syn2" "&if -a -v"
mk f2_syn3    "&syn3" "&if -a -v"
mk f3_syn4    "&syn4" "&if -a -v"
mk f4_resyn3  "&resyn3" "&if -a -v"
mk f5_comp3rs "&compress3rs" "&if -a -v"
mk f6_resub   "&resub" "&if -a -v"
mk f7_deep    "&deepsyn" "&if -a -v"
mk f8_bidec   "&bidec" "&if -a -v"
# 路线 G：MUX 专用命令（题目本体）
mk g1_muxstr  "&muxstr" "&if -a -v"
mk g2_muxdec  "&muxdec" "&if -a -v"
mk g3_muxpos  "&muxpos" "&if -a -v"
mk g4_dch_muxstr "&dch -f -r" "&muxstr" "&if -a -v"
# 路线 H：&dch 的参数
mk h1_dchW    "&dch -W 16 -f -r" "&if -a -v"
mk h2_dchCS   "&dch -C 5000 -S 50000 -f -r" "&if -a -v"
mk h3_dchs    "&dch -s -f -r" "&if -a -v"
mk h4_dchp    "&dch -p -f -r" "&if -a -v"
mk h5_dcht    "&dch -t -f -r" "&if -a -v"
mk h6_dchsp   "&dch -s -p -f -r" "&if -a -v"
# 路线 I：LUT 打包 / 还原
mk i1_pack    "&dch -f -r" "&if -a -v" "&pack"
mk i2_unmap   "&dch -f -r" "&unmap" "&if -a -v"
mk i3_pack2   "&dch -f -r" "&if -v" "&pack"
# 基准
mk base       "&dch -f -r" "&if -a -v"

stat_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(f\"{d['design']['num_cells']-seq}/{seq}\")
except Exception: print('?')"
}

run() { # $1=case $2=标签
  # 每条限时 180s：&deepsyn 之类 SAT 重度命令在大用例上会跑很久甚至卡死
  timeout 180 yosys -q -p "
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
  [ $? -eq 124 ] && { echo "TIMEOUT" > "$D/$1_$2.timeout"; echo "?"; return; }
  stat_of "$D/$1_$2.json"
}

echo "=== 路线 F/G/H/I 扫描（格式 逻辑/DFF；基线 288/222, 25/0, 13/17, 36/10）==="
printf '  %-24s %-11s %-11s %-11s %-11s %s\n' "变体" "test1" "test2" "test3" "test4" "平均"
echo "  -------------------------------------------------------------------------------------"
for f in $S/*.abc; do
  tag=$(basename "$f" .abc)
  [ "$tag" = "f7_deep" ] && { echo "  f7_deep                （&deepsyn 在大用例上超时，已跳过）"; continue; }
  # 跳过已完成的变体（4 个用例的 json 都在）
  if [ -f "$D/test1_$tag.json" ] && [ -f "$D/test2_$tag.json" ] && \
     [ -f "$D/test3_$tag.json" ] && [ -f "$D/test4_$tag.json" ]; then
    done_already=1
  else
    done_already=0
  fi
  printf '  %-24s' "$tag"
  [ $done_already -eq 1 ] && printf '%s' "（已测，跳过）" && echo && continue
  ok=1
  for case in test1 test2 test3 test4; do
    v=$(run "$case" "$tag")
    [ "$v" = "?" ] && ok=0
    printf '%-11s' "$v"
  done
  if [ $ok -eq 1 ]; then
    python3 - "$D" "$tag" <<'PY'
import json, sys
D, tag = sys.argv[1], sys.argv[2]
base = {"test1": 288, "test2": 25, "test3": 13, "test4": 36}
s = 0.0
for c, b in base.items():
    d = json.load(open(f"{D}/{c}_{tag}.json", encoding="utf-8"))
    nbt = d["design"]["num_cells_by_type"]
    seq = sum(v for k, v in nbt.items() if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
    s += (b - (d["design"]["num_cells"] - seq)) / b
print(f"{s/4*100:6.2f}%")
PY
  else
    echo "  （有变体失败）"
  fi
done
