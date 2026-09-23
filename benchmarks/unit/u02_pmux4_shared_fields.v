// u02_pmux4_shared_fields.v —— 类别：模式样本（位片重复）   W=8  K=4
// 4 选 1，但各分支的数据字**部分字段相同**，构造出跨位分组共享机会：
//   位 [7:4]：分支 0/1 都取 a 的对应位，分支 2/3 都取 c 的对应位
//             → 分组模式 (a,a,c,c)，且该模式被 4 个位共用 → 跨位共享机会
//   位 [3:0]：分支 1/2 都取 b 的对应位 → 也有分支级复用
// 期望：bits_with_reuse > 0，opportunity 非 none，slice_patterns 至少 2 段。
// `(* parallel_case *)` 只是给 proc 的提示，能否真正留下 $pmux 必须实测确认。
module u02_pmux4_shared_fields (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output reg  [7:0] y
);
    always @* begin
        (* parallel_case *)
        case (sel)
            2'd0: y = {a[7:4], a[3:0]};
            2'd1: y = {a[7:4], b[3:0]};   // 高 4 位与分支 0 相同
            2'd2: y = {c[7:4], b[3:0]};   // 低 4 位与分支 1 相同
            2'd3: y = {c[7:4], d[3:0]};
        endcase
    end
endmodule
