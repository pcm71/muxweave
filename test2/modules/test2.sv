module miter (
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_d ,
  input  [  4:0] \__pi_dataa ,
  input  [  4:0] \__pi_datab ,
  input  [  4:0] \__pi_datac ,
  input  [  4:0] \__pi_datad ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__mp__00___gold ,
  output [  0:0] \__mp__01___gold ,
  output [  0:0] \__mp__02___gold ,
  output [  0:0] \__mp__03___gold ,
  output [  0:0] \__mp__04___gold ,
  output [  0:0] \__mp__05___gold ,
  output [  0:0] \__mp__06___gold ,
  output [  0:0] \__mp__07___gold ,
  output [  0:0] \__mp__08___gold ,
  output [  0:0] \__mp__09___gold ,
  output [  0:0] \__mp__00___gate ,
  output [  0:0] \__mp__01___gate ,
  output [  0:0] \__mp__02___gate ,
  output [  0:0] \__mp__03___gate ,
  output [  0:0] \__mp__04___gate ,
  output [  0:0] \__mp__05___gate ,
  output [  0:0] \__mp__06___gate ,
  output [  0:0] \__mp__07___gate ,
  output [  0:0] \__mp__08___gate ,
  output [  0:0] \__mp__09___gate ,
  output [  4:0] \__po_out__gold ,
  output [  4:0] \__po_out__gate
);
  \gold.test2 gold (
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
    .\__pi_c (\__pi_c ),
    .\__pi_clk (\__pi_clk ),
    .\__pi_d (\__pi_d ),
    .\__pi_dataa (\__pi_dataa ),
    .\__pi_datab (\__pi_datab ),
    .\__pi_datac (\__pi_datac ),
    .\__pi_datad (\__pi_datad ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__mp__00_ (\__mp__00___gold ),
    .\__mp__01_ (\__mp__01___gold ),
    .\__mp__02_ (\__mp__02___gold ),
    .\__mp__03_ (\__mp__03___gold ),
    .\__mp__04_ (\__mp__04___gold ),
    .\__mp__05_ (\__mp__05___gold ),
    .\__mp__06_ (\__mp__06___gold ),
    .\__mp__07_ (\__mp__07___gold ),
    .\__mp__08_ (\__mp__08___gold ),
    .\__mp__09_ (\__mp__09___gold ),
    .\__po_out (\__po_out__gold )
  );
  \gate.test2 gate (
    .\__pi_a (\__pi_a ),
    .\__pi_b (\__pi_b ),
    .\__pi_c (\__pi_c ),
    .\__pi_clk (\__pi_clk ),
    .\__pi_d (\__pi_d ),
    .\__pi_dataa (\__pi_dataa ),
    .\__pi_datab (\__pi_datab ),
    .\__pi_datac (\__pi_datac ),
    .\__pi_datad (\__pi_datad ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__mp__00_ (\__mp__00___gate ),
    .\__mp__01_ (\__mp__01___gate ),
    .\__mp__02_ (\__mp__02___gate ),
    .\__mp__03_ (\__mp__03___gate ),
    .\__mp__04_ (\__mp__04___gate ),
    .\__mp__05_ (\__mp__05___gate ),
    .\__mp__06_ (\__mp__06___gate ),
    .\__mp__07_ (\__mp__07___gate ),
    .\__mp__08_ (\__mp__08___gate ),
    .\__mp__09_ (\__mp__09___gate ),
    .\__po_out (\__po_out__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_a__assume (\__pi_a );
  miter_def_prop #(1, "assume") \__pi_b__assume (\__pi_b );
  miter_def_prop #(1, "assume") \__pi_c__assume (\__pi_c );
  miter_def_prop #(1, "assume") \__pi_clk__assume (\__pi_clk );
  miter_def_prop #(1, "assume") \__pi_d__assume (\__pi_d );
  miter_def_prop #(5, "assume") \__pi_dataa__assume (\__pi_dataa );
  miter_def_prop #(5, "assume") \__pi_datab__assume (\__pi_datab );
  miter_def_prop #(5, "assume") \__pi_datac__assume (\__pi_datac );
  miter_def_prop #(5, "assume") \__pi_datad__assume (\__pi_datad );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
  miter_cmp_prop #(1, "assert") \__mp__00___assert (\__mp__00___gold , \__mp__00___gate );
  miter_cmp_prop #(1, "assert") \__mp__01___assert (\__mp__01___gold , \__mp__01___gate );
  miter_cmp_prop #(1, "assert") \__mp__02___assert (\__mp__02___gold , \__mp__02___gate );
  miter_cmp_prop #(1, "assert") \__mp__03___assert (\__mp__03___gold , \__mp__03___gate );
  miter_cmp_prop #(1, "assert") \__mp__04___assert (\__mp__04___gold , \__mp__04___gate );
  miter_cmp_prop #(1, "assert") \__mp__05___assert (\__mp__05___gold , \__mp__05___gate );
  miter_cmp_prop #(1, "assert") \__mp__06___assert (\__mp__06___gold , \__mp__06___gate );
  miter_cmp_prop #(1, "assert") \__mp__07___assert (\__mp__07___gold , \__mp__07___gate );
  miter_cmp_prop #(1, "assert") \__mp__08___assert (\__mp__08___gold , \__mp__08___gate );
  miter_cmp_prop #(1, "assert") \__mp__09___assert (\__mp__09___gold , \__mp__09___gate );
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(5, "assert") \__po_out__assert (\__po_out__gold , \__po_out__gate );
`endif
`ifdef COVER_DEF_CROSS_POINTS
  `ifdef DIRECT_CROSS_POINTS
  `else
  `endif
`endif
`ifdef COVER_DEF_GOLD_MATCH_POINTS
  miter_def_prop #(1, "cover") \__mp__00___gold_cover (\__mp__00___gold );
  miter_def_prop #(1, "cover") \__mp__01___gold_cover (\__mp__01___gold );
  miter_def_prop #(1, "cover") \__mp__02___gold_cover (\__mp__02___gold );
  miter_def_prop #(1, "cover") \__mp__03___gold_cover (\__mp__03___gold );
  miter_def_prop #(1, "cover") \__mp__04___gold_cover (\__mp__04___gold );
  miter_def_prop #(1, "cover") \__mp__05___gold_cover (\__mp__05___gold );
  miter_def_prop #(1, "cover") \__mp__06___gold_cover (\__mp__06___gold );
  miter_def_prop #(1, "cover") \__mp__07___gold_cover (\__mp__07___gold );
  miter_def_prop #(1, "cover") \__mp__08___gold_cover (\__mp__08___gold );
  miter_def_prop #(1, "cover") \__mp__09___gold_cover (\__mp__09___gold );
`endif
`ifdef COVER_DEF_GATE_MATCH_POINTS
  miter_def_prop #(1, "cover") \__mp__00___gate_cover (\__mp__00___gate );
  miter_def_prop #(1, "cover") \__mp__01___gate_cover (\__mp__01___gate );
  miter_def_prop #(1, "cover") \__mp__02___gate_cover (\__mp__02___gate );
  miter_def_prop #(1, "cover") \__mp__03___gate_cover (\__mp__03___gate );
  miter_def_prop #(1, "cover") \__mp__04___gate_cover (\__mp__04___gate );
  miter_def_prop #(1, "cover") \__mp__05___gate_cover (\__mp__05___gate );
  miter_def_prop #(1, "cover") \__mp__06___gate_cover (\__mp__06___gate );
  miter_def_prop #(1, "cover") \__mp__07___gate_cover (\__mp__07___gate );
  miter_def_prop #(1, "cover") \__mp__08___gate_cover (\__mp__08___gate );
  miter_def_prop #(1, "cover") \__mp__09___gate_cover (\__mp__09___gate );
`endif
`ifdef COVER_DEF_GOLD_OUTPUTS
  miter_def_prop #(5, "cover") \__po_out__gold_cover (\__po_out__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(5, "cover") \__po_out__gate_cover (\__po_out__gate );
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
module \gold.test2 (
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_d ,
  input  [  4:0] \__pi_dataa ,
  input  [  4:0] \__pi_datab ,
  input  [  4:0] \__pi_datac ,
  input  [  4:0] \__pi_datad ,
  output [  0:0] \__mp__00_ ,
  output [  0:0] \__mp__01_ ,
  output [  0:0] \__mp__02_ ,
  output [  0:0] \__mp__03_ ,
  output [  0:0] \__mp__04_ ,
  output [  0:0] \__mp__05_ ,
  output [  0:0] \__mp__06_ ,
  output [  0:0] \__mp__07_ ,
  output [  0:0] \__mp__08_ ,
  output [  0:0] \__mp__09_ ,
  output [  4:0] \__po_out
);
endmodule
module \gate.test2 (
  input  [  0:0] \__pi_a ,
  input  [  0:0] \__pi_b ,
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_d ,
  input  [  4:0] \__pi_dataa ,
  input  [  4:0] \__pi_datab ,
  input  [  4:0] \__pi_datac ,
  input  [  4:0] \__pi_datad ,
  output [  0:0] \__mp__00_ ,
  output [  0:0] \__mp__01_ ,
  output [  0:0] \__mp__02_ ,
  output [  0:0] \__mp__03_ ,
  output [  0:0] \__mp__04_ ,
  output [  0:0] \__mp__05_ ,
  output [  0:0] \__mp__06_ ,
  output [  0:0] \__mp__07_ ,
  output [  0:0] \__mp__08_ ,
  output [  0:0] \__mp__09_ ,
  output [  4:0] \__po_out
);
endmodule
