#!/usr/bin/env bash
# probe_write_netlist.sh —— 探清"把网表写成 Verilog 交给 EQY"是否可行
#
# 背景：EQY 比较 [gold]/[gate] 两段流程时，会因 abc9 创建/删除内部辅助模块而报
#       "Unmatched module exists in gold that does not exist in gate"。
#       因此改成**两侧各写一份网表文件，再用 EQY 比较两个文件**。
# 本脚本先确认：
#       ① 写出的文件里内部单元（$_AND_ / $_DFF_*）是否自带模块定义；
#       ② 停在 map_ffs 之前能否让 FF 保持通用类型（避开 dffeas 无 SAT 模型的问题）。
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p runs/netlist_probe
D=runs/netlist_probe

echo "=== 1) 停在 map_ffs 之前 + 官方 abc9 映射，写网表 ==="
yosys -q -p "
read_verilog benchmarks/official/test4.v
hierarchy -top test4
synth_intel -family cycloneiv -top test4 -run begin:map_ffs
abc9 -lut 4 -W 300
clean
opt -fast
write_verilog -noattr $D/test4_gold.v
" > $D/gen_gold.log 2>&1 && echo "  写出 $D/test4_gold.v" || tail -3 $D/gen_gold.log

echo
echo "=== 2) 文件里出现了哪些模块定义（前 20 个）==="
grep -E "^module" $D/test4_gold.v 2>/dev/null | head -20
echo "  --- 模块总数 ---"
grep -cE "^module" $D/test4_gold.v 2>/dev/null

echo
echo "=== 3) 单元类型统计 ==="
grep -oE "^\s+\S+\s+[_A-Za-z0-9\\\$.]+ \[" $D/test4_gold.v 2>/dev/null | head -5
echo "  --- 出现的关键类型 ---"
for t in '\$_AND_' '\$_NOT_' '\$_MUX_' '\$_DFF_' 'dffeas' '\$lut'; do
  c=$(grep -c -- "$t" $D/test4_gold.v 2>/dev/null || echo 0)
  echo "    $t : $c"
done

echo
echo "=== 4) 文件规模 ==="
wc -l $D/test4_gold.v 2>/dev/null
echo
echo "=== 5) 文件开头 15 行 ==="
head -15 $D/test4_gold.v 2>/dev/null
