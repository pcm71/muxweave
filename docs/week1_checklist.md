# 第 1 周任务清单（逐日 + 责任人）

> **执行结果见 [`week1_report.md`](week1_report.md)**：2026-09-23 已由自动化脚本跑完全部关卡，
> 除「队友独立复现（REQ07）」外均已 PASS。本清单保留作为流程与责任人模板。

> 目标：打通「工具链—基线—验证」最小闭环，**锁死版本**。本周不追优化效果，任何收益数字都不作为成果。
> 角色：**A** = 算法/插件，**B** = 验证/评测，**C** = 集成/展示。

## 第 1 天 —— 立项与版本决策

- [ ] 读题目（`../中科亿海微 (1).pdf` 第 6～7 页）与问答记录（`../副本FPGA创新大赛问题汇总.xlsx`）——**全员**
- [ ] `bash scripts/check_env.sh`，确认 WSL2/Ubuntu 24.04 与依赖 —— **C**
      （先跑 `python3 scripts/static_check.py` 与 `--fake-yosys` 冒烟，不等 Yosys 编译完也能验证驱动）
- [ ] 决定 0.68 还是 0.69，填 `VERSION_LOCK.md` 第 1 节 —— **A 主持，全员确认**
- [ ] 把仍未闭环的 3 个问题发到 QQ 群（1107062816）—— 提问稿见 [`docs/open_questions.md`](open_questions.md)，可直接复制 —— **B**
- [ ] 产出：需求表 + 版本决策 + 责任人 —— 全员

## 第 2～3 天 —— pass 编入主程序（本周唯一硬关卡；按答疑 C41-3 不要求 Tcl 接口）

- [ ] `bash scripts/bootstrap_yosys.sh` 编译并安装 Yosys，记录 `yosys -V` 到 `VERSION_LOCK.md` —— **A**
- [ ] 按 `plugin/INTEGRATION.md` 把 `pmux_analyze.cc`、`pmux_opt.cc` 接进 `passes/` 并重新构建 —— **A**
- [ ] `yosys -p "help pmux_analyze"` 与 `yosys -p "pmux_analyze"` 均正常 —— **A**
- [ ] ~~从 Tcl 脚本调用成功~~（答疑 C41-3 已明确**不需要 Tcl 接口**，此项取消）
- [ ] 明确记录：**未使用 `plugin -i` 加载 .so** —— **A**
- [ ] 若编译失败：立刻降级到另一个版本或调整工具链，**不要拖到第 2 周**

## 第 3～4 天 —— B0 基线 + EQY 正误最小例

- [ ] `yosys -p "help synth_intel"` 核对 `-family` 名称与 LUT 选项，校正 `configs/b0_synth_intel_cycloneiv.ys` —— **B**
- [ ] B0 在 5 个基础用例上都跑通并出 `stat -json` —— **B**
- [ ] `bash formal/mini/run_formal_mini.sh`：**错误例必须 FAIL、正确例必须 PASS** —— **B**
- [ ] 把两例的日志与退出码归档到 `formal/mini/logs/` —— **B**

## 第 4～5 天 —— PMUX 分析器

- [ ] `pmux_analyze` 能列出每个 PMUX 的 W、K、选择信号身份、各分支数据源、重复位模式 —— **A**
- [ ] 对每个用例**人工核对**目标数与分析结果一致（写进 `benchmarks/unit/MANIFEST.md` 末列）—— **A + B**
- [ ] 确认 u05（负对照）报告"没有目标结构"，不是报错 —— **B**

## 第 5～7 天 —— 基础用例 + 统一结果格式

- [ ] 5 个基础用例全部纳入 `benchmarks/unit/`，每个用例用 `run_case.py` 产出 `runs/<id>/result.json` —— **C**
- [ ] `python3 scripts/report.py --runs runs --out reports` 生成第一版基线报告 —— **C**
- [ ] 报告字段与方案第 22 节一致（含 `cpu_time`、`wall_time`、`peak_process_tree_memory`、`dff_base`、`dff_opt`）—— **C**
- [ ] 采集方式交叉核对：`scripts/measure_cmd.sh` 与 `run_case.py` 的数字应一致（±噪声）—— **B**

## 第 7 天 —— 收口

- [ ] `VERSION_LOCK.md` 第 2～4 节全部填完 —— **A**
- [ ] 队友在干净目录按 README 重跑成功（REQ07 前置）—— **B/C 交叉**
- [ ] 记录未解决的反例与次日需要谁配合 —— 全员
- [ ] 第 2 周内部关卡预告：至少数个结构不同的样本在全流程后仍有收益，且不是只比人为削弱的基线好

---

## 本周明确不做的事

- 不做界面、不做演示视频、不做 PPT
- 不写优化规则（`pmux_opt` 本周只保留骨架与回退）
- 不追求缩减率数字；**不把目标值写成实测成果**
- 不购买开发板、不做上板验证（映射终点是 Cyclone IV 网表，不是 EQ6HL130P）
