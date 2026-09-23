// e03_u02_decoded.v —— 另一种改写：显式一热译码 + 或合并
// 思路：sel 只有 4 个取值，ohe 必然恰好一位有效，所以"没有命中"的默认路径是死代码，可以整块删掉。
// 用途：验证"利用 $pmux 多选未定义 / 默认路径不可达"这一杠杆能否省单元。
module dut (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [7:0] y
);
    wire [3:0] ohe = { (sel == 2'd3), (sel == 2'd2), (sel == 2'd1), (sel == 2'd0) };

    // 按位分组后直接用一热信号做与-或合并（多选情况在本题语义下不会出现）
    wire [7:0] t0 = ohe[0] ? {a[7:4], a[3:0]} : 8'h00;
    wire [7:0] t1 = ohe[1] ? {a[7:4], b[3:0]} : 8'h00;
    wire [7:0] t2 = ohe[2] ? {c[7:4], b[3:0]} : 8'h00;
    wire [7:0] t3 = ohe[3] ? {c[7:4], d[3:0]} : 8'h00;

    assign y = t0 | t1 | t2 | t3;
endmodule
