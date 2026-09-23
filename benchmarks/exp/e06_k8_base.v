// e06_k8_base.v —— K=8 大分支基线（最强机会测试）
// 8 分支 × 16 位，位级重复度很高：
//   高字节 [15:8]：分支 0-3 取 x，分支 4-7 取 z          → 2 组，组内 4 个分支共用
//   低字节 [7:0] ：分支 0-1 取 x，分支 2-5 取 z，6-7 取 w  → 3 组
// 这是"跨位分组共享"理论上最该有收益的形态（分支多、组内成员多）。
module dut (
    input  wire [2:0]  sel,
    input  wire [15:0] x,
    input  wire [15:0] z,
    input  wire [15:0] w,
    output reg  [15:0] y
);
    always @* begin
        (* parallel_case *)
        case (sel)
            3'd0: y = {x[15:8], x[7:0]};
            3'd1: y = {x[15:8], x[7:0]};
            3'd2: y = {x[15:8], z[7:0]};
            3'd3: y = {x[15:8], z[7:0]};
            3'd4: y = {z[15:8], z[7:0]};
            3'd5: y = {z[15:8], z[7:0]};
            3'd6: y = {z[15:8], w[7:0]};
            3'd7: y = {z[15:8], w[7:0]};
        endcase
    end
endmodule
