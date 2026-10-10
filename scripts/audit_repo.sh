#!/usr/bin/env bash
# audit_repo.sh —— 全仓库审计：语法、链接、残留、异常文件
set -uo pipefail
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1

echo "########## 1) Shell 脚本语法（bash -n）##########"
bad=0; n=0
while IFS= read -r f; do
  n=$((n+1))
  if ! bash -n "$f" 2>/dev/null; then echo "  ✗ $f"; bad=$((bad+1)); fi
done < <(git ls-files "*.sh")
echo "  检查 $n 个，失败 $bad 个"

echo
echo "########## 2) Python 语法 ##########"
bad=0; n=0
while IFS= read -r f; do
  n=$((n+1))
  if ! python3 -m py_compile "$f" 2>/dev/null; then echo "  ✗ $f"; bad=$((bad+1)); fi
done < <(git ls-files "*.py")
echo "  检查 $n 个，失败 $bad 个"

echo
echo "########## 3) 所有 .sh/.py 是否 LF 行尾（CRLF 会导致 \$'\\r' 报错）##########"
crlf=0
while IFS= read -r f; do
  if grep -qU $'\r' "$f" 2>/dev/null; then echo "  ✗ CRLF: $f"; crlf=$((crlf+1)); fi
done < <(git ls-files "*.sh" "*.py")
echo "  CRLF 文件数：$crlf"

echo
echo "########## 4) Markdown 内部链接是否有断链 ##########"
python3 - <<'PY'
import re, subprocess
from pathlib import Path
files = subprocess.run(["git","ls-files","*.md"], capture_output=True, text=True).stdout.split()
broken, total = [], 0
for f in files:
    p = Path(f)
    try:
        txt = p.read_text(encoding="utf-8", errors="replace")
    except Exception:
        continue
    for m in re.finditer(r"\]\(([^)#\s]+?)(?:#[^)]*)?\)", txt):
        link = m.group(1)
        if link.startswith(("http://", "https://", "mailto:")):
            continue
        total += 1
        target = (p.parent / link).resolve()
        if not target.exists():
            broken.append(f"{f} -> {link}")
print(f"  检查 {total} 条本地链接，断链 {len(broken)} 条")
for b in broken[:20]:
    print("  ✗", b)
PY

echo
echo "########## 5) 疑似生成物 / 临时残留（已跟踪的）##########"
git ls-files | grep -E "(^|/)(ctrl_|target_|fix_).*/" | awk -F/ '{print $1}' | sort | uniq -c | sort -rn | head -20 | sed 's/^/  /'
echo "  --- 其它可疑 ---"
git ls-files | grep -iE "\.(log|tmp|bak|orig|swp)$|~$|_tmp|\.pyc$" | head -20 | sed 's/^/  /'
echo "  --- 空文件 ---"
git ls-files -z | xargs -0 -I{} sh -c '[ -s "{}" ] || echo "  ✗ 空文件: {}"' 2>/dev/null | head -10
