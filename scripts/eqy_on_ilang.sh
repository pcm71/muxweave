#!/usr/bin/env bash
# eqy_on_ilang.sh —— 按答疑 C54-3 的原话做等价性验证
#
# C54-3 原文：「映射用 synth_intel -family cycloneiv，eqy 验证 **abc 之后的 $lut 单元**，
#            因完全映射之后的 cycloneiv 单元 eqy 不能识别功能，
#            因此在 **abc 之后输出 ilang** 进行 eqy 验证。」
#
# 做法：
#   gold = 原始 RTL（read_verilog + prep）
#   gate = 官方流程跑到 abc 之后、map_cells 之前，write_ilang 出来的 $lut 网表
# 这样验证的是「RTL ↔ abc 之后的 $lut 网表」的功能一致（正是 C54-3 要求的口径）。
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D="$P/runs/eqy_ilang"   # 用绝对路径：EQY 在自己的工作子目录里执行，相对路径会失效
mkdir -p "$D"

echo "=== 工具版本 ==="
echo "  $(yosys -V | head -1)"
echo "  $(eqy --version 2>&1 | head -1)"
echo

for case in test1 test2 test3 test4; do
  echo "=== $case ==="
  # 1) 生成 abc 之后的 $lut 网表（ilang）
  #    在 map_ffs **之前**跑 abc：此时组合逻辑是 $lut、触发器还是通用类型（$adff/$dff），
  #    正是 C54-3 所说"abc 之后的 $lut 单元"，且无需引入 Intel 单元模型
  #    （dffeas 的行为模型有多重边沿触发，Yosys 前端不接受）。
  #    若在 map_ffs 之后取网表，FF 会变成 \dffeas，EQY 无法建模。
  yosys -q -p "
read_verilog benchmarks/official/$case.v
hierarchy -top $case
synth_intel -family cycloneiv -top $case -run begin:map_ffs
abc9 -lut 4 -script configs/abc_scripts/nkl/n_win.abc
clean
hierarchy -top $case
write_rtlil $D/${case}_postabc.il
" > "$D/${case}_gen.log" 2>&1
  # 只留顶层模块：techmap 会留下 dffeas / cycloneiv_* 等库模块，
  # EQY 会因"gate 里有 gold 没有的模块"直接报错。
  python3 - "$D/${case}_postabc.il" "$case" <<'PY'
import re, sys
p, top = sys.argv[1], sys.argv[2]
lines = open(p, encoding="utf-8", errors="ignore").read().split("\n")

head, blocks = [], []      # head=模块区之前的内容；blocks=每个模块及其**前置 attribute 行**
cur, attrs = None, []
for ln in lines:
    if ln.startswith("attribute "):
        attrs.append(ln)                     # 先攒着，归属下一个 module
        continue
    m = re.match(r"module (\\?\S+)", ln)
    if m:
        cur = {"name": m.group(1).strip("\\"), "lines": attrs + [ln]}
        attrs = []
        blocks.append(cur)
        continue
    if cur is not None:
        cur["lines"].append(ln)
        if ln.strip() == "endmodule":
            cur = None
        continue
    head.extend(attrs)                        # 不属于任何模块的属性（如 head 里的）
    attrs = []
    head.append(ln)

keep = [b for b in blocks if b["name"] == top]
out = "\n".join(head + [l for b in keep for l in b["lines"]])
open(p, "w", encoding="utf-8").write(out)
print(f"  模块裁剪: {len(blocks)} → {len(keep)}（保留 {top}）")
PY
  if [ ! -f "$D/${case}_postabc.il" ]; then
    echo "  ✗ 生成 ilang 失败"; tail -3 "$D/${case}_gen.log" | sed 's/^/    /'; continue
  fi
  # 2) 看 ilang 里的单元类型（确认是 $lut 层）
  types=$(grep -oE "cell \$[a-zA-Z0-9_]+" "$D/${case}_postabc.il" 2>/dev/null | sort | uniq -c | sort -rn | head -4 | tr '\n' ' ')
  echo "  网表单元: $types"

  # 3) 用 EQY 验证 RTL ↔ abc 之后的 $lut 网表
  #    gate 端先读 Intel 单元模型（网表里有 \dffeas 等原语，需行为定义才能被 SAT 建模），
  #    避免用 -lib（那样会当黑盒，无法证明等价）。
  mkdir -p "$D/${case}_eqy"
  cat > "$D/${case}_eqy/${case}.eqy" <<EOF
[gold]
read_verilog $P/benchmarks/official/${case}.v
prep -top ${case}
[gate]
read_rtlil $D/${case}_postabc.il
prep -top ${case}
[strategy simple]
use sat
EOF
  ( cd "$D/${case}_eqy" && eqy -f "${case}.eqy" ) > "$D/${case}_eqy/run.log" 2>&1
  rc=$?
  if [ $rc -eq 0 ]; then
    echo "  EQY: ✓ PASS"
  else
    echo "  EQY: ✗ FAIL/INCONCLUSIVE (rc=$rc)"
    grep -iE "unproven|Skipping strategy|No configured strategy|ERROR|Timeout|failed" "$D/${case}_eqy/run.log" 2>/dev/null | head -4 | sed 's/^/    /'
  fi
done
echo
echo "说明：本项与 scripts/verify_new_script.sh 的 miter+sat 方法互为交叉验证。"
