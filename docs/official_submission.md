# 官方 4 个 case 逐用例提交报告

生成时间：2026-10-03 16:18 UTC　重复测量：每项 7 次取中位数

## 一、口径与基线

| 项 | 依据 |
|---|---|
| 面积 | `(优化前逻辑单元数 − 优化后) / 优化前逻辑单元数`，**按每个用例的平均算**，主看逻辑单元 |
| DFF | 不做硬性要求，但**不应多于优化前** |
| 效率 | 开销 = CPU 时间 + 整进程峰值内存，**每个用例都要满足**，CPU 时间含 abc |
| 基线 | 「加优化算法编译的程序」vs「原始代码编译的程序」在**同一环境**比较 ⇒ 两个真实二进制 |

两个二进制（同一源码树，唯一差别是 `techlibs/intel/synth_intel.cc` 是否调用 `pmux_opt`）：

```text
runs/binaries/yosys-baseline   原始代码编译（synth_intel 直接调用 abc9 -lut 4 -W 300）
runs/binaries/yosys-pmux       优化版编译（synth_intel 调用自研 pass pmux_opt）
```

## 二、逐用例结果

| 用例 | 逻辑单元(优化前) | 逻辑单元(优化后) | **缩减率** | DFF(前→后) | CPU 开销 | 内存开销 | 等价性 |
|---|---|---|---|---|---|---|---|
| test1 | 288 | **288** | **0.0%** | 222→222 | -9.1% | +17.7% | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test2 | 25 | **15** | **40.0%** | 0→0 | +26.6% | +37.1% | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test3 | 13 | **12** | **7.7%** | 17→17 | +24.9% | +30.6% | PASS（有界 -seq 12 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test4 | 36 | **24** | **33.3%** | 10→10 | +23.5% | +33.9% | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| **逐用例平均（官方口径）** | 362 | **339** | **20.26%** | — | — | — | — |

### 面积判定

- ✅ **逐用例平均 20.26% ≥ 20%** —— 达到评分表「20% 以上该项满分」
- DFF 约束：✅ 全部用例均未增加

### 效率判定（官方口径：每个用例都要 ≤5%）

- 最大 CPU 开销：**+26.6%**
- 最大内存开销：**+37.1%**
- >>> **❌ 存在超标用例（5% 门槛未满足）**

> 说明：经典 `abc` 映射器的内存开销是结构性的（脚本从 12 步砍到 7 步后 CPU 开销可降到约 +13%，
> 内存仍约 +30%）。若主办方确认效率项按超出比例重罚，则应改用纯 `abc9` 方案（面积约 5%）。

## 三、等价性

方法：`scripts/wsl_equiv_unbounded.sh`（miter + sat，含 `proc` / `async2sync` / 显式 `flatten miter`）。
完整矩阵与踩坑记录见 [`docs/equivalence_matrix.md`](../docs/equivalence_matrix.md)。

| 用例 | 结论 |
|---|---|
| test1 | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test2 | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test3 | PASS（有界 -seq 12 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test4 | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |

> 每个用例的检查器都先通过**自检**（同一网表比自身必须 PASS）与**负对照**
> （人为引入可观测差异必须 FAIL）双重校验，结论才有效。
> 该方法是**无界时序归纳**；EQY 在 test4 上因 partition 含 memory 而无法验证（且同样影响官方基线），
> 本方法不依赖 SBY，可覆盖该场景。

## 四、复现

```bash
bash scripts/wsl_build_baseline.sh      # 编译出原始/优化两个二进制
bash scripts/wsl_verify_binaries.sh     # 校验两者行为差异
python3 scripts/official_report.py 7    # 生成本报告
bash scripts/wsl_equiv_unbounded.sh <用例> <周期>   # 等价性（含自检+负对照）
```
