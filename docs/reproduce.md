# 复现指南（REQ07）

目标：**另一名成员在干净目录、按本文件重跑，得到与 `docs/week1_report.md` 一致的结果。**
本文件是第 1 周关卡「队友独立复现」的执行依据。

---

## 1. 前置环境

- Windows 11 + **WSL2 + Ubuntu 24.04**（或任意 Linux；原生 Windows 不作为主环境）
- 磁盘 ≥ 20 GB 可用（Yosys 源码 152 MB + 构建产物 + 工具链）
- 网络能访问 `github.com` 与 `archive.ubuntu.com`

## 2. 一键复现步骤

```bash
# 0) 进入仓库（WSL 里路径形如 /mnt/c/.../muxweave）
cd /mnt/c/Users/<你的用户名>/Desktop/PMUX/muxweave

# 1) 环境诊断：应显示缺 cmake/gcc/bison/flex 等
bash scripts/check_env.sh

# 2) 装编译依赖（唯一需要 sudo 的一步，会要密码，输入时不显示字符）
sudo apt update && sudo apt install -y cmake ninja-build build-essential clang lld \
  bison flex gawk git make python3 pkg-config libffi-dev libfl-dev \
  libreadline-dev tcl-dev zlib1g-dev graphviz xdot

# 3) 诊断复查（可选）：应全 OK
bash scripts/wsl_status.sh

# 4) 编译安装 Yosys v0.69 + EQY v0.69（约 18 分钟；脚本按内存自动定并行度）
bash scripts/wsl_build_yosys.sh

# 5) 把自研 pass 编入 Yosys 主程序（增量编译约 13 秒）
bash scripts/install_into_yosys.sh

# 6) 形式验证 + 5 个基线用例 + 报告（一条流水线）
bash scripts/wsl_stage2.sh
```

> `PATH` 已由脚本内部导出（`~/.local/bin`、`~/src/eqy`）。若你手动执行命令，先：
> `export PATH="$HOME/.local/bin:$HOME/src/eqy:$PATH"`

## 3. 预期结果（对照 week1_report.md）

`bash scripts/wsl_stage2.sh` 末尾的总表应全部为 PASS：

```
阶段1 pass 编入主程序 : PASS
阶段2 EQY 正误最小例  : PASS
阶段3 5 个基础用例 B0 : PASS
阶段4 汇总报告        : PASS
```

`reports/summary.md` 中的基线数字应与你自己的机器**量级一致**（绝对值允许有小差异）：

| 用例 | 逻辑单元 | 复用位/跨位共享 | $pmux |
|---|---|---|---|
| u01_mux2_wide | 8 | 0/0 | 1 |
| u02_pmux4_shared_fields | 12 | 8/8 | 1 |
| u03_pmux4_const_and_default | 31 | 4/4 | 1 |
| u04_pmux8_narrow_onehot | 14 | 0/0 | 1 |
| u05_negative_no_mux | 20 | 0/0 | 0 |

**逻辑单元数与复用判定必须完全一致**（它们只取决于设计与工具版本）；
CPU 时间与内存会因机器不同而不同，只要求同一量级（秒级 / 几十 MB）。

## 4. 版本一致性检查（复现的核心）

```bash
yosys -V
# 期望：Yosys 0.69 (git sha1 9f75ca1f9..., Release, GNU ...)
git -C ~/src/yosys rev-parse HEAD
# 期望：9f75ca1f9834a39a863915b5dae0c7b1e33533bc
git -C ~/src/yosys/abc rev-parse HEAD
# 期望：a51bf4a7bb38ce06ea3a544b1463b40832213917
git -C ~/src/eqy rev-parse HEAD
# 期望：4a72eb94fc253062464afee4d0018359017bb846
```

**任何一项不一致，先对齐版本再跑** —— 0.68 与 0.69 的 ABC 差异会让结果完全不可比（实测 9.5% vs 24.6%）。

## 5. 已知坑（都已在脚本里处理，手动操作时注意）

| 坑 | 现象 | 正解 |
|---|---|---|
| `stat -json <文件>` 不写文件 | 指标全为 `None` | 用 `tee -o <文件> stat -json` |
| `eqy` 命令不存在 | `找不到 eqy` | `eqy` 是 `make install` 时生成的；用 `PREFIX=~/.local` 装，**无需 sudo** |
| EQY 目录不可重入 | `ERROR: Directory 'equiv_ok' already exists` | 跑前删同名目录（`run_formal_mini.sh` 已处理） |
| 在 `/mnt/c` 上编译 | 极慢 | 源码放 `~/src`（Linux 文件系统内） |
| CRLF 破坏 shell 脚本 | `bash: $'\r': command not found` | 仓库已带 `.gitattributes` 强制 LF；不要用 autocrlf=true 重写 |

## 6. 复现记录（由复现人填写）

| 项 | 值 |
|---|---|
| 复现人 | |
| 日期 | |
| 机器 / 发行版 | |
| 四个阶段是否全 PASS | |
| 逻辑单元数是否与上表一致 | |
| 偏差与原因 | |
| 结论（通过 / 不通过） | |

> 把关纪律：**不允许**只截取几张图就算复现通过；必须是"在干净目录从零跑完并留下 `runs/` 证据"。
> 复现不通过时，把 `runs/*.log` 一起提交，而不是只报"跑不起来"。
