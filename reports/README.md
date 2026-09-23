# 本目录全部是生成物，不入版本库
#
# 生成方式：
#   python3 scripts/run_case.py --case ... --pipeline ...   → runs/<run_id>/result.json
#   python3 scripts/report.py  --runs runs --out reports     → reports/summary.md|csv
#   python3 scripts/exp_summary.py --runs runs --out reports/exp_insertion_point.md
#   bash    scripts/wsl_stage2.sh                            → 上面两者的组合
#
# 需要证据时看 runs/<run_id>/（含 result.json、synth.ys、yosys.log、stat.json），
# 或重跑上面的命令再生成。docs/ 下的报告里记录了证据索引。
