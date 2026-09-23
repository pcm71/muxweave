# passes/pmux/CMakeLists.txt —— 自研 pass 的注册文件
#
# 本文件要复制到 Yosys 源码树的 passes/pmux/CMakeLists.txt。
# 写法与 Yosys 0.69 自带组完全一致（参考 passes/opt/CMakeLists.txt）：
#   yosys_pass(<名称> <源文件> [REQUIRES ...] [ENABLE_IF ...] [ESSENTIAL])
# 宏定义位置：cmake/YosysComponent.cmake 的 function(yosys_pass ...)
#
# 说明：这里刻意把两个自研 pass 放在独立子目录，好处是
#   ① 提交时 diff 极小（passes/CMakeLists.txt 只多一行 add_subdirectory(pmux)）；
#   ② 自研边界一目了然，答辩时便于说明"哪些是我们写的"。

yosys_pass(pmux_analyze
	pmux_analyze.cc
)
yosys_pass(pmux_opt
	pmux_opt.cc
)
