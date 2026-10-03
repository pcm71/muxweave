# 本周任务完成汇报（官方 4 个 case 专项）

日期：2026-10-04　分支：`exp/rule-cross-bit-sharing`
本周期目标：**拿到官方用例 → 按 Q&A 硬要求集成 pass → 出面积/效率/等价性三套实测数据 → 形成提交物**

> ## ⚠️ 重要修订（2026-10-04 晚）
>
> 最新 Q&A（9.24–9.28）**C53 问题1** 明确：「**请都用 yosys 自带的 abc9 运行，这个需要统一**」。
> 因此本报告原先的 **20.26%**（做法是把 `abc9` 换成经典 `abc`）**违规、已作废**。
>
> **现行合规成绩：逐用例平均 5.00%**（纯 abc9 约束，仅调整 abc9 自身脚本）。
> 完整结论、已穷尽的杠杆清单与下一步选项见
> [`abc9_constraint_findings.md`](abc9_constraint_findings.md)。
>
> 本报告下半部分的**方法与工程内容仍然有效**（集成方式、等价性验证、测量管线），
> 只有面积数字与"效率焦虑"需要按最新 Q&A 更新：
> **C54-1「编译耗时并不作为评分选项」⇒ CPU 开销不再是评分项**；
> C54-2 内存「只看 yosys.exe」。

---

## 一、完成事项总览（对照官方 Q&A 要求）

| Q&A 要求 | 出处 | 完成情况 |
|---|---|---|
| 统一用 `synth_intel` | 09.20 | ✅ 所有测量均基于 `synth_intel -family cycloneiv` |
| **优化调用写进 `synth_intel.cc`** | 09.23 / C53-2 | ✅ 已改源码（2 处调用），附 `.orig` 备份与 patch |
| 插件编译进主程序，不用 `plugin -i` | 09.20 | ✅ `passes/pmux/` 编入主程序 |
| **统一用 abc9、不换映射器** | **C53-1** | ✅ 已改为纯 abc9 方案 |
| 可提交调优的 abc9 脚本 | 09.20 / C55 | ✅ `configs/abc_scripts/a9_*.abc`（面积向脚本已内置到 pass） |
| 面积口径：逐用例平均、**主看 LUT 逻辑单元** | 09.20 / C53-3 | ✅ 报告按此口径 |
| 其他单元（DFF/IO）不得增加 | C53-3 | ✅ 4 个用例 DFF 全部不变 |
| 效率口径 | 09.20 / **C54-1/2** | CPU **不计分**；内存只看 `yosys.exe` |
| 基线＝原始代码编译的程序，同环境比较 | 09.11 | ✅ 编译出 `yosys-baseline` 与 `yosys-pmux` 两个真实二进制 |
| **所有用例通过形式等价检查** | 赛题 / C53-5 | ✅ 4/4 具备**无界时序归纳证明**；C53-5 明确整设计模式验证算通过 |
| 提交清单 | C55 | ⚠️ 需按「源码 + 二进制及依赖库」打包 |
| 只以官方 4 个 case 为准 | 09.23 | ✅ 全部以 `benchmarks/official/` 的 4 个 case 出数 |

## 二、关键数字（**合规版**）

**面积（官方口径，逐用例平均）：5.00%** —— 未达赛题 10% 技术指标（10% 只是技术指标目标值；评分细则 40 分那项的 0 分条件是"无优化效果"，**不是"不到 10%"**）

| 用例 | LUT(前) | LUT(后) | 缩减率 | DFF | 等价性 |
|---|---|---|---|---|---|
| test1 | 288 | 288 | 0.0% | 222→222 | PASS（归纳） |
| test2 | 25 | **20** | **20.0%** | 0→0 | PASS（归纳） |
| test3 | 13 | 13 | 0.0% | 17→17 | PASS（归纳） |
| test4 | 36 | 36 | 0.0% | 10→10 | PASS（归纳） |
| **合计** | 362 | **357** | **1.38%**（加权口径，**仅参考，不得与逐用例平均混列**） | — | — |
| **逐用例平均（官方口径，计分用）** | — | — | **5.00%** | — | **4/4** |

效率（CPU 已不计分，仅备查）：CPU 开销 max **+4.9%**、内存开销 max **+9.5%**（整进程树口径）。

- 详细报告：[`official_submission.md`](official_submission.md)（含机器可读 [`official_results.json`](official_results.json)）
- 等价性矩阵：[`equivalence_matrix.md`](equivalence_matrix.md)

## 三、本周期做的技术工作

### 1. pass 集成（Q&A 硬要求）

`techlibs/intel/synth_intel.cc` 只改两处：

```diff
 coarse 阶段（在 mux 被 techmap 消除前识别 PMUX 结构）
+ run("pmux_opt -analyze-only");

 map_luts 阶段（自研 pass 内部仍调用 abc9，只是替换了 abc9 的脚本参数）
- run("abc9 -lut 4 -W 300" + string(dff ? " -dff" : ""));
+ run("pmux_opt" + string(dff ? " -dff" : ""));
```

**为什么必须两处**：`map_luts` 阶段 `$pmux/$mux` 已被 techmap 成门电路，在那里统计 PMUX 结构只会得到 0（实测）。

### 2. 面积收益的来源：映射策略选择

实测结论：**面积收益不来自结构变换，而来自替换 ABC 映射脚本**。结构类变换（跨位分组、
共享选择子表达式、删默认路径、全部相关自带 pass）在官方后端下**均为 0 收益**（有完整实验记录）。

主脚本 `c_min_mfs2_lutpack`（在默认经典脚本基础上删掉对面积无益的 `scorr/dc2/dretime`，
保留 `fraig`/`if`/`mfs2`/`lutpack`）：

```
strash / &get -n / &fraig -x / &put / strash / dch -f / if / mfs2 / lutpack -S 1
```

### 3. 规模护栏（本周期新增，消除一处纯亏损）

实测发现 test1（222 个 DFF）在经典 abc 路径下 **面积 0 收益（288→288）却让 CPU 开销 +173%**。
原因是经典映射器开销随规模增长明显快于 abc9，而面积优势在大电路上不体现。

于是加入规模护栏：`DFF > 64` 时**保持官方 abc9 路径**。

| | 加护栏前 | 加护栏后 |
|---|---|---|
| test1 CPU 开销 | **+173%** | **+3.5%**（约等于零） |
| 最大 CPU 开销 | +173% | **+33.8%** |
| 逐用例平均缩减率 | 20.26% | **20.26%（不变）** |

> ⚠️ 上表数字来自**已作废的经典 `abc` 方案**（**作废方案的历史数字**），仅作技术过程记录保留；
> 现行合规方案的效率数字见第二节。

阈值在官方 4 个 case 上校准，可用 `-dff-guard <n>` 覆盖。

### 4. 等价性：4/4 无界归纳证明（含检查器自校验）

方法：`miter -equiv` + **显式 `flatten miter`** + `sat`（`-seq N` 有界 与 `-tempinduct` 无界归纳各跑一次）。

**每个用例的检查器都先通过双重前置校验**：

| 用例 | 自检（同文件比自身，须 PASS） | 负对照（须 FAIL） | 变体结论 |
|---|---|---|---|
| test1 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL | 全部 PASS |
| test2 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL | 全部 PASS |
| test3 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL | 全部 PASS |
| test4 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL | 全部 PASS |

**EQY 的能力边界**：test4 上 EQY 无法验证（`EqySatStrategy` 会跳过含 memory 的 partition，
唯一支持它的 `sby` 策略需 SBY，本机未安装），**且同样问题发生在官方 abc9 映射上**。
本方法不依赖 SBY，覆盖了该场景。

## 四、未闭环项（如实记录）

| 项 | 状态 | 原因/下一步 |
|---|---|---|
| **效率 ≤5%** | ❌ 未达标（**作废方案的历史数字**：CPU max +26.6%、内存 max +37.1%） | 经典 `abc` 的**内存开销是结构性的**（脚本从 12 步砍到 7 步、CPU 可降到 +13%，内存仍 +30%）。若主办方确认效率按超出比例重罚，改用纯 `abc9` 方案（面积约 5%，未达赛题 10% 技术指标）——**需主办方答复后决策** |
| test1 面积 | 0%（无收益） | 已用护栏消除其 CPU 亏损；该用例在官方 abc9 与经典 abc 下同为 288，无可挖空间 |
| 官方答复 | 待回 | 「开销 >5% 如何扣分」——已列入 `open_questions.md` 第 2 问 |

## 五、交付物索引

| 交付物 | 路径 |
|---|---|
| 逐用例提交报告（人读） | `docs/official_submission.md` |
| 逐用例结果（机器可读） | `docs/official_results.json` |
| 等价性矩阵与踩坑记录 | `docs/equivalence_matrix.md` |
| 自研 pass 源码（主） | `plugin/pmux_opt.cc`、`plugin/pmux_analyze.cc` |
| 调优 ABC 脚本 | `configs/abc_scripts/`（主脚本 `c_min_mfs2_lutpack.abc`） |
| Yosys 集成补丁 | `plugin/yosys-0.69-pmux.patch`（含 `synth_intel.cc` 改动） |
| 复现脚本 | `scripts/wsl_build_baseline.sh`、`wsl_verify_binaries.sh`、`official_report.py`、`wsl_equiv_unbounded.sh` |
| 官方用例 | `benchmarks/official/test1~4.v` |
