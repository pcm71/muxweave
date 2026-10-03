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
