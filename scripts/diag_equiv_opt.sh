#!/usr/bin/env bash
# diag_equiv_opt.sh —— 用 Yosys 专门为此设计的 equiv_opt 验证"换 abc 是否保等价"
#
# 思路（比手搓 miter 更标准）：
#   1) 把设计推到 abc 之前（-run begin:map_luts）
#   2) 先跑官方 abc9 得到参考状态
#   3) 用 equiv_opt -assert <变体命令> 验证"在该状态上跑变体"与参考等价
#      —— equiv_opt 内部自己做 FF 匹配与 $equiv 单元证明，正是为这种场景设计的。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
mkdir -p /tmp/eqv runs

echo "=== equiv_opt 的可用选项 ==="
yosys -p "help equiv_opt" 2>&1 | sed -n '1,60p'

probe() { # $1=case $2=top $3=额外选项
  local v="$1" top="$2" extra="${3:-}"
  echo
  echo "=== 用例 $top （eqy_opt 额外选项: ${extra:-无}）==="
  cat > /tmp/eqv/eo_${top}.ys <<EOF
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top -run begin:map_luts
abc9 -lut 4 -W 300
clean
opt -fast
equiv_opt -assert $extra abc -lut 4
EOF
  timeout 120 yosys -s /tmp/eqv/eo_${top}.ys > "runs/diag_equivopt_${top}.log" 2>&1
  local rc=$?
  if [ $rc -eq 124 ]; then echo "  【超时】120s"
  elif [ $rc -eq 0 ]; then echo "  【通过】rc=0"
  else echo "  【未通过】rc=$rc"; fi
  grep -E "Equivalence successfully proven|unproven|No more equivalence|ERROR|Proved [0-9]+ previously unproven" \
    "runs/diag_equivopt_${top}.log" | tail -4 | sed 's/^/    /'
}

# 组合用例：直接试
probe benchmarks/unit/u02_pmux4_shared_fields.v u02_pmux4_shared_fields
# 时序用例：先不加 -seq，再加 -seq 1
probe benchmarks/mixed/m03_registered_pmux.v m03_registered_pmux
probe benchmarks/mixed/m03_registered_pmux.v m03_registered_pmux "-seq 1"

echo
echo "=== 结论提示 ==="
echo "  若某个选项组合 rc=0，就用它作为标准验证方式；"
echo "  若全部失败/超时，则改用'两侧各写网表 + 官方 EQY 比较两个文件'的路线。"
