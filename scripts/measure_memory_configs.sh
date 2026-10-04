#!/usr/bin/env bash
# measure_memory_configs.sh —— 定位内存开销来源（脚本本身 vs 多候选机制）
#
# 背景：面积已到 18.26%，但内存开销 +24.6% 远超细则"超限 15% 以上本项不得分"的线。
#       必须查清是 `&dch -p`（功耗感知）吃的内存，还是多候选副本吃的。
# 口径：C54-2，只看 yosys.exe 自身峰值（measure_yosys_self.py 轮询 VmHWM）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/mem_cfg
mkdir -p "$D" "$D/scripts"

cat > "$D/scripts/s_dch.abc" <<'EOF'
&dch -f -r
&if -a -v
EOF
cat > "$D/scripts/s_dchp.abc" <<'EOF'
&dch -p -f -r
&if -a -v
EOF
cat > "$D/scripts/s_official.abc" <<'EOF'
&scorr
&sweep
&dc2
&dch -f -r
&ps
&if -W 300 -v
&mfs
EOF

measure() { # $1=case $2=命令 -> 输出 KB
  python3 scripts/measure_yosys_self.py 1 -- "$HOME/.local/bin/yosys-baseline" -q -p "$2" \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['maxrss_self_kb'])"
}

seg() { # $1=case $2=abc 命令（在分段流程里跑）
  echo "read_verilog benchmarks/official/$1.v; hierarchy -top $1; \
synth_intel -family cycloneiv -top $1 -run begin:map_luts; $2; clean; opt -fast"
}

echo "=== 各配置的内存开销（口径 C54-2：只看 yosys.exe）==="
printf '  %-34s %-12s %-12s %s\n' "配置" "内存基线(KB)" "优化后(KB)" "开销"
echo "  -------------------------------------------------------------------------"
for case in test1 test2 test3 test4; do
  b=$(measure "$case" "$(seg $case 'abc9 -lut 4 -W 300')")
  v1=$(measure "$case" "$(seg $case 'abc9 -lut 4 -script runs/mem_cfg/scripts/s_dch.abc')")
  v2=$(measure "$case" "$(seg $case 'abc9 -lut 4 -script runs/mem_cfg/scripts/s_dchp.abc')")
  python3 -c "
b=$b
for name,v in (('abc9 官方脚本', $v1), ('&dch -f -r; &if -a', $v2)):
    print(f'  {\"$case \" + name:<34} {b:<12} {v:<12} {(v-b)/b*100:+.1f}%')
"
done

echo
echo "=== 多候选机制的内存代价（同一脚本跑两遍）==="
for case in test1 test4; do
  b=$(measure "$case" "$(seg $case 'abc9 -lut 4 -W 300')")
  v=$(measure "$case" "$(seg $case 'abc9 -lut 4 -script runs/mem_cfg/scripts/s_dch.abc; abc9 -lut 4 -script runs/mem_cfg/scripts/s_dch.abc')")
  python3 -c "print(f'  {\"$case 两候选\":<34} {b:<12} {v:<12} {(v-b)/b*100:+.1f}%')"
done
