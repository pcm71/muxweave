#!/usr/bin/env bash
# build_eqy.sh —— 构建并安装 EQY（必须与所用 Yosys 同环境）
#
#   bash scripts/build_eqy.sh                 # 默认 tag v0.69
#   bash scripts/build_eqy.sh --tag v0.68
#
# 关键事实（2026-09-23 在 EQY v0.69 源码里核实，之前的版本误报过成功）：
#   * 仓库里**没有**现成的 `eqy` 可执行文件；它是在 `make install` 时由 src/eqy.py 生成的：
#       src/eqy.py --(sed 替换 shebang 与版本)--> $(PREFIX)/bin/eqy
#     插件同时装到 $(PREFIX)/share/yosys/plugins/，eqy_job.py 装到 $(PREFIX)/share/yosys/python3/
#   * Makefile 默认 PREFIX=/usr/local（要 sudo）。把 PREFIX 指到 ~/.local 就**不需要 sudo**，
#     而且必须如此 —— 插件必须与 Yosys 的 datdir 一致（我们的 Yosys 就装在 ~/.local）。
#
# 注意：第 1 周的 formal/mini 例子用内置 sat 策略，不需要 SBY 与外部求解器；
#       只有切到 [strategy sby] 时才需要额外安装 SBY 与求解器（z3/yices/bitwuzla）。
set -euo pipefail

SRC_DIR="${HOME}/src"
PREFIX="${HOME}/.local"
TAG="v0.69"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)    TAG="$2"; shift 2 ;;
    --src)    SRC_DIR="$2"; shift 2 ;;
    --prefix) PREFIX="$2"; shift 2 ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "未知参数: $1" >&2; exit 2 ;;
  esac
done

command -v yosys >/dev/null || { echo "先把 ~/.local/bin 加入 PATH（Yosys 装在那里）"; exit 1; }
echo "yosys        : $(yosys -V)"
echo "yosys datdir : $(yosys-config --datdir 2>/dev/null || echo "$PREFIX/share/yosys")"
echo "EQY 安装前缀 : $PREFIX"

cd "$SRC_DIR"
[[ -d eqy/.git ]] || git clone https://github.com/YosysHQ/eqy.git eqy
cd eqy
git checkout --force "$TAG"

echo "==> 构建 EQY 插件（3 个 .so）"
make -j"$(nproc)"

echo "==> 安装到 $PREFIX（无需 sudo）"
make install PREFIX="$PREFIX"

echo "==> 自检（这一步以前缺失，导致误报成功）"
EQY_BIN="$PREFIX/bin/eqy"
if [[ ! -x "$EQY_BIN" ]]; then
  echo "!!! 失败：$EQY_BIN 不存在或不可执行"
  echo "    请查看安装目标： grep -n 'install' $SRC_DIR/eqy/Makefile"
  exit 1
fi
export PATH="$PREFIX/bin:$PATH"
command -v eqy >/dev/null || { echo "!!! eqy 不在 PATH"; exit 1; }
if eqy --help >/dev/null 2>&1; then echo "EQY 可用: $(command -v eqy)"; else echo "!!! eqy 执行失败"; exit 1; fi
echo "插件目录 .so 数量: $(ls -1 "$PREFIX"/share/yosys/plugins/*.so 2>/dev/null | wc -l)"

cat <<EOF

================ VERSION_LOCK 片段 ================
EQY tag    : $TAG
EQY commit : $(git rev-parse HEAD)
EQY 路径   : $(command -v eqy)
插件目录   : $PREFIX/share/yosys/plugins
==================================================

下一步：cd /mnt/c/Users/LEGION/Desktop/PMUX/muxweave && bash formal/mini/run_formal_mini.sh
EOF
