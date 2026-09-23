# 第 2 周：插入点实验结果与结论

日期：2026-09-23　分支：`exp/insertion-point`　基线 tag：`week1-baseline`
数据来源：`runs/exp_*.log`、`runs/*/result.json`　对比报告：`reports/exp_insertion_point.md`

---

## 一、实验设计

主办方 2026.09.20 答复："在 synth_intel 组合命令集中调试来确定 pass 执行位置，结果最优即可"，
因此把「插入点」当成显式实验变量，在 **8 个用例 × 4 种 pipeline** 上做全交叉（共 32 次运行，全部成功）。

| pipeline | 序列 |
|---|---|
| `B0` | `proc` → `synth_intel -family cycloneiv` |
| `B1` | `proc` → `opt` → `opt_reduce -fine` / `opt_merge` / `opt_muxtree` / `opt_share` → `synth_intel` |
| `O_INSERT_A` | `proc` → **`pmux_opt`** → `opt_clean` → `synth_intel` |
| `O_INSERT_B` | `proc` → `opt` → **`pmux_opt`** → `opt` → `synth_intel` |

用例：`benchmarks/unit/` 5 个 + `benchmarks/mixed/` 3 个（本周新增，含时序与存储器用例）。

## 二、结果：四种 pipeline 的单元数**完全相同**

| 用例 | B0 | B1 | O_INSERT_A | O_INSERT_B | 最大差异 |
|---|---|---|---|---|---|
| m01_decode_mask_pmux | 44 | 44 | 44 | 44 | 0 |
| m02_regfile_readback | 120 | 120 | 120 | 120 | 0 |
| m03_registered_pmux | 35 | 35 | 35 | 35 | 0 |
| u01_mux2_wide | 8 | 8 | 8 | 8 | 0 |
| u02_pmux4_shared_fields | 12 | 12 | 12 | 12 | 0 |
| u03_pmux4_const_and_default | 31 | 31 | 31 | 31 | 0 |
| u04_pmux8_narrow_onehot | 14 | 14 | 14 | 14 | 0 |
| u05_negative_no_mux | 20 | 20 | 20 | 20 | 0 |
| **合计** | **284** | **284** | **284** | **284** | **0** |

汇总：平均相对基线缩减率均为 0.00%，CPU 时间 0.20~0.21 s，峰值内存 28.9~30.0 MB，失败 0，DFF 超标 0。

## 三、结论一：**加强基线 B1 与官方基线 B0 等价 —— 现有能力比预期强得多**

原因已从源码查实（证据：`runs/synth_intel_flow.txt`，取自 `techlibs/intel/synth_intel.cc`）。
`synth_intel` 内部**自己就完整跑了这些优化**：

```
proc → flatten → tribuf → deminout → opt_expr → opt_clean → check
→ opt -nodffe -nosdff → fsm → opt → wreduce → peepopt → opt_clean
→ techmap(cmp2lut, LUT_WIDTH=4) → opt_expr → opt_clean
→ [DSP/alumacc] → opt → memory -nomap → opt_clean
→ [memory_bram] → opt -fast -mux_undef -undriven -fine -full     ← 关键
→ memory_map → opt -undriven -fine → techmap → opt -full
→ clean -purge → setundef → dfflegalize → techmap(ff_map)
→ abc9 -lut 4 -W 300 → clean → opt -fast → autoname → clean
```

也就是说，我们在外面叠加的 `opt` / `opt_reduce -fine` / `opt_merge` / `opt_muxtree` / `opt_share`
**全部被 `opt … -fine -full` 与 `abc9 -lut 4` 提前覆盖**，没有任何增量。

**对项目的直接影响（重要）**

1. 第 2 周「去留判断」的对照基线**比方案原先设想的更强**：不是"比默认 synth 好一点"就行，
   而是要**在 `opt -fine -full` + `abc9 -lut 4` 之后仍有增量**。
2. 方案第 7 节提到的 `opt_reduce -fine`、`opt_merge`、`opt_muxtree`、`opt_share`
   **已经被官方流程完全包含**，因此"发现重复就合并"这类规则不可能带来增益。
   必须靠**更高层、更结构化的变换**（跨位分组 + 共享选择子表达式），在 ABC 做 LUT 映射**之前**
   改变电路的分解方式 —— 这是唯一可能产生增量的位置。
3. `abc9 -lut 4 -W 300` 证实目标器件是 **4 输入 LUT**（与 `-family cycloneiv` 一致），
   我们后续的收益评估必须落到这个映射终点上。

## 四、结论二：**插入点必须在 `synth_intel` 之前，A 与 B 无差别**

- `synth_intel` 内部第一步就是 `proc`，紧接着 `opt_expr` / `opt_clean` / `opt -nodffe -nosdff`，
  **mux 树很快被破坏**；流程末尾又整体映射为 `cycloneiv_lcell_comb`（4 输入 LUT），
  此时已不存在 `$pmux`。所以**放在 synth_intel 之后无意义**。
- `O_INSERT_A`（紧随 `proc`）与 `O_INSERT_B`（先 `opt` 再插入）结果完全一致，
  说明当前阶段的 `opt` 对结果没有影响；但按方案第 6 节"不要过早破坏 mux 树"的原则，
  **应选 A：`proc` → `pmux_opt` → `synth_intel`**，让自研规则在看到完整 `$pmux` 结构时介入。
- 选定后固化到 `configs/pipelines.json`（当前默认 pipeline 保持 `B0` 作为对照，作品路线用 `O_INSERT_A`）。

## 五、结论三：自研 pass 未扰动网表（只读设计验证通过）

`O_INSERT_A/B` 与含相同前后 pass 的基线**逐用例完全一致**。
这同时验证了第 1 周骨架版 `pmux_opt` 的行为符合设计：**只统计机会、不改网表、显式回退**
（`fallback=true`）。若将来出现差异，即为必须立刻定位的缺陷。

## 六、新增用例的基线数据（B0）

| 用例 | $pmux | W | K | 复用位/跨位共享 | 逻辑单元 | DFF | 说明 |
|---|---|---|---|---|---|---|---|
| m01_decode_mask_pmux | 1 | 16 | 4 | **0/0** | 44 | 0 | 周边译码/掩码/移位把位级重复消化掉了 → 无机会 |
| m02_regfile_readback | 1 | 32 | 4 | **0/0** | 120 | 64 | 存储器映射后的读回选择；$pmux 位宽 32 超出预期，值得复查 |
| m03_registered_pmux | 1 | 8 | 4 | **8/8** | 35 | 30 | 时序版 u02，复用结构与 u02 一致 ✅ |
| u01…u05 | — | — | — | 同周 1 | 8/12/31/14/20 | 0 | 与第 1 周一致（可复现性验证） |

**观察**：m01 与 m02 都是"混合/应用"类电路，位级重复为 0 —— 这印证了方案的判断：
**混合逻辑与后端推断会吃掉一部分位级冗余**，真正有收益的场景是 u02 / m03 这类
"多分支、字段重复"的纯选择结构。第 3 周扩大样本时应按此分布配比，不要指望混合电路普遍有收益。

## 七、下一步（第 2 周剩余 + 第 3 周）

1. **主规则原型**（第 2 周核心）：在 `O_INSERT_A` 位置实现「跨位分组 + 共享选择子表达式」，
   目标用例是 u02 / m03（复用位 8/8，已确认有结构机会）。判据：
   - 相对 **B0** 有缩减（这是题目指标）
   - 相对 **B1** 也有缩减（这是"独立于已有能力"的证明 —— 由于 B1≡B0，两者其实同一门槛）
   - DFF 不增加、EQY 全 PASS
2. **扩大样本到 20~30 个**，按第 6 节的分布配比：模式样本（有复用）为主，混合/负对照为辅。
3. **补时序用例的 DFF 核对**：m02/m03 已有 DFF，规则实现后必须逐用例核对 `dff_opt <= dff_base`。
4. 若 2 周内规则在 B1 之上仍无增量 → 按方案第 19 节执行退路：
   将该规则降为分析/预处理功能，转向位片分区或跨 PMUX 共享路线。
