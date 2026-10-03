module miter (
  input  [  0:0] \__pi__04_ ,
  input  [  0:0] \__pi__05_ ,
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_out__1__gold ,
  output [  0:0] \__po_out__1__gate
);
  \gold.test2.out.1 gold (
    .\__pi__04_ (\__pi__04_ ),
    .\__pi__05_ (\__pi__05_ ),
    .\__pi__06_ (\__pi__06_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_out__1 (\__po_out__1__gold )
  );
  \gate.test2.out.1 gate (
    .\__pi__04_ (\__pi__04_ ),
    .\__pi__05_ (\__pi__05_ ),
    .\__pi__06_ (\__pi__06_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_out__1 (\__po_out__1__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__04___assume (\__pi__04_ );
  miter_def_prop #(1, "assume") \__pi__05___assume (\__pi__05_ );
  miter_def_prop #(1, "assume") \__pi__06___assume (\__pi__06_ );
  miter_def_prop #(1, "assume") \__pi__07___assume (\__pi__07_ );
  miter_def_prop #(1, "assume") \__pi_a__assume (\__pi_a );
  miter_def_prop #(1, "assume") \__pi_b__assume (\__pi_b );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_out__1__assert (\__po_out__1__gold , \__po_out__1__gate );
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
  miter_def_prop #(1, "cover") \__po_out__1__gold_cover (\__po_out__1__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_out__1__gate_cover (\__po_out__1__gate );
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
module \gold.test2.out.1 (
  input  [  0:0] \__pi__04_ ,
  input  [  0:0] \__pi__05_ ,
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  output [  0:0] \__po_out__1
);
endmodule
module \gate.test2.out.1 (
  input  [  0:0] \__pi__04_ ,
  input  [  0:0] \__pi__05_ ,
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  output [  0:0] \__po_out__1
);
endmodule
