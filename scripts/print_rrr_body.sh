#!/usr/bin/env bash
# print_rrr_body.sh —— 打印 Abc_CommandAbc9Rrr 函数体（看它接受什么参数、默认做什么）
set -uo pipefail
ABC=~/src/yosys/abc/src/base/abci/abc.c
F=49083
sed -n "${F},$((F+70))p" "$ABC" | sed 's/^/  /'
