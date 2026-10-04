#!/usr/bin/env bash
# diag_test1_enable.sh —— 查 abc9 之前 test1 的触发器是否已带各自使能
#
# 假设：i0..i7、q0..q7 只在 START 加载（其余状态保持），若"保持"由各自 FF 的 ena 承担，
#       则省掉每位一个反馈 mux（LUT4）。若 FF 只有一个全局 ena(=!reset)，
#       说明保持逻辑压在 LUT 里 —— 那就是可挖的空间。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/test1_enable
mkdir -p "$D"

echo "=== abc9 之前（begin:map_luts）的单元类型统计 ==="
yosys -q -p "
read_verilog benchmarks/official/test1.v
hierarchy -top test1
synth_intel -family cycloneiv -top test1 -run begin:map_luts
tee -o $D/pre.json stat -json
" > "$D/pre.log" 2>&1
python3 - "$D/pre.json" <<'PY'
import collections, json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
mods = d["modules"]
def nc(m):
    return len(m.get("cells", {}))
name = "test1" if "test1" in mods else max(mods, key=lambda k: nc(mods[k]))
m = mods[name]
print("  模块:", name, " 单元数:", nc(m))
c = collections.Counter(v["type"] for v in m.get("cells", {}).values())
print("  单元类型:", dict(c.most_common(12)))
ff = collections.Counter(v["type"] for v in m.get("cells", {}).values() if "dff" in v["type"] or "ff" in v["type"])
print("  触发器类型:", dict(ff))
PY

echo
echo "=== 试：在 abc9 之前强制再跑一次 opt_dff，看触发器类型是否变化 ==="
for pass in "opt_dff" "opt_dff -sat" "opt_dff -nodffe" "dfflegalize -cell \$_DFF_P_ 0" ; do
  yosys -q -p "
read_verilog benchmarks/official/test1.v
hierarchy -top test1
synth_intel -family cycloneiv -top test1 -run begin:map_luts
$pass
opt_clean
tee -o $D/t.json stat -json
" > "$D/t.log" 2>&1
  r=$(python3 - "$D/t.json" <<'PY'
import collections, json, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8")); mods = d["modules"]
    def nc(m):
        return len(m.get("cells", {}))
    name = "test1" if "test1" in mods else max(mods, key=lambda k: nc(mods[k]))
    m = mods[name]
    cnt = collections.Counter(v["type"] for v in m.get("cells", {}).values())
    ff = {k: v for k, v in cnt.items() if "dff" in k or "ff" in k}
    mux = sum(v for k, v in cnt.items() if "mux" in k)
    print(f"{ff}  mux={mux}  总单元={nc(m)}")
except Exception as e:
    print("? " + str(e))
PY
)
  printf '  %-34s %s\n' "$pass" "$r"
done
