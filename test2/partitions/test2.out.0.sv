module miter (
  input  [  0:0] \__pi__00_ ,
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_out__0__gold ,
  output [  0:0] \__po_out__0__gate
);
  \gold.test2.out.0 gold (
    .\__pi__00_ (\__pi__00_ ),
    .\__pi__01_ (\__pi__01_ ),
    .\__pi__02_ (\__pi__02_ ),
    .\__pi__03_ (\__pi__03_ ),
    .\__pi__06_ (\__pi__06_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_out__0 (\__po_out__0__gold )
  );
  \gate.test2.out.0 gate (
    .\__pi__00_ (\__pi__00_ ),
    .\__pi__01_ (\__pi__01_ ),
    .\__pi__02_ (\__pi__02_ ),
    .\__pi__03_ (\__pi__03_ ),
    .\__pi__06_ (\__pi__06_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_out__0 (\__po_out__0__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__00___assume (\__pi__00_ );
  miter_def_prop #(1, "assume") \__pi__01___assume (\__pi__01_ );
  miter_def_prop #(1, "assume") \__pi__02___assume (\__pi__02_ );
  miter_def_prop #(1, "assume") \__pi__03___assume (\__pi__03_ );
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
  miter_cmp_prop #(1, "assert") \__po_out__0__assert (\__po_out__0__gold , \__po_out__0__gate );
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
  miter_def_prop #(1, "cover") \__po_out__0__gold_cover (\__po_out__0__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_out__0__gate_cover (\__po_out__0__gate );
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
module \gold.test2.out.0 (
  input  [  0:0] \__pi__00_ ,
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  output [  0:0] \__po_out__0
);
endmodule
module \gate.test2.out.0 (
  input  [  0:0] \__pi__00_ ,
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  output [  0:0] \__po_out__0
);
endmodule
