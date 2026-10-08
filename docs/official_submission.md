# 官方 4 个 case 逐用例提交报告

生成时间：2026-10-08 00:03 UTC　重复测量：每项 7 次取中位数

## 〇、合规性声明（依据最新 Q&A 2026.9.24–9.28）

| 约束 | 官方原文 | 本方案 |
|---|---|---|
| 映射器 | C53 问题1：「**请都用 yosys 自带的 abc9 运行，这个需要统一**」 | ✅ 只用 `abc9`，**未更换映射器**；仅调整 abc9 自身的脚本（属 9.20「可以调整 abc 的脚本」范围） |
| 集成方式 | C53 问题2：「把新加的优化pass放到 synth_intel.cc 里编译到 exe 中，脚本相同，yosys.exe 不同」 | ✅ 已写入 `synth_intel.cc` |
| 面积指标 | C53 问题3：「**主要看 lut 逻辑单元**，原则上其他单元不能增加（如 dff, io）」 | ✅ 只统计 LUT 逻辑单元；DFF 不变 |
| CPU 计时 | C54 问题1：「**编译耗时并不作为评分选项**」 | 故本报告效率列仅供参考，不构成扣分 |
| 内存口径 | C54-2：「峰值工作内存，**只看 yosys.exe**」 | ✅ 用 `scripts/measure_yosys_self.py` 轮询 `/proc/<pid>/status` 的 `VmHWM`，**不含 abc 子进程**，即官方口径 |
| 等效性验证 | C54 问题3：映射用 `-family cycloneiv`；eqy 验证 **abc 之后的 `$lut` 单元**（abc 之后输出 ilang） | ✅ 等价性验证在 abc 之后的网表上进行 |

> **历史说明**：本报告早先用「把 `abc9` 换成经典 `abc`」得到 20.26%，该做法违反 C53 问题1，**已作废**。
> 现结果为**纯 abc9 约束**下的成绩。

> 纯 abc9 约束下已穷尽的杠杆与结果见 [`abc9_constraint_findings.md`](abc9_constraint_findings.md)。

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
| test1 | 288 | **287** | **0.3%** | 222→222 | +520.9% | +8.5% | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test2 | 25 | **15** | **40.0%** | 0→0 | +37.9% | +10.9% | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test3 | 13 | **9** | **30.8%** | 17→17 | -3.4% | +10.5% | PASS（有界 -seq 12 + 无界归纳；自检 PASS / 负对照 FAIL） |
| test4 | 36 | **29** | **19.4%** | 10→10 | +295.6% | +10.5% | PASS（有界 -seq 5 + 无界归纳；自检 PASS / 负对照 FAIL） |
| **逐用例平均（官方口径）** | 362 | **340** | **22.64%** | — | — | — | — |

### 面积判定

- ✅ **逐用例平均 22.64% ≥ 20%** —— 达到评分表「20% 以上该项满分」
- DFF 约束：✅ 全部用例均未增加

### 效率判定（官方口径：每个用例都要 ≤5%）

- 最大 CPU 开销：**+520.9%**
- 最大内存开销：**+10.9%**
- >>> **⚠️ 内存开销超过 5% 满分线（细则：超限 15% 以上本项不得分，当前未触及该线）**

> 说明：**CPU 时间已按答疑 C54-1「编译耗时并不作为评分选项」移出评分**，仅备查。
> 内存按 **C54-2「峰值工作内存，只看 yosys.exe」** 统计（`scripts/measure_yosys_self.py` 轮询 `/proc/<pid>/status` 的 VmHWM，不含 abc 子进程）。
> 赛题绝对阈值为峰值 ≤2GB，本机实测为数十 MB，距阈值极远。

## 三、等价性

使用**两套独立方法**互为交叉印证：

1. **官方口径 EQY**（答疑 C54-3：abc 之后输出 ilang 交给 eqy 验证 `$lut` 单元）
   —— 脚本 `scripts/eqy_on_ilang.sh`。结果：**test1 / test2 通过**；
   test3 因分区抽象、test4 因分区含 memory 而未通过，**但同样的失败也发生在官方基线上**，
   属工具限制而非优化引入的问题。
2. **设计模式 miter + sat**（答疑 C53-5 明确「切换设计模式验证是允许的，算作通过」）
   —— 脚本 `scripts/wsl_equiv_unbounded.sh`，含 `proc` / `async2sync` / **显式 `flatten miter`**。
   结果：**4/4 全部通过**，且每个用例都先通过①自检（同网表比自身须 PASS）
   与②负对照（人为引入可观测差异须 FAIL）双重校验。

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
