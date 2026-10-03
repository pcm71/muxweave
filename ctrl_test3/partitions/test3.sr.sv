module miter (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  0:0] \__pi_rw ,
  input  [  0:0] \__pi_sr_in ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  7:0] \__po_sr__gold ,
  output [  7:0] \__po_sr__gate
);
  \gold.test3.sr gold (
    .\__pi_clk (\__pi_clk ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_rw (\__pi_rw ),
    .\__pi_sr_in (\__pi_sr_in ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_sr (\__po_sr__gold )
  );
  \gate.test3.sr gate (
    .\__pi_clk (\__pi_clk ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_rw (\__pi_rw ),
    .\__pi_sr_in (\__pi_sr_in ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_sr (\__po_sr__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_clk__assume (\__pi_clk );
  miter_def_prop #(1, "assume") \__pi_cs__assume (\__pi_cs );
  miter_def_prop #(1, "assume") \__pi_rw__assume (\__pi_rw );
  miter_def_prop #(1, "assume") \__pi_sr_in__assume (\__pi_sr_in );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(8, "assert") \__po_sr__assert (\__po_sr__gold , \__po_sr__gate );
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
  miter_def_prop #(8, "cover") \__po_sr__gold_cover (\__po_sr__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(8, "cover") \__po_sr__gate_cover (\__po_sr__gate );
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
module \gold.test3.sr (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  0:0] \__pi_rw ,
  input  [  0:0] \__pi_sr_in ,
  output [  7:0] \__po_sr
);
endmodule
module \gate.test3.sr (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  0:0] \__pi_rw ,
  input  [  0:0] \__pi_sr_in ,
  output [  7:0] \__po_sr
);
endmodule
