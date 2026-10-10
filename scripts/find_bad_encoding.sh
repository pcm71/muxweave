#!/usr/bin/env bash
# find_bad_encoding.sh —— 找出被跟踪的文本文件里编码不合法的（防止再出现 .gitignore 那种 GBK 乱码）
set -uo pipefail
cd /mnt/c/Users/LEGION/Desktop/PMUX/muxweave || exit 1
echo "=== 扫描已跟踪的文本文件（.md/.sh/.py/.txt/.cc/.h/.json/.v/.abc/.ys）==="
bad=0; n=0
while IFS= read -r f; do
  n=$((n+1))
  if ! python3 -c "
import sys
try:
    open(sys.argv[1], encoding='utf-8').read()
except UnicodeDecodeError as e:
    print(f'  ✗ {sys.argv[1]}  非法字节 @{e.start}')
    sys.exit(1)
except Exception:
    pass
" "$f"; then
    bad=$((bad+1))
  fi
done < <(git ls-files "*.md" "*.sh" "*.py" "*.txt" "*.cc" "*.h" "*.json" "*.v" "*.abc" "*.ys" "*.eqy" "*.patch")
echo "  检查 $n 个，编码异常 $bad 个"

echo
echo "=== 复核：4 个官方用例自检是否仍通过 ==="
export PATH="$HOME/.local/bin:$PATH"
for c in test1 test2 test3 test4; do
  yosys -q -p "
read_verilog benchmarks/official/$c.v
hierarchy -top $c
synth_intel -family cycloneiv -top $c
tee -o /tmp/audit_$c.json stat -json
" > /dev/null 2>&1
  python3 -c "
import json
d=json.load(open('/tmp/audit_$c.json')); nbt=d['design']['num_cells_by_type']
seq=sum(v for k,v in nbt.items() if any(t in k.lower() for t in ('dff','latch','dffeas')))
exp={'test1':287,'test2':15,'test3':9,'test4':29}['$c']
got=d['design']['num_cells']-seq
print(f\"  {'$c':<7} 逻辑={got:<5} DFF={seq:<5} {'✓' if got==exp else '✗ 期望 '+str(exp)}\")"
done
