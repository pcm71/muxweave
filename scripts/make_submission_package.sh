#!/usr/bin/env bash
# make_submission_package.sh —— 按答疑 C55 的打包清单生成提交物
#
# C55 原文：「1.优化源码（包括新加的 opt_xxx.cc，若有修改 abc 脚本也需要一并提交）
#            2.编译后的 yosys 二进制可执行程序以及其依赖库」
#
# 本脚本组装一个自包含目录，并在最后**实际运行包内二进制**验证它能复现 16.34%。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1

STAMP=$(date +%Y%m%d)
PKG="$P/dist/pmux-submission-$STAMP"
rm -rf "$PKG"
mkdir -p "$PKG"/{src,abc_scripts,bin,lib,evidence}

echo "=== 1) 优化源码（C55 第①项）==="
# pass 源码
for f in plugin/pmux_opt.cc plugin/pmux_analyze.cc; do
  [ -f "$f" ] && cp "$f" "$PKG/src/" && echo "  ✓ $f"
done
# 对 yosys 源码树的改动（synth_intel.cc 集成点）
if [ -f plugin/yosys-0.69-pmux.patch ]; then
  cp plugin/yosys-0.69-pmux.patch "$PKG/src/" && echo "  ✓ plugin/yosys-0.69-pmux.patch"
fi
[ -f plugin/CMakeLists.txt ] && cp plugin/CMakeLists.txt "$PKG/src/" && echo "  ✓ plugin/CMakeLists.txt"

echo
echo "=== 2) 调优的 abc9 脚本（C55 明确要求一并提交）==="
# 只提交 pass 实际用到的脚本 + 官方脚本对照
cp configs/abc_scripts/nkl/n_win.abc "$PKG/abc_scripts/area_script.abc" 2>/dev/null \
  && echo "  ✓ area_script.abc（pass 内 SCRIPT_AREA，逐字一致）"
cat > "$PKG/abc_scripts/official_script.abc" <<'EOF'
&scorr
&sweep
&dc2
&dch -f -r
&ps
&if -W 300 -v
&mfs
EOF
echo "  ✓ official_script.abc（官方默认脚本，供对照）"

echo
echo "=== 3) 编译后的二进制（C55 第②项）==="
for b in yosys yosys-abc yosys-config; do
  if [ -x "$HOME/.local/bin/$b" ]; then
    cp "$HOME/.local/bin/$b" "$PKG/bin/" && echo "  ✓ $b"
  fi
done
# yosys 需要的 share 数据目录（techlibs 等）
if [ -d "$HOME/.local/share/yosys" ]; then
  mkdir -p "$PKG/share"
  cp -r "$HOME/.local/share/yosys" "$PKG/share/" 2>/dev/null
  echo "  ✓ share/yosys（techlibs 等数据文件，二进制运行所必需）"
fi

echo
echo "=== 4) 依赖库（C55 明确要求）==="
if command -v ldd >/dev/null 2>&1; then
  ldd "$PKG/bin/yosys" 2>/dev/null | awk '{print $3}' | grep -E "^/" | while read -r lib; do
    # 只收集非系统默认路径下的库
    case "$lib" in
      /lib/*|/usr/lib/x86_64-linux-gnu/libc*|/usr/lib/x86_64-linux-gnu/libstdc++*|\
      /usr/lib/x86_64-linux-gnu/libm*|/usr/lib/x86_64-linux-gnu/libgcc*|\
      /usr/lib/x86_64-linux-gnu/libpthread*|/usr/lib/x86_64-linux-gnu/libdl*)
        ;;
      *) cp "$lib" "$PKG/lib/" 2>/dev/null && echo "  ✓ $(basename "$lib")" ;;
    esac
  done
  echo "  （系统自带的 libc/libstdc++ 等未复制，评测机通常已具备）"
fi

echo
echo "=== 5) 证据材料 ==="
for f in docs/official_submission.md docs/equivalence_matrix.md docs/requirements_authoritative.md; do
  [ -f "$f" ] && cp "$f" "$PKG/evidence/" && echo "  ✓ $f"
done
cp benchmarks/official/*.v "$PKG/evidence/" 2>/dev/null && echo "  ✓ 官方 4 个用例"

echo
echo "=== 6) 打包内验证：用包内二进制复现成绩 ==="
cd "$PKG" || exit 1
printf '  %-8s %-12s %-12s %s\n' "用例" "逻辑单元" "期望值" "判定"
echo "  ----------------------------------------------------"
for v in evidence/test*.v; do
  top=$(basename "$v" .v)
  ./bin/yosys -q -p "
read_verilog $v
hierarchy -top $top
synth_intel -family cycloneiv -top $top
tee -o /tmp/${top}_pkg.json stat -json
" > /dev/null 2>&1
  n=$(python3 -c "
import json
try:
    d=json.load(open('/tmp/${top}_pkg.json')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
    print(d['design']['num_cells']-seq)
except Exception: print('?')" 2>/dev/null)
  case "$top" in
    test1) exp=287 ;; test2) exp=15 ;; test3) exp=13 ;; test4) exp=27 ;; *) exp=? ;;
  esac
  ok="✓"; [ "$n" != "$exp" ] && ok="✗"
  printf '  %-8s %-12s %-12s %s\n' "$top" "$n" "$exp" "$ok"
done
cd "$P" || exit 1

echo
echo "=== 7) 生成清单 ==="
{
  echo "# 提交物清单（按答疑 C55）"
  echo
  echo "生成时间：$(date '+%Y-%m-%d %H:%M %Z')"
  echo
  echo "## 目录结构"
  echo '```'
  ( cd "$PKG" && find . -maxdepth 2 -type d | sort )
  echo '```'
  echo
  echo "## ① 优化源码"
  ls -la "$PKG/src" | tail -n +4 | awk '{printf "- %s  (%s 字节)\n", $9, $5}'
  echo
  echo "## 调优的 abc9 脚本"
  ls -la "$PKG/abc_scripts" | tail -n +4 | awk '{printf "- %s  (%s 字节)\n", $9, $5}'
  echo
  echo "## ② 二进制与依赖"
  ls -la "$PKG/bin" | tail -n +4 | awk '{printf "- bin/%s  (%s 字节)\n", $9, $5}'
  [ -d "$PKG/lib" ] && ls -la "$PKG/lib" | tail -n +4 | awk '{printf "- lib/%s\n", $9}'
  echo
  echo "## 集成点（对 yosys 源码树的改动）"
  echo "文件：\`techlibs/intel/synth_intel.cc\`，共两处："
  echo '```diff'
  echo '+ run("pmux_opt -analyze-only");   // coarse 阶段：在 mux 被 techmap 消除前识别 PMUX 结构'
  echo '- run("abc9 -lut 4 -W 300" + string(dff ? " -dff" : ""));'
  echo '+ run("pmux_opt" + string(dff ? " -dff" : ""));   // map_luts 阶段：PMUX 感知的映射策略选择'
  echo '```'
  echo
  echo "## 结果摘要"
  echo "- 面积：逐用例平均 **16.34%**（287/15/13/27，基线 288/25/13/36）"
  echo "- DFF：全部不变"
  echo "- 等价性：官方口径 EQY 2/4 + 设计模式 miter+sat 4/4（含自检与负对照）"
  echo "- 内存开销：+11.3%（C54-2 口径，只看 yosys.exe）；CPU 按 C54-1 不计分"
} > "$PKG/MANIFEST.md"
echo "  ✓ MANIFEST.md"

echo
echo "=== 完成 ==="
echo "  提交物目录: $PKG"
du -sh "$PKG" 2>/dev/null | sed 's/^/  体积: /'
