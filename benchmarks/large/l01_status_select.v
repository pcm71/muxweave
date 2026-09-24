// l01_status_select.v —— 应用样本：多源状态字选择（寄存器读回风格）
// 结构：32 位、K=8 的 PMUX，且**字段有明显重复**（高 16 位只有两个来源，低 16 位来自 8 个源）
//       —— 正是"跨位分组共享"最该有收益的形态，用来检验 ABC 杠杆在真实字段结构上的效果。
// 规模：约百级单元。
module l01_status_select (
    input  wire        clk,
    input  wire        rst,
    input  wire [2:0]  sel,
    input  wire [31:0] src0, src1, src2, src3,
    input  wire [31:0] src4, src5, src6, src7,
    output reg  [31:0] dout
);
    reg [31:0] muxed;

    // 高 16 位：分支 0~3 都取 src0，分支 4~7 都取 src4（组内 4 个分支共用）
    // 低 16 位：8 个分支各取一个源
    always @* begin
        (* parallel_case *)
        case (sel)
            3'd0: muxed = {src0[31:16], src0[15:0]};
            3'd1: muxed = {src0[31:16], src1[15:0]};
            3'd2: muxed = {src0[31:16], src2[15:0]};
            3'd3: muxed = {src0[31:16], src3[15:0]};
            3'd4: muxed = {src4[31:16], src4[15:0]};
            3'd5: muxed = {src4[31:16], src5[15:0]};
            3'd6: muxed = {src4[31:16], src6[15:0]};
            3'd7: muxed = {src4[31:16], src7[15:0]};
        endcase
    end

    // 混合组合逻辑：掩码 + 字节交换
    wire [31:0] masked = muxed & src1;
    wire [31:0] swapped = {masked[23:16], masked[31:24], masked[7:0], masked[15:8]};

    always @(posedge clk) begin
        if (rst) dout <= 32'h0000_0000;
        else     dout <= swapped ^ src2;
    end
endmodule
