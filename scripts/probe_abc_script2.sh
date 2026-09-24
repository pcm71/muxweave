#!/usr/bin/env bash
# probe_abc_script2.sh —— 对比"默认脚本"与"自定义 -script"时 Yosys 实际发给 ABC 的命令序列
#
# 关键问题：用 -script 时，Yosys 还会不会先发 read_lut <lutdefs.txt>？
#   * 若会 → 自定义脚本可以正常工作，上一轮的劣化另有原因
#   * 若不会 → 必须在自定义脚本里自己加载 LUT 库（但路径是动态临时目录，需另想办法）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
HEAD="read_verilog benchmarks/unit/u02_pmux4_shared_fields.v; hierarchy -top u02_pmux4_shared_fields; synth_intel -family cycloneiv -top u02_pmux4_shared_fields -run begin:map_luts"

run_variant() { # $1=标签 $2=abc 命令
  local tag="$1" cmd="$2"
  echo "=== [$tag] abc 命令：$cmd ==="
  yosys -p "$HEAD; $cmd" > "runs/abcprobe_${tag}.log" 2>&1
  echo "  --- Yosys 发给 ABC 的命令序列（ABC: 行）---"
  grep -E "^ABC: " "runs/abcprobe_${tag}.log" | head -25 | sed 's/^/    /'
  echo "  --- 是否出现 read_lut ---"
  if grep -q "read_lut" "runs/abcprobe_${tag}.log"; then
    grep -m1 "read_lut" "runs/abcprobe_${tag}.log" | sed 's/^/    ✓ /'
  else
    echo "    ✗ 没有 read_lut —— LUT 库未被加载"
  fi
  echo "  --- 单元数 ---"
  yosys -q -p "$HEAD; $cmd; stat" 2>/dev/null | grep -E "Number of cells|^\s+[0-9]+ cells" | tail -1 | sed 's/^/    /'
  echo
}

run_variant "default"  "abc -lut 4"
run_variant "custom"   "abc -lut 4 -script +strash,&get,-n,&fraig,-x,&put,scorr,dc2,dretime,strash,dch,-f,if,mfs2,lutpack,-S,1"

echo "=== 结论 ==="
echo "  对比上面两个变体的 'ABC:' 命令序列："
echo "  * default 应包含 read_lut <临时路径>/lutdefs.txt"
echo "  * 若 custom 缺少 read_lut，就解释了上一轮 5 个自定义脚本变体全部劣化 500 的原因"
echo "  * 解决办法：在自定义脚本里显式加入 read_lut（路径需动态获取），"
echo "    或不使用 -script 而改用 -luts/-lut w1:w2 等官方选项调成本模型"
