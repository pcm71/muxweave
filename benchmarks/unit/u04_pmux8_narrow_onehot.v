// u04_pmux8_narrow_onehot.v —— 类别：基础结构（窄位宽、多分支、一热译码）   W=1  K=8
// 位宽只有 1 位而分支有 8 个：用于检查
//   ① 位宽=1 时位片分析（slice_patterns 只有 1 位宽）是否正确；
//   ② K=8 时的选择信号身份记录是否完整；
//   ③ 一热译码选择结构是否会被后端直接化简掉（这正是方案提醒的"写了 case 不一定留 PMUX"）。
module u04_pmux8_narrow_onehot (
    input  wire [7:0] sel,
    input  wire       d0,
    input  wire       d1,
    input  wire       d2,
    input  wire       d3,
    input  wire       d4,
    input  wire       d5,
    input  wire       d6,
    input  wire       d7,
    output reg        y
);
    always @* begin
        (* parallel_case *)
        case (sel)
            8'h01: y = d0;
            8'h02: y = d1;
            8'h04: y = d2;
            8'h08: y = d3;
            8'h10: y = d4;
            8'h20: y = d5;
            8'h40: y = d6;
            8'h80: y = d7;
            default: y = 1'b0;
        endcase
    end
endmodule
