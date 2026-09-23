// u01_mux2_wide.v —— 类别：基础结构   W=8  K=2
// 最简 2 选 1（宽位）。这一步只确认"识别与基线可跑通"。
// 期望：出现 1 个目标 cell（$mux 或 $pmux 均可）。
// 注意：`proc` 之后是 $mux 还是 $pmux 取决于 Yosys 版本与并行性判断，
//       必须以 `pmux_analyze` 的实测结果为准，不要按预期填写。
module u01_mux2_wide (
    input  wire       sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] y
);
    always @* begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end
endmodule
