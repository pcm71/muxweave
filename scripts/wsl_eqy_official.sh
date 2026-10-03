#!/usr/bin/env bash
# wsl_eqy_official.sh —— 用官方 EQY 给官方 4 个 case 出形式等价证据
#
# 为什么这样设计（前几次失败的经验都体现在这里）：
#   ① EQY 比较"两段流程"时会因 abc9 创建/删除内部辅助模块而报
#      "Unmatched module exists in gold that does not exist in gate"
#      ⇒ 改为**两侧各写一份网表文件**，EQY 只比较两个文件。
#   ② 停在 map_ffs 之前（-run begin:map_ffs），FF 保持通用形式，
#      write_verilog 输出的是纯行为 Verilog（LUT 为 const>>{inputs}、FF 为 always 块），
#      既没有内部单元、也没有 dffeas 原语 ⇒ EQY 可直接读取。
#   ③ gold = 官方 abc9 映射；gate = 自研 pmux_opt。两者在同一输入网表上做映射，
#      因此证明的就是"我们的映射与官方映射等价"。
#
#   bash scripts/wsl_eqy_official.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
EQDIR="formal/eqy_official"
mkdir -p "$EQDIR/logs" runs/netlist_official

gen() { # $1=verilog $2=top $3=映射命令 $4=输出文件
  yosys -q -p "
read_verilog $1
hierarchy -top $2
synth_intel -family cycloneiv -top $2 -run begin:map_ffs
$3
clean
opt -fast
write_verilog -noattr $4
" > "${4%.v}.genlog" 2>&1
}

pass=0; fail=0
for v in benchmarks/official/*.v; do
  top=$(basename "$v" .v)
  gold="runs/netlist_official/${top}_gold.v"
  gate="runs/netlist_official/${top}_gate.v"
  cfg="$EQDIR/${top}.eqy"
  log="$EQDIR/logs/${top}.log"

  echo "=== $top ==="
  gen "$v" "$top" "abc9 -lut 4 -W 300" "$gold" || { echo "  gold 生成失败"; tail -3 "${gold%.v}.genlog" | sed 's/^/    /'; fail=$((fail+1)); continue; }
  gen "$v" "$top" "pmux_opt" "$gate" || { echo "  gate 生成失败"; tail -3 "${gate%.v}.genlog" | sed 's/^/    /'; fail=$((fail+1)); continue; }

  # 两侧顶层模块名必须一致 —— 都来自同一份源文件，天然一致
  g_mod=$(grep -m1 -oE "^module [A-Za-z0-9_]+" "$gold" | awk '{print $2}')
  e_mod=$(grep -m1 -oE "^module [A-Za-z0-9_]+" "$gate" | awk '{print $2}')
  if [ "$g_mod" != "$e_mod" ]; then
    echo "  ✗ 顶层模块名不一致（gold=$g_mod gate=$e_mod），EQY 无法比较"
    fail=$((fail+1)); continue
  fi

  cat > "$cfg" <<EOF
# 自动生成：官方 4 个 case 的等价性验证
# gold = 官方 abc9 映射；gate = 自研 pmux_opt（两者在同一输入网表上映射）
[options]
splitnets off

[gold]
read_verilog $gold
prep -top $top

[gate]
read_verilog $gate
prep -top $top

[strategy simple]
use sat
depth 5
EOF

  rm -rf "./${top}_eqy" "${top}_eqy" 2>/dev/null
  timeout 300 eqy "$cfg" > "$log" 2>&1
  rc=$?
  if [ $rc -eq 0 ]; then
    pass=$((pass+1)); verdict="PASS"
  else
    fail=$((fail+1)); verdict="FAIL"
  fi
  printf '  %-6s rc=%-3s %s\n' "$verdict" "$rc" "$(grep -oE 'Successfully proved designs equivalent|DONE \([A-Z]+' "$log" | tail -1)"
  grep -E "ERROR|Failed to prove|unproven|Unproven" "$log" | head -3 | sed 's/^/      /'
  rm -rf "./${top}_eqy" 2>/dev/null
done

echo
echo "=== EQY 等价性汇总：PASS $pass / FAIL $fail ==="
if [ "$fail" -eq 0 ]; then
  cat <<'EOF'
结论：官方 4 个 case 的"自研 pmux_opt 映射"与"官方 abc9 映射"经 EQY 证明等价。

口径说明：gold 与 gate 都停在 map_ffs 之前做映射，两者输入网表完全相同，
          之后的 map_ffs / map_cells 等步骤两侧一致，故结论对最终 cycloneiv 网表同样成立。
EOF
else
  echo "存在未通过用例 —— 需逐个定位（先看 formal/eqy_official/logs/ 下对应日志）。"
fi
