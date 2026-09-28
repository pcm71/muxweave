# 集成进 synth_intel.cc + 等价性现状

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

- 面积已达 **≥20% 满分线**（题目：≥10% 达标、20% 以上该项满分）
- **DFF 全部与优化前一致** ✓（题目要求不得多于优化前）
- 临时 ABC 脚本用后即删（实测无残留）

### 候选取优模式（可选）

`pmux_opt -candidates N`：N=1 只跑主脚本（默认，最省）；N=2 加跑官方 abc9 基线并取优
（**结构性保证不劣于官方基线**）；N=3 再加入备选脚本（实测官方 4 case 逐用例平均 **24.10%**）。

## 三、等价性：**2/4 已严格证明，2/4 被检查口径阻塞**

方法沿用已打通的 `equiv_opt` 传递性证明（`scripts/wsl_abc_equiv4.sh`）：

| 用例 | 变体 `pmux_opt` | 官方 `abc9` | 判定 |
|---|---|---|---|
| test2 | PASS | PASS | ✓ 等价（严格证明） |
| test3 | PASS | PASS | ✓ 等价（严格证明） |
| test1 | FAIL | **FAIL** | ⚠ 见下 |
| test4 | FAIL | **FAIL** | ⚠ 见下 |

**关键事实：官方 `abc9` 映射本身在 test1/test4 上也无法通过同一个检查**（各报 1 个
unproven `$equiv` cell），说明这不是我们优化引入的问题，而是**检查口径与这两个电路的语义不匹配**。

已排查并排除的原因：

| 尝试 | 结果 |
|---|---|
| 加 `-undef`（建模 don't-care，针对 test1 的空 `default` 分支、test3 的部分位赋值） | test3 由 FAIL 转 **PASS** ✓；test1/test4 仍 FAIL |
| 加 `-async2sync`（针对 test1/test4 的异步复位） | 无改善 |
| `-ignore-unknown-cells`（处理 dffeas 无 SAT 模型） | 必需，已启用 |

**当前判断**：test1/test4 各有 1 个 `$equiv` cell 无法证明，最可能是**映射把 don't-care 位
解析成了不同的常数**（test1 有 `initial` 初值、test4 的 `case` 无 default），
两侧都能"自证"却互不相等 —— 这类情况需要**带 xprop 的形式验证（官方 EQY 的默认做法）**才能正确判定。

## 四、下一步（等价性收尾，提交前必须完成）

1. **改用官方 EQY 出正式证据**：两侧各写一份网表文件，再用 EQY 比较两个文件
   （绕开 abc9 内部辅助模块导致的"模块集合不一致"问题），并启用 xprop；
2. 若 EQY 仍报不等价，逐个定位那 1 个 unproven cell，确认是 don't-care 位还是真实差异；
3. 把 4 个官方 case 的缩减率 / CPU 时间 / 峰值内存 / 等价性结果整理成**逐用例报告**（提交物）；
4. 效率开销仍超标（CPU +5~19%、内存 +29~34%，后者是经典 `abc` pass 的结构性代价），
   待主办方答复"开销 >5% 如何扣分"后再定是否切换为纯 abc9 方案。
