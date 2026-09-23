// m02_regfile_readback.v —— 类别：应用样本（寄存器读回）   含存储器
// 4×16 寄存器堆 + 读回多路选择。对应方案推荐的主展示场景"重复字段的多源状态／寄存器读回选择"。
// 期望：识别到目标 cell；同时观察存储器是否被映射为 DFF（$mem 与 DFF 分别计数）。
module m02_regfile_readback (
    input  wire        clk,
    input  wire        rst,
    input  wire        we,
    input  wire [1:0]  waddr,
    input  wire [15:0] wdata,
    input  wire [1:0]  raddr,
    output reg  [15:0] rdata
);
    reg [15:0] rf [0:3];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) rf[i] <= 16'h0000;
        end else if (we) begin
            rf[waddr] <= wdata;
        end
    end

    always @* begin
        (* parallel_case *)
        case (raddr)
            2'd0: rdata = rf[0];
            2'd1: rdata = rf[1];
            2'd2: rdata = rf[2];
            2'd3: rdata = rf[3];
        endcase
    end
endmodule
