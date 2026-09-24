// l04_scale_bank.v —— 规模压力：由 generate 展开的并行选择阵列
// 结构：LANES 条通道，每条含一个 32 位 K=4 的 PMUX + 加法/掩码逻辑，全部共用同一 sel。
// 每条通道用**不同的常数**参与运算，避免不同通道被优化折叠成同一结构
//   （早先版本每条通道只差 1 个 bit，结果 8 条通道塌缩成 32 个单元，没能起到规模压力作用）。
// 调规模只改 LANES：LANES=4 ≈ 300、LANES=8 ≈ 600、LANES=12 ≈ 1000 节点级。
module l04_scale_bank (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  sel,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [31:0] c,
    input  wire [31:0] d,
    output reg  [31:0] out
);
    localparam LANES = 12;

    wire [31:0] lane [0:LANES-1];
    genvar g;

    generate
        for (g = 0; g < LANES; g = g + 1) begin : LANE
            // 每条通道一个不同的常数（generate 里是编译期常量）
            localparam [31:0] KK = 32'h9E37_79B9 + g * 32'h0001_0001;

            wire [31:0] t0 = a + KK;          // 加法
            wire [31:0] t1 = b ^ KK;          // 异或
            wire [31:0] t2 = c & ~KK;         // 掩码
            wire [31:0] t3 = d | KK;          // 置位

            reg [31:0] m;
            always @* begin
                (* parallel_case *)
                case (sel)
                    2'd0: m = t0;
                    2'd1: m = t1;
                    2'd2: m = t2;
                    2'd3: m = t3;
                endcase
            end
            assign lane[g] = m;
        end
    endgenerate

    // 跨通道折叠（制造跨通道组合逻辑）
    reg [31:0] acc;
    integer k;
    always @* begin
        acc = 32'h0000_0000;
        for (k = 0; k < LANES; k = k + 1) acc = acc ^ lane[k];
    end

    always @(posedge clk) begin
        if (rst) out <= 32'h0;
        else     out <= acc + a;
    end
endmodule
