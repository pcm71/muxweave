// e05_m03_grouped.v —— 时序用例的跨位分组改写
// 与 e04 功能完全等价（同样的寄存器边界、同样的周期延迟），只把组合部分的位级结构改写为分组共享。
// 用途：① 验证改写能否省单元；② 验证 DFF 数是否与基线一致（不得增加）。
module dut (
    input  wire       clk,
    input  wire       rst,
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output reg  [7:0] y
);
    reg [7:0] a_r, b_r, c_r, d_r;
    reg [1:0] sel_r;
    reg [7:0] y_c;

    always @(posedge clk) begin
        if (rst) begin
            a_r <= 8'h00; b_r <= 8'h00; c_r <= 8'h00; d_r <= 8'h00; sel_r <= 2'b00;
        end else begin
            a_r <= a; b_r <= b; c_r <= c; d_r <= d; sel_r <= sel;
        end
    end

    wire hi_e01 = (sel_r == 2'd0) | (sel_r == 2'd1);
    wire lo_e0  = (sel_r == 2'd0);
    wire lo_e12 = (sel_r == 2'd1) | (sel_r == 2'd2);

    always @* begin
        y_c = { hi_e01 ? a_r[7:4] : c_r[7:4],
                lo_e0  ? a_r[3:0] : lo_e12 ? b_r[3:0] : d_r[3:0] };
    end

    always @(posedge clk) begin
        if (rst) y <= 8'h00; else y <= y_c;
    end
endmodule
