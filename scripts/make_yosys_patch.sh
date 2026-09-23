#!/usr/bin/env bash
# make_yosys_patch.sh —— 生成"自研 pass 接入 Yosys 0.69"的补丁，随仓库提交
#
# 目的：自研改动的完整证据在 ~/src/yosys 里（不在本仓库目录内）。
#       把 diff 落到 plugin/yosys-0.69-pmux.patch，队友/评委可直接 git apply 复现接入。
#
#   bash scripts/make_yosys_patch.sh
set -uo pipefail

Y="$HOME/src/yosys"
OUT=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/plugin/yosys-0.69-pmux.patch
cd "$Y" || { echo "找不到 $Y"; exit 1; }

{
  echo "# 自研 pass 接入 Yosys 0.69 —— 补丁"
  echo "# 生成时间 : $(date -Is)"
  echo "# 基版本   : $Y"
  echo "# Yosys    : $(git describe --tags --always)  commit $(git rev-parse HEAD)"
  echo "#"
  echo "# 用法："
  echo "#   cd <你的 yosys 源码树（tag v0.69）>"
  echo "#   git apply /path/to/yosys-0.69-pmux.patch"
  echo "#   cmake -B build . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=\$HOME/.local"
  echo "#   cmake --build build --config Release --parallel 5 && cmake --install build --strip"
  echo "#"
  echo "# 等价做法（推荐给队友）：直接跑本仓库的 scripts/install_into_yosys.sh"
  echo "#   它会复制 plugin/*.cc 到 passes/pmux/、追加注册行、重编并自检。"
  echo "#"
  echo "# 改动清单（应只有这些）："
  echo "#   M passes/CMakeLists.txt      （新增 1 行 add_subdirectory(pmux)）"
  echo "#   A passes/pmux/CMakeLists.txt"
  echo "#   A passes/pmux/pmux_analyze.cc"
  echo "#   A passes/pmux/pmux_opt.cc"
  echo "# 明确未使用 plugin -i 动态加载方案。"
  echo
  echo "=== git status --porcelain ==="
  git status --porcelain
  echo
  echo "=== 注册行 diff（passes/CMakeLists.txt）==="
  git diff -- passes/CMakeLists.txt
  echo
  echo "=== 新增文件（未跟踪内容单独附上）==="
  git add -N passes/pmux >/dev/null 2>&1 || true
  git diff -- passes/pmux
  git reset -q -- passes/pmux >/dev/null 2>&1 || true
} > "$OUT" 2>&1

echo "已写出: $OUT"
echo "行数: $(wc -l < "$OUT")  大小: $(du -h "$OUT" | cut -f1)"
echo
echo "--- 校验：补丁里应出现关键内容 ---"
grep -c "add_subdirectory(pmux)" "$OUT" | sed 's/^/  add_subdirectory(pmux) 命中: /'
grep -c "yosys_pass" "$OUT" | sed 's/^/  yosys_pass 命中: /'
grep -c "plugin -i" "$OUT" | sed 's/^/  提及 plugin -i（应为注释/说明）: /'
