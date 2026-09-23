// e07_k8_grouped.v —— e06 的手工跨位分组改写（与 e06 功能完全等价）
// 高字节：sel<4 选 x，否则选 z        （一套控制覆盖 8 个位）
// 低字节：sel<2 选 x，sel<6 选 z，否则 w（一套控制覆盖 8 个位）
// 若 synth_intel 之后 e07 不比 e06 少，说明"跨位分组共享"这条路在官方后端下没有空间。
module dut (
    input  wire [2:0]  sel,
    input  wire [15:0] x,
    input  wire [15:0] z,
    input  wire [15:0] w,
    output wire [15:0] y
);
    wire hi_lo = (sel < 3'd4);          // 高字节：分支 0-3
    wire lo_lo = (sel < 3'd2);          // 低字节：分支 0-1
    wire lo_mid = (sel < 3'd6);         // 低字节：分支 2-5

    assign y = { hi_lo ? x[15:8] : z[15:8],
                 lo_lo ? x[7:0]  : lo_mid ? z[7:0] : w[7:0] };
endmodule
