#!/usr/bin/env bash
# wsl_final_verify.sh —— 加了规模护栏后的等价性复核
#
# 护栏改变的是"选哪条映射路径"，因此复核逻辑分两种：
#   · 走 official-abc9 的用例 ⇒ 产物应与基线**逐字节相同** ⇒ 平凡等价（可直接哈希比对）
#   · 走经典脚本的用例      ⇒ 需重新跑等价性检查（脚本已含自检+负对照）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
BIN="$P/runs/binaries"
D="$P/runs/final_verify"
mkdir -p "$D"
cd "$P" || exit 1

echo "=== 1) 用两个二进制各生成一份最终网表，并记录各自选了哪条路径 ==="
printf '  %-8s %-16s %-10s %s\n' "用例" "选中的候选" "哈希" "与基线是否逐字节相同"
echo "  ------------------------------------------------------------------------"
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  declare -A h
  for b in yosys-baseline yosys-pmux; do
    "$HOME/.local/bin/$b" -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
write_verilog -noattr $D/${top}_${b}.v
" > "$D/${top}_${b}.log" 2>&1
    h[$b]=$(sha256sum "$D/${top}_${b}.v" | cut -c1-16)
    # 记录选中路径（pmux_opt 的日志或被调用的 pass）
    if grep -q "候选 official-abc9" "$D/${top}_${b}.log"; then
      echo "official-abc9" > "$D/${top}_${b}.choice"
    elif grep -q "候选 pmux-primary" "$D/${top}_${b}.log"; then
      echo "pmux-primary" > "$D/${top}_${b}.choice"
    else
      echo "（基线：直接 abc9）" > "$D/${top}_${b}.choice"
    fi
  done
  same=$([ "${h[yosys-baseline]}" = "${h[yosys-pmux]}" ] && echo "是 ✓（平凡等价）" || echo "否 → 需跑等价性检查")
  printf '  %-8s %-16s %-10s %s\n' "$top" "$(cat $D/${top}_yosys-pmux.choice)" "${h[yosys-pmux]}" "$same"
  echo "${h[yosys-baseline]}" > "$D/${top}_hash_base"
  echo "${h[yosys-pmux]}"    > "$D/${top}_hash_pmux"
done

echo
echo "=== 2) 对"产物不同"的用例重跑等价性检查（含自检 + 负对照）==="
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  if [ "$(cat $D/${top}_hash_base)" = "$(cat $D/${top}_hash_pmux)" ]; then
    echo "  $top：产物与基线逐字节相同，平凡等价，跳过 ✓"
    continue
  fi
  depth=5; [ "$top" = "test3" ] && depth=12
  echo "  --- $top（周期 $depth）---"
  bash scripts/wsl_equiv_unbounded.sh "$top" "$depth" 900 2>&1 \
    | grep -E "自检|负对照|PASS|FAIL|ERROR|^  [a-z_0-9]+ " | head -12 | sed 's/^/    /'
done
