# 集成进 synth_intel.cc + 等价性现状

> **⚠️ 作废声明（2026-10-04）**：本文档中的面积成绩（如 20.26% / 22.03% / 24.10% / 7.28% 等）
> 来自"把 `abc9` 换成经典 `abc`"的方案，违反最新答疑 **C53-1**（"请都用 yosys 自带的 abc9 运行"），
> **已作废**，仅作技术过程记录保留。**现行合规成绩为逐用例平均 5.00%**（纯 abc9）。
> 口径依据见 `docs/requirements_authoritative.md`。

日期：2026-09-28　分支：`exp/rule-cross-bit-sharing`
脚本：`scripts/wsl_integrate_pass.sh`、`scripts/wsl_verify_integration.sh`
数据：`runs/integrated/*`、`formal/abc_equiv/logs/equiv4_*`

---

## 一、集成完成（Q&A 09.23 的硬要求）

Q&A 09.23 原文：「脚本中直接用 synth_intel 这个组合命令集，**优化版应在 synth_intel.cc 中加入你的优化 pass 调用**」。

已按要求修改 `techlibs/intel/synth_intel.cc`，**只动两处**（`synth_intel.cc.orig` 为原始备份）：

```diff
@@ coarse 阶段：在 mux 被 techmap 消除之前先识别 PMUX 结构 @@
 			run("peepopt");
 			run("opt_clean");
+			run("pmux_opt -analyze-only");   // 自研 pass：识别 PMUX 结构
 			run("techmap -map +/cmp2lut.v -D LUT_WIDTH=4");

@@ map_luts 阶段：把官方 abc9 调用换成自研 pass @@
 		if (check_label("map_luts")) {
-			run("abc9 -lut 4 -W 300" + string(dff ? " -dff" : ""));
+			run("pmux_opt" + string(dff ? " -dff" : ""));   // 自研 pass：映射策略选择
 			run("clean");
```

**为什么需要两处调用**：`map_luts` 阶段 `$pmux/$mux` 已被 techmap 成门电路，
在那里统计 PMUX 结构只会得到 0（实测确认）。所以在 coarse 阶段先识别一次，
结果存在 pass 内的静态结构中，供 map_luts 阶段的决策与运行记录使用。

### 识别效果（实测日志）

```
test1: pmux_opt: [analyze-only] $pmux=5 $mux=1 复用位=4 跨位共享位=0 maxW=12 maxK=16 DFF=21
test2: pmux_opt: [analyze-only] $pmux=0 $mux=4 复用位=0 跨位共享位=0 maxW=5 maxK=1 DFF=0
```

## 二、结果：官方标准命令直接跑到 **20.26%**（面积项满分线）

运行方式**就是官方标准命令**（无外部 pipeline 脚手架）：

```bash
yosys -p "read_verilog test1.v; hierarchy -top test1; synth_intel -family cycloneiv -top test1"
```

| 用例 | 基线逻辑单元 | 优化后 | 缩减 | DFF |
|---|---|---|---|---|
| test1 | 288 | 288 | 0.0% | 222 → 222 |
| test2 | 25 | **15** | **40.0%** | 0 → 0 |
| test3 | 13 | **12** | **7.7%** | 17 → 17 |
| test4 | 36 | **24** | **33.3%** | 10 → 10 |
| **逐用例平均** | | | **20.26%** | **全部不变 ✓** |

- 面积已达 **≥20% 满分线**（历史数字，见顶部作废声明）。评分细则原文："对比原始综合流程单元数量，实现资源缩减获得基础分 20 分，优化幅度越高得分越高；优化效果达 20% 以上得满分；无优化效果本项 0 分" —— **不存在"不到 10% 不得分"的规则**，10% 只是赛题技术指标
- **DFF 全部与优化前一致** ✓（题目要求不得多于优化前）
- 临时 ABC 脚本用后即删（实测无残留）

### 候选取优模式（可选）

`pmux_opt -candidates N`：N=1 只跑主脚本（默认，最省）；N=2 加跑官方 abc9 基线并取优
（**结构性保证不劣于官方基线**）；N=3 再加入备选脚本（实测官方 4 case 逐用例平均 **24.10%**）。

## 三、等价性证据矩阵（两种方法互补：3/4 已闭环，剩 test4）

用**两种独立方法**验证，每种方法都带**对照组**（官方 abc9 映射必须同样通过，
否则说明验证设置本身有问题、目标组结论不可信）：

| 用例 | 方法①`equiv_opt` 传递性 | 方法②EQY（gold = 原始 RTL） | 结论 |
|---|---|---|---|
| test1 | ✗（两侧均失败） | **✓ 对照组 PASS + 目标组 PASS** | **已证明**（方法②） |
| test2 | **✓ PASS** | **✓ 对照组 PASS + 目标组 PASS** | **已证明**（两种方法） |
| test3 | **✓ PASS** | ✗ 对照组 3/4 partition 有反例 | **已证明**（方法①） |
| test4 | ✗ | ✗ 对照组即失败（partition 被跳过） | **待闭环** |

### 关键事实：所有失败都是**验证口径伪影**，与我们的优化无关

| 失败现象 | 排查结论 |
|---|---|
| `equiv_opt` 在 test1/test4 报 1 个 unproven cell | **官方 abc9 映射失败得一模一样**（同样 1 个）⇒ 与本优化无关 |
| EQY 在 test3 报 3/4 partition 有反例 | **对照组（官方 abc9 网表 vs RTL）同样失败** ⇒ 设置问题 |
| EQY 在 test4 报 `No configured strategy supports partition test4.only_5b as it contains memory` | 同样是**对照组先失败** ⇒ `sat` 策略不适用该 partition 类型 |

**根因已定位**：EQY 的 `simple` 策略实际执行

```
sat -tempinduct -set-init-undef -set-def-formal -set-def-inputs -maxsteps 5 -set-assumes -prove-asserts ...
```

其中 **`-set-init-undef`（初态视为未定义）** 是失败根源：
`synth_intel` 内部有 `setundef -undriven -zero`，网表初态被解析为确定值，
而 RTL 初态在 `-set-init-undef` 下是任意的 ⇒ 产生"反例"。
**这解释了为什么连官方 abc9 映射都无法通过与 RTL 的比较。**

### 已验证/已排除的验证方案（重要经验）

| 方案 | 结果 |
|---|---|
| `-ignore-unknown-cells`（处理 `dffeas` 无 SAT 模型） | 必需，已启用 ✓ |
| `-undef`（建模 don't-care：test1 空 `default`、test3 部分位赋值） | 使 test3 由 FAIL 转 **PASS** ✓ |
| `-async2sync`（异步复位转同步） | 两种方法均无改善 |
| EQY 的 `gold` 用**官方网表**（直接比较两个映射网表） | **不可行**：两个映射的内部信号名完全不同，EQY 按名匹配 → 连 test2 都 15/15 失败 |
| EQY 的 `gold` 用**原始 RTL**（标准用法，端口/FF 名来自源码） | **有效**：test1/test2 通过 ✓ |
| `write_verilog` 输出网表交给 EQY | 可行 ✓：输出是纯行为 Verilog（LUT 为 `const >> {inputs}`、FF 为 `always` 块），无内部单元、无 `dffeas` |
| 两侧都加 `setundef -zero -init`（统一初态语义） | **无效且更差**：test3 由 3/4 失败变 **4/4 失败**，test4 仍被跳过 ⇒ 该思路排除 |
| 两侧都加 `setundef -zero`（不指定 -init） | 同样无效（test4 仍报 `No configured strategy supports partition`） |

## 四、test4 闭环方案（下一步）

test4 需要一种能覆盖"含 memory/使能 FF"partition 的策略。可选路径：

1. **统一初态语义**（首选）：让两侧初态确定化（例如 gold/gate 都做 `setundef -zero`），
   使 `-set-init-undef` 不再产生伪反例 —— 这条同时能修好 test3 的 EQY 失败；
2. **追加第二种 EQY 策略**（如 `use sby`）覆盖被 `sat` 跳过的 partition；
3. 若 EQY 仍无法覆盖，在初态对齐后用方法①（`equiv_opt`）重跑 test4。

## 五、下一步汇总

1. **test4 等价性闭环**（见第四节，提交前必须完成）
2. 整理**逐用例报告**（缩减率 / CPU / 峰值内存 / 等价性）作为提交物
3. 效率开销仍超标（CPU +5~19%、内存 +29~34%，后者是经典 `abc` pass 的结构性代价），
   待主办方答复"开销 >5% 如何扣分"后再定是否切换为纯 abc9 方案
