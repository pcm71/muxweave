// m01_decode_mask_pmux.v —— 类别：混合组合逻辑   W=16  K=4
// 译码 + 掩码 + 位运算 + PMUX 混在一起，对应题目要求的"混合组合逻辑 PMUX 复杂电路"。
// 期望：识别到目标 cell；周边逻辑会压缩掉一部分位级重复，因此复用位可能少于纯模式样本。
module m01_decode_mask_pmux (
    input  wire [3:0]  sel,
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [7:0]  mask,
    output reg  [15:0] y
);
    wire [3:0] dec = sel;                     // 译码后的选择
    wire [15:0] a_masked = a & {8'h00, mask}; // 掩码
    wire [15:0] b_rot    = {b[11:0], b[15:12]};

    always @* begin
        (* parallel_case *)
        case (dec)
            4'b0001: y = a;
            4'b0010: y = a_masked;
            4'b0100: y = b;
            4'b1000: y = b_rot;
            default: y = 16'h0000;
        endcase
    end
endmodule
