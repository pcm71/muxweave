#!/usr/bin/env bash
# 一键构建 Yosys（v0.68/v0.69，CMake 流程）并生成 VERSION_LOCK 片段。
#
#   bash scripts/bootstrap_yosys.sh                 # 默认 v0.69
#   bash scripts/bootstrap_yosys.sh --tag v0.68     # 换版本（注意：全队只能用一个）
#   bash scripts/bootstrap_yosys.sh --src ~/src --prefix ~/.local
#
# 说明：Yosys 0.67 起改用 CMake，旧的 `make config-gcc` 已失效。
set -euo pipefail

TAG="v0.69"
SRC_DIR="${HOME}/src"
PREFIX="${HOME}/.local"
JOBS="$(nproc 2>/dev/null || echo 4)"
REPO="https://github.com/YosysHQ/yosys.git"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)    TAG="$2"; shift 2 ;;
    --src)    SRC_DIR="$2"; shift 2 ;;
    --prefix) PREFIX="$2"; shift 2 ;;
    --jobs)   JOBS="$2"; shift 2 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "未知参数: $1" >&2; exit 2 ;;
  esac
done

command -v cmake >/dev/null || { echo "缺少 cmake（>=3.28）"; exit 1; }
CV="$(cmake --version | head -1 | awk '{print $3}')"
if [[ "$(printf '%s\n3.28\n' "$CV" | sort -V | head -1)" != "3.28" ]]; then
  echo "CMake $CV 低于 3.28。Ubuntu 22.04 请执行: sudo snap install cmake --classic"; exit 1
fi

mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

if [[ -d yosys/.git ]]; then
  echo "==> 复用已有仓库: $SRC_DIR/yosys"
  git -C yosys fetch --tags --depth 1 origin "refs/tags/${TAG}:refs/tags/${TAG}" || git -C yosys fetch --tags
else
  echo "==> 克隆 Yosys"
  git clone "$REPO" yosys
fi

cd yosys
echo "==> 检出 $TAG"
git checkout --force "$TAG"
# 子模块必须初始化：abc 等在被编译进主程序
git submodule update --init --recursive

echo "==> 配置（CMake）"
cmake -B build . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PREFIX"

echo "==> 编译（并行 $JOBS）"
cmake --build build --config Release --parallel "$JOBS"

echo "==> 安装到 $PREFIX"
cmake --install build --strip

export PATH="$PREFIX/bin:$PATH"
command -v yosys >/dev/null || { echo "安装后仍找不到 yosys，请把 $PREFIX/bin 加入 PATH"; exit 1; }

YS_VER="$(yosys -V)"
YS_SHA="$(git rev-parse HEAD)"
ABC_SHA="$(git -C abc rev-parse HEAD 2>/dev/null || echo 'n/a')"
CC_VER="$( (g++ --version 2>/dev/null || clang++ --version) | head -1)"
PY_VER="$(python3 --version 2>&1)"

# 自检：Tcl 是否可用（题目要求自定义 Tcl 命令）
TCL_OK="否"
if yosys -p "tcl help" >/dev/null 2>&1 || yosys -p "help tcl" >/dev/null 2>&1; then TCL_OK="是"; fi

cat <<EOF

================ VERSION_LOCK 片段（粘贴到 VERSION_LOCK.md 第 2 节）================
Yosys tag        : $TAG
Yosys commit     : $YS_SHA
yosys -V         : $YS_VER
ABC 子模块 commit: $ABC_SHA
编译器           : $CC_VER
CMake            : $CV
Python           : $PY_VER
Tcl 可用         : $TCL_OK
构建目录         : $SRC_DIR/yosys/build
安装前缀         : $PREFIX
====================================================================================

下一步：把 plugin/*.cc 接进 passes/（见 plugin/INTEGRATION.md），重新 cmake --build build。
EOF
