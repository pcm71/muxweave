// e04_m03_base.v —— 时序用例基线：与 benchmarks/mixed/m03 功能相同，仅换模块名
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

    always @* begin
        (* parallel_case *)
        case (sel_r)
            2'd0: y_c = {a_r[7:4], a_r[3:0]};
            2'd1: y_c = {a_r[7:4], b_r[3:0]};
            2'd2: y_c = {c_r[7:4], b_r[3:0]};
            2'd3: y_c = {c_r[7:4], d_r[3:0]};
        endcase
    end

    always @(posedge clk) begin
        if (rst) y <= 8'h00; else y <= y_c;
    end
endmodule
