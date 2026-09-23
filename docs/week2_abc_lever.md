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

## 五、第 2 轮：脚本变体扫描 + 等价性验证（**等价性尚未打通，务必先看这里**）

### 5.1 脚本变体扫描结果（72 次运行，0 失败）

以 abc 默认 `-lut` 脚本为基准做定向改动：

```
默认：strash; &get -n; &fraig -x; &put; scorr; dc2; dretime; strash; dch -f; if; mfs2; lutpack -S 1
```

| 变体 | ABC 命令 | 合计 | 相对 B0 |
|---|---|---|---|
| `B0` | 官方 `abc9 -lut 4 -W 300` | 284 | 基准 |
| **`ABC_classic`** | `abc -lut 4` | **263** | **★ 省 21（7.4%）** |
| **`ABC_and`** | `abc -lut 4 -g AND` | **263** | **★ 省 21**（与 classic 相同） |
| `ABC9_noW` | `abc9 -lut 4`（去掉 `-W 300`） | 284 | 持平 → **`-W 300` 无任何作用**（已隔离验证） |
| `ABC_noret` | 自定义脚本：去掉 `dretime` | 784 | 多 500 |
| `ABC_dc2aig` | 自定义脚本：插 `&dc2` | 784 | 多 500 |
| `ABC_if_area` | 自定义脚本：`if -a` | 784 | 多 500 |
| `ABC_lutpack2` | 自定义脚本：`lutpack -S 2` | 784 | 多 500 |
| `ABC_nf` | 自定义脚本：插 `&nf` | 784 | 多 500 |

**五个自定义脚本变体结果完全相同（784）**，说明 `-script` 一旦生效就**绕过了 `-lut` 的 LUT 库生成机制**：
ABC 拿不到 LUT 库，等于没做 LUT 映射，所以单元数暴涨。**这是我的用法错误，不是 ABC 的问题** ——
要写自定义脚本，必须把 LUT 库的读取与映射命令一并写进脚本里（后续要用 `-showtmp`/`-nocleanup`
看清 Yosys 生成的临时脚本与 LUT 库文件，再据此改写）。这条已记为待办。

### 5.2 等价性验证：**尚未打通，变体不得用于成绩数据**

换映射器必须逐用例给出等价证据（题目硬性要求）。目前尝试了三种方法，都还没拿到完整证据：

| 方法 | 结果 | 问题 |
|---|---|---|
| EQY（[gold]/[gate] 各跑一遍流程再 `prep`） | 8/8 报错 | `combine: ERROR: Unmatched module exists in gold that does not exist in gate` —— **abc9 会在流程中创建/删除内部辅助模块**，两侧模块集合不一致。EQY 更适合比较"两个独立源文件" |
| Yosys `miter -equiv` + `sat -tempinduct` | **6/8 PASS**，2 个 ERROR | 组合用例（u01~u05、m01）**严格二值 SAT 证明通过**；两个时序用例报 `No SAT model available for cell dffeas`（Intel DFF 原语没有 SAT 模型） |
| Yosys `equiv_make` + `equiv_simple` + `equiv_status` | 1/8 PASS | 与上一行**互相矛盾**（组合用例在这里反而报 unproven）→ 说明**我这个 equiv_make 流程设置有缺陷**，不是设计不等价 |

**当前结论：等价性尚未证明，`ABC_classic`/`ABC_and` 只能作为"有希望的方向"，不能进入成绩数据。**

### 5.3 下一步（等价性优先）

1. **修好验证流程**（最高优先级）。推荐路径：
   - 时序用例：把 `dffeas` 反向映射回通用 FF（写一个小的 techmap，或在比较前用
     `synth_intel -run begin:map_ffs` 停住，让 FF 仍是通用 `$_DFF_*`，SAT 有模型）
   - 组合用例：以 `miter+sat`（已 6/8 PASS）为准，同时查清 `equiv_make` 为何给出矛盾结果
   - 最终仍需用官方指定的 **EQY** 出正式证据：改为**先各写一份网表文件、再用 EQY 比较两个文件**，
     绕开"同一进程内两段流程导致模块集合不一致"的问题
2. 弄懂自定义 abc 脚本的正确写法（含 LUT 库），再扫一轮 —— 这是唯一还没被正确探索的空间
3. 扩样本到 20~30 个，重点覆盖寄存器读回/状态字选择/配置译码
4. 对本次的负面结果也保留证据（`runs/abc2_*.log`），答辩时说明"哪些路试过、为什么不行"同样有价值

## 六、历史结论（第 1 轮，供对照）

- `abc -lut 4` 相对官方 `abc9 -lut 4 -W 300` 省 21 个单元（7.4%），其中 m02 寄存器读回 120→101（15.8%）
- 自洽性：分段复刻官方流程（`ABC_baseline`）= 284，与 B0 逐用例完全一致 → 分段替换法无偏差
- abc9 的 `-W`（effort）、`-D`（延迟）旋钮在本批用例上完全无效
