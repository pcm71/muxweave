#!/usr/bin/env bash
# grep_abc_if_opts.sh —— 从 ABC 源码里找 GIA `&if` 的完整选项表
set -uo pipefail
cd "$HOME/src" || exit 1
echo "=== ABC 源码位置 ==="
ls -d */abc */*/abc 2>/dev/null | head -5
ABC=$(ls -d ~/src/yosys/abc 2>/dev/null | head -1)
echo "  使用: ${ABC:-未找到}"
[ -n "${ABC:-}" ] || { echo "未找到 ABC 源码目录"; exit 1; }

echo
echo "=== 找 &if（Gia_ManIf / If_Man）的 usage 字符串 ==="
grep -rn "usage: &if" "$ABC/src" 2>/dev/null | head -3
grep -rn "usage: if " "$ABC/src" 2>/dev/null | head -3

echo
echo "=== 相关实现文件 ==="
grep -rln "&if" "$ABC/src/base/abci/abc.c" 2>/dev/null | head -2
grep -rn "Abc_CommandIf\b" "$ABC/src" 2>/dev/null | head -5

echo
echo "=== 直接打印 Gia 版 if 的选项（从源码里的字符串块）==="
F=$(grep -rln "Abc_CommandIf" "$ABC/src/base/abci/abc.c" 2>/dev/null | head -1)
[ -n "${F:-}" ] && awk '/Abc_CommandIf\(/,/^}/' "$F" | grep -E "Abc_Print|usage" | head -40
