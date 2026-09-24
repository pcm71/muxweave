// l02_config_regfile.v —— 应用样本：配置寄存器组 + 读回选择（含存储器）
// 结构：16×32 寄存器堆 + 16 路 32 位读回 PMUX。规模约三百级单元。
// 用途：对应方案推荐的主展示场景"重复字段的多源状态／寄存器读回选择"。
module l02_config_regfile (
    input  wire        clk,
    input  wire        rst,
    input  wire        we,
    input  wire [3:0]  waddr,
    input  wire [31:0] wdata,
    input  wire [3:0]  raddr,
    output reg  [31:0] rdata
);
    reg [31:0] cfg [0:15];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) cfg[i] <= 32'h0000_0000;
        end else if (we) begin
            cfg[waddr] <= wdata;
        end
    end

    // 读回：16 路 32 位 PMUX（题目要求的"多路选择器结构优化"主战场之一）
    always @* begin
        (* parallel_case *)
        case (raddr)
            4'd0:  rdata = cfg[0];
            4'd1:  rdata = cfg[1];
            4'd2:  rdata = cfg[2];
            4'd3:  rdata = cfg[3];
            4'd4:  rdata = cfg[4];
            4'd5:  rdata = cfg[5];
            4'd6:  rdata = cfg[6];
            4'd7:  rdata = cfg[7];
            4'd8:  rdata = cfg[8];
            4'd9:  rdata = cfg[9];
            4'd10: rdata = cfg[10];
            4'd11: rdata = cfg[11];
            4'd12: rdata = cfg[12];
            4'd13: rdata = cfg[13];
            4'd14: rdata = cfg[14];
            4'd15: rdata = cfg[15];
        endcase
    end
endmodule
