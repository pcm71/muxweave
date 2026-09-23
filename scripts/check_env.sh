#!/usr/bin/env bash
# 环境自检：第 1 天第一条命令。缺失项会给出可直接执行的安装提示。
set -uo pipefail

ok=0; bad=0
pass() { printf '  \033[32m[OK]\033[0m   %-16s %s\n' "$1" "$2"; ok=$((ok+1)); }
fail() { printf '  \033[31m[MISS]\033[0m %-16s %s\n' "$1" "$2"; bad=$((bad+1)); }
warn() { printf '  \033[33m[WARN]\033[0m %-16s %s\n' "$1" "$2"; }

echo "== 1. 平台 =="
if [[ "$(uname -s)" == "Linux" ]]; then
  pass "平台" "$(uname -srm)"
  if [[ -r /etc/os-release ]]; then
    . /etc/os-release; echo "       发行版: ${PRETTY_NAME:-unknown}"
    case "${VERSION_ID:-}" in
      22.04) warn "Ubuntu 22.04" "apt 的 CMake 只有 3.22 < 3.28，请执行: sudo snap install cmake --classic" ;;
    esac
  fi
else
  fail "平台" "需要 Linux 或 WSL2（当前 $(uname -s)）；Windows 原生不作为主环境"
fi

echo "== 2. 必需工具 =="
check_any() { # name, required_ver, cmd...
  local name="$1"; shift
  local found=""
  for c in "$@"; do command -v "$c" >/dev/null 2>&1 && { found="$c"; break; }; done
  if [[ -n "$found" ]]; then pass "$name" "$("$found" --version 2>&1 | head -1)"; else fail "$name" "未找到（尝试: $*）"; fi
}
check_any "cmake" cmake
check_any "编译器" g++ clang++
check_any "make/ninja" make ninja
check_any "flex" flex
check_any "bison" bison
check_any "python3" python3
check_any "git" git
check_any "pkg-config" pkg-config

echo "== 3. CMake 版本（Yosys 0.67+ 要求 >= 3.28）=="
if command -v cmake >/dev/null 2>&1; then
  cv="$(cmake --version | head -1 | awk '{print $3}')"
  if [[ "$(printf '%s\n3.28\n' "$cv" | sort -V | head -1)" == "3.28" ]]; then
    pass "CMake 版本" "$cv"
  else
    fail "CMake 版本" "$cv < 3.28（sudo snap install cmake --classic）"
  fi
fi

echo "== 4. 编译器标准（需要 C++20 / GCC>=13 或 Clang>=16）=="
for c in g++ clang++; do
  command -v "$c" >/dev/null 2>&1 || continue
  v="$("$c" -dumpversion 2>/dev/null | cut -d. -f1)"
  if [[ -n "$v" && "$v" -ge 13 ]]; then pass "$c" "主版本 $v"; else warn "$c" "主版本 ${v:-?}，建议 >= 13（clang >= 16）"; fi
done

echo "== 5. 开发库 =="
# Ubuntu/Debian 是多架构布局：tcl.h 在 /usr/include/tcl8.6/，ffi.h 在 /usr/include/x86_64-linux-gnu/
# 只查 /usr/include/xxx.h 会误报缺失，所以逐个候选路径查找。
have_hdr() {
  local n="$1"; shift
  for h in "$@"; do
    [ -e "$h" ] && { pass "$n" "$h"; return; }
  done
  fail "$n" "未找到（候选：$*）"
}
have_hdr "tcl-dev"         /usr/include/tcl.h /usr/include/tcl8.6/tcl.h /usr/include/tcl/tcl.h
have_hdr "libffi-dev"      /usr/include/ffi.h /usr/include/x86_64-linux-gnu/ffi.h
have_hdr "libreadline-dev" /usr/include/readline/readline.h
have_hdr "zlib1g-dev"      /usr/include/zlib.h
have_hdr "libfl-dev"       /usr/include/FlexLexer.h /usr/include/flex/FlexLexer.h

echo "== 6. 可选工具 =="
for c in dot xdot iverilog verilator yosys eqy; do
  if command -v "$c" >/dev/null 2>&1; then pass "$c" "$(command -v "$c")"; else warn "$c" "未安装（可选，或尚未构建）"; fi
done

echo "== 7. 一键安装提示（Ubuntu）=="
cat <<'EOF'
  sudo apt-get install -y gawk git make python3 lld bison clang flex \
    libffi-dev libfl-dev libreadline-dev pkg-config tcl-dev zlib1g-dev \
    graphviz xdot
EOF

echo
echo "结果：通过 ${ok} 项，缺失 ${bad} 项。"
if [[ $bad -gt 0 ]]; then echo "→ 先补齐缺失项，再运行 scripts/bootstrap_yosys.sh"; exit 1; fi
echo "→ 环境就绪，继续 scripts/bootstrap_yosys.sh"
