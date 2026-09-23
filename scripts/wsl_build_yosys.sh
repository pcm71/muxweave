#!/usr/bin/env bash
# wsl_build_yosys.sh —— 在 WSL 里构建 Yosys v0.69 + EQY v0.69（不需要 sudo）
#
#   bash scripts/wsl_build_yosys.sh
# 或后台跑：
#   nohup bash scripts/wsl_build_yosys.sh > runs/build.log 2>&1 &
#
# 产出：
#   ~/.local/bin/yosys            已安装的 Yosys
#   ~/.local/bin/yosys-config     供 EQY 编译插件用
#   ~/src/eqy/eqy                 可直接调用的 EQY
#   runs/VERSION_LOCK.generated.md  版本证据（供回填 VERSION_LOCK.md）
set -uo pipefail

PROJ_WIN="/mnt/c/Users/LEGION/Desktop/PMUX/muxweave"
SRC="$HOME/src"
PREFIX="$HOME/.local"
YOSYS="$SRC/yosys"
EQY="$SRC/eqy"
mkdir -p "$PROJ_WIN/runs"
GEN="$PROJ_WIN/runs/VERSION_LOCK.generated.md"

stage() { echo; echo "########## $* ##########"; }
die()   { echo "!!! 失败: $*"; exit 1; }

stage "0/5 环境检查"
command -v cmake >/dev/null || die "缺少 cmake，请先运行：sudo apt install -y cmake ninja-build build-essential clang lld bison flex gawk git make python3 pkg-config libffi-dev libfl-dev libreadline-dev tcl-dev zlib1g-dev graphviz xdot"
for t in g++ clang++ bison flex python3; do command -v "$t" >/dev/null || die "缺少 $t"; done
[ -e /usr/include/tcl.h ] || echo "警告：缺 tcl.h（题目要求 Tcl 命令，建议装 tcl-dev 后重建）"

CM_VER=$(cmake --version | head -1 | awk '{print $3}')
[ "$(printf '%s\n3.28\n' "$CM_VER" | sort -V | head -1)" = "3.28" ] || die "CMake $CM_VER < 3.28"
echo "cmake  : $CM_VER"
echo "g++    : $(g++ --version | head -1)"
echo "python : $(python3 --version)"
[ -d "$YOSYS/.git" ] || die "找不到 $YOSYS，请先克隆源码"
[ -d "$EQY/.git" ]   || die "找不到 $EQY"

# 依据内存自适应并行度，避免 OOM（slang/sv-elab 单文件很吃内存）
MEM_MB=$(awk '/MemTotal/{print int($2/1024)}' /proc/meminfo)
JOBS=$(( MEM_MB / 1500 ))
[ "$JOBS" -lt 2 ] && JOBS=2
[ "$JOBS" -gt "$(nproc)" ] && JOBS="$(nproc)"
[ "$JOBS" -gt 12 ] && JOBS=12
echo "内存   : ${MEM_MB} MB  ->  并行度 ${JOBS}（CPU $(nproc) 核）"

stage "1/5 检出 v0.69 并同步子模块"
cd "$YOSYS" || die "cd yosys"
git checkout --force v0.69 || die "checkout v0.69"
git submodule update --init --recursive || die "submodule update"
YOSYS_SHA=$(git rev-parse HEAD)
ABC_SHA=$(git -C abc rev-parse HEAD 2>/dev/null || echo n/a)
echo "yosys commit: $YOSYS_SHA"
echo "abc   commit: $ABC_SHA"

stage "2/5 CMake 配置"
cmake -B build . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PREFIX" || die "cmake 配置失败"

stage "3/5 编译 Yosys（最慢的一步，可能 20~60 分钟）"
T0=$(date +%s)
cmake --build build --config Release --parallel "$JOBS" || die "编译失败"
T1=$(date +%s)
echo "编译耗时: $((T1-T0)) 秒"

stage "4/5 安装到 $PREFIX"
cmake --install build --strip || die "安装失败"
export PATH="$PREFIX/bin:$PATH"
command -v yosys >/dev/null || die "安装后找不到 yosys"
YS_VER=$(yosys -V)
echo "$YS_VER"

echo
echo "== Tcl 支持自检（题目要求自定义 Tcl 命令）=="
TCL_OK="否"
if yosys -p "help tcl" >/dev/null 2>&1; then TCL_OK="是"; echo "Tcl 可用"; else echo "警告：Tcl 不可用"; fi

stage "5/5 编译 EQY v0.69（与 Yosys 同环境）"
cd "$EQY" || die "cd eqy"
git checkout --force v0.69 || die "eqy checkout v0.69"
EQY_SHA=$(git rev-parse HEAD)
make -j"$JOBS" || die "EQY 编译失败"
chmod +x ./eqy 2>/dev/null || true
echo "EQY 就绪: $EQY/eqy"

stage "写出 VERSION_LOCK 证据"
cat > "$GEN" <<EOF
# VERSION_LOCK 自动生成证据

生成时间: $(date -Is)

| 项 | 值 |
|---|---|
| Yosys tag | v0.69 |
| Yosys commit | $YOSYS_SHA |
| yosys -V | $YS_VER |
| ABC commit | $ABC_SHA |
| EQY tag | v0.69 |
| EQY commit | $EQY_SHA |
| CMake | $CM_VER |
| 编译器 | $(g++ --version | head -1) |
| Python | $(python3 --version) |
| Tcl 可用 | $TCL_OK |
| 安装前缀 | $PREFIX |
| 源码目录 | $SRC |
| 并行度 | $JOBS |
| 编译耗时 | $((T1-T0)) 秒 |
EOF
cat "$GEN"
echo
echo "########## 全部完成 ##########"
echo "下一步："
echo "  export PATH=\$HOME/.local/bin:\$PATH"
echo "  cd $PROJ_WIN && bash formal/mini/run_formal_mini.sh"
