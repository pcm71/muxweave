# 把自研 pass 编入 Yosys 主程序（0.68 / 0.69，CMake）

> 主办方硬性要求：**统一做成一个 pass 编译到 yosys 主程序，不要使用 `plugin` 加载方案。**
> 因此不要用 `plugin -i xxx.so`，也不要在提交物里出现 `.so` 动态加载流程。

本文件里的注册方式**不是猜的**：2026-09-23 已在你本机的 `~/src/yosys`（v0.69，commit `9f75ca1`）
源码树里逐项核实，证据在 `runs/cmake_probe.txt` 与 `runs/cmake_probe2.txt`。

---

## 一、已核实的 Yosys 0.69 注册机制

| 事实 | 核实结果 |
|---|---|
| 顶层如何收集 passes | `CMakeLists.txt:400` → `add_subdirectory(passes)` |
| `passes/CMakeLists.txt` 长什么样 | **只有 11 行**，每行一个 `add_subdirectory(组名)`：cmds / equiv / fsm / hierarchy / memory / opt / pmgen / proc / sat / techmap / tests |
| 组级如何注册单个 pass | `passes/opt/CMakeLists.txt` 里逐条 `yosys_pass(名称 文件.cc)`，例如 `yosys_pass(opt_muxtree opt_muxtree.cc)` |
| 注册宏定义在哪 | `cmake/YosysComponent.cmake` 的 `function(yosys_pass ...)`（第 172 行） |
| 支持嵌套子目录吗 | 支持：`passes/opt/` 下还有 `clean/`、`dff/` 两个子目录 |
| 头文件包含路径 | 顶层有 `target_include_directories(yosys_common INTERFACE ${YOSYS_CMAKE_SOURCE_DIR})` → 我们用 `#include "kernel/register.h"` 直接可用 |
| `execute` 签名 | 参考 `passes/opt/opt_muxtree.cc`：`struct XxxPass : public Pass{ void help() override; void execute(vector<std::string> args, RTLIL::Design *design) override; }`，内部首行 `extra_args(args, 1, design);` |
| `ID::A/B/S/Y` 可用吗 | 可用：`opt_reduce.cc`、`opt_share.cc`、`wreduce.cc` 都在用 `ID::S`，`$mux/$pmux` 处理参考这几个文件 |
| 有现成 JSON 工具吗 | 有：`kernel/json.h`（`passes/sat/sim.cc` 在用）；我们目前自带手写序列化，避免依赖细节 |

## 二、推荐做法：一键脚本

```bash
bash scripts/install_into_yosys.sh
```

它幂等地完成 6 步，并自动产出证据 `runs/REQ10_integration_evidence.md`：

1. 前置检查（Yosys 已构建安装到 `~/.local`）
2. 复制 `plugin/*.cc` 与 `plugin/CMakeLists.txt` → `$YOSYS/passes/pmux/`
3. 向 `passes/CMakeLists.txt` **追加一行** `add_subdirectory(pmux)`（已存在则跳过）
4. 重新配置 + 编译 + 安装（只新增两个源文件 + 重链接，通常几分钟）
5. 自检：`help pmux_analyze`、`help pmux_opt`，并对 `s ? b : a` 小例跑分析，确认产出 JSON
6. 写证据（git status、注册文件、版本、help 输出、自检 JSON）

## 三、手工做法（等价，3 条命令）

```bash
PROJ=/mnt/c/Users/LEGION/Desktop/PMUX/muxweave
Y=$HOME/src/yosys

mkdir -p "$Y/passes/pmux"
cp "$PROJ/plugin/pmux_analyze.cc" "$PROJ/plugin/pmux_opt.cc" "$PROJ/plugin/CMakeLists.txt" "$Y/passes/pmux/"

grep -q "add_subdirectory(pmux)" "$Y/passes/CMakeLists.txt" || echo "add_subdirectory(pmux)" >> "$Y/passes/CMakeLists.txt"

cd "$Y" && cmake -B build . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  && cmake --build build --config Release --parallel 5 \
  && cmake --install build --strip
```

`passes/pmux/CMakeLists.txt` 的内容（与自带组同构）：

```cmake
yosys_pass(pmux_analyze
	pmux_analyze.cc
)
yosys_pass(pmux_opt
	pmux_opt.cc
)
```

## 四、校验清单（缺一不可）

```bash
export PATH="$HOME/.local/bin:$PATH"

yosys -V                                   # 版本未变
yosys -p "help pmux_analyze"               # 能打印帮助
yosys -p "help pmux_opt"                   # 能打印帮助

# 最小功能自检：s ? b : a 会产生一个 $mux
cat > /tmp/t.v <<'EOF'
module t(input s, input [3:0] a, input [3:0] b, output [3:0] y);
  assign y = s ? b : a;
endmodule
EOF
yosys -p "read_verilog /tmp/t.v; hierarchy -top t; proc; pmux_analyze -table -json /tmp/t.json"
test -s /tmp/t.json && echo "JSON OK"

# Tcl 入口自检（**说明**：赛题原文要求"在 Yosys 框架内新增自定义 Tcl 命令"，但答疑 9.23 / C41-3 明确
# "yosys 的每个 pass 都类似 tcl 一样在脚本中可以写成一行单独调用，**不需要 tcl 接口**"。
# 本项目**以答疑为准、不实现 Tcl 接口**，以下仅为构建期的冒烟检查。）
printf 'yosys read_verilog /tmp/t.v\nyosys hierarchy -top t\nyosys proc\nyosys pmux_analyze\n' > /tmp/t.tcl
yosys -c /tmp/t.tcl
```

> `-c` / `tcl` 的确切入口名以 `yosys -h` 为准。本机构建已确认 **with_tcl 已启用**
> （CMake 日志：`* with_tcl, Tcl scripting and SDC parsing`）。

## 五、常见坑（按已核实信息更新）

| 现象 | 原因 | 处理 |
|---|---|---|
| `unknown command: pmux_analyze` | `passes/CMakeLists.txt` 没有 `add_subdirectory(pmux)`，或没重新 `cmake -B build` | 检查注册行并重新配置后再 build |
| `help` 有了但运行报网络/符号错 | 只 build 没 install，或跑的是旧二进制 | 确认 `command -v yosys` 指向 `~/.local/bin/yosys` |
| 编译报 `ID::S` 未定义 | 极罕见（0.69 里确实存在） | 退路：改用 `RTLIL::escape_id("S")` |
| 编译报 `execute` 签名不匹配 | API 变动 | 抄 `passes/opt/opt_muxtree.cc` 的签名 |
| 想用 `plugin -i` 省事 | **主办方明令禁止** | 不要用；本方案走编入主程序 |
| 重新配置后没生效 | CMake 缓存 | `rm -rf build` 后重新 `cmake -B build .`（最后手段，会全量重编） |

## 六、交付形态的自我证明（答辩用）

- `git -C $YOSYS status --porcelain` 只应出现：新增 `passes/pmux/`（3 个文件）+ 修改 `passes/CMakeLists.txt`（1 行）
- 全流程**没有** `plugin -i`、没有 `.so` 动态加载
- 这两条已由 `runs/REQ10_integration_evidence.md` 自动留档
