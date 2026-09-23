#!/usr/bin/env bash
# ============================================================================
#  setup.sh —— 一键搭建（解压后只跑这一条）
#
#    bash setup.sh                 # 全流程：自检 → 依赖检查 → 编译 → 接入 → 验证
#    bash setup.sh --install-deps  # 顺便帮你装 apt 依赖（会要 sudo 密码）
#    bash setup.sh --check-only    # 只做包完整性与环境自检，不编译
#
#  幂等：可以反复运行；已完成的阶段会自动跳过。
#  预计：依赖齐全时约 20 分钟（其中 Yosys 编译约 18 分钟）。
# ============================================================================
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT" || exit 1
INSTALL_DEPS=0
CHECK_ONLY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --install-deps) INSTALL_DEPS=1; shift ;;
    --check-only)   CHECK_ONLY=1; shift ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "未知参数: $1"; exit 2 ;;
  esac
done

APT_DEPS="cmake ninja-build build-essential clang lld bison flex gawk git make python3 pkg-config libffi-dev libfl-dev libreadline-dev tcl-dev zlib1g-dev graphviz xdot"
STAGE=0
say()  { echo; echo "##################### $* #####################"; }
die()  { echo; echo "!!! 失败: $*"; exit 1; }

# ---------------------------------------------------------------------------
say "阶段 0/6：包完整性自检（含 Windows 行尾自动修复）"
# 这是"解压后不能用"的头号原因：zip 传输/解压把 LF 变成 CRLF，bash 会报 $'\r'
crlf=$(grep -rlU $'\r' --include="*.sh" --include="*.py" --include="*.ys" --include="*.eqy" . 2>/dev/null | head -20)
if [ -n "$crlf" ]; then
  echo "  检测到 CRLF 行尾，正在修复（这是 Windows 解压的常见副作用）："
  echo "$crlf" | sed 's/^/    /'
  for f in $crlf; do sed -i 's/\r$//' "$f"; done
  chmod +x scripts/*.sh formal/mini/*.sh 2>/dev/null || true
  echo "  已修复"
else
  echo "  [OK] 行尾全部为 LF"
fi
missing=""
for f in README.md VERSION_LOCK.md configs/pipelines.json plugin/pmux_analyze.cc plugin/pmux_opt.cc \
         plugin/CMakeLists.txt scripts/run_case.py scripts/install_into_yosys.sh \
         benchmarks/unit/u02_pmux4_shared_fields.v formal/mini/equiv_ok.eqy; do
  [ -f "$f" ] || missing="$missing $f"
done
[ -z "$missing" ] && echo "  [OK] 关键文件齐全" || die "包不完整，缺少：$missing"
[ "$(uname -s)" = "Linux" ] && echo "  [OK] 运行在 Linux/WSL" \
  || die "本套件必须在 Linux 或 WSL2 的 Ubuntu 里运行（当前：$(uname -s)）。Windows 原生不支持。"
STAGE=1

# ---------------------------------------------------------------------------
say "阶段 1/6：依赖检查"
missing_tools=""
for t in cmake make g++ bison flex python3 git; do
  command -v "$t" >/dev/null 2>&1 || missing_tools="$missing_tools $t"
done
if [ -n "$missing_tools" ]; then
  echo "  缺少工具:$missing_tools"
  echo
  echo "  请先执行下面这条（唯一需要 sudo 的一步；密码输入时不显示字符）："
  echo
  echo "    sudo apt update && sudo apt install -y $APT_DEPS"
  echo
  if [ "$INSTALL_DEPS" = "1" ]; then
    echo "  --install-deps 已指定，现在执行…"
    sudo apt update && sudo apt install -y $APT_DEPS || die "apt 安装失败"
  else
    echo "  装好后重新运行： bash setup.sh"
    exit 1
  fi
fi
for t in cmake make g++ bison flex python3 git; do
  printf '  %-8s %s\n' "$t" "$(command -v "$t")"
done
CV=$(cmake --version | head -1 | awk '{print $3}')
[ "$(printf '%s\n3.28\n' "$CV" | sort -V | head -1)" = "3.28" ] || die "CMake $CV < 3.28（Yosys 0.67+ 要求）"
GCCV=$(g++ -dumpversion | cut -d. -f1)
[ "$GCCV" -ge 13 ] || echo "  警告：g++ 主版本 $GCCV < 13，Yosys 可能编译失败"
echo "  cmake $CV / g++ $GCCV"
# Tcl 是多架构路径，别只查 /usr/include/tcl.h
if [ -e /usr/include/tcl.h ] || [ -e /usr/include/tcl8.6/tcl.h ]; then
  echo "  [OK] Tcl 开发库存在（题目要求自定义 Tcl 命令）"
else
  echo "  警告：缺 tcl.h，编译出的 Yosys 将不支持 Tcl；建议 sudo apt install -y tcl-dev"
fi
[ "$CHECK_ONLY" = "1" ] && { say "仅自检模式：到此结束（--check-only）"; echo "包完整、环境可用。去掉 --check-only 即可开始编译。"; exit 0; }
STAGE=2

# ---------------------------------------------------------------------------
say "阶段 2/6：编译安装 Yosys v0.69（最慢，约 18 分钟）"
if [ -x "$HOME/.local/bin/yosys" ] && "$HOME/.local/bin/yosys" -V 2>/dev/null | grep -q "0.69"; then
  echo "  已存在：$("$HOME/.local/bin/yosys" -V)"
  echo "  跳过编译（如需重建：rm -rf ~/src/yosys/build 后重跑）"
else
  bash scripts/bootstrap_yosys.sh --tag v0.69 || die "Yosys 构建失败（见上方输出）"
fi
export PATH="$HOME/.local/bin:$PATH"
yosys -V || die "yosys 不可用"
STAGE=3

# ---------------------------------------------------------------------------
say "阶段 3/6：构建安装 EQY v0.69"
if command -v eqy >/dev/null 2>&1; then
  echo "  已存在：$(command -v eqy)"
else
  bash scripts/build_eqy.sh --tag v0.69 || die "EQY 构建失败"
fi
STAGE=4

# ---------------------------------------------------------------------------
say "阶段 4/6：把自研 pass 编入 Yosys 主程序（增量约 13 秒）"
bash scripts/install_into_yosys.sh || die "pass 接入失败"
STAGE=5

# ---------------------------------------------------------------------------
say "阶段 5/6：形式验证 + 基线用例 + 报告"
bash scripts/wsl_stage2.sh
STAGE=6

# ---------------------------------------------------------------------------
say "阶段 6/6：结果核对"
echo "  预期的 5 个用例逻辑单元数：u01=8  u02=12  u03=31  u04=14  u05=20"
echo "  预期的复用判定：u02=8/8  u03=4/4  其余为 0/0"
if [ -f reports/summary.md ]; then
  echo
  sed -n '1,12p' reports/summary.md | sed 's/^/    /'
else
  echo "  !! 没有生成 reports/summary.md，请检查上方阶段 5 的输出"
fi
cat <<'EOF'

============================================================
搭建完成。你可以开始用了：
  export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"
  yosys -p "help pmux_analyze"
  python3 scripts/run_case.py --case benchmarks/unit/u02_pmux4_shared_fields.v --top u02_pmux4_shared_fields
  bash formal/mini/run_formal_mini.sh
  cat docs/week1_report.md      # 第 1 周做了什么、证据在哪
  cat docs/reproduce.md         # 复现记录表（请填写并交回）
============================================================
EOF
