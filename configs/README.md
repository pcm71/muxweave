# configs —— 基线、加强基线与插入点实验

## 1. 三个对照（方案第 11 节）

| 编号 | 内容 | 作用 |
|---|---|---|
| **B0** | `proc` → `synth_intel -family cycloneiv` | 正式题目指标基线，**不能人为削弱** |
| **B1** | `proc` → `opt` → `opt_reduce -fine` / `opt_merge` / `opt_muxtree` / `opt_share` → `synth_intel` | 检查收益是否只来自已有能力 |
| **O** | B0 公共流程 + 自研 pass | 衡量作品对正式基线的增益 |
| **O+B1** | B1 + 自研 pass | 在较强流程上是否仍有增量 |

公平条件（每次实验都必须一致）：相同输入、顶层、参数、约束、目标器件族、后端选项、
**工具版本**、**计数阶段**。

## 2. 插入点实验（第 2 周的主任务）

主办方明确"不设固定 pass pipeline，在 synth_intel 组合命令集中调试确定，结果最优即可"，
所以插入点是**显式实验变量**：

| 候选 | 序列 | 假设 |
|---|---|---|
| `O_INSERT_A` | `proc` → `pmux_opt` → `opt_clean` → `synth_intel` | `$pmux` 结构完整，但周边逻辑未清理，别名/常量未归一 |
| `O_INSERT_B` | `proc` → `opt` → `pmux_opt` → `opt` → `synth_intel` | 控制与数据重复已暴露，但 mux 树可能已被部分化简 |

第 2 周对同一批样本跑 A/B，记录：逻辑单元数、DFF 数、**CPU 时间**、整进程峰值内存、
EQY 状态，选收益最好的一套固化，并把结果写入 `VERSION_LOCK.md` 的"构建参数"。

**禁止**逐用例临时调参：选定后 `configs/pipelines.json` 就是版本化配置，改动要留记录。

## 3. 计数口径（易错，务必遵守）

- 基线与候选在**同一 Cyclone IV 映射终点**统计，且 `stat` 的调用位置完全一致。
- 主指标：**逻辑单元数**（`cells_by_type` 扣除 DFF/存储器后的合计）。
- 单列 **DFF 数**：不得多于优化前（方案口径）。
- 一个 32 位 `$and` 与一个 1 位门都记 1 个 cell，所以**raw cell 数不能直接说明面积**，
  报告中必须给出分类型明细。
- 缩减率：`r_i = (N_base − N_opt) / N_base`，主成绩取 **逐用例算术平均**；
  加权口径 `(ΣN_base − ΣN_opt)/ΣN_base` 仅作参考并列展示。

## 4. 手工核对路径

```bash
# 1) 先核对 synth_intel 的参数
yosys -p "help synth_intel"

# 2) 手工跑 B0（把占位符替换掉）
yosys -s configs/b0_synth_intel_cycloneiv.ys

# 3) 看 CPU 时间与整进程峰值内存（人工与 run_case.py 交叉核对）
bash scripts/measure_cmd.sh yosys -s /tmp/b0_resolved.ys
```
