# 第 2 周：ABC 步骤杠杆实验（首个正向结果）

日期：2026-09-23　分支：`exp/rule-cross-bit-sharing`
脚本：`scripts/wsl_abc_battery.sh`　配置：`configs/pipelines.json` 的 `ABC_*`
数据：`runs/abc_*.log`、`runs/help_abc.txt`

---

## 一、为什么转向 ABC

前三个抓手全部验证为 **0 增益**（见 [`week2_rule_feasibility.md`](week2_rule_feasibility.md)）：

| 抓手 | 结果 |
|---|---|
| 跨位分组 + 共享选择子表达式（方案主算法） | 0（连 K=8 重度重复用例也 0） |
| 删默认路径 / 利用多选未定义 | 0 |
| 全部相关自带 pass（muxpack/share/opt_reduce -fine/opt_muxtree/wreduce） | 0 或劣化 |

而本项目**迄今观测到的唯一大杠杆就是 ABC**：
Yosys 0.68 → 0.69 的实测差异 **9.5% → 24.6%**，发布说明确认 0.69 改了 abc 的 sum-of-products 参数。
主办方也明确允许："**可以调整 abc 的脚本**"，且要求"调优较好的 abc 脚本需一并提交"。

## 二、实验方法：用 `synth_intel` 的分段标签替换 abc 那一步

`synth_intel` 支持 `-run <from>:<to>`，其标签结构（`runs/synth_intel_flow.txt` 实测）：

```
begin: → family: → coarse: → map_bram: → map_ffram: → map_ffs:
       → map_luts: (abc9 -lut 4 -W 300)  ← 官方 abc 步骤在这里
       → map_cells: → check:
```

于是可以只替换这一步，其余完全保持官方流程：

```text
read_verilog <case>
hierarchy -top <top>
synth_intel -family cycloneiv -top <top> -run begin:map_luts     # 跑到 abc 之前
<ABC 变体>                                                        # ← 只换这里
clean ; opt -fast ; autoname ; clean                              # 复刻 map_luts 的收尾
synth_intel -family cycloneiv -top <top> -run map_cells:check     # 继续官方收尾
stat ; tee -o ... stat -json
```

**自洽性验证**：用与官方完全相同的 `abc9 -lut 4 -W 300` 走这条分段流程（`ABC_baseline`），
结果 **284 = B0 的 284，逐用例完全一致** —— 证明分段替换方法没有引入额外偏差，
下面的差异确实来自 ABC 本身。

## 三、结果

| pipeline | ABC 步骤 | 合计逻辑单元 | 相对 B0 |
|---|---|---|---|
| `B0` | 官方 `synth_intel`（内部 `abc9 -lut 4 -W 300`） | **284** | 基准 |
| `ABC_baseline` | 分段复刻，同为 `abc9 -lut 4 -W 300` | **284** | 持平 ✅ 方法自洽 |
| `ABC_w100` | `abc9 -lut 4 -W 100` | 284 | 持平 |
| `ABC_w1000` | `abc9 -lut 4 -W 1000` | 284 | 持平 |
| `ABC_delay` | `abc9 -lut 4 -W 300 -D 10` | 284 | 持平 |
| **`ABC_classic`** | **`abc -lut 4`（经典映射器）** | **263** | **★ 省 21 个（7.4%）** |
| `ABC_fast` | `abc9 -lut 4 -fast` | — | **选项无效**（0.69 的 abc9 无 `-fast`），8/8 失败 |

### 省在哪里（逐用例）

| 用例 | B0 | `ABC_classic` | 变化 |
|---|---|---|---|
| **m02_regfile_readback**（4×16 寄存器堆读回，含存储器） | 120 | **101** | **−19（−15.8%）** |
| u04_pmux8_narrow_onehot（W=1, K=8） | 14 | 13 | −1 |
| u05_negative_no_mux（负对照） | 20 | 19 | −1 |
| m01 / m03 / u01 / u02 / u03 | — | 同 | 0 |

- `abc9` 的 **effort（`-W`）与延迟目标（`-D`）这两个旋钮在本批用例上完全不起作用**（1000 与 100 的结果一样）。
- **收益集中在"含存储器/寄存器堆读回"的电路**（m02 一个用例贡献了 19/21）。
  这与"读回多路选择的译码与数据通路"有关，值得作为主展示场景深挖。

## 四、结论与影响

> **把官方流程里的 `abc9 -lut 4 -W 300` 换成经典 `abc -lut 4`，在 8 个用例上合计省 21 个单元（7.4%），
> 其中寄存器读回用例省 15.8%。这是本项目第一个可复现的正向优化结果。**

三点影响：

1. **路线调整**：面积收益的主要来源可能不在"自研结构变换"，而在 **ABC 映射步骤的调优**
   —— 这与 0.68/0.69 差异的根源（ABC 版本/参数）完全一致。
2. **合规性**：主办方明确允许调整 abc 脚本，并要求把调优结果一并提交。
   我们仍需保留自研 pass（题目硬性要求自定义 Tcl 命令 + 分析能力），但**不能把全部希望押在结构变换上**。
3. **下一步优先级**：
   - 扩展 ABC 变体空间：自定义 `.abc` 脚本（`abc -script <file>`）、`abc -g`、`-luts` 成本参数、
     `abc` 与 `abc9` 的组合（如先 `abc9` 再局部 `abc`）等
   - 把 m02 这类"含存储器读回"的电路扩到 20~30 个样本，确认 7.4% 不是偶然
   - 用 EQY 验证 `abc -lut 4` 产生的网表与原网表等价（**必做**：换映射器属于流程变更，
     虽不改变语义，但必须按题目要求逐用例给等价证据）

## 五、待办（按优先级）

1. **等价性验证**：对本批 8 个用例，用 EQY 验证 `ABC_classic` 的输出网表与 B0 输出等价
   （当前只比较了单元数，还没给等价证据）
2. 扩大 ABC 变体扫描（自定义脚本是最有希望的方向，主办方点名要求提交 abc 脚本）
3. 扩大样本集到 20~30 个，重点覆盖"寄存器读回 / 状态字选择 / 配置译码"
4. 修正电池脚本的判定逻辑：`ABC_fast` 这类**选项无效导致的 0 单元**必须显示为"无效"而不是"省 284"
