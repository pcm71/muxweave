// u05_negative_no_mux.v —— 类别：负对照（无目标结构）
// 纯算术逻辑，不含任何多路选择结构。
// 期望：pmux_analyze 报告 $pmux=0, $mux=0，并明确说明"没有目标结构"，
//       而不是报错、也不是硬凑出目标。
// 这个用例与正例同等重要：它证明工具能区分"没有目标结构"与"工具运行失败"。
module u05_negative_no_mux (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] tmp = {1'b0, a} + {1'b0, b} + {{8{1'b0}}, cin};
    assign sum  = tmp[7:0];
    assign cout = tmp[8];
endmodule
