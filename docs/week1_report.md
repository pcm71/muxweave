# 第 1 周完成报告

日期：2026-09-23　环境：WSL2 + Ubuntu 24.04.5 LTS（内核 6.18.33.2-microsoft-standard-WSL2）
执行：由 DSH 自动化完成（构建、接入、验证、实验、报告均为脚本化，可重跑）

---

## 一、第 1 周关卡总表

| 关卡 | 结果 | 关键证据 |
|---|---|---|
| 版本锁定（0.68/0.69 二选一并全队统一） | ✅ PASS | `VERSION_LOCK.md` 第 2 节全部回填 |
| **pass 编入 Yosys 主程序**（本周唯一硬关卡） | ✅ PASS | `runs/REQ10_integration_evidence.md` |
| Tcl 支持（**按答疑不实现 Tcl 接口**：赛题原文要求"新增自定义 Tcl 命令"，答疑 9.23 / C41-3 明确"不需要 tcl 接口"，本项目以答疑为准；此项仅记录 `with_tcl` 构建开关已启用） | ✅ PASS（**仅构建依赖**） | CMake 日志 `* with_tcl, Tcl scripting and SDC parsing` |
| B0 基线（synth_intel → Cyclone IV）跑通 | ✅ PASS | 5 个用例全部产出 `stat.json` |
| EQY 正误最小例（错误必 FAIL、正确必 PASS） | ✅ PASS | 错误例 rc=2 FAIL；正确例 rc=0 PASS |
| 5 个基础用例 + 第一版基线报告 | ✅ PASS | `reports/summary.md` |
| 队友在干净目录复现（REQ07） | ⬜ **待做** | 需另一名成员按 README 重跑 |

## 二、版本锁定摘要

| 项 | 值 |
|---|---|
| Yosys | tag `v0.69`，commit `9f75ca1f9834a39a863915b5dae0c7b1e33533bc` |
| yosys -V | `Yosys 0.69 (git sha1 9f75ca1f9-dirty, Release, GNU /usr/bin/c++ 13.3.0)` |
| ABC | commit `a51bf4a7bb38ce06ea3a544b1463b40832213917` |
| EQY | tag `v0.69`，commit `4a72eb94fc253062464afee4d0018359017bb846`，`~/.local/bin/eqy` |
| 工具链 | CMake 3.28.3 / g++ 13.3.0 / Python 3.12.3 / Tcl 8.6.14 |
| 首次编译 | 1075 秒（并行度 5，按 7.7 GB 内存自适应）；加入自研 pass 后增量编译 13 秒 |
| 求解器 | 不需要（本轮用 EQY 内置 `sat` 策略） |

## 三、5 个基础用例基线数据（B0，映射至 Cyclone IV）

| 用例 | $pmux | W | K | 复用位/跨位共享 | 逻辑单元 | DFF | CPU 时间 | 整进程峰值内存 |
|---|---|---|---|---|---|---|---|---|
| u01_mux2_wide（2 选 1） | 1 | 8 | 2 | **0/0** | 8 | 0 | 0.171 s | 28.7 MB |
| u02_pmux4_shared_fields（位片重复） | 1 | 8 | 4 | **8/8** | 12 | 0 | 0.206 s | 28.9 MB |
| u03_pmux4_const_and_default（常量字段＋非零默认） | 1 | 16 | 4 | **4/4** | 31 | 0 | 0.208 s | 29.1 MB |
| u04_pmux8_narrow_onehot（W=1、K=8） | 1 | 1 | 8 | **0/0** | 14 | 0 | 0.209 s | 29.0 MB |
| u05_negative_no_mux（负对照） | **0** | — | — | 0/0 | 20 | 0 | 0.206 s | 29.3 MB |

要点：

- **识别正确**：4 个正例各识别到 1 个目标 cell，负对照正确报 0 个，且不是报错。
- **复用判定正确**：u01 与 u04 的 `复用位/跨位共享` 均为 0/0 —— 它们确实没有可复用结构；
  u02 是 8/8（高 4 位与低 4 位分别共用数据源）；u03 是 4/4（`0xA5` 与 `0xFF` 在同 4 个位上都是常量 1）。
- **资源远低于门槛**：CPU 时间 0.17~0.21 s（门槛 60 s），整进程峰值 28~29 MB（门槛 2 GB）。
- 本批用例均为组合逻辑，DFF = 0；时序用例要到第 3 周补。

> **内存口径**：赛题阈值为峰值 ≤2GB。答疑早期（C26）称"内存是整个进程的峰值"，**最新 C54-2 明确"峰值工作内存，只看 yosys.exe"**；上表"整进程峰值 28~29 MB"是整进程树峰值（**偏保守**，含 abc 子进程）。

## 四、验证闭环证据（REQ03 第一份）

| 例 | 期望 | 实际 | 退出码 | 日志 | 归档产物 |
|---|---|---|---|---|---|
| `equiv_bad.eqy`（最低位取反的故意错误） | FAIL | **FAIL** | 2 | `formal/mini/logs/equiv_bad.log` | `runs/eqy_equiv_bad_20260923T215018Z/` |
| `equiv_ok.eqy`（三元链，功能等价） | PASS | **PASS** | 0 | `formal/mini/logs/equiv_ok.log` | `runs/eqy_equiv_ok_20260923T215019Z/` |

两个方向都验到了：**错误候选会被检出**（说明验证器不是永远显示绿色），**正确的结构改写会通过**
（说明验证不过度严格）。两者均使用 gold=原始参考设计、gate=候选实现的方向。

## 五、过程中发现并修复的 4 个真缺陷

| # | 缺陷 | 现象 | 修复 |
|---|---|---|---|
| 1 | **`stat -json <文件>` 不写文件** | 所有用例"逻辑单元 = None"；Yosys 把路径当成模块选择模式，JSON 只打到 stdout | 改用 `tee -o <文件> stat -json`（实测确认） |
| 2 | **EQY 入口不存在 / 误报就绪** | `~/src/eqy/eqy` 根本没有该文件，脚本却打印"EQY 就绪" | `eqy` 是 `make install` 由 `src/eqy.py` 生成；改为 `make install PREFIX=~/.local`（免 sudo）并**加存在性校验** |
| 3 | **分析器复用判定错误（假信号）** | 最简单的 2 选 1 被报"跨位共享 8 位"，会误导第 2 周去追不存在的机会 | 只有"至少两个分支取同一数据源"的位才计入；并区分"复用位"与"跨位共享" |
| 4 | **EQY 输出目录不可重入** | 同一命令跑第二次报 `ERROR: Directory 'equiv_ok' already exists` | 运行前清理同名目录，跑完把产物归档到 `runs/eqy_<名称>_<时间戳>/` |

另外修正了两处**我自己的检测脚本**误报：`tcl.h`/`ffi.h` 在 Ubuntu 多架构路径下（`/usr/include/tcl8.6/`、
`/usr/include/x86_64-linux-gnu/`），只查 `/usr/include/xxx.h` 会假报缺失。

## 六、证据索引

| 类别 | 路径 |
|---|---|
| 版本证据 | `VERSION_LOCK.md`（人工填写）、`runs/VERSION_LOCK.generated.md`（脚本生成） |
| 交付形态证据（REQ10） | `runs/REQ10_integration_evidence.md` |
| 构建日志 | `runs/build_yosys.log`（991 KB） |
| 接入日志 | `runs/stage1_install.log` |
| 形式验证日志 | `formal/mini/logs/`、`runs/stage2_formal.log` |
| 逐用例日志与结果 | `runs/stage3_u0*.log`、`runs/u0*__B0__*/result.json` |
| 汇总报告 | `reports/summary.md`、`reports/summary.csv` |
| 源码结构探查 | `runs/cmake_probe.txt`、`runs/cmake_probe2.txt` |

## 七、第 1 周明确未做的事（按计划）

- 未写任何优化规则 —— `pmux_opt` 目前只统计机会并**显式回退**（`fallback=true`），不改网表
- 未做界面、演示视频、PPT
- 未购买硬件、未做上板（映射终点是 Cyclone IV 网表）
- 未把任何目标数值写成实测成果

## 八、第 2 周起点

1. **插入点实验**：跑 `configs/pipelines.json` 里的 `O_INSERT_A` / `O_INSERT_B`，对比 A/B 在
   逻辑单元、CPU 时间、验证状态上的差异，选定并固化 pipeline。
2. **主规则原型**：按方案第 7 节实现"跨位分组 + 共享选择子表达式"，对 u02/u03 这类**已确认有复用**
   的用例先做出可解释的映射增益。
3. **去留判断**（第 2 周关卡）：收益必须独立于 `opt_reduce -fine` / ABC 已经实现的能力 —— 用 B1 加强基线对照。
4. 补时序类用例（含 DFF），因为 DFF 不得多于优化前是硬约束。
