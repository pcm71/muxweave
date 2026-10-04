#!/usr/bin/env bash
# try_mfs_position.sh —— 把 &mfs 放在 &write 之前（即写进我们的脚本里）
#
# 关键观察（从 abc9 生成的 abc.script 实测）：
#     <用户脚本>  →  &write -n output.aig  →  &mfs  →  &ps -l
#   官方默认脚本以 `&mfs` 结尾，但它落在 `&write` **之后** ⇒ 对输出结果永远无效。
#   若把 `&mfs` 写进我们自己的脚本，它就会跑在 `&write` **之前**，结果才会被采纳。
#
# 已知参照：经典流程里 don't-care 重综合 `mfs2` 能把 test4 从 27 降到 24。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/mfs_pos
S=configs/abc_scripts/mfspos
mkdir -p "$D" "$S"

mk() { local n="$1"; shift; printf '%s\n' "$@" > "$S/$n.abc"; }
mk m0_base   "&dch -p -f -r" "&if -a -v"
mk m1_after  "&dch -p -f -r" "&if -a -v" "&mfs"
mk m2_mfsd   "&dch -p -f -r" "&if -a -v" "&mfsd"
mk m3_before "&dch -p -f -r" "&mfs" "&if -a -v"
mk m4_both   "&dch -p -f -r" "&mfs" "&if -a -v" "&mfs"
mk m5_odc    "&dch -p -f -r" "&if -a -v" "&odc"
mk m6_andcare "&dch -p -f -r" "&if -a -v" "&andcare"

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
  [ $? -eq 124 ] && { echo "TIMEOUT"; return; }
  stat_of "$D/$1_$2.json"
}

echo "=== &mfs 位置实验（格式 逻辑/DFF）==="
printf '  %-34s %-11s %-11s %-11s %-11s %s\n' "脚本" "test1" "test2" "test3" "test4" "平均缩减"
echo "  -----------------------------------------------------------------------------------------"
for spec in "m0_base|基准（当前最优）" \
            "m1_after|&if 之后加 &mfs" \
            "m2_mfsd|&if 之后加 &mfsd" \
            "m3_before|&mfs 放在 &if 之前" \
            "m4_both|&mfs 前后各一次" \
            "m5_odc|&if 之后加 &odc" \
            "m6_andcare|&if 之后加 &andcare"; do
  IFS='|' read -r tag label <<< "$spec"
  printf '  %-34s' "$label"
  for case in test1 test2 test3 test4; do printf '%-11s' "$(run "$case" "$tag")"; done
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
echo
echo "=== 检查 m1/m3 是否出现 abc9 写回类报错 ==="
for t in m1_after m3_before; do
  if grep -qiE "error|aborting" "$D/test4_$t.log" 2>/dev/null; then
    echo "  $t: 有报错 → $(grep -iE 'error|aborting' "$D/test4_$t.log" | head -1 | tr -d '\r')"
  else
    echo "  $t: 无报错"
  fi
done
