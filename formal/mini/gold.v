// formal/mini/gold.v —— 参考设计（gold）
// 4 选 1、8 位宽的数据选择：这是本题 PMUX 的典型形态。
// 注意：EQY 里 gold 侧必须是**原始参考设计**，不允许为了让验证通过而改动它。
module mini (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output reg  [7:0] y
);
    always @* begin
        case (sel)
            2'd0: y = a;
            2'd1: y = b;
            2'd2: y = c;
            2'd3: y = d;
        endcase
    end
endmodule
