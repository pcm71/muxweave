module miter (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  1:0] \__pi_sr__1_0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_sr_reg[1]__gold ,
  output [  0:0] \__po_sr_reg[1]__gate
);
  \gold.test3.sr_reg.1 gold (
    .\__pi_clk (\__pi_clk ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_sr__1_0 (\__pi_sr__1_0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_sr_reg[1] (\__po_sr_reg[1]__gold )
  );
  \gate.test3.sr_reg.1 gate (
    .\__pi_clk (\__pi_clk ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_sr__1_0 (\__pi_sr__1_0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_sr_reg[1] (\__po_sr_reg[1]__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_clk__assume (\__pi_clk );
  miter_def_prop #(1, "assume") \__pi_cs__assume (\__pi_cs );
  miter_def_prop #(2, "assume") \__pi_sr__1_0__assume (\__pi_sr__1_0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_sr_reg[1]__assert (\__po_sr_reg[1]__gold , \__po_sr_reg[1]__gate );
`endif
`ifdef COVER_DEF_CROSS_POINTS
  `ifdef DIRECT_CROSS_POINTS
  `else
  `endif
`endif
`ifdef COVER_DEF_GOLD_MATCH_POINTS
`endif
`ifdef COVER_DEF_GATE_MATCH_POINTS
`endif
`ifdef COVER_DEF_GOLD_OUTPUTS
  miter_def_prop #(1, "cover") \__po_sr_reg[1]__gold_cover (\__po_sr_reg[1]__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_sr_reg[1]__gate_cover (\__po_sr_reg[1]__gate );
`endif
endmodule
module miter_cmp_prop #(parameter WIDTH=1, parameter TYPE="assert") (input [WIDTH-1:0] in_gold, in_gate);
  reg okay;
  integer i;
  always @* begin
    okay = 1;
    for (i = 0; i < WIDTH; i = i+1)
      okay = okay && (in_gold[i] === 1'bx || in_gold[i] === in_gate[i]);
  end
  generate
    if (TYPE == "assert") always @* assert(okay);
    if (TYPE == "assume") always @* assume(okay);
    if (TYPE == "cover")  always @* cover(okay);
  endgenerate
endmodule
module miter_def_prop #(parameter WIDTH=1, parameter TYPE="assert") (input [WIDTH-1:0] in);
  wire okay = ^in !== 1'bx;
  generate
    if (TYPE == "assert") always @* assert(okay);
    if (TYPE == "assume") always @* assume(okay);
    if (TYPE == "cover")  always @* cover(okay);
  endgenerate
endmodule
module \gold.test3.sr_reg.1 (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  1:0] \__pi_sr__1_0 ,
  output [  0:0] \__po_sr_reg[1]
);
endmodule
module \gate.test3.sr_reg.1 (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  1:0] \__pi_sr__1_0 ,
  output [  0:0] \__po_sr_reg[1]
);
endmodule
