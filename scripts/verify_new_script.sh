#!/usr/bin/env bash
# verify_new_script.sh —— 验证新脚本映射的等价性（强制：含自检与负对照）
#
# 对象：脚本 `&dch -f -r; &if -a -v`（GIA 域，仍为 abc9）
#   gold = 官方流程（abc9 默认脚本）网表
#   gate = 新脚本网表
# 方法：miter -equiv -make_outputs -make_assert + **显式 flatten miter** + sat
#   （必须 proc + async2sync；判定区分 PASS/FAIL/ERROR）
# 前置校验：
#   ① 自检   ：gold vs gold           必须 PASS
#   ② 负对照 ：gold vs RTL 变异网表    必须 FAIL
set -uo pipefail
export PATH="$HOME/.local/bin:$PATH"
P=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
cd "$P" || exit 1
D=runs/verify_new
L=formal/verify_new
mkdir -p "$D" "$L"
NEW=configs/abc_scripts/tune/c0_base.abc

gen() { # $1=verilog $2=top $3=abc9参数 $4=输出
  # 在 map_ffs **之前**跑 abc9：此时触发器仍是通用类型（$adff/$dff），
  # sat 能直接建模；若等到 begin:map_luts 之后再取，FF 已变成 Intel 原语 dffeas，
  # sat 会报 "No SAT model available for cell ... (dffeas)"。
  yosys -q -p "
read_verilog $1
hierarchy -top $2
synth_intel -family cycloneiv -top $2 -run begin:map_ffs
abc9 -lut 4 $3
clean
opt -fast
write_verilog -noattr $4
" > "${4%.v}.log" 2>&1
}

eqcheck() { # $1=gold.v $2=gate.v $3=顶层模块名 $4=标签 $5=周期
  local log="$L/${4}.log"
  yosys -q -p "
read_verilog $1
hierarchy -top $3
proc
async2sync
opt -fast
design -stash g
design -reset
read_verilog $2
hierarchy -top $3
proc
async2sync
opt -fast
design -stash e
design -copy-from g -as gold $3
design -copy-from e -as gate $3
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter
hierarchy -top miter
sat -verify -prove-asserts -seq $5 -set-init-zero miter
" > "$log" 2>&1
  local rc=$?
  if [ $rc -eq 0 ]; then echo PASS
  elif grep -qE "model found: FAIL|proof did fail|SAT proof finished - no solution" "$log"; then echo FAIL
  else echo ERROR; fi
}

# 负对照用的 RTL 变异
mutate() {
  python3 - "$1" "$2" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
t = open(src, encoding="utf-8").read()
def mask(s):
    return "\n".join(l.split("//")[0] + " " * (len(l) - len(l.split("//")[0])) if "//" in l else l for l in s.split("\n"))
code = mask(t)
for pat in (r"(\d+)'b([01]{2,})", r"(\d+)'d(\d+)"):
    m = re.search(pat, code)
    if not m: continue
    if "'b" in m.group(0):
        b = m.group(2); nb = b[:-1] + ("1" if b[-1] == "0" else "0")
        t = t[:m.start(2)] + nb + t[m.end(2):]
        print(f"  负对照变异：{m.group(1)}'b{b} -> {m.group(1)}'b{nb}")
    else:
        v = int(m.group(2)) ^ 1
        t = t[:m.start(2)] + str(v) + t[m.end(2):]
        print(f"  负对照变异：{m.group(1)}'d{m.group(2)} -> {m.group(1)}'d{v}")
    break
else:
    ms = list(re.finditer(r"(\w+\s*=\s*)([A-Za-z_]\w*)(\s*;)", code))
    if len(ms) >= 2:
        t = t[:ms[1].start(2)] + ms[0].group(2) + t[ms[1].end(2):]
        print(f"  负对照变异（结构）：{ms[1].group(2)} -> {ms[0].group(2)}")
    else:
        raise SystemExit("无法构造负对照")
open(dst, "w", encoding="utf-8").write(t)
PY
}

echo "新脚本：$(tr '\n' ' ' < $NEW)"
echo
for case in test1 test2 test3 test4; do
  depth=5; [ "$case" = "test3" ] && depth=12
  gen benchmarks/official/$case.v $case "-W 300" "$D/${case}_gold.v"
  gen benchmarks/official/$case.v $case "-script $NEW" "$D/${case}_new.v"
  mutate benchmarks/official/$case.v "$D/${case}_mut.v" > /dev/null
  gen "$D/${case}_mut.v" $case "-W 300" "$D/${case}_neg.v"

  r1=$(eqcheck "$D/${case}_gold.v" "$D/${case}_gold.v" "$case" "${case}_self" $depth)
  r2=$(eqcheck "$D/${case}_gold.v" "$D/${case}_neg.v" "$case" "${case}_negctl" $depth)
  r3=$(eqcheck "$D/${case}_gold.v" "$D/${case}_new.v" "$case" "${case}_new" $depth)
  printf '  %-7s ①自检=%-7s ②负对照=%-7s ③新脚本 vs 官方=%s\n' "$case" "$r1" "$r2" "$r3"
done
echo
echo "判定：只有 ①=PASS 且 ②=FAIL 时，③ 的结论才有效"
