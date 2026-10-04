# 官方 4 个 case 的形式等价验证矩阵（已闭环）

日期：2026-10-03　分支：`exp/rule-cross-bit-sharing`
脚本：`scripts/wsl_equiv_final.sh`（网表常量变异对照）、`scripts/wsl_equiv_final2.sh`（RTL 变异对照）
日志：`formal/equiv_final/`

---

## 一、结论

> **官方 4 个 case 全部通过形式等价验证，且每个用例的检查器都单独通过了
> 「自检 + 负对照」双重前置校验。**
> **我们的主脚本 `c_min_mfs2_lutpack` 与官方 `abc9` 映射在所有 4 个用例上均等价。**

| 用例 | 检查周期 | ① 自检（同文件比自身，须 PASS） | ② 负对照（须 FAIL） | ③ 各脚本变体 |
|---|---|---|---|---|
| test1 | 5 | PASS ✓ | FAIL ✓ | **全部 PASS** |
| test2 | 5 | PASS ✓ | FAIL ✓ | **全部 PASS** |
| test3 | **12** | PASS ✓ | FAIL ✓ | **全部 PASS** |
| test4 | 5 | PASS ✓ | FAIL ✓ | **全部 PASS** |

**为什么必须有 ①②**：没有它们，"等价"结论可能只是检查器坏了（后面第五节有三次真实的踩坑记录）。

### 各脚本在官方用例上的等价性与面积（逻辑单元）

| 脚本 | test1 | test2 | test3 | test4 | 等价性 |
|---|---|---|---|---|---|
| `baseline_lut4`（经典 abc 默认脚本） | 291 | 15 | 10 | 32 | 全部 PASS |
| `c_min` | 288 | 25 | 12 | 27 | 全部 PASS |
| `c_min_lutpack` | 288 | 15 | 12 | 27 | 全部 PASS |
| **`c_min_mfs2_lutpack`（主脚本）** | 288 | 15 | 12 | **24** | **全部 PASS** |
| `c_full` | 291 | 15 | 10 | 32 | 全部 PASS |
| `if_area` | 291 | 15 | 11 | 31 | 全部 PASS |

（面积以本脚本口径为准；正式成绩数据仍以 `scripts/wsl_official_eval.sh` 的完整流程口径为准。）

## 二、检查方法（可复现）

```bash
bash scripts/wsl_equiv_final.sh  test1 5     # 网表常量变异做负对照
bash scripts/wsl_equiv_final.sh  test2 5
bash scripts/wsl_equiv_final.sh  test4 5
bash scripts/wsl_equiv_final2.sh test3 12    # test3 改用 RTL 变异对照（见第四节）
```

核心流程（每个用例）：

```text
① 自检   ：base vs base                        —— 必须 PASS
② 负对照 ：base vs 有已知差异的网表             —— 必须 FAIL
③ 待测   ：base（官方 abc9） vs 各脚本变体网表   —— 结论才有资格解读
```

比较本身（脚本内 `eqcheck()`）：

```text
read_verilog <网表>
hierarchy -top <top>
proc                      # 关键①：网表里是 always 进程，必须先转成通用 FF
async2sync                # 关键②：网表含异步复位 FF($adff)，不转 sat 会直接报错
opt -fast
design -stash g           # 对另一侧重复同样步骤后 stash 为 e
design -copy-from g -as gold <top>
design -copy-from e -as gate <top>
miter -equiv -make_outputs -make_assert gold gate miter
flatten miter             # 关键③：miter 自带的 -flatten 不生效，必须显式再 flatten
hierarchy -top miter
sat -verify -prove-asserts -seq <N> -set-init-zero miter
```

**周期数 N 的选择**：要覆盖设计里"状态可达"所需的周期。
test3 是移位寄存器，`case(sr)` 的分支需要先移入 8 位才可达 ⇒ N=5 时负对照的差异**不可达**、
检查器无法被验证；提到 **N=12** 后负对照正常 FAIL。

## 三、这些结论相对 EQY 的价值

- EQY（官方工具）在 test4 上**无法验证**：其 `sat` 策略会跳过"含 memory 属性"的 partition
  （`EqySatStrategy.partition_supported`），而唯一支持该 partition 的 `sby` 策略需要 SBY，
  本机未安装。**且同样的问题发生在官方 abc9 映射上**（对照组一样过不了）。
- 本节的 miter+sat 方法**不依赖 SBY**，且对每个用例都做过自检+负对照，
  因此能覆盖 EQY 覆盖不了的场景。
- 两者可互为补充：EQY（RTL 为 gold）已在 test1/test2 上通过；本方法在 4 个用例上全通过。

## 四、test3 为什么改用 RTL 变异做负对照

两次失败尝试（都记下来，避免重犯）：

| 尝试 | 现象 | 原因 |
|---|---|---|
| 翻转网表里某个 LUT 常量 | 负对照 **PASS**（无鉴别力） | 翻转的位对应**不可达的输入组合**，功能无变化 |
| 变异 RTL 的 `8'b10101010` 模式，但只查 5 周期 | 负对照 **PASS** | 该分支要等 `sr` 移位 8 次才可达，5 周期内够不到 |
| 同上 + 查 **12** 周期 | 负对照 **FAIL** ✓ | 差异可达，检查器被成功验证 |

## 五、三次真实的踩坑（方法论教训）

1. **漏 `async2sync`** ⇒ sat 报 `No SAT model available for async FF cell $adff`。
   我的脚本当时把"rc≠0"一律当成 FAIL ⇒ **把 ERROR 误读成"不等价"**，
   一度得出"4 个变体全部破坏功能"的错误结论。
   ⇒ **判定必须区分 PASS / FAIL(反例) / ERROR 三态，不能把 ERROR 当反例。**
2. **依赖 `miter -equiv -flatten` 的 `-flatten`** ⇒ 实测不生效（SAT 只 import 7 个 cell），
   等于在证空性质 ⇒ **假阳性**（连改了常量的负对照都 PASS）。
   ⇒ **必须显式再跑一次 `flatten miter`。**
3. **没有跑"自己 vs 自己"的自检** ⇒ 检查器坏了也看不出来。
   ⇒ **任何等价性检查器，先用"同一输入比自身必须 PASS"筛一遍。**

---

## 六、升级为无界归纳证明（2026-10-04 完成）

脚本：`scripts/wsl_equiv_unbounded.sh`。每种模式各跑一次、分别判定：

| 模式 | 含义 |
|---|---|
| `sat -seq N` | 前 N 个周期无差异（有界证据） |
| `sat -tempinduct` | 时序归纳 —— **无界证明** |

**结果：4 个官方 case 全部拿到无界归纳证明**，且每个用例的前置校验都通过：

| 用例 | ① 自检（须 PASS） | ② 负对照（须 FAIL） | ③ 6 个脚本变体 |
|---|---|---|---|
| test1 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL ✓ | **全部 PASS（有界+归纳）** |
| test2 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL ✓ | **全部 PASS（有界+归纳）** |
| test3 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL ✓ | **全部 PASS（有界+归纳）** |
| test4 | 有界 PASS / 归纳 PASS | 有界 FAIL / 归纳 FAIL ✓ | **全部 PASS（有界+归纳）** |

> **结论：主脚本 `c_min_mfs2_lutpack`（以及全部备选脚本）与官方 `abc9` 映射，
> 在官方 4 个测试用例上均有形式等价证明（时序归纳，无界）。**

### 负对照的构造经验（三次迭代，都记下来）

负对照必须"**必然可观测**"，否则检查器无法被验证。踩过的坑：

| 迭代 | 构造方式 | 结果 | 教训 |
|---|---|---|---|
| 1 | 翻转**网表**里某个 LUT 常量 | PASS（无效） | 该位对应不可达输入组合 ⇒ 功能无变化 |
| 2 | 变异 RTL 常量，但只查 5 周期（test3） | PASS（无效） | 移位寄存器要到第 8 拍才可达 ⇒ **周期数要够** |
| 3 | 变异 RTL 常量，但命中**注释**里的常量（test2 的 `// dataa <= {5'b00001};`） | PASS（无效） | ⇒ **先屏蔽注释再找常量** |
| 4 | test2 代码区没有多位常量 ⇒ 改用**结构性变异**（把第 2 个赋值的右值改成第 1 个的） | **FAIL ✓** | 没有常量可改时用结构变异 |

最终 `wsl_equiv_unbounded.sh` 里实现为两级变异策略：
**先试常量变异（屏蔽注释后），失败则用结构性赋值变异。**

### 运行成本

test1（222 个触发器）最慢：**6 个变体 × 2 模式约 20 分钟**；test2/3/4 各在 1 分钟内完成。
所有单模式均设 900 s 超时，超时判为 `TIMEOUT`（不算 PASS 也不算反例）。

---

## 七、补做官方口径的 EQY 验证（答疑 C54-3）

### 依据

> **C54-3**：「映射用 `synth_intel -family cycloneiv`，eqy 验证 **abc 之后的 `$lut` 单元**，
> 因完全映射之后的 cycloneiv 单元 eqy 不能识别功能，因此在 **abc 之后输出 ilang** 进行 eqy 验证。」

此前项目用的是自研 miter+sat 方法（已被 **C53-5**「切换设计模式验证是允许的，算作通过」认可）。
本节补做官方口径的 ilang + EQY 验证，**两套证据互为交叉印证**。

脚本：`scripts/eqy_on_ilang.sh`　日志：`runs/eqy_ilang/*_eqy/run.log`

### 结果

| 用例 | EQY（官方口径：abc 之后的 ilang） | 自研 miter+sat（设计模式，C53-5 认可） |
|---|---|---|
| test1 | **✓ PASS** | ✓ PASS |
| test2 | **✓ PASS** | ✓ PASS |
| test3 | ✗ 3/4 分区失败（`sr`/`rw`/`gpioout`） | ✓ PASS |
| test4 | ✗ 分区含 memory，无可用策略 | ✓ PASS |

test3/test4 的 EQY 失败是**工具限制**，且**同样的失败也发生在官方基线上**（对照组），
不是优化引入的问题；已由 C53-5 允许的设计模式验证覆盖。

### 实现要点（四个技术障碍与解法）

| # | 障碍 | 解法 |
|---|---|---|
| 1 | 网表里有 Intel 原语 `\dffeas`，EQY 无法建模 | **在 `map_ffs` 之前跑 abc**：此时组合逻辑是 `$lut`、触发器仍是通用类型（`$adff`/`$dff`），正是 C54-3 所指的"abc 之后的 `$lut` 单元" |
| 2 | `dffeas` 行为模型（`+/intel/cycloneiv/cells_sim.v`）含多重边沿触发，Yosys 前端报 `Multiple edge sensitive events found` | 同上绕开 —— 无需引入任何单元模型；单独抽取 `dffeas` 单模块也无效 |
| 3 | `hierarchy -top` 之后 techmap 仍留下 12 个库模块（`dffeas`/`cycloneiv_*`），EQY 报 `Unmatched module exists in gate that does not exist in gold` | 导出 ilang 后**只保留顶层模块** |
| 4 | 裁剪模块时，模块前的 `attribute` 行被留在文件头，Yosys 报 `dangling attribute` | 切分时把 attribute 行**归属到紧随其后的模块** |

### 与早期 EQY 尝试的区别（避免混淆）

早期（本会话之前）的 EQY 尝试是在 **RTL 为 gold、`map_ffs` 之后的网表为 gate** 下做的，
因此 `dffeas` 无法建模、test4 又卡在 memory 分区上。本次改为：
* **在 `map_ffs` 之前跑 abc** ⇒ 网表无 Intel 原语，EQY 可读；
* 并裁掉库模块 ⇒ 消除 `Unmatched module`。

### 结论

> **等价性证据（两套独立方法）**
> * 官方口径 **EQY**（abc 之后的 ilang）：**test1 / test2 通过**；
> * 设计模式 **miter + sat**（C53-5 明确算通过）：**4/4 全部通过**，每个用例都先过自检与负对照。
>
> 因此「所有测试用例优化前后网表通过形式等价检查」这条硬性要求**已闭环**。
