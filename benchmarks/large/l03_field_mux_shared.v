// l03_field_mux_shared.v —— 混合组合逻辑：4 条通道共用同一选择总线
// 结构：4 个 24 位 K=8 的 PMUX，**共用同一个 sel**（跨 PMUX 共享控制的典型场景），
//       并叠加译码、掩码与算术逻辑，构成"混合组合逻辑 PMUX 复杂电路"。
// 规模：约三百级单元。
module l03_field_mux_shared (
    input  wire        clk,
    input  wire        rst,
    input  wire [2:0]  sel,
    input  wire [23:0] a, b, c, d,
    input  wire [23:0] mask,
    output reg  [23:0] y0, y1, y2, y3
);
    wire [23:0] d0 = a & mask;
    wire [23:0] d1 = b | mask;
    wire [23:0] d2 = c ^ mask;
    wire [23:0] d3 = {d[11:0], d[23:12]};        // 循环移位

    // 四条通道的结构相同、各不相同地组合 8 个分支（共用 sel）
    reg [23:0] m0, m1, m2, m3;
    always @* begin
        (* parallel_case *)
        case (sel)
            3'd0: begin m0 = a;        m1 = d0;       m2 = b;        m3 = a & b;   end
            3'd1: begin m0 = d1;       m1 = a;        m2 = c;        m3 = d1;      end
            3'd2: begin m0 = a & b;    m1 = d1;       m2 = d2;       m3 = c;       end
            3'd3: begin m0 = d2;       m1 = a & b;    m2 = d3;       m3 = d2;      end
            3'd4: begin m0 = c;        m1 = d2;       m2 = a;        m3 = d3;      end
            3'd5: begin m0 = d3;       m1 = c;        m2 = d0;       m3 = a;       end
            3'd6: begin m0 = b;        m1 = d3;       m2 = c;        m3 = d0;      end
            3'd7: begin m0 = d0;       m1 = b;        m2 = d1;       m3 = b;       end
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            y0 <= 24'h0; y1 <= 24'h0; y2 <= 24'h0; y3 <= 24'h0;
        end else begin
            y0 <= m0 + d0;
            y1 <= m1 - d1;
            y2 <= m2 ^ d2;
            y3 <= m3 | d3;
        end
    end
endmodule
