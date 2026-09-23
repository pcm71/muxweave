#!/usr/bin/env bash
# 第 1 周的形式验证关卡：错误例必须 FAIL，正确例必须 PASS。
#
#   bash formal/mini/run_formal_mini.sh
#
# 设计意图：先证伪、再证真。一个"永远显示绿色"的验证流程等于没有验证，
# 所以本脚本在错误例被判 PASS 时会以非零状态退出。
#
# 已实测的两个 EQY 行为（踩过坑，故在此固化）：
#   1) EQY 把输出目录建在**当前工作目录**，名字取自 .eqy 文件名（如 ./equiv_ok）；
#   2) 该目录已存在时 EQY 直接报 `ERROR: Directory 'equiv_ok' already exists` 并以非零码退出
#      —— 也就是说**同样的命令跑第二次会失败**。
#   因此本脚本每次运行前先清理同名目录，跑完再把产物归档到 runs/eqy_<名称>_<时间戳>/。
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
LOGDIR="formal/mini/logs"
ARCHIVE="runs"
mkdir -p "$LOGDIR" "$ARCHIVE"

if ! command -v eqy >/dev/null 2>&1; then
  echo "找不到 eqy。请先运行 scripts/build_eqy.sh"; exit 1
fi
echo "Yosys: $(yosys -V)"
echo "EQY  : $(command -v eqy)"
echo

run_one() { # $1 = eqy 文件, $2 = 期望 PASS|FAIL
  local cfg="$1" expect="$2" name log rc verdict stamp outdir
  name="$(basename "$cfg" .eqy)"
  log="$LOGDIR/${name}.log"
  stamp="$(date +%Y%m%dT%H%M%SZ)"

  echo "== 运行 $cfg（期望 $expect） =="
  # 清理上次遗留的同名输出目录（EQY 拒绝覆盖已存在目录）
  if [ -e "$name" ]; then
    rm -rf "$name" && echo "   已清理上次遗留的 ./$name"
  fi

  eqy "$cfg" >"$log" 2>&1
  rc=$?

  grep -E "DONE \(|Successfully proved|Failed to prove|ERROR" "$log" | tail -3 | sed 's/^/   /'
  if [ "$rc" -eq 0 ]; then verdict="PASS"; else verdict="FAIL"; fi
  echo "   退出码=$rc  判定=$verdict  日志=$log"

  # 归档本次产物（保留 evidence，不污染仓库根目录）
  if [ -d "$name" ]; then
    outdir="$ARCHIVE/eqy_${name}_${stamp}"
    mv "$name" "$outdir" && echo "   产物已归档到 $outdir"
  fi

  if [ "$verdict" != "$expect" ]; then
    echo "   ✗ 与期望不符（期望 $expect，实际 $verdict）"
    return 1
  fi
  echo "   ✓ 符合期望"
  return 0
}

fails=0
run_one formal/mini/equiv_bad.eqy FAIL || fails=$((fails+1))
run_one formal/mini/equiv_ok.eqy  PASS || fails=$((fails+1))

echo
if [ "$fails" -gt 0 ]; then
  echo "结果：$fails 项不符合期望 —— 第 1 周验证关卡未通过。"
  echo "排查顺序：① eqy 版本是否与 yosys 匹配，以及 eqy 是否已 make install（入口才存在）；"
  echo "          ② 日志里是 FAIL 还是 ERROR/TIMEOUT（ERROR 多为环境问题，不是设计问题）；"
  echo "          ③ 错误例若被判 PASS，说明验证配置有严重问题，必须立即定位。"
  exit 1
fi

cat <<'EOF'
结果：形式验证最小闭环通过。
  - 错误候选被检出（说明验证流程有效）
  - 正确候选通过（说明验证流程不过度严格）
证据：formal/mini/logs/（日志）+ runs/eqy_equiv_*/（EQY 完整产物目录）
EOF
