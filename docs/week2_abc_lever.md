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
   我们仍需保留自研 pass（赛题原文写「新增自定义 Tcl 命令」，但答疑 C41-3 已明确**不需要 Tcl 接口**，本项目按答疑执行；保留 pass 是为了分析能力与可复现性），但**不能把全部希望押在结构变换上**。
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

### 5.2 等价性验证：**已证明（8/8 通过 + 负对照有效）**

#### 最终方法：`equiv_opt` 传递性证明

`equiv_opt` 是 Yosys **专门用于"验证某个优化命令是否保持等价"**的命令（`help equiv_opt`：
"This command uses temporal induction to check circuit equivalence before and after an
optimization pass"）。用传递性来证明最干净：

```
证：abc  -lut 4        保持等价   ⎫
                                  ⎬ ⇒ 两种映射的输出互相等价（都等于 abc 之前的网表）
证：abc9 -lut 4 -W 300 保持等价   ⎭
```

对应脚本：`scripts/wsl_abc_equiv4.sh`，每个用例执行：

```
read_verilog <case>
hierarchy -top <top>
synth_intel -family cycloneiv -top <top> -run begin:map_luts   # 停在 abc 之前
equiv_opt -assert -ignore-unknown-cells abc  -lut 4            # 或 abc9 -lut 4 -W 300
```

#### 结果

| 用例 | `abc -lut 4` | `abc9 -lut 4 -W 300` | 判定 |
|---|---|---|---|
| u01 / u02 / u03 / u04 / u05 | PASS | PASS | ✓ 等价 |
| m01 / m02 / m03 | PASS | PASS | ✓ 等价 |
| **合计** | **8/8** | **8/8** | **✓ 8/8 完成传递性证明** |

**负对照**（`benchmarks/exp/e09_u02_mutated.v`，输出最低位取反）：

```
✓ 负对照被正确判为不等价（rc=1）
    ERROR: Called with -verify and proof did fail!
```

即：这套验证流程能检出真实差异，不是"永远显示绿色"。

#### 关键选项与可靠性依据

- **`-ignore-unknown-cells`**：忽略无法匹配 SAT 模型的单元 —— 用于处理 Intel 的 `dffeas` 原语。
  **可靠性依据**：这些 FF 单元在两侧**同名同连接**（abc 不使用 `-dff`，不跨 FF 边界），
  `equiv_make` 把它们作为割点匹配，因此无需其内部逻辑模型。
- 证明发生在 **LUT 阶段**；其后的 `clean / opt -fast / autoname / map_cells` 等步骤两侧命令完全相同，
  语义保持，因此结论对最终 cycloneiv 网表同样成立。

#### 走过的三个弯路（记录下来，答辩与后续都用得上）

| 方法 | 结果 | 失败原因 |
|---|---|---|
| EQY（`[gold]`/`[gate]` 各跑一遍完整流程再 `prep`） | 8/8 报错 | `combine: ERROR: Unmatched module exists in gold that does not exist in gate`
—— **abc9 会在流程中创建/删除内部辅助模块**，两侧模块集合不一致。EQY 更适合比较"两个独立源文件" |
| `miter -equiv` + `sat -tempinduct`（完整流程） | 组合用例 6/8 PASS；时序用例 ERROR / 超时 | `No SAT model available for cell dffeas`；换到 `map_ffs` 之前后虽能证明，但 `-tempinduct` 在 64 个 DFF 的电路上 **>90 秒不返回** |
| `equiv_make` + `equiv_simple` + `equiv_status` | 1/8 PASS，其余报 unproven | 与上一行结论矛盾 → 该流程的 **FF 匹配没生效**（unproven 数恰好等于 DFF 数） |
| `sat -seq 1`（有界） | 通过 | **但只证明 cycle 0，不足以覆盖全部时序行为**，故不采用 |

### 5.4 真正的 ABC 脚本文件实验（**最终方案**）

#### 上一轮 5 个内联脚本为什么全劣化：找到了确切原因

用 `-showtmp` 看 Yosys 实际发给 ABC 的命令，真相一目了然：

```
默认（abc -lut 4）                     自定义（-script "+strash,&get,-n,..."）
ABC: + strash                          ABC: + strash &get -n &fraig -x &put scorr dc2 ...
ABC: + &get -n                                 ↑ 整个脚本被当成「一行」发过去
ABC: + &fraig -x
...
```

`-script "+..."` 只把**逗号替换成空格**，而 ABC 的**命令分隔符是分号/换行**。
所以内联写法等于只执行了 `strash` 加一堆垃圾参数，**脚本根本没跑** —— 这才是劣化 500 的原因。

**正确做法：用真正的脚本文件**（`-script <file>`），一行一条命令。这也正是主办方要求提交的形态。
探测还确认：**用 `-script <file>` 时 Yosys 仍会照常发送 `read_lut <lutdefs.txt>`**，LUT 库不会丢。

#### 脚本文件清单与结果

脚本放在 `configs/abc_scripts/`（可直接作为交付物提交）：

| 脚本 | 与默认脚本的差异 | 合计 | 相对 B0 |
|---|---|---|---|
| `baseline_lut4.abc` | 默认脚本原文（自洽性检查用） | **263** | 省 21 —— **与 `abc -lut 4` 完全一致 ✓ 机制正确** |
| **`if_area.abc`** | **`if` → `if -a`（面积优先映射）** | **259** | **★ 省 25（8.8%）** |
| `ifarea_nodretime.abc` | `if -a` + 去掉 `dretime` | 259 | 省 25（无额外收益） |
| `ifarea_lutpack2.abc` | `if -a` + `lutpack -S 2` | 259 | 省 25（无额外收益） |
| `andif_area.abc` | 改用新版映射器 `&if -K 4 -a` | 259 | 省 25（与 `if -a` 等价） |
| `ifarea_dc2.abc` | `if -a` + AIG 上的 `&dc2` | 260 | 省 24（略差，m02 反而 101→103） |
| `dc2_aig.abc` | 默认 + `&dc2` | 263 | 省 21（dc2 无收益） |
| `lutpack2.abc` / `no_dretime.abc` | 单改 `lutpack -S 2` / 去 `dretime` | 263 | 省 21（无收益） |
| `nf_resub.abc` | 加 `&nf` / `&resub -K 6` | — | **无效**（`&resub` 选项语法不对，8/8 失败） |

**最优：`if_area.abc` —— 259 个单元，比官方基线省 25 个（8.8%）。**

逐用例收益（`if_area` vs B0）：

| 用例 | B0 | `if -a` | 变化 |
|---|---|---|---|
| **m02_regfile_readback** | 120 | **101** | **−19（−15.8%）** |
| **u05_negative_no_mux** | 20 | **16** | **−4（−20%）** |
| **u04_pmux8_narrow_onehot** | 14 | **12** | **−2（−14.3%）** |
| u01 / u02 / u03 / m01 / m03 | — | 同 | 0 |

#### 等价性验证：**8/8 通过 + 负对照有效**

用 5.2 的 `equiv_opt` 传递性方法验证 `abc -lut 4 -script configs/abc_scripts/if_area.abc`：

```
A 传递性证明 : 8/8        （变体保持等价 且 官方 abc9 保持等价）
B 负对照     : 有效        （输出最低位取反的设计被判为不等价）
```

对应脚本 `scripts/wsl_abc_equiv4.sh`（已参数化，可验证任意变体命令）。

#### 可交付成果

1. **`configs/abc_scripts/if_area.abc`** —— 调优后的 ABC 脚本，**省 8.8% 且等价性已证明**，
   满足主办方"调优较好的 abc 脚本需一并提交"的要求。
2. **`configs/pipelines.json` 的 `SCRIPT_ifarea`** —— 把该脚本接入 `synth_intel` 分段流程的完整配置。
3. 全部 10 个脚本文件（含失败的 `nf_resub.abc` 与各对照），保留完整实验记录。

#### 下一步

1. **扩样本到 20~30 个**，确认 8.8% 不是小样本偶然（重点覆盖寄存器读回/状态字选择/配置译码）
2. 继续挖脚本空间：`if` 的其它选项（`-K`/`-n`/`-C`/`-F`）、`&if` 迭代次数、`mfs2` 参数、
   以及 `-lut <w1>:<w2>` / `-luts` 成本模型（Cyclone IV 是 4 输入 LUT，成本模型可能有调整空间）
3. 给最终 cycloneiv 网表出 EQY 正式报告（提交前待办）
4. 在 `runs/` 保留全部扫描日志作为证据链

## 六、历史结论（第 1 轮，供对照）

- `abc -lut 4` 相对官方 `abc9 -lut 4 -W 300` 省 21 个单元（7.4%），其中 m02 寄存器读回 120→101（15.8%）
- 自洽性：分段复刻官方流程（`ABC_baseline`）= 284，与 B0 逐用例完全一致 → 分段替换法无偏差
- abc9 的 `-W`（effort）、`-D`（延迟）旋钮在本批用例上完全无效
