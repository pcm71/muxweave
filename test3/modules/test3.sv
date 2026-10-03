module miter (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  0:0] \__pi_sr_in ,
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
  output [  0:0] \__mp__10___gold ,
  output [  0:0] \__mp_rw__gold ,
  output [  7:0] \__mp_sr__gold ,
  output [  0:0] \__mp_sr_reg[0]__gold ,
  output [  0:0] \__mp_sr_reg[1]__gold ,
  output [  0:0] \__mp_sr_reg[2]__gold ,
  output [  0:0] \__mp_sr_reg[3]__gold ,
  output [  0:0] \__mp_sr_reg[4]__gold ,
  output [  0:0] \__mp_sr_reg[5]__gold ,
  output [  0:0] \__mp_sr_reg[6]__gold ,
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
  output [  0:0] \__mp__10___gate ,
  output [  0:0] \__mp_rw__gate ,
  output [  7:0] \__mp_sr__gate ,
  output [  0:0] \__mp_sr_reg[0]__gate ,
  output [  0:0] \__mp_sr_reg[1]__gate ,
  output [  0:0] \__mp_sr_reg[2]__gate ,
  output [  0:0] \__mp_sr_reg[3]__gate ,
  output [  0:0] \__mp_sr_reg[4]__gate ,
  output [  0:0] \__mp_sr_reg[5]__gate ,
  output [  0:0] \__mp_sr_reg[6]__gate ,
  output [  7:0] \__po_gpioout__gold ,
  output [  0:0] \__po_sr_out__gold ,
  output [  7:0] \__po_gpioout__gate ,
  output [  0:0] \__po_sr_out__gate
);
  \gold.test3 gold (
    .\__pi_clk (\__pi_clk ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_sr_in (\__pi_sr_in ),
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
    .\__mp__10_ (\__mp__10___gold ),
    .\__mp_rw (\__mp_rw__gold ),
    .\__mp_sr (\__mp_sr__gold ),
    .\__mp_sr_reg[0] (\__mp_sr_reg[0]__gold ),
    .\__mp_sr_reg[1] (\__mp_sr_reg[1]__gold ),
    .\__mp_sr_reg[2] (\__mp_sr_reg[2]__gold ),
    .\__mp_sr_reg[3] (\__mp_sr_reg[3]__gold ),
    .\__mp_sr_reg[4] (\__mp_sr_reg[4]__gold ),
    .\__mp_sr_reg[5] (\__mp_sr_reg[5]__gold ),
    .\__mp_sr_reg[6] (\__mp_sr_reg[6]__gold ),
    .\__po_gpioout (\__po_gpioout__gold ),
    .\__po_sr_out (\__po_sr_out__gold )
  );
  \gate.test3 gate (
    .\__pi_clk (\__pi_clk ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_sr_in (\__pi_sr_in ),
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
    .\__mp__10_ (\__mp__10___gate ),
    .\__mp_rw (\__mp_rw__gate ),
    .\__mp_sr (\__mp_sr__gate ),
    .\__mp_sr_reg[0] (\__mp_sr_reg[0]__gate ),
    .\__mp_sr_reg[1] (\__mp_sr_reg[1]__gate ),
    .\__mp_sr_reg[2] (\__mp_sr_reg[2]__gate ),
    .\__mp_sr_reg[3] (\__mp_sr_reg[3]__gate ),
    .\__mp_sr_reg[4] (\__mp_sr_reg[4]__gate ),
    .\__mp_sr_reg[5] (\__mp_sr_reg[5]__gate ),
    .\__mp_sr_reg[6] (\__mp_sr_reg[6]__gate ),
    .\__po_gpioout (\__po_gpioout__gate ),
    .\__po_sr_out (\__po_sr_out__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_clk__assume (\__pi_clk );
  miter_def_prop #(1, "assume") \__pi_cs__assume (\__pi_cs );
  miter_def_prop #(1, "assume") \__pi_sr_in__assume (\__pi_sr_in );
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
  miter_cmp_prop #(1, "assert") \__mp__10___assert (\__mp__10___gold , \__mp__10___gate );
  miter_cmp_prop #(1, "assert") \__mp_rw__assert (\__mp_rw__gold , \__mp_rw__gate );
  miter_cmp_prop #(8, "assert") \__mp_sr__assert (\__mp_sr__gold , \__mp_sr__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[0]__assert (\__mp_sr_reg[0]__gold , \__mp_sr_reg[0]__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[1]__assert (\__mp_sr_reg[1]__gold , \__mp_sr_reg[1]__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[2]__assert (\__mp_sr_reg[2]__gold , \__mp_sr_reg[2]__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[3]__assert (\__mp_sr_reg[3]__gold , \__mp_sr_reg[3]__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[4]__assert (\__mp_sr_reg[4]__gold , \__mp_sr_reg[4]__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[5]__assert (\__mp_sr_reg[5]__gold , \__mp_sr_reg[5]__gate );
  miter_cmp_prop #(1, "assert") \__mp_sr_reg[6]__assert (\__mp_sr_reg[6]__gold , \__mp_sr_reg[6]__gate );
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(8, "assert") \__po_gpioout__assert (\__po_gpioout__gold , \__po_gpioout__gate );
  miter_cmp_prop #(1, "assert") \__po_sr_out__assert (\__po_sr_out__gold , \__po_sr_out__gate );
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
  miter_def_prop #(1, "cover") \__mp__10___gold_cover (\__mp__10___gold );
  miter_def_prop #(1, "cover") \__mp_rw__gold_cover (\__mp_rw__gold );
  miter_def_prop #(8, "cover") \__mp_sr__gold_cover (\__mp_sr__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[0]__gold_cover (\__mp_sr_reg[0]__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[1]__gold_cover (\__mp_sr_reg[1]__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[2]__gold_cover (\__mp_sr_reg[2]__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[3]__gold_cover (\__mp_sr_reg[3]__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[4]__gold_cover (\__mp_sr_reg[4]__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[5]__gold_cover (\__mp_sr_reg[5]__gold );
  miter_def_prop #(1, "cover") \__mp_sr_reg[6]__gold_cover (\__mp_sr_reg[6]__gold );
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
  miter_def_prop #(1, "cover") \__mp__10___gate_cover (\__mp__10___gate );
  miter_def_prop #(1, "cover") \__mp_rw__gate_cover (\__mp_rw__gate );
  miter_def_prop #(8, "cover") \__mp_sr__gate_cover (\__mp_sr__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[0]__gate_cover (\__mp_sr_reg[0]__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[1]__gate_cover (\__mp_sr_reg[1]__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[2]__gate_cover (\__mp_sr_reg[2]__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[3]__gate_cover (\__mp_sr_reg[3]__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[4]__gate_cover (\__mp_sr_reg[4]__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[5]__gate_cover (\__mp_sr_reg[5]__gate );
  miter_def_prop #(1, "cover") \__mp_sr_reg[6]__gate_cover (\__mp_sr_reg[6]__gate );
`endif
`ifdef COVER_DEF_GOLD_OUTPUTS
  miter_def_prop #(8, "cover") \__po_gpioout__gold_cover (\__po_gpioout__gold );
  miter_def_prop #(1, "cover") \__po_sr_out__gold_cover (\__po_sr_out__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(8, "cover") \__po_gpioout__gate_cover (\__po_gpioout__gate );
  miter_def_prop #(1, "cover") \__po_sr_out__gate_cover (\__po_sr_out__gate );
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
module \gold.test3 (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  0:0] \__pi_sr_in ,
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
  output [  0:0] \__mp__10_ ,
  output [  0:0] \__mp_rw ,
  output [  7:0] \__mp_sr ,
  output [  0:0] \__mp_sr_reg[0] ,
  output [  0:0] \__mp_sr_reg[1] ,
  output [  0:0] \__mp_sr_reg[2] ,
  output [  0:0] \__mp_sr_reg[3] ,
  output [  0:0] \__mp_sr_reg[4] ,
  output [  0:0] \__mp_sr_reg[5] ,
  output [  0:0] \__mp_sr_reg[6] ,
  output [  7:0] \__po_gpioout ,
  output [  0:0] \__po_sr_out
);
endmodule
module \gate.test3 (
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_cs ,
  input  [  0:0] \__pi_sr_in ,
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
  output [  0:0] \__mp__10_ ,
  output [  0:0] \__mp_rw ,
  output [  7:0] \__mp_sr ,
  output [  0:0] \__mp_sr_reg[0] ,
  output [  0:0] \__mp_sr_reg[1] ,
  output [  0:0] \__mp_sr_reg[2] ,
  output [  0:0] \__mp_sr_reg[3] ,
  output [  0:0] \__mp_sr_reg[4] ,
  output [  0:0] \__mp_sr_reg[5] ,
  output [  0:0] \__mp_sr_reg[6] ,
  output [  7:0] \__po_gpioout ,
  output [  0:0] \__po_sr_out
);
endmodule
