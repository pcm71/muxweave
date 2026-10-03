#!/usr/bin/env bash
# wsl_lut_dedup_probe.sh —— 探测"映射后 LUT 级去重"这条路有没有空间
#
# 思路：官方流程在 abc9 之后还有 map_cells（techmap 成 cycloneiv_lcell_comb）+ clean。
#       如果最终网表里存在**输入与功能完全相同的 LUT**，那么一个后置 pass 就能合并它们，
#       从而在不换映射器的前提下减少 LUT 逻辑单元（完全合规）。
# 探测方法：综合完成后依次跑若干"合并类"pass，看 LUT 单元数是否下降。
#   · opt_merge       合并完全相同的单元
#   · opt -full       全套优化
#   · 再来一轮 abc9    对 $lut 层重新映射（须在 map_cells 之前）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
BIN="$HOME/.local/bin/yosys-baseline"   # 用真基线二进制，避免我们自己的 pass 干扰
cd "$P" || exit 1
D=runs/lut_dedup
mkdir -p "$D"

logic_of() {
  python3 -c "
import json
try:
    d=json.load(open('$1')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')"
}

echo "=== 逐用例：官方流程后追加"合并类" pass，看 LUT 是否下降 ==="
printf '  %-8s %-10s %-12s %-12s %-12s %s\n' "用例" "官方基线" "+opt_merge" "+opt -full" "+opt_merge后clean" "结论"
echo "  ----------------------------------------------------------------------------------"
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  base=$D/${top}_base.json
  m1=$D/${top}_merge.json
  m2=$D/${top}_optfull.json
  m3=$D/${top}_merge2.json

  "$BIN" -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
tee -o $base stat -json
opt_merge
clean
tee -o $m1 stat -json
opt -full
clean
tee -o $m2 stat -json
opt_merge
clean -purge
opt_clean
tee -o $m3 stat -json
" > "$D/${top}.log" 2>&1

  b=$(logic_of "$base"); a=$(logic_of "$m1"); c=$(logic_of "$m2"); d=$(logic_of "$m3")
  verdict="无空间"
  if [ "$a" != "?" ] && [ "$b" != "?" ]; then
    drop=$(python3 -c "print($b-$a)")
    [ "$drop" -gt 0 ] && verdict="★ 有空间：-${drop}"
  fi
  printf '  %-8s %-10s %-12s %-12s %-12s %s\n' "$top" "$b" "$a" "$c" "$d" "$verdict"
done

echo
echo "=== 另一条：在 map_cells 之前对 \$lut 层再跑一轮 abc9（仍只用 abc9）==="
printf '  %-8s %-14s %-14s %s\n' "用例" "官方基线" "再跑一轮abc9" "变化"
echo "  ------------------------------------------------------"
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  r=$D/${top}_rerun.json
  "$BIN" -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run begin:map_luts
abc9 -lut 4 -W 300
abc9 -lut 4 -W 300
clean
opt -fast
autoname
clean
synth_intel -family cycloneiv -top $top -run map_cells:check
tee -o $r stat -json
" > "$D/${top}_rerun.log" 2>&1
  b=$(logic_of "$D/${top}_base.json"); n=$(logic_of "$r")
  delta=$(python3 -c "
try: print($b-$n)
except Exception: print('?')")
  printf '  %-8s %-14s %-14s %s\n' "$top" "$b" "$n" "$delta"
done
