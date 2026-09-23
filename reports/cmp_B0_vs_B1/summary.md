# 实验汇总（自动生成，请勿手改）

- 基线：`B0`　候选：`B1`
- 用例数：8（含候选对照 8）
- **平均缩减率（官方口径，逐用例平均）**：0.00%
- 中位数 / 最差 / 最好：0.00% / 0.00% / 0.00%
- 加权缩减率（**仅参考**，不得与上面混列）：0.00%
- DFF 违规用例数（优化后 DFF 多于优化前）：0
- 验证非 PASS / 非未运行的用例数：0

## 逐用例

| 用例 | $pmux | $mux | W | K | 复用位/跨位共享 | 基线逻辑单元 | 候选逻辑单元 | 缩减率 | DFF(基/候) | 验证 | 运行目录 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| benchmarks/mixed/m01_decode_mask_pmux.v | 1 | 0 | 16 | 4 | 0/0 | 44 | 44 | 0.00% | 0/0 | NOT_RUN | `runs/m01_decode_mask_pmux__B0__20260923T143324Z/result.json` |
| benchmarks/mixed/m02_regfile_readback.v | 1 | 14 | 32 | 4 | 0/0 | 120 | 120 | 0.00% | 64/64 | NOT_RUN | `runs/m02_regfile_readback__B0__20260923T143325Z/result.json` |
| benchmarks/mixed/m03_registered_pmux.v | 1 | 6 | 8 | 4 | 8/8 | 35 | 35 | 0.00% | 30/30 | NOT_RUN | `runs/m03_registered_pmux__B0__20260923T143326Z/result.json` |
| benchmarks/unit/u01_mux2_wide.v | 1 | 0 | 8 | 2 | 0/0 | 8 | 8 | 0.00% | 0/0 | NOT_RUN | `runs/u01_mux2_wide__B0__20260923T143327Z/result.json` |
| benchmarks/unit/u02_pmux4_shared_fields.v | 1 | 0 | 8 | 4 | 8/8 | 12 | 12 | 0.00% | 0/0 | NOT_RUN | `runs/u02_pmux4_shared_fields__B0__20260923T143327Z/result.json` |
| benchmarks/unit/u03_pmux4_const_and_default.v | 1 | 0 | 16 | 4 | 4/4 | 31 | 31 | 0.00% | 0/0 | NOT_RUN | `runs/u03_pmux4_const_and_default__B0__20260923T143328Z/result.json` |
| benchmarks/unit/u04_pmux8_narrow_onehot.v | 1 | 0 | 1 | 8 | 0/0 | 14 | 14 | 0.00% | 0/0 | NOT_RUN | `runs/u04_pmux8_narrow_onehot__B0__20260923T143329Z/result.json` |
| benchmarks/unit/u05_negative_no_mux.v | 0 | 0 | 0 | 0 | 0/0 | 20 | 20 | 0.00% | 0/0 | NOT_RUN | `runs/u05_negative_no_mux__B0__20260923T143330Z/result.json` |

## 口径提醒

- 平均(r_i) 与 (ΣN_base−ΣN_opt)/ΣN_base **不等价**；评分用前者，后者仅供对照。
- 「复用位」= 至少两个分支取同一数据源的位（真正的机会来源）；「跨位共享」= 这种含复用的模式被多个位共用。两者都为 0 表示该 cell 没有可优化空间。
- 一个 32 位 `$and` 与一个 1 位门都记 1 个 cell，raw cell 数不能直接说明面积，需看分类型明细。
- 时间按 CPU 时间、内存按整进程峰值；本表 CPU/内存列来自基线运行。
- 非 PASS 的用例不得计入成绩，即使缩减率好看。
