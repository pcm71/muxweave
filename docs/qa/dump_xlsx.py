"""dump_xlsx.py —— 把 xlsx 的全部内容按工作表导出成易读文本（只读，不修改源文件）。

用法: python dump_xlsx.py <xlsx路径> <输出txt路径>
"""
import sys
from openpyxl import load_workbook

src, out = sys.argv[1], sys.argv[2]
wb = load_workbook(src, data_only=True)
lines = []
lines.append(f"工作表数量: {len(wb.sheetnames)}")
lines.append(f"工作表: {wb.sheetnames}")
lines.append("")

for ws in wb.worksheets:
    lines.append("=" * 100)
    lines.append(f"### 工作表: {ws.title}   维度: {ws.dimensions}  行数: {ws.max_row}  列数: {ws.max_column}")
    if ws.merged_cells.ranges:
        lines.append(f"合并单元格: {[str(r) for r in ws.merged_cells.ranges]}")
    lines.append("=" * 100)
    for row in ws.iter_rows():
        vals = []
        for c in row:
            v = c.value
            if v is None:
                continue
            vals.append(f"[{c.coordinate}] {str(v).strip()}")
        if vals:
            lines.append(" || ".join(vals))
    lines.append("")

with open(out, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"已写出 {out}")
print(f"总行数: {len(lines)}")
