# 芯简 PMUX —— 最终交付版（2026-10-29）

本目录是参赛最终交付物（开发方向：多路选择器 PMUX 结构优化），与报名系统提交内容对应。

## 文件清单

| 文件 | 说明 |
|---|---|
| `pmux-merge946-20261027.zip` | 最终交付包（约 20 MB，1200+ 文件）：Windows 自编译 yosys.exe / yosys-abc.exe（官方 Yosys 0.69 `9f75ca1` + 锁定 ABC `a51bf4a7`）+ 5 个依赖 DLL + PMUX 七个 pass 源码 + eqy 等价证明工具链 + 9 用例全部验证工件 |
| `PMUX946-技术文档.docx` | 按组委会官方模板填写的技术报告（作品名称：芯简 PMUX），上传前另存为 PDF 即可 |

## 核心结果（9 用例：4 功能 + 5 官方效率用例）

- 逻辑资源（LUT+反相器，官方 Q&A 口径）相对官方 pristine 0.69：**平均 −11.99%**，单例最高 −36.00%，无一例上升；
- 综合耗时平均 +0.80%、最差 +3.44%（≤ +5% 门槛）；
- 功能等价：**网表级 SAT 9/9 EQUIV，YosysHQ eqy 归纳证明 9/9 PASS**；
- 一键验收 `validation/validate-all.py` 九阶段全绿（四例对账 / 回归 / 重放哨兵 / 双层消融 / 效率门 / SAT 等价 / eqy 证明 / 工件校验）。

## 快速验证

```bat
:: 解包后，干净 Windows 环境（无需 MSYS2）
python four-case-check.py
:: 预期：test1 288 / test2 16 / test3 13 / test4 26，结尾 ALL-OK
python validation\validate-all.py
:: 预期：九阶段全部 PASS，退出码 0
```

## 与仓库主线的关系

本仓库 `exp/*` 分支为研发过程代码与实验记录；本目录为基于官方 0.69 的最终合并版
（PMUX 补丁以 `src/yosys-0.69-pmux.patch` 形式随包提供，可离线复现合并）。
