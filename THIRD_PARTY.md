# THIRD_PARTY —— 第三方组件与许可

> 提交前必须核对：来源、版本、许可、自研边界。禁止把第三方代码说成自研，也禁止漏列许可证。

| 组件 | 版本（见 VERSION_LOCK.md） | 来源 | 许可 | 用途 | 是否修改 |
|---|---|---|---|---|---|
| Yosys | v0.68 / v0.69 | github.com/YosysHQ/yosys | ISC | 综合框架；自研 pass 编译进其主程序 | ☐ 未修改　☐ 已修改（说明） |
| ABC | Yosys 子模块 | github.com/berkeley-abc/abc | MIT 类 | 逻辑映射；**可能提交调优后的 abc 脚本** | 仅脚本调优 |
| EQY | 与 Yosys 对应 tag | github.com/YosysHQ/eqy | ISC | 形式等价验证 | ☐ 未修改 |
| SBY（可选） | | github.com/YosysHQ/sby | ISC | 仅 `[strategy sby]` 需要 | 未修改 |
| SMT 求解器（可选） | z3 / yices / bitwuzla | 各自项目 | MIT / GPL 类 | 仅 `sby` 策略需要 | 未修改 |
| eLinx | 教育版 | 中科亿海微（主办方提供） | 厂商 EULA | 编译与仿真侧验收 | 未修改 |
| Graphviz / xdot | | graphviz.org | EPL | `show` 结构图 | 未修改 |
| Icarus Verilog / Verilator（可选） | | 各自项目 | GPL / LGPL | 辅助排错，**不替代 EQY** | 未修改 |
| Python 报告脚本依赖 | 标准库为主 | — | — | 实验驱动与报告 | 自研 |

## 自研部分边界（答辩必答）

- **自研**：`plugin/pmux_analyze.cc`、`plugin/pmux_opt.cc` 及其后续规则实现，`scripts/` 下的实验驱动与报告，
  `configs/` 下的基线/插入点配置，`benchmarks/` 下的用例，`formal/` 下的 EQY 配置。
- **非自研**：Verilog 解析、通用综合与优化 pass、ABC 映射、EQY 形式验证引擎、eLinx 工具链。
- **调优类**：若提交调优后的 abc 脚本，需在实验报告中写明改动点与对照数据，**不得称为自研算法**。

## 陈述纪律

- 没有可靠测量就不写功耗/频率提升数字。
- 未完成目标器件流程适配，就不写"已适配国产 FPGA"。
- 上报数据必须来自冻结版本 + 统一配置，禁止手填。
