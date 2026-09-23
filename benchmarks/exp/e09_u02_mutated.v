// e09_u02_mutated.v —— 负对照：与 u02 功能**故意不等价**（输出最低位取反）
//
// 用途：证明等价性验证器能检出真实差异。
// 一个"永远显示绿色"的验证器等于没有验证，所以每次验证方法变更后，
// 都必须用这个负对照确认它仍然会报 FAIL。
//
// 注意：模块名必须与 gold 侧一致（u02_pmux4_shared_fields），
// 因为 miter 需要把两侧的同名模块作为 gold/gate 顶层。
module u02_pmux4_shared_fields (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [7:0] y
);
    reg [7:0] y_c;

    always @* begin
        (* parallel_case *)
        case (sel)
            2'd0: y_c = {a[7:4], a[3:0]};
            2'd1: y_c = {a[7:4], b[3:0]};
            2'd2: y_c = {c[7:4], b[3:0]};
            2'd3: y_c = {c[7:4], d[3:0]};
        endcase
    end

    assign y = y_c ^ 8'h01;   // 故意错误：与 u02 只差最低位
endmodule
