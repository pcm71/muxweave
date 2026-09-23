# VERSION_LOCK —— 工具链版本锁定

> **第 1 周必须填完并在全队同步。** 任何一个字段为空，第 1 周关卡不算通过。
> 规则：0.68 与 0.69 **二选一**，主数据只由该版本产出；换版本必须全量重跑基线并重出报告。

## 1. 决策记录

| 项 | 值 | 负责人 | 日期 |
|---|---|---|---|
| 选定 Yosys 版本（只能一个） | ☑ **`v0.69`**　☐ `v0.68` | 待填 | 2026-09-23 |
| 决策依据 | 主办方 9.20 答复：官方基准为 0.68（出题时 0.69 未发布），**若 0.69 效果更好则统一在 0.69 上开发**；0.69 含 ABC 相关改动，实测同用例差异显著（9.5% vs 24.6%）。故选定 0.69 为唯一成绩版本。 | 待填 | 2026-09-23 |
| 是否启用 Tcl 支持 | ☑ **是**（已确认 `with_tcl` 启用，`yosys -c` 可用） | 待填 | 2026-09-23 |

**已核实的外部事实（2026-09-23 查证）**

- Yosys `v0.69` 发布日 **2026-09-09**；`v0.68` 发布日 **2026-08-05**。
- 0.69 的发布说明含 **ABC 相关改动**：移除 `abc` pass 的 sum-of-products 参数；
  从综合 pass 移除 `-abc` / `-abc2` / `-noabc9` / `-retime`。
  → 这与"0.69 把 MUX 树映射得更好、同用例 9.5% vs 24.6%"的观测一致；
  调优 abc 脚本必须按 0.69 的新参数写。
- 0.67 起构建系统改为 **CMake ≥ 3.28**，编译器 **GCC ≥ 13 / Clang ≥ 16**，**C++20**。

## 2. 锁定值（已回填，2026-09-23 实测）

| 组件 | 版本 / 标识 | 来源 | 校验命令与输出 |
|---|---|---|---|
| Yosys tag | **`v0.69`** | github.com/YosysHQ/yosys | `git describe --tags` → `v0.69` |
| Yosys commit | **`9f75ca1f9834a39a863915b5dae0c7b1e33533bc`** | 同上 | `git rev-parse HEAD` |
| Yosys 构建输出 | **`Yosys 0.69 (git sha1 9f75ca1f9-dirty, Release, GNU /usr/bin/c++ 13.3.0)`** | 本机 | `yosys -V` |
| ABC 子模块 commit | **`a51bf4a7bb38ce06ea3a544b1463b40832213917`** | `yosys/abc` | `git -C abc rev-parse HEAD` |
| EQY tag | **`v0.69`**（与 Yosys 对应） | github.com/YosysHQ/eqy | `git -C eqy describe --tags` |
| EQY commit | **`4a72eb94fc253062464afee4d0018359017bb846`** | 同上 | `git -C eqy rev-parse HEAD` |
| EQY 安装路径 | **`/home/ylk/.local/bin/eqy`**（`make install PREFIX=~/.local`，无需 sudo） | 本机 | `command -v eqy` |
| EQY 插件目录 | **`~/.local/share/yosys/plugins`**（3 个 .so，必须与 Yosys datdir 一致） | 本机 | `ls $PREFIX/share/yosys/plugins/*.so` |
| 编译器 | **`g++ (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0`** | 本机 | `g++ --version` |
| CMake | **`3.28.3`**（满足 ≥ 3.28） | 本机 | `cmake --version` |
| Python | **`3.12.3`** | 本机 | `python3 --version` |
| Tcl | **8.6.14**（头文件 `/usr/include/tcl8.6/tcl.h`） | 本机 apt `tcl-dev` | `dpkg -l tcl-dev` |
| SMT 求解器 | **不需要**（第 1 周 EQY 用内置 `sat` 策略） | — | 切到 `[strategy sby]` 时再登记 |

> 关于 `-dirty`：因为自研 pass 源码已加入 `passes/pmux/`（未提交），属预期状态。
> 版本证据另存 `runs/VERSION_LOCK.generated.md`（构建脚本自动生成）。

## 3. 构建参数

| 项 | 值 |
|---|---|
| 源码目录 | `~/src/yosys`（Linux 文件系统内，**不在 /mnt/c**，避免跨文件系统编译慢） |
| 构建目录 | `~/src/yosys/build` |
| CMake 参数 | `-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local` |
| 启用的关键特性 | `with_abc`、`with_tcl`、`with_libffi`、`with_zlib`、`have_plugins` |
| 未启用 | `with_python`、`with_verific`、`with_editline`（不需要） |
| 并行度 | 5（按内存自适应：WSL 内存 7777 MB，避免 OOM；机器 32 核但不能全用） |
| 构建命令原文 | `cmake -B build . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local && cmake --build build --config Release --parallel 5 && cmake --install build --strip` |
| 首次编译耗时 | **1075 秒**（约 18 分钟） |
| 加入自研 pass 后增量编译 | 12 秒 |

## 4. 复现声明

| 项 | 状态 |
|---|---|
| 能在干净环境复现的人 | ☐ 待队友复现（REQ07） |
| 复现步骤 | `bash scripts/check_env.sh` → `bash scripts/bootstrap_yosys.sh` → `bash scripts/build_eqy.sh` → `bash scripts/install_into_yosys.sh` |
| 环境 | WSL2 + Ubuntu 24.04.5 LTS，内核 6.18.33.2-microsoft-standard-WSL2 |
| 已知偏差 | 无（基线用例 CPU 时间 0.19~0.21 s、整进程峰值 28~29 MB，远低于 60 s／2 GB 门槛） |

## 5. 变更日志

| 日期 | 变更 | 原因 | 是否重跑全套基线 |
|---|---|---|---|
| 2026-09-23 | 初始化并锁定 v0.69 / EQY v0.69 | 第 1 周立项 | — |
| 2026-09-23 | pass 编入主程序（`passes/pmux/`），创建 `passes/CMakeLists.txt` 注册行 | 满足 REQ01／REQ10 | 增量编译后重跑 5 用例 |
| 2026-09-23 | 修正 `stat -json` 写法为 `tee -o <file> stat -json` | 0.69 中前者不写文件 | 是（重跑 5 用例） |
| 2026-09-23 | 修正分析器"复用位"判定（排除无复用的同构模式假信号） | 普通 2 选 1 被误判为有机会 | 是（重跑 5 用例） |
