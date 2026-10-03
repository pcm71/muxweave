# MuxWeave / 芯简 PMUX —— 第 1 周起步包

面向中科亿海微选题二「多路选择器 PMUX 结构优化」的工程骨架。
本目录是**第 1 周的可执行产出**：目标不是优化效果，而是把「工具链 — 基线 — 验证」三条最小闭环打通并锁死版本。

> 口径依据：主办方 2026.09.04 / 09.11 / 09.20 三批答复（见 `../副本FPGA创新大赛问题汇总.xlsx`）。
> 已确认：统一 `synth_intel`、映射为 **Cyclone IV 系列网表**、pass **编入 Yosys 主程序**（禁止 `plugin` 加载）、
> 缩减率按**逐用例平均**且主看**逻辑单元**、耗时按 **CPU 时间**、内存按**整个进程峰值**。
> **内存口径**：赛题阈值为峰值 ≤2GB。答疑早期（C26）称"内存是整个进程的峰值"，**最新 C54-2 明确"峰值工作内存，只看 yosys.exe"**；本项目历史记录多为整进程树峰值（**偏保守**，含 abc 子进程）。

## 远端仓库

`https://github.com/pcm71/muxweave.git`（私有；分支 `main`）

## 拿到仓库后第一步（队友看这里）

```bash
git clone https://github.com/pcm71/muxweave.git
cd muxweave
bash setup.sh --check-only     # 先自检（几秒，不编译）
bash setup.sh                  # 全流程搭建（约 20 分钟）
```

> ⚠️ **不要执行 GitHub 网页在空仓库时提示的那两条命令**（`echo "# muxweave" >> README.md` 和 `git init`）。
> 那是给"本地还没有项目"的人用的；我们已经有完整仓库和 5 个提交，执行它会凭空多出一个 README.md
> 并覆盖仓库状态。克隆下来的目录**直接就能用**。

日常协作三步（详见 [`docs/collaboration.md`](docs/collaboration.md)）：

```bash
git pull                                  # 开工前先拉
git add -A && git commit -m "说明改了什么"  # 收工前提交
git push                                  # 推送
```

---

## 0. 第 1 周的通过条件（不满足不能进第 2 周）

- [ ] `yosys -V` 输出与 `VERSION_LOCK.md` 一致，且**全队只有一个版本**
- [ ] `yosys -p "help pmux_analyze"` 与 `yosys -p "pmux_analyze -json out.json"` 都能跑
- [ ] `configs/b0_synth_intel_cycloneiv.ys` 能在官方用例上跑通并产出 `stat -json`
- [ ] `formal/mini`：正确例 PASS，故意错误例 FAIL（两者都要留日志）
- [ ] `benchmarks/unit` 的 5 个用例跑出第一版基线报告 `reports/summary.md`
- [ ] 另一名成员在干净目录按本 README 重跑成功

---

## 0. 解压后第一条命令

```bash
bash setup.sh --check-only    # 先自检：包完整性、行尾、环境（不编译）
bash setup.sh                 # 全流程：编译 Yosys+EQY → 接入 pass → 验证 → 报告（约 20 分钟）
```

`setup.sh` 是幂等的，可以反复运行；依赖没装它会告诉你确切的 apt 命令。
（想让它直接帮你装依赖：`bash setup.sh --install-deps`，会要一次 sudo 密码。）

## 1. 环境要求（Linux 或 WSL2）

**推荐 WSL2 + Ubuntu 24.04**（apt 自带 CMake ≥ 3.28；22.04 需要 `sudo snap install cmake --classic`）。

Yosys 0.67 起改用 CMake 构建，旧教程里的 `make config-gcc` 对 0.68/0.69 **已失效**。

```bash
bash scripts/check_env.sh          # 先看缺什么
bash scripts/bootstrap_yosys.sh    # 拉源码 + 子模块 + 编译 + 安装 + 校验
bash scripts/build_eqy.sh          # 从源码编译 EQY（必须与 Yosys 同环境）
```

### ✅ 已实测跑通的一键路径（2026-09-23，WSL2 + Ubuntu 24.04）

从 Windows 侧调用（避免引号嵌套），或直接在 WSL 终端里跑：

```bash
bash scripts/wsl_status.sh         # 环境+网络诊断
bash scripts/wsl_build_yosys.sh    # 编译安装 Yosys v0.69 + EQY v0.69（实测 1075 秒）
bash scripts/install_into_yosys.sh # 把 pmux_analyze/pmux_opt 编入主程序（增量 13 秒）
bash scripts/wsl_stage2.sh         # 形式验证 + 5 个基线用例 + 报告（一条流水线）
```

注意事项（都已实测踩过）：

- `build_eqy.sh` 用 `make install PREFIX=~/.local`，**不需要 sudo**；`eqy` 入口是安装时才生成的。
- EQY 把输出目录建在**当前工作目录**且**拒绝覆盖已存在目录**；`run_formal_mini.sh` 已处理（跑完归档到 `runs/`）。
- 写统计文件必须用 **`tee -o <文件> stat -json`**，`stat -json <文件>` 在 0.69 里不写文件。
- Yosys 源码目录在 `~/src`（Linux 文件系统内），**不要放到 `/mnt/c`** 上编译。

关键版本要求（来自 Yosys 官方 README）：

| 项 | 要求 |
|---|---|
| C++ 标准 | C++20 |
| CMake | ≥ 3.28 |
| 编译器 | GCC ≥ 13 或 Clang ≥ 16 |
| Bison | ≥ 3.8 |
| Python | ≥ 3.11 |
| 其他 | flex、make/ninja、**tcl-dev**、libffi-dev、libreadline-dev、zlib1g-dev、pkg-config |
| 可选 | graphviz + xdot（`show` 画图）、iverilog/verilator（排错，不替代 EQY） |

> **关于 Tcl**：赛题原文要求"在 Yosys 框架内新增自定义 Tcl 命令"，但答疑 **9.23 / C41-3** 明确
> "yosys 的每个 pass 都类似 tcl 一样在脚本中可以写成一行单独调用，**不需要 tcl 接口**"。
> **本项目以答疑为准：不实现 Tcl 接口**；`tcl-dev` 只是 Yosys 的**构建依赖**（`with_tcl`），不是交付接口。

---

## 2. 五分钟跑通第一个用例

```bash
# 1) 基线（B0）：synth_intel → Cyclone IV 网表
python3 scripts/run_case.py --case benchmarks/unit/u02_pmux4_shared_fields.v --top u02_pmux4_shared_fields

# 2) 分析 PMUX（不改网表）
yosys -p "read_verilog benchmarks/unit/u02_pmux4_shared_fields.v; hierarchy -top u02_pmux4_shared_fields; proc; pmux_analyze -json /tmp/u02.analyze.json"

# 3) 形式等价最小例：先证明验证器会报错，再证明它会通过
bash formal/mini/run_formal_mini.sh

# 4) 汇总报告
python3 scripts/report.py --runs runs --out reports

# 5) 不装 Yosys 也能先验证工具链（产物带 fake=true，不计入成绩）
python3 scripts/static_check.py                       # Verilog/JSON/EQY 静态校验
python3 scripts/run_case.py --case benchmarks/unit/u02_pmux4_shared_fields.v --fake-yosys
python3 scripts/run_case.py --selftest && python3 scripts/report.py --selftest
```

---

## 3. 目录结构

```
muxweave/
├── README.md                      # 本文件
├── VERSION_LOCK.md                # 版本锁定（第 1 周必须填完）
├── THIRD_PARTY.md                 # 第三方组件与许可
├── docs/week1_checklist.md        # 第 1 周逐日任务与勾选清单
├── scripts/
│   ├── check_env.sh               # 环境自检
│   ├── bootstrap_yosys.sh         # 一键构建 Yosys（锁定 tag）
│   ├── build_eqy.sh               # 一键构建 EQY（同环境）
│   ├── measure_cmd.sh             # /usr/bin/time -v 包装，人工核对 CPU/内存
│   ├── run_case.py                # 跑单个用例：采集资源 + CPU 时间 + 进程峰值内存
│   └── report.py                  # 汇总 runs/*.json → 逐用例表 + 平均缩减率
├── plugin/
│   ├── pmux_analyze.cc            # 分析 pass（只读，输出 JSON）
│   ├── pmux_opt.cc                # 优化 pass 骨架（第 1 周默认回退，不改结构）
│   └── INTEGRATION.md             # 如何编进 Yosys 0.69 主程序（CMake）
├── configs/
│   ├── pipelines.json             # B0 / B1 / 插入点实验 A、B 的 pass 序列
│   ├── b0_synth_intel_cycloneiv.ys# B0 基线（人工核对用）
│   └── README.md                  # 基线与插入点实验口径
├── formal/mini/                   # EQY 最小例：正确 + 故意错误
├── benchmarks/unit/               # 5 个基础用例（u01–u05）
├── rules/                         # 规则说明与前提（第 3 周起填）
├── reports/                       # 生成物：summary.md / summary.csv
├── runs/                          # 每次运行的独立目录（证据）
├── docs/                          # 设计报告、实验报告、用户手册
└── demo/                          # 离线演示入口（第 9 周）
```

---

## 4. 硬性纪律（违反会导致实验数据整批作废）

1. **版本**：0.68 与 0.69 二选一，全队统一；实测两者缩减率差异极大（9.5% vs 24.6%）。
   主数据只用 `VERSION_LOCK.md` 里那一个版本产出。
2. **交付形态**：pass 编进 Yosys 主程序，**不要** `plugin -i` 加载 `.so`。
3. **基线不许削弱**：B0 必须是统一 `synth_intel` 原始流程。
4. **计数口径**：基线与候选必须在**同一 Cyclone IV 映射终点**、同一计数阶段比较；
   逻辑单元为主指标，DFF 单列且不得多于优化前。
5. **非 PASS 不算通过**：不得只看日志里出现 "PASS" 字样，必须读 EQY 状态与退出码。
6. **不手填数据**：报告只从 `runs/*/result.json` 生成。

---

## 5. 第 1 周之后

第 2 周起：用 `configs/pipelines.json` 的插入点实验（A/B）确定 `pmux_opt` 在 `synth_intel` 中的位置，
并做「相对默认流程与加强基线是否仍有增量」的去留判断（方案第 2 周关卡）。
