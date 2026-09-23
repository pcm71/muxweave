# 分支与提交规范

> 核心原则：**`main` 上任何一个提交都必须是"随时能复现、验证全过"的状态。**
> 所有实验性改动都走 `exp/*` 分支，结论稳定后再合回 main。

---

## 1. 分支模型

| 分支 | 用途 | 进入条件 |
|---|---|---|
| `main` | 稳定线。任何人 clone 下来跑 `bash setup.sh` 都能得到一致结果 | 必须 `setup.sh --check-only` + `wsl_stage2.sh` 四阶段全 PASS |
| `exp/<主题>` | 实验分支（插入点、规则原型、性能优化…） | 随便建，允许失败；**不得直接改 main** |
| `fix/<主题>` | 缺陷修复 | 修复后补一条回归用例再合回 |
| `docs/<主题>` | 纯文档改动 | 内容准确即可 |

**里程碑用 tag 固化**（比分支更稳，不会被后续提交移动）：

```bash
git tag -a week1-baseline -m "第 1 周基线：四阶段全 PASS"     # 已打
git tag -a week2-insertion -m "第 2 周：插入点实验完成"        # 待打
git push --tags
```

回到某个已验证状态：

```bash
git checkout week1-baseline        # 只读查看
git switch -c rescue week1-baseline  # 想在此基础上改
```

## 2. 当前状态（2026-09-23）

| 项 | 值 |
|---|---|
| 远端 | `https://github.com/pcm71/muxweave.git`（私有） |
| `main` | `28e5eae`（第 2 周插入点实验已合并；`--no-ff` 保留实验分支记录） |
| tag | `week1-baseline`（第 1 周四阶段全 PASS）、`week2-insertion`（插入点实验完成） |
| 已归档分支 | `exp/insertion-point` @ `b67cfaa`（已完成使命，可保留作证据或删除） |

**第 2 周实验结论摘要**（详见 [`week2_insertion_point.md`](week2_insertion_point.md)）：

- 加强基线 `B1` 与官方基线 `B0` **完全等价**（8 用例合计 284 vs 284 单元）——
  `synth_intel` 内部已含 `opt_expr/wreduce/peepopt/opt -fine -full/abc9 -lut 4`，
  外部叠加的 `opt_reduce/opt_merge/opt_muxtree/opt_share` 无增量。
- 插入点选定 **`O_INSERT_A`：`proc` → `pmux_opt` → `synth_intel`**
  （必须在 synth_intel 之前：其内部 `proc` 后立刻 `opt`，末尾已整体映射为 LCELL，不再有 `$pmux`）。
- 自研 pass 未扰动网表（A/B 与基线逐用例一致），只读设计验证通过。

## 3. 日常操作

```bash
# 开工
git switch main && git pull
git switch -c exp/我的实验          # 或 git switch exp/已存在的分支

# 干活…（每次改动都提交，别攒）

# 收工
git add -A
git commit -m "exp: 插入点 A/B 对比；B1 加强基线已量化"
git push -u origin exp/我的实验
```

## 4. 合并回 main 的门槛（缺一不可）

1. `bash setup.sh --check-only` 通过
2. `bash scripts/wsl_stage2.sh` 四阶段全 PASS（形式验证 / 基线用例 / 报告）
3. 涉及的实验结论已写进 `docs/`，并**指明确切的 `runs/` 证据路径**
4. 没有把 `runs/`、`*.so`、二进制加进仓库（`.gitignore` 已排除，不要 `git add -f`）
5. 版本相关改动（Yosys/EQY 版本、构建参数）**必须**同步更新 `VERSION_LOCK.md` 并在群里公告

```bash
git switch main
git merge --no-ff exp/我的实验
git push
```

用 `--no-ff` 保留实验分支的合并记录，答辩时能清晰展示"做了哪些实验、结论是什么"。

## 5. 按目录分工（减少冲突）

| 角色 | 地盘 | 尽量别动 |
|---|---|---|
| A 算法/插件 | `plugin/` `configs/` | `scripts/` `docs/` |
| B 验证/评测 | `benchmarks/` `formal/` | `plugin/` |
| C 集成/展示 | `scripts/` `docs/` `reports/` | `plugin/` `configs/` |

公共文件（根 `README.md`、`VERSION_LOCK.md`）改动前**先在群里说一声**。

## 6. 提交信息约定

```
<类型>: <一句话说清改了什么>

类型：feat / fix / exp / docs / test / chore
```

写清**触发条件与验证范围**（方案第 17 节要求），例如：

```
fix: 分析器复用判定假信号（普通2选1不再报有机会）

- 原因：按"分组模式字符串相同"统计，2选1每位都是 g0|g1 被误判为共享
- 修法：只有含"分支复用"的模式才计入，并区分复用位/跨位共享
- 验证：重跑 u01-u05，u01 从 8/8 变为 0/0，u02/u03 保持 8/8、4/4
```

## 7. 大文件与证据

- `runs/`（运行证据，当前约 1.4 MB）**不入库**：它是可重生成的派生物
- 需要给队友看原始日志时，用 `git bundle` 或单独压缩包
- 答辩需要的证据：`docs/week1_report.md` 里有完整索引，指向 `runs/` 的具体文件
