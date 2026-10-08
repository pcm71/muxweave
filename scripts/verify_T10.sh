#!/usr/bin/env bash
# verify_T10.sh —— 确认把 &rrr 的超时从 1 秒放大到 10 秒后，4 个用例结果不变
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/t10
S=configs/abc_scripts/tosens
mkdir -p "$D"

echo "=== -T 10 的 4 用例结果（期望与 -T 1 相同：287/15/9/29）==="
for c in test1 test2 test3 test4; do
  local_t0=$(date +%s)
  timeout 120 yosys -q -p "
read_verilog benchmarks/official/$c.v
hierarchy -top $c
synth_intel -family cycloneiv -top $c -run begin:map_luts
abc9 -lut 4 -script $S/T10.abc
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $c -run map_cells:check
tee -o $D/${c}.json stat -json
" > "$D/${c}.log" 2>&1
  rc=$?
  dt=$(( $(date +%s) - local_t0 ))
  if [ $rc -ne 0 ]; then echo "  $c: 失败/超时 (rc=$rc, ${dt}s)"; continue; fi
  python3 - "$D/${c}.json" "$c" "$dt" <<'PY'
import json, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
nbt = d["design"]["num_cells_by_type"]
seq = sum(v for k, v in nbt.items() if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
print(f"  {sys.argv[2]:<7} 逻辑={d['design']['num_cells']-seq:<5} DFF={seq:<5} 耗时={sys.argv[3]}s")
PY
done
