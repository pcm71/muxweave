// e02_u02_grouped.v —— 手工实现方案第 7 节的「跨位分组 + 共享选择子表达式」
//
// 原始 u02 的位级模式：
//   位 [7:4]：分支 {0,1} 都取 a，分支 {2,3} 都取 c    → 分组 e01 / e23
//   位 [3:0]：分支 {0} 取 a，{1,2} 取 b，{3} 取 d     → 分组 e0 / e12 / e3
// 因此"哪些分支会选择这类值"的控制表达式可以在 4 个位上共用（高位片共用一套，低位片共用一套）。
//
// 这是把 C++ 规则想做的事**手工写出来**，用来验证：
//   在 synth_intel（内部含 opt -fine -full + abc9 -lut 4）之后，这种结构改写到底能不能省单元。
// 功能与 e01 完全等价（sel 只有 4 个取值，case 全覆盖，默认分支不可达）。
module dut (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [7:0] y
);
    wire hi_e01 = (sel == 2'd0) | (sel == 2'd1);   // 高位片：选 a 的组
    wire lo_e0  = (sel == 2'd0);                   // 低位片：选 a
    wire lo_e12 = (sel == 2'd1) | (sel == 2'd2);   // 低位片：选 b

    assign y = { hi_e01 ? a[7:4] : c[7:4],
                 lo_e0  ? a[3:0] : lo_e12 ? b[3:0] : d[3:0] };
endmodule
