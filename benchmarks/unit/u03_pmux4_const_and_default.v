// u03_pmux4_const_and_default.v —— 类别：语义/边界（常量字段 + 非零默认路径）   W=16  K=4
// 选择总线是 3 位，case 只覆盖 4 个值，因此**存在真实的默认路径**且默认值非零
// （对应方案语义表的"所有选择位为零 → 输出默认数据 A；A 不是零时尤其容易暴露遗漏"）。
// 分支里还混有常量字段，用于检查常量是否被当作同一数据源处理。
// 期望：$pmux 的默认数据 A 非零；分析器必须把默认路径与 4 个分支都列全。
module u03_pmux4_const_and_default (
    input  wire [2:0]  sel,
    input  wire [15:0] a,
    input  wire [15:0] b,
    output reg  [15:0] y
);
    always @* begin
        (* parallel_case *)
        case (sel)
            3'd0: y = a;
            3'd1: y = {8'hA5, b[7:0]};    // 高字节为常量字段
            3'd2: y = {b[15:8], 8'h00};   // 低字节为常量零
            3'd3: y = 16'hFFFF;           // 整字常量
            default: y = 16'hBEEF;        // 非零默认路径，不能被优化掉
        endcase
    end
endmodule
