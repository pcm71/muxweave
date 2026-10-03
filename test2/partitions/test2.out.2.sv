module miter (
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__08_ ,
  input  [  0:0] \__pi__09_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_datab__2 ,
  input  [  0:0] \__pi_datac__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_out__2__gold ,
  output [  0:0] \__po_out__2__gate
);
  \gold.test2.out.2 gold (
    .\__pi__02_ (\__pi__02_ ),
    .\__pi__03_ (\__pi__03_ ),
    .\__pi__08_ (\__pi__08_ ),
    .\__pi__09_ (\__pi__09_ ),
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
    .\__pi_c (\__pi_c ),
    .\__pi_datab__2 (\__pi_datab__2 ),
    .\__pi_datac__2 (\__pi_datac__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_out__2 (\__po_out__2__gold )
  );
  \gate.test2.out.2 gate (
    .\__pi__02_ (\__pi__02_ ),
    .\__pi__03_ (\__pi__03_ ),
    .\__pi__08_ (\__pi__08_ ),
    .\__pi__09_ (\__pi__09_ ),
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
    .\__pi_c (\__pi_c ),
    .\__pi_datab__2 (\__pi_datab__2 ),
    .\__pi_datac__2 (\__pi_datac__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_out__2 (\__po_out__2__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__02___assume (\__pi__02_ );
  miter_def_prop #(1, "assume") \__pi__03___assume (\__pi__03_ );
  miter_def_prop #(1, "assume") \__pi__08___assume (\__pi__08_ );
  miter_def_prop #(1, "assume") \__pi__09___assume (\__pi__09_ );
  miter_def_prop #(1, "assume") \__pi_a__assume (\__pi_a );
  miter_def_prop #(1, "assume") \__pi_b__assume (\__pi_b );
  miter_def_prop #(1, "assume") \__pi_c__assume (\__pi_c );
  miter_def_prop #(1, "assume") \__pi_datab__2__assume (\__pi_datab__2 );
  miter_def_prop #(1, "assume") \__pi_datac__2__assume (\__pi_datac__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_out__2__assert (\__po_out__2__gold , \__po_out__2__gate );
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
  miter_def_prop #(1, "cover") \__po_out__2__gold_cover (\__po_out__2__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_out__2__gate_cover (\__po_out__2__gate );
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
module \gold.test2.out.2 (
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__08_ ,
  input  [  0:0] \__pi__09_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_datab__2 ,
  input  [  0:0] \__pi_datac__2 ,
  output [  0:0] \__po_out__2
);
endmodule
module \gate.test2.out.2 (
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__08_ ,
  input  [  0:0] \__pi__09_ ,
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_datab__2 ,
  input  [  0:0] \__pi_datac__2 ,
  output [  0:0] \__po_out__2
);
endmodule
