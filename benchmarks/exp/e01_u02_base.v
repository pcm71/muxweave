// e01_u02_base.v —— 实验基线：与 benchmarks/unit/u02 功能完全相同，仅换模块名
// 用途：与"手工跨位分组版"在同一批运行里对比，排除机器/批次差异。
module dut (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output reg  [7:0] y
);
    always @* begin
        (* parallel_case *)
        case (sel)
            2'd0: y = {a[7:4], a[3:0]};
            2'd1: y = {a[7:4], b[3:0]};
            2'd2: y = {c[7:4], b[3:0]};
            2'd3: y = {c[7:4], d[3:0]};
        endcase
    end
endmodule
