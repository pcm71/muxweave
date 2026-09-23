#!/usr/bin/env bash
# wsl_status.sh —— 在 WSL 里跑的环境 + 网络诊断（第 1 天用）
# 用法：bash scripts/wsl_status.sh
set -uo pipefail

echo "=== 系统 ==="
if [ -r /etc/os-release ]; then . /etc/os-release; echo "$PRETTY_NAME  kernel $(uname -r)"; fi
echo "=== 当前用户 ==="
echo "user=$(whoami)  HOME=$HOME"
echo "=== 项目目录是否可见 ==="
PROJ=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
if [ -d "$PROJ" ]; then echo "OK   $PROJ"; else echo "MISS $PROJ"; fi
echo "=== 必需工具 ==="
for t in gcc g++ clang cmake make git python3 bison flex tclsh curl wget tar; do
  if command -v "$t" >/dev/null 2>&1; then printf '%-8s OK      %s\n' "$t" "$(command -v "$t")"
  else printf '%-8s MISSING\n' "$t"; fi
done
echo "=== 版本要点 ==="
command -v cmake  >/dev/null && echo "cmake : $(cmake --version | head -1)"
command -v g++    >/dev/null && echo "g++   : $(g++ --version | head -1)"
command -v clang++>/dev/null && echo "clang : $(clang++ --version | head -1)"
command -v bison  >/dev/null && echo "bison : $(bison --version | head -1)"
command -v python3>/dev/null && echo "python: $(python3 --version)"
echo "=== 开发库头文件（Yosys 构建需要；注意多架构路径）==="
chk() { # 名称 候选路径...
  local n="$1"; shift
  for h in "$@"; do [ -e "$h" ] && { echo "OK   $n  ($h)"; return; }; done
  echo "MISS $n  (候选: $*)"
}
chk "tcl-dev"         /usr/include/tcl.h /usr/include/tcl8.6/tcl.h /usr/include/tcl/tcl.h
chk "libffi-dev"      /usr/include/ffi.h /usr/include/x86_64-linux-gnu/ffi.h
chk "libreadline-dev" /usr/include/readline/readline.h
chk "zlib1g-dev"      /usr/include/zlib.h
chk "libfl-dev"       /usr/include/FlexLexer.h /usr/include/flex/FlexLexer.h
echo "=== CMake 是否满足 Yosys 0.67+ 要求的 >= 3.28 ==="
if command -v cmake >/dev/null 2>&1; then
  CV=$(cmake --version | head -1 | awk '{print $3}')
  if [ "$(printf '%s\n3.28\n' "$CV" | sort -V | head -1)" = "3.28" ]; then echo "OK   CMake $CV"; else echo "FAIL CMake $CV < 3.28"; fi
fi
echo "=== sudo 是否免密 ==="
if sudo -n true 2>/dev/null; then echo "免密可用（我可以直接帮你装依赖）"; else echo "需要密码（正常，装依赖那一步要你敲一次）"; fi
echo "=== 网络：apt 源与 GitHub ==="
for u in http://archive.ubuntu.com/ubuntu/ https://github.com https://raw.githubusercontent.com; do
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 15 "$u" 2>/dev/null)
  printf '%-42s HTTP=%s\n' "$u" "${code:-fail}"
done
echo "=== 完成 ==="
