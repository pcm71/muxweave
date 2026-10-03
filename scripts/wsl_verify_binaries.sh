#!/usr/bin/env bash
# wsl_verify_binaries.sh —— 校验两个二进制的行为差异（不静默，才能看到 pass 调用）
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
BIN="$P/runs/binaries"
cd "$P" || exit 1
mkdir -p runs/binaries

# 关键：Yosys 按"可执行文件所在目录的 ../share/yosys"找数据目录，
# 复制到别处会报 "ERROR: init_share_dirname: unable to determine share/ directory!"。
# YOSYS_DATDIR 环境变量在本版本无效，因此把两个二进制放到已安装 yosys 的同级目录。
LOCALBIN="$HOME/.local/bin"
for b in yosys-baseline yosys-pmux; do
  cp "$BIN/$b" "$LOCALBIN/$b"
  chmod +x "$LOCALBIN/$b"
done
echo "已放到 $LOCALBIN/（与已安装 yosys 同级，可正确解析 share 目录）"
echo "（回退：删除 $LOCALBIN/yosys-baseline 与 $LOCALBIN/yosys-pmux 即可）"
echo

for b in yosys-baseline yosys-pmux; do
  echo "=== $b ==="
  "$LOCALBIN/$b" -p "
read_verilog benchmarks/official/test2.v
hierarchy -top test2
synth_intel -family cycloneiv -top test2
tee -o runs/binaries/${b}_test2.json stat -json
" > "runs/binaries/${b}_test2.log" 2>&1
  echo "  rc=$?"
  printf '  日志中 "pmux_opt" 出现次数: %s\n' "$(grep -c 'pmux_opt' runs/binaries/${b}_test2.log || true)"
  grep -m2 "pmux_opt:" runs/binaries/${b}_test2.log | sed 's/^/    /'
  python3 -c "
import json
try:
    d=json.load(open('runs/binaries/${b}_test2.json')); nbt=d['design']['num_cells_by_type']
    seq=sum(v for k,v in nbt.items() if any(x in k.lower() for x in ('dff','latch','dffeas')))
    print(f'  总单元={d[\"design\"][\"num_cells\"]}  DFF={seq}  逻辑单元={d[\"design\"][\"num_cells\"]-seq}')
except Exception as e:
    print('  读取 stat 失败:', e)"
  echo
done

echo "=== 差异总结 ==="
echo "  预期：baseline 无 pmux_opt 调用、test2 逻辑单元=25；pmux 有调用、逻辑单元=15"
