#!/usr/bin/env bash
# gen_abc9_variants.sh —— 生成"纯 abc9"约束下的脚本变体（全部只调 abc9 的脚本，不换映射器）
#
# 依据最新 Q&A（C53 问题1）："请都用 yosys 自带的 abc9 运行，这个需要统一"
#   ⇒ 只能在 abc9 内部调脚本（这是 9.20 "可以调整 abc 的脚本" 的范围）
#
# abc9 默认脚本（`help abc9`）：
#   &scorr; &sweep; &dc2; &dch -f -r; &ps; &if {W} {D} {R} -v; &mfs
# 其中 {W} → `-W 300`；末尾 `&mfs` 在本版本**每次都报错失效**（已实测），故基变体直接省掉它。
set -uo pipefail
D="$(cd "$(dirname "$0")/.." && pwd)/configs/abc_scripts"
mkdir -p "$D"
cd "$D" || exit 1

# 公共前缀：官方流程的前五步
PREFIX='&scorr
&sweep
&dc2
&dch -f -r
&ps'

emit() { # $1=文件名 $2=可选的前置额外命令 $3=&if 参数行 $4=可选的后置命令
  {
    echo "$PREFIX"
    [ -n "${2:-}" ] && echo "$2"
    echo "$3"
    [ -n "${4:-}" ] && echo "$4"
  } > "$1"
  printf '  %-22s : %s\n' "$1" "$(tr '\n' ' ' < "$1")"
}

echo "=== 生成 abc9 脚本变体 ==="
emit a9_base.abc      "" "&if -W 300 -v"            ""            # 官方脚本去掉失效的 &mfs
emit a9_a.abc         "" "&if -W 300 -a -v"         ""            # 面积优先
emit a9_a_A8.abc      "" "&if -W 300 -a -A 8 -v"    ""            # 面积恢复迭代 ×8
emit a9_a_A30.abc     "" "&if -W 300 -a -A 30 -v"   ""            # 面积恢复迭代 ×30
emit a9_a_C32.abc     "" "&if -W 300 -a -C 32 -v"   ""            # 更多优先割
emit a9_a_m.abc       "" "&if -W 300 -a -m -v"      ""            # 割集最小化
emit a9_a_F5.abc      "" "&if -W 300 -a -F 5 -v"    ""            # 面积流恢复 ×5
emit a9_a_dc2.abc     "" "&if -W 300 -a -v"         "&dc2"        # 映射后再做 dc 化简
emit a9_a_resub.abc   "" "&if -W 300 -a -v"         "&resub"      # 映射后重代入
emit a9_a_twice.abc   "" "&if -W 300 -a -v"         "&if -W 300 -a -v"
emit a9_fraig_a.abc   "&fraig -x" "&if -W 300 -a -v" ""
emit a9_nf_a.abc      "" "&if -W 300 -a -v"         "&nf"
echo
echo "共生成 $(ls a9_*.abc 2>/dev/null | wc -l) 个变体到 $D"
