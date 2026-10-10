#!/usr/bin/env python3
"""check_gitignore_encoding.py —— 查 .gitignore 的编码问题并顺手补上需要的忽略规则"""
from pathlib import Path

p = Path("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/.gitignore")
b = p.read_bytes()

print(f"总字节数: {len(b)}")
try:
    txt = b.decode("utf-8")
    print("  ✓ 是合法 UTF-8")
    need_fix = False
except UnicodeDecodeError as e:
    print(f"  ✗ 非法字节：位置 {e.start}，字节 {b[e.start]:#04x}")
    print("    上下文(hex):", " ".join(f"{x:02X}" for x in b[max(0, e.start - 8):e.start + 8]))
    print("    前面可解码结尾:", repr(b[max(0, e.start - 50):e.start].decode("utf-8", "replace")))
    txt = b.decode("utf-8", "replace")
    need_fix = True

# 需要的忽略规则
WANT = [
    "",
    "# EQY 运行工作目录（生成物；由 scripts/ 下的验证脚本重新产生）",
    "/ctrl_test*/",
    "/target_test*/",
    "/fix_test*/",
]
missing = [w for w in WANT if w and w not in txt]
print()
print("缺失的规则:", missing if missing else "无")

if missing:
    if need_fix:
        # 修正非法字节（用 U+FFFD 位置重写为合法 UTF-8，再追加规则）
        p.write_text(txt + "\n".join(WANT) + "\n", encoding="utf-8")
        print("  已：修正编码并追加规则")
    else:
        with p.open("a", encoding="utf-8") as f:
            f.write("\n".join(WANT) + "\n")
        print("  已：追加规则")

# 复核
b2 = p.read_bytes()
try:
    b2.decode("utf-8")
    print("  复核：✓ 现在为合法 UTF-8")
except UnicodeDecodeError as e:
    print(f"  复核：✗ 仍有非法字节 @{e.start}")
print()
print("=== .gitignore 当前内容 ===")
for i, ln in enumerate(b2.decode("utf-8", "replace").split("\n"), 1):
    if ln.strip():
        print(f"  {i:2d}  {ln}")
