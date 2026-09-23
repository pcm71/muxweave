// formal/mini/gate_bad.v —— 故意错误实现（gate，必须 FAIL）
// 与 gold.v 相比把输出的最低位取反，功能必然不等价。
//
// 这个文件是**验证流程的负测试**：如果它被判成 PASS，说明验证流程形同虚设，
// run_formal_mini.sh 会直接报错终止。它只在隔离的最小例中使用，不得混入正式交付输出。
module mini (
    input  wire [1:0] sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [7:0] y
);
    wire [7:0] y_sel = (sel == 2'd0) ? a :
                       (sel == 2'd1) ? b :
                       (sel == 2'd2) ? c : d;
    assign y = y_sel ^ 8'h01;   // 故意错误：最低位取反
endmodule
