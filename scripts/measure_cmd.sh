#!/usr/bin/env bash
# 用 /usr/bin/time -v 采集「CPU 时间 + 整个进程峰值内存」，用于人工核对 run_case.py 的数字。
#
#   bash scripts/measure_cmd.sh yosys -p "read_verilog bench.v; hierarchy -top top; proc; synth_intel -family cycloneiv; stat"
#
# 官方口径：耗时按 CPU 时间（user+sys），内存按整个进程的峰值（Maximum resident set size）。
set -euo pipefail

if [[ $# -eq 0 ]]; then sed -n '2,8p' "$0"; exit 2; fi
TIME_BIN="/usr/bin/time"
if [[ ! -x "$TIME_BIN" ]]; then
  echo "缺少 /usr/bin/time（Ubuntu: sudo apt-get install time）"; exit 1
fi

LOG="$(mktemp)"
echo "== 命令: $*"
"$TIME_BIN" -v -o "$LOG" "$@"

echo "== 关键指标 =="
grep -E "User time|System time|Elapsed \(wall clock\)|Maximum resident set size|Percent of CPU" "$LOG" || true
UP="$(awk -F': ' '/User time/{print $2}' "$LOG")"
SP="$(awk -F': ' '/System time/{print $2}' "$LOG")"
RSS="$(awk -F': ' '/Maximum resident set size/{print $2}' "$LOG")"
echo "-------------------------------------------------"
printf 'CPU 时间(用户+系统) : %.3f s\n' "$(awk -v u="$UP" -v s="$SP" 'BEGIN{print u+s}')"
printf '整进程峰值内存      : %.1f MB (=%s KB)\n' "$(awk -v r="$RSS" 'BEGIN{print r/1024}')" "$RSS"
echo "完整 /usr/bin/time -v 输出保存在: $LOG"
