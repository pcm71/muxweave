#!/usr/bin/env bash
# install_into_yosys.sh —— 把自研 pass 编入 Yosys 主程序（0.68/0.69，CMake）
#
#   bash scripts/install_into_yosys.sh
#
# 做的事（全部幂等，可重复执行）：
#   1. 前置检查：Yosys 已构建安装
#   2. 复制 plugin/*.cc 与 plugin/CMakeLists.txt 到 $YOSYS/passes/pmux/
#   3. 在 passes/CMakeLists.txt 追加一行 add_subdirectory(pmux)（已存在则跳过）
#   4. 重新配置 + 编译 + 安装（只多编两个文件 + 重链接，通常几分钟）
#   5. 自检：help pmux_analyze / help pmux_opt / 对一个 $mux 小例跑分析
#   6. 写证据 runs/REQ10_integration_evidence.md（对应 REQ10「插件交付形态」）
#
# 纪律：全程不使用 `plugin -i` 加载 .so —— 主办方明确要求 pass 编进 Yosys 主程序。
set -uo pipefail

PROJ=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
YOSYS="$HOME/src/yosys"
PREFIX="$HOME/.local"
GEN="$PROJ/runs/REQ10_integration_evidence.md"
mkdir -p "$PROJ/runs"

stage() { echo; echo "########## $* ##########"; }
die()   { echo "!!! 失败: $*"; exit 1; }

stage "1/6 前置检查"
[ -d "$YOSYS/.git" ] || die "找不到 Yosys 源码 $YOSYS"
[ -x "$PREFIX/bin/yosys" ] || die "Yosys 尚未安装到 $PREFIX，请先跑 scripts/wsl_build_yosys.sh"
export PATH="$PREFIX/bin:$PATH"
echo "yosys: $(yosys -V)"
echo "源码: $YOSYS"
[ -f "$YOSYS/passes/CMakeLists.txt" ] || die "passes/CMakeLists.txt 不存在，源码结构异常"

MEM_MB=$(awk '/MemTotal/{print int($2/1024)}' /proc/meminfo)
JOBS=$(( MEM_MB / 1500 )); [ "$JOBS" -lt 2 ] && JOBS=2
[ "$JOBS" -gt "$(nproc)" ] && JOBS="$(nproc)"; [ "$JOBS" -gt 12 ] && JOBS=12
echo "并行度: $JOBS（内存 ${MEM_MB} MB）"

stage "2/6 复制自研 pass 到 passes/pmux/"
mkdir -p "$YOSYS/passes/pmux"
for f in pmux_analyze.cc pmux_opt.cc; do
  cp "$PROJ/plugin/$f" "$YOSYS/passes/pmux/$f" || die "复制 $f 失败"
  echo "  copied $f"
done
cp "$PROJ/plugin/CMakeLists.txt" "$YOSYS/passes/pmux/CMakeLists.txt" || die "复制 CMakeLists.txt 失败"
echo "  copied CMakeLists.txt"

stage "3/6 注册到 passes/CMakeLists.txt（幂等）"
if grep -q "add_subdirectory(pmux)" "$YOSYS/passes/CMakeLists.txt"; then
  echo "  已存在 add_subdirectory(pmux)，跳过"
else
  printf 'add_subdirectory(pmux)\n' >> "$YOSYS/passes/CMakeLists.txt" || die "写入注册行失败"
  echo "  已追加 add_subdirectory(pmux)"
fi
echo "  --- passes/CMakeLists.txt 现状 ---"
cat "$YOSYS/passes/CMakeLists.txt"

stage "4/6 重新配置并编译（只新增两个源文件 + 重链接）"
cd "$YOSYS" || die "cd"
cmake -B build . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PREFIX" >/tmp/pmux_cfg.log 2>&1 || { tail -20 /tmp/pmux_cfg.log; die "cmake 配置失败"; }
echo "  配置 OK"
T0=$(date +%s)
cmake --build build --config Release --parallel "$JOBS" || die "编译失败"
T1=$(date +%s)
echo "  编译耗时 $((T1-T0)) 秒"
cmake --install build --strip || die "安装失败"

stage "5/6 自检"
command -v yosys >/dev/null || die "安装后找不到 yosys"
echo "  yosys -V : $(yosys -V)"

yosys -p "help pmux_analyze" >/tmp/help_analyze.txt 2>&1 \
  && echo "  [OK] help pmux_analyze" \
  || { cat /tmp/help_analyze.txt; die "help pmux_analyze 失败 —— pass 可能没被链进主程序"; }
yosys -p "help pmux_opt" >/tmp/help_opt.txt 2>&1 \
  && echo "  [OK] help pmux_opt" \
  || { cat /tmp/help_opt.txt; die "help pmux_opt 失败"; }

# 造一个会产生 $mux 的最小例（s ? b : a）
cat > /tmp/pmux_selftest.v <<'VEOF'
module t (
    input  wire       s,
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] y
);
    assign y = s ? b : a;
endmodule
VEOF
yosys -p "read_verilog /tmp/pmux_selftest.v; hierarchy -top t; proc; pmux_analyze -table -json /tmp/pmux_selftest.json" \
  >/tmp/pmux_selftest.log 2>&1 || { cat /tmp/pmux_selftest.log; die "pmux_analyze 自检运行失败"; }
echo "  --- 自检输出 ---"
grep -E "pmux_analyze:|pmux_cells|\\\$mux" /tmp/pmux_selftest.log | head -10
[ -s /tmp/pmux_selftest.json ] && echo "  [OK] 产出 JSON" || die "未产出 JSON"

echo
echo "  --- 确认未使用 plugin 加载 ---"
yosys -p "read_verilog /tmp/pmux_selftest.v; hierarchy -top t; proc; pmux_opt -json /tmp/pmux_opt_selftest.json" \
  >/tmp/pmux_opt_selftest.log 2>&1 && echo "  [OK] pmux_opt 可直接调用（无需 plugin -i）" || die "pmux_opt 运行失败"

stage "6/6 写证据 $GEN"
{
  echo "# 自研 pass 编入 Yosys 主程序 —— 证据（REQ10）"
  echo
  echo "生成时间: $(date -Is)"
  echo
  echo "## 1. 交付形态"
  echo '本流程把 pmux_analyze / pmux_opt 作为 pass 编译进 Yosys 主程序，'
  echo '**未使用 `plugin -i` 加载 .so**，符合主办方 2026.09.20 答复的要求。'
  echo
  echo "## 2. 源码改动（git status --porcelain）"
  echo '```'
  git -C "$YOSYS" status --porcelain
  echo '```'
  echo
  echo "## 3. 注册方式（与 Yosys 自带组同构）"
  echo '```cmake'
  cat "$YOSYS/passes/pmux/CMakeLists.txt"
  echo '```'
  echo
  echo "## 4. 版本"
  echo '```'
  yosys -V
  git -C "$YOSYS" rev-parse HEAD
  echo '```'
  echo
  echo "## 5. help 输出"
  echo '```'
  cat /tmp/help_analyze.txt
  echo '```'
  echo
  echo "## 6. 最小自检（s ? b : a，应识别到 1 个 \$mux）"
  echo '```'
  grep -E "pmux_analyze:|\\\$mux|\\\$pmux" /tmp/pmux_selftest.log | head -20
  echo '```'
  echo
  echo "## 7. 分析 JSON"
  echo '```json'
  cat /tmp/pmux_selftest.json
  echo '```'
} > "$GEN" 2>&1
echo "  已写出 $GEN"

stage "完成"
echo "下一步："
echo "  export PATH=\$HOME/.local/bin:\$PATH"
echo "  cd $PROJ && python3 scripts/run_case.py --case benchmarks/unit/u02_pmux4_shared_fields.v"
