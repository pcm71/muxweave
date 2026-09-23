// m03_registered_pmux.v —— 类别：时序电路（DFF + PMUX）   W=8  K=4
// 选择逻辑前后都有寄存器。用途：
//   ① 补上第 1 周缺失的时序用例；
//   ② 检验"优化后 DFF 不得多于优化前"这条硬约束（主办方口径）；
//   ③ 确认优化不改变周期延迟（方案第 1 节：不主动插入流水线、不改变寄存器边界）。
module m03_registered_pmux (
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
            2'd1: y_c = {a_r[7:4], b_r[3:0]};   // 高 4 位与分支 0 相同（跨位复用机会）
            2'd2: y_c = {c_r[7:4], b_r[3:0]};   // 低 4 位与分支 1 相同
            2'd3: y_c = {c_r[7:4], d_r[3:0]};
        endcase
    end

    always @(posedge clk) begin
        if (rst) y <= 8'h00; else y <= y_c;
    end
endmodule
