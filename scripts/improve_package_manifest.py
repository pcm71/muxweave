#!/usr/bin/env python3
"""improve_package_manifest.py
给打包脚本补两件事：
  ① 包根目录生成一份 README.md（让人一眼看到该先读哪份文档）
  ② MANIFEST.md 里补上"证据材料"清单（原来没列 evidence/ 的内容，会被误以为缺文件）
"""
from pathlib import Path

p = Path("/mnt/c/Users/LEGION/Desktop/PMUX/muxweave/scripts/make_submission_package.sh")
t = p.read_text(encoding="utf-8")

# ---- ① 在 MANIFEST 生成块之前插入：包根目录 README ----
anchor = 'echo "=== 7) 生成清单 ==="'
if anchor not in t:
    raise SystemExit("找不到锚点 '=== 7) 生成清单 ==='")

readme_block = r'''# 包根目录 README（先读这个）
cat > "$PKG/README.md" <<'READMEEOF'
# PMUX 结构优化 —— 提交物

**面积：逐用例平均 22.64%**（官方 4 个用例，287 / 15 / 9 / 29；基线 288 / 25 / 13 / 36）

## 先读哪份

| 文档 | 作用 |
|---|---|
| [`evidence/work_summary.md`](evidence/work_summary.md) | **当前工作说明** —— 我们在做什么、做到哪、怎么证明可信 |
| [`evidence/roadmap.md`](evidence/roadmap.md) | **预期工作大纲** —— 还缺什么、设计文档提纲、答辩提纲 |
| [`MANIFEST.md`](MANIFEST.md) | 本包清单：目录结构、文件明细、集成点 diff、结果摘要 |
| [`evidence/official_submission.md`](evidence/official_submission.md) | 逐用例提交报告（含合规性声明） |
| [`evidence/equivalence_matrix.md`](evidence/equivalence_matrix.md) | 等价性验证矩阵 |
| [`evidence/requirements_authoritative.md`](evidence/requirements_authoritative.md) | 赛题原文与主办方答疑的权威口径 |

## 目录

```
src/            优化源码（C55 第①项）
abc_scripts/    调优后的 abc9 脚本（C55 明确要求一并提交）
bin/            编译后的 yosys 二进制及其依赖（C55 第②项）
share/yosys/    二进制运行所需的数据文件
lib/            非系统依赖库
evidence/       证据材料 + 官方 4 个测试用例
MANIFEST.md     本包清单
```

## 快速验证（无需安装，用包内二进制）

```bash
cd <解压目录>
for c in test1 test2 test3 test4; do
  ./bin/yosys -q -p "read_verilog evidence/$c.v; hierarchy -top $c; synth_intel -family cycloneiv -top $c; stat"
done
```

期望逻辑单元数：test1=287、test2=15、test3=9、test4=29。
READMEEOF
echo "  ✓ README.md（包根目录，指路用）"

'''

t = t.replace(anchor, readme_block + anchor, 1)

# ---- ② MANIFEST 里补"证据材料"清单 ----
old_line = '''  echo "## ② 二进制与依赖"'''
new_block = '''  echo "## 证据材料（evidence/）"
  ls -la "$PKG/evidence" | tail -n +4 | awk '{printf "- evidence/%s  (%s 字节)\\n", $9, $5}'
  echo
  echo "## ② 二进制与依赖"'''
if old_line in t:
    t = t.replace(old_line, new_block, 1)
    print("  ✓ MANIFEST 增加 evidence/ 清单")
else:
    print("  ! 未找到 MANIFEST 的'② 二进制与依赖'锚点")

p.write_text(t, encoding="utf-8", newline="\n")
print("已写回")
