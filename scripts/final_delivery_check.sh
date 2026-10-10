#!/usr/bin/env bash
# final_delivery_check.sh —— 交付前自检：已安装 yosys 用官方标准命令跑 4 个用例
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs

echo "=== 已安装 yosys 版本 ==="
yosys -V | head -1 | sed 's/^/  /'
echo
echo "=== 用官方标准命令 synth_intel 跑 4 个官方用例 ==="
printf '  %-8s %-10s %-8s %s\n' "用例" "逻辑单元" "DFF" "期望（优化后）"
echo "  ------------------------------------------------"
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  yosys -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
tee -o runs/final_$top.json stat -json
" > "runs/final_$top.log" 2>&1
  python3 - "$top" <<'PY'
import json, sys
top = sys.argv[1]
exp = {"test1": 287, "test2": 15, "test3": 9, "test4": 29}   # 当前配置（逐用例平均 22.64%）
try:
    d = json.load(open(f"runs/final_{top}.json", encoding="utf-8"))
    nbt = d["design"]["num_cells_by_type"]
    seq = sum(v for k, v in nbt.items()
              if any(t in k.lower() for t in ("dff", "latch", "dffeas")))
    logic = d["design"]["num_cells"] - seq
    ok = "✓" if logic == exp.get(top) else f"✗ 期望 {exp.get(top)}"
    print(f"  {top:<8} {logic:<10} {seq:<8} {ok}")
except Exception as e:
    print(f"  {top:<8} 读取失败: {e}")
PY
done

echo
echo "=== 是否残留临时脚本 ==="
ls -la .pmux_opt_*.abc 2>/dev/null && echo "  ✗ 有残留" || echo "  ✓ 无残留"
