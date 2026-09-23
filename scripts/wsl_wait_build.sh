#!/usr/bin/env bash
# wsl_wait_build.sh —— 等待后台构建结束，然后打印结果摘要
# 用途：作为守护进程挂在后台，构建一结束就把结论吐出来（供 DSH 后台任务捕获）。
LOG=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/runs/build_yosys.log
MAX_WAIT=5400   # 最多等 90 分钟
STEP=15

echo "开始等待构建结束（最多 $((MAX_WAIT/60)) 分钟）..."
waited=0
while [ "$waited" -lt "$MAX_WAIT" ]; do
  if ! pgrep -f "wsl_build_yosys.sh" >/dev/null 2>&1; then
    echo "构建进程已退出（等待了 ${waited}s）"
    break
  fi
  sleep "$STEP"
  waited=$((waited+STEP))
done

echo
echo "=================== 结果 ==================="
if grep -q "全部完成" "$LOG" 2>/dev/null; then
  echo "状态: 成功"
elif grep -qE "^!!! 失败" "$LOG" 2>/dev/null; then
  echo "状态: 失败"
  grep -nE "^!!! 失败" "$LOG" | tail -3
else
  echo "状态: 未完成（仍在运行或异常退出）"
fi
echo "--------------------------------------------"
echo "--- 日志尾部 40 行 ---"
tail -40 "$LOG" 2>/dev/null
echo "============================================"
