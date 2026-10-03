#!/usr/bin/env bash
# wsl_celltype_compliance.sh —— 核查 C53-3 合规：**其他单元（DFF/IO）不得增加**
#
# 依据 C53-3："主要看 lut 逻辑单元，原则上其他单元不能增加（如 dff, io）"
# 对**全部**基准用例逐一比较 基线二进制 vs 优化版二进制的各类单元数。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/celltype
mkdir -p "$D"

report() { # $1=json $2=标签 -> "总:序列:逻辑"
  python3 -c "
import json
d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
tot=d['design']['num_cells']
print(f'{tot}:{seq}:{tot-seq}')"
}

echo "C53-3 合规核查：其他单元（DFF/IO）不得增加"
echo
printf '  %-22s %-14s %-14s %s\n' "用例" "基线(总:DFF:逻辑)" "优化(总:DFF:逻辑)" "判定"
echo "  ------------------------------------------------------------------------------"
bad=0; total=0
for v in benchmarks/official/*.v benchmarks/unit/*.v benchmarks/mixed/*.v benchmarks/large/*.v; do
  [ -f "$v" ] || continue
  top=$(basename "$v" .v)
  ok=1
  "$HOME/.local/bin/yosys-baseline" -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
tee -o $D/${top}_b.json stat -json
" > "$D/${top}_b.log" 2>&1 || ok=0
  "$HOME/.local/bin/yosys-pmux" -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
tee -o $D/${top}_o.json stat -json
" > "$D/${top}_o.log" 2>&1 || ok=0
  if [ $ok -eq 0 ]; then printf '  %-22s %s\n' "$top" "（综合失败，跳过）"; continue; fi

  b=$(report "$D/${top}_b.json"); o=$(report "$D/${top}_o.json")
  bt=${b%%:*}; br=$(echo "$b" | cut -d: -f2); bl=$(echo "$b" | cut -d: -f3)
  ot=${o%%:*}; orr=$(echo "$o" | cut -d: -f2); ol=$(echo "$o" | cut -d: -f3)
  verdict="✓ 合规"
  if [ "$orr" -gt "$br" ]; then verdict="✗ **DFF 增加** $br→$orr"; bad=$((bad+1)); fi
  if [ "$ot" -gt "$bt" ]; then verdict="$verdict / **总单元增加** $bt→$ot"; fi
  total=$((total+1))
  printf '  %-22s %-14s %-14s %s\n' "$top" "$b" "$o" "$verdict"
done

echo "  ------------------------------------------------------------------------------"
echo "  共 $total 个用例，其中 $bad 个出现 DFF 增加"
[ $bad -eq 0 ] && echo "  ✅ 全部合规：没有任何用例的 DFF 增加" || echo "  ❌ 存在 DFF 增加，违反 C53-3，必须修复"
