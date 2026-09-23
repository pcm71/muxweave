#!/usr/bin/env bash
# verify_package.sh —— 把交付包解压到干净目录，验证"解压后即可使用"
#
#   bash scripts/verify_package.sh /path/to/muxweave-week1-code.zip
#
# 检查项：
#   1) 解压后目录结构正确（顶层是 muxweave/，不会散落一地）
#   2) 关键文件齐全
#   3) 行尾全为 LF（CRLF 是解压后不可用的头号原因）
#   4) 所有 shell 脚本通过 bash -n 语法校验
#   5) setup.sh --check-only 能在干净目录里跑通
set -uo pipefail

ZIP="${1:-}"
[ -n "$ZIP" ] || { echo "用法: bash scripts/verify_package.sh <zip 路径>"; exit 2; }
[ -f "$ZIP" ] || { echo "找不到 $ZIP"; exit 2; }

WORK="${HOME}/_pkg_verify"
rm -rf "$WORK"; mkdir -p "$WORK"
cd "$WORK" || exit 1

echo "=== 1) 解压（用 python3 的 zipfile，避免依赖 unzip）==="
python3 - "$ZIP" <<'PY'
import sys, zipfile
with zipfile.ZipFile(sys.argv[1]) as z:
    bad = z.testzip()
    if bad:
        print("  !! 压缩包损坏，首个坏文件:", bad); sys.exit(1)
    names = z.namelist()
    z.extractall(".")
    print(f"  解压 {len(names)} 个条目，CRC 校验通过")
PY
[ $? -eq 0 ] || { echo "!!! 解压失败"; exit 1; }

echo "=== 2) 目录结构 ==="
if [ -d muxweave ]; then
  echo "  [OK] 顶层目录 muxweave/ 存在"
else
  echo "  !! 顶层没有 muxweave/，解压会散落一地"; ls | head; exit 1
fi
cd muxweave || exit 1
echo "  文件数: $(find . -type f | wc -l)   大小: $(du -sh . | cut -f1)"

echo "=== 3) 关键文件 ==="
miss=0
for f in setup.sh README.md VERSION_LOCK.md configs/pipelines.json configs/b0_synth_intel_cycloneiv.ys \
         plugin/pmux_analyze.cc plugin/pmux_opt.cc plugin/CMakeLists.txt plugin/INTEGRATION.md \
         scripts/install_into_yosys.sh scripts/run_case.py scripts/report.py scripts/bootstrap_yosys.sh \
         scripts/build_eqy.sh benchmarks/unit/u02_pmux4_shared_fields.v \
         formal/mini/equiv_ok.eqy formal/mini/equiv_bad.eqy formal/mini/gold.v \
         docs/week1_report.md docs/reproduce.md; do
  if [ -f "$f" ]; then printf '  [OK] %s\n' "$f"; else printf '  [MISS] %s\n' "$f"; miss=$((miss+1)); fi
done
[ "$miss" -eq 0 ] || echo "  !! 缺 $miss 个关键文件"

echo "=== 4) 行尾检查（必须是 LF）==="
crlf=$(grep -rlU $'\r' --include="*.sh" --include="*.py" --include="*.ys" --include="*.eqy" . 2>/dev/null | head -20)
if [ -z "$crlf" ]; then echo "  [OK] 全部 LF"; else echo "  [FAIL] 以下文件含 CRLF:"; echo "$crlf" | sed 's/^/    /'; fi

echo "=== 5) shell 脚本语法校验 ==="
fail=0
while IFS= read -r f; do
  if bash -n "$f" 2>/dev/null; then printf '  [OK] %s\n' "$f"; else printf '  [FAIL] %s\n' "$f"; fail=$((fail+1)); fi
done < <(find . -name "*.sh" | sort)
[ "$fail" -eq 0 ] || echo "  !! $fail 个脚本语法失败"

echo "=== 6) setup.sh --check-only（干净目录实跑）==="
if bash setup.sh --check-only > /tmp/pkg_setup.log 2>&1; then
  echo "  [OK] setup.sh --check-only 通过"
  sed -n '1,20p' /tmp/pkg_setup.log | sed 's/^/    /'
else
  echo "  !! setup.sh --check-only 失败，输出："
  sed 's/^/    /' /tmp/pkg_setup.log | tail -25
fi

echo "=== 7) Python 工具自检 ==="
python3 scripts/static_check.py > /tmp/pkg_static.log 2>&1 && echo "  [OK] static_check" || { echo "  !! static_check 失败"; tail -10 /tmp/pkg_static.log | sed 's/^/    /'; }
python3 scripts/run_case.py --selftest > /tmp/pkg_s1.log 2>&1 && echo "  [OK] run_case --selftest" || { echo "  !! run_case 自检失败"; tail -10 /tmp/pkg_s1.log | sed 's/^/    /'; }
python3 scripts/report.py --selftest > /tmp/pkg_s2.log 2>&1 && echo "  [OK] report --selftest" || { echo "  !! report 自检失败"; tail -10 /tmp/pkg_s2.log | sed 's/^/    /'; }

echo
echo "=== 验证目录保留在 $WORK/muxweave （确认无误后可删）==="
