// formal/mini/gate_ok.v —— 等价实现（gate，应当 PASS）
// 与 gold.v 功能完全一致，但结构不同（三元链而非 case），用于证明验证器
// 能够对"结构不同但功能相同"的两个设计判定等价。
module mini (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [7:0] y
);
    assign y = (sel == 2'd0) ? a :
               (sel == 2'd1) ? b :
               (sel == 2'd2) ? c : d;
endmodule
