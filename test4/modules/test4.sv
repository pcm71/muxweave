module miter (
  input  [  0:0] \__pi_clk ,
  input  [  4:0] \__pi_datain ,
  input  [  0:0] \__pi_ena ,
  input  [  0:0] \__pi_reset_n ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__mp__00___gold ,
  output [  0:0] \__mp__01___gold ,
  output [  5:0] \__mp__02___gold ,
  output [  0:0] \__mp__03___gold ,
  output [  0:0] \__mp__04___gold ,
  output [  0:0] \__mp__05___gold ,
  output [  0:0] \__mp__06___gold ,
  output [  0:0] \__mp__07___gold ,
  output [  0:0] \__mp__08___gold ,
  output [  0:0] \__mp__09___gold ,
  output [  0:0] \__mp__10___gold ,
  output [  0:0] \__mp__11___gold ,
  output [  0:0] \__mp__12___gold ,
  output [  0:0] \__mp__13___gold ,
  output [  0:0] \__mp__14___gold ,
  output [  0:0] \__mp__15___gold ,
  output [  0:0] \__mp__16___gold ,
  output [  0:0] \__mp__17___gold ,
  output [  0:0] \__mp__00___gate ,
  output [  0:0] \__mp__01___gate ,
  output [  5:0] \__mp__02___gate ,
  output [  0:0] \__mp__03___gate ,
  output [  0:0] \__mp__04___gate ,
  output [  0:0] \__mp__05___gate ,
  output [  0:0] \__mp__06___gate ,
  output [  0:0] \__mp__07___gate ,
  output [  0:0] \__mp__08___gate ,
  output [  0:0] \__mp__09___gate ,
  output [  0:0] \__mp__10___gate ,
  output [  0:0] \__mp__11___gate ,
  output [  0:0] \__mp__12___gate ,
  output [  0:0] \__mp__13___gate ,
  output [  0:0] \__mp__14___gate ,
  output [  0:0] \__mp__15___gate ,
  output [  0:0] \__mp__16___gate ,
  output [  0:0] \__mp__17___gate ,
  output [  0:0] \__po_data_dn__gold ,
  output [  0:0] \__po_data_dp__gold ,
  output [  0:0] \__po_datain_5bis7__gold ,
  output [  5:0] \__po_dataout__gold ,
  output [  0:0] \__po_only_5b__gold ,
  output [  0:0] \__po_data_dn__gate ,
  output [  0:0] \__po_data_dp__gate ,
  output [  0:0] \__po_datain_5bis7__gate ,
  output [  5:0] \__po_dataout__gate ,
  output [  0:0] \__po_only_5b__gate
);
  \gold.test4 gold (
    .\__pi_clk (\__pi_clk ),
    .\__pi_datain (\__pi_datain ),
    .\__pi_ena (\__pi_ena ),
    .\__pi_reset_n (\__pi_reset_n ),
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
    .\__mp__11_ (\__mp__11___gold ),
    .\__mp__12_ (\__mp__12___gold ),
    .\__mp__13_ (\__mp__13___gold ),
    .\__mp__14_ (\__mp__14___gold ),
    .\__mp__15_ (\__mp__15___gold ),
    .\__mp__16_ (\__mp__16___gold ),
    .\__mp__17_ (\__mp__17___gold ),
    .\__po_data_dn (\__po_data_dn__gold ),
    .\__po_data_dp (\__po_data_dp__gold ),
    .\__po_datain_5bis7 (\__po_datain_5bis7__gold ),
    .\__po_dataout (\__po_dataout__gold ),
    .\__po_only_5b (\__po_only_5b__gold )
  );
  \gate.test4 gate (
    .\__pi_clk (\__pi_clk ),
    .\__pi_datain (\__pi_datain ),
    .\__pi_ena (\__pi_ena ),
    .\__pi_reset_n (\__pi_reset_n ),
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
    .\__mp__11_ (\__mp__11___gate ),
    .\__mp__12_ (\__mp__12___gate ),
    .\__mp__13_ (\__mp__13___gate ),
    .\__mp__14_ (\__mp__14___gate ),
    .\__mp__15_ (\__mp__15___gate ),
    .\__mp__16_ (\__mp__16___gate ),
    .\__mp__17_ (\__mp__17___gate ),
    .\__po_data_dn (\__po_data_dn__gate ),
    .\__po_data_dp (\__po_data_dp__gate ),
    .\__po_datain_5bis7 (\__po_datain_5bis7__gate ),
    .\__po_dataout (\__po_dataout__gate ),
    .\__po_only_5b (\__po_only_5b__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_clk__assume (\__pi_clk );
  miter_def_prop #(5, "assume") \__pi_datain__assume (\__pi_datain );
  miter_def_prop #(1, "assume") \__pi_ena__assume (\__pi_ena );
  miter_def_prop #(1, "assume") \__pi_reset_n__assume (\__pi_reset_n );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
  miter_cmp_prop #(1, "assert") \__mp__00___assert (\__mp__00___gold , \__mp__00___gate );
  miter_cmp_prop #(1, "assert") \__mp__01___assert (\__mp__01___gold , \__mp__01___gate );
  miter_cmp_prop #(6, "assert") \__mp__02___assert (\__mp__02___gold , \__mp__02___gate );
  miter_cmp_prop #(1, "assert") \__mp__03___assert (\__mp__03___gold , \__mp__03___gate );
  miter_cmp_prop #(1, "assert") \__mp__04___assert (\__mp__04___gold , \__mp__04___gate );
  miter_cmp_prop #(1, "assert") \__mp__05___assert (\__mp__05___gold , \__mp__05___gate );
  miter_cmp_prop #(1, "assert") \__mp__06___assert (\__mp__06___gold , \__mp__06___gate );
  miter_cmp_prop #(1, "assert") \__mp__07___assert (\__mp__07___gold , \__mp__07___gate );
  miter_cmp_prop #(1, "assert") \__mp__08___assert (\__mp__08___gold , \__mp__08___gate );
  miter_cmp_prop #(1, "assert") \__mp__09___assert (\__mp__09___gold , \__mp__09___gate );
  miter_cmp_prop #(1, "assert") \__mp__10___assert (\__mp__10___gold , \__mp__10___gate );
  miter_cmp_prop #(1, "assert") \__mp__11___assert (\__mp__11___gold , \__mp__11___gate );
  miter_cmp_prop #(1, "assert") \__mp__12___assert (\__mp__12___gold , \__mp__12___gate );
  miter_cmp_prop #(1, "assert") \__mp__13___assert (\__mp__13___gold , \__mp__13___gate );
  miter_cmp_prop #(1, "assert") \__mp__14___assert (\__mp__14___gold , \__mp__14___gate );
  miter_cmp_prop #(1, "assert") \__mp__15___assert (\__mp__15___gold , \__mp__15___gate );
  miter_cmp_prop #(1, "assert") \__mp__16___assert (\__mp__16___gold , \__mp__16___gate );
  miter_cmp_prop #(1, "assert") \__mp__17___assert (\__mp__17___gold , \__mp__17___gate );
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_data_dn__assert (\__po_data_dn__gold , \__po_data_dn__gate );
  miter_cmp_prop #(1, "assert") \__po_data_dp__assert (\__po_data_dp__gold , \__po_data_dp__gate );
  miter_cmp_prop #(1, "assert") \__po_datain_5bis7__assert (\__po_datain_5bis7__gold , \__po_datain_5bis7__gate );
  miter_cmp_prop #(6, "assert") \__po_dataout__assert (\__po_dataout__gold , \__po_dataout__gate );
  miter_cmp_prop #(1, "assert") \__po_only_5b__assert (\__po_only_5b__gold , \__po_only_5b__gate );
`endif
`ifdef COVER_DEF_CROSS_POINTS
  `ifdef DIRECT_CROSS_POINTS
  `else
  `endif
`endif
`ifdef COVER_DEF_GOLD_MATCH_POINTS
  miter_def_prop #(1, "cover") \__mp__00___gold_cover (\__mp__00___gold );
  miter_def_prop #(1, "cover") \__mp__01___gold_cover (\__mp__01___gold );
  miter_def_prop #(6, "cover") \__mp__02___gold_cover (\__mp__02___gold );
  miter_def_prop #(1, "cover") \__mp__03___gold_cover (\__mp__03___gold );
  miter_def_prop #(1, "cover") \__mp__04___gold_cover (\__mp__04___gold );
  miter_def_prop #(1, "cover") \__mp__05___gold_cover (\__mp__05___gold );
  miter_def_prop #(1, "cover") \__mp__06___gold_cover (\__mp__06___gold );
  miter_def_prop #(1, "cover") \__mp__07___gold_cover (\__mp__07___gold );
  miter_def_prop #(1, "cover") \__mp__08___gold_cover (\__mp__08___gold );
  miter_def_prop #(1, "cover") \__mp__09___gold_cover (\__mp__09___gold );
  miter_def_prop #(1, "cover") \__mp__10___gold_cover (\__mp__10___gold );
  miter_def_prop #(1, "cover") \__mp__11___gold_cover (\__mp__11___gold );
  miter_def_prop #(1, "cover") \__mp__12___gold_cover (\__mp__12___gold );
  miter_def_prop #(1, "cover") \__mp__13___gold_cover (\__mp__13___gold );
  miter_def_prop #(1, "cover") \__mp__14___gold_cover (\__mp__14___gold );
  miter_def_prop #(1, "cover") \__mp__15___gold_cover (\__mp__15___gold );
  miter_def_prop #(1, "cover") \__mp__16___gold_cover (\__mp__16___gold );
  miter_def_prop #(1, "cover") \__mp__17___gold_cover (\__mp__17___gold );
`endif
`ifdef COVER_DEF_GATE_MATCH_POINTS
  miter_def_prop #(1, "cover") \__mp__00___gate_cover (\__mp__00___gate );
  miter_def_prop #(1, "cover") \__mp__01___gate_cover (\__mp__01___gate );
  miter_def_prop #(6, "cover") \__mp__02___gate_cover (\__mp__02___gate );
  miter_def_prop #(1, "cover") \__mp__03___gate_cover (\__mp__03___gate );
  miter_def_prop #(1, "cover") \__mp__04___gate_cover (\__mp__04___gate );
  miter_def_prop #(1, "cover") \__mp__05___gate_cover (\__mp__05___gate );
  miter_def_prop #(1, "cover") \__mp__06___gate_cover (\__mp__06___gate );
  miter_def_prop #(1, "cover") \__mp__07___gate_cover (\__mp__07___gate );
  miter_def_prop #(1, "cover") \__mp__08___gate_cover (\__mp__08___gate );
  miter_def_prop #(1, "cover") \__mp__09___gate_cover (\__mp__09___gate );
  miter_def_prop #(1, "cover") \__mp__10___gate_cover (\__mp__10___gate );
  miter_def_prop #(1, "cover") \__mp__11___gate_cover (\__mp__11___gate );
  miter_def_prop #(1, "cover") \__mp__12___gate_cover (\__mp__12___gate );
  miter_def_prop #(1, "cover") \__mp__13___gate_cover (\__mp__13___gate );
  miter_def_prop #(1, "cover") \__mp__14___gate_cover (\__mp__14___gate );
  miter_def_prop #(1, "cover") \__mp__15___gate_cover (\__mp__15___gate );
  miter_def_prop #(1, "cover") \__mp__16___gate_cover (\__mp__16___gate );
  miter_def_prop #(1, "cover") \__mp__17___gate_cover (\__mp__17___gate );
`endif
`ifdef COVER_DEF_GOLD_OUTPUTS
  miter_def_prop #(1, "cover") \__po_data_dn__gold_cover (\__po_data_dn__gold );
  miter_def_prop #(1, "cover") \__po_data_dp__gold_cover (\__po_data_dp__gold );
  miter_def_prop #(1, "cover") \__po_datain_5bis7__gold_cover (\__po_datain_5bis7__gold );
  miter_def_prop #(6, "cover") \__po_dataout__gold_cover (\__po_dataout__gold );
  miter_def_prop #(1, "cover") \__po_only_5b__gold_cover (\__po_only_5b__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_data_dn__gate_cover (\__po_data_dn__gate );
  miter_def_prop #(1, "cover") \__po_data_dp__gate_cover (\__po_data_dp__gate );
  miter_def_prop #(1, "cover") \__po_datain_5bis7__gate_cover (\__po_datain_5bis7__gate );
  miter_def_prop #(6, "cover") \__po_dataout__gate_cover (\__po_dataout__gate );
  miter_def_prop #(1, "cover") \__po_only_5b__gate_cover (\__po_only_5b__gate );
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
module \gold.test4 (
  input  [  0:0] \__pi_clk ,
  input  [  4:0] \__pi_datain ,
  input  [  0:0] \__pi_ena ,
  input  [  0:0] \__pi_reset_n ,
  output [  0:0] \__mp__00_ ,
  output [  0:0] \__mp__01_ ,
  output [  5:0] \__mp__02_ ,
  output [  0:0] \__mp__03_ ,
  output [  0:0] \__mp__04_ ,
  output [  0:0] \__mp__05_ ,
  output [  0:0] \__mp__06_ ,
  output [  0:0] \__mp__07_ ,
  output [  0:0] \__mp__08_ ,
  output [  0:0] \__mp__09_ ,
  output [  0:0] \__mp__10_ ,
  output [  0:0] \__mp__11_ ,
  output [  0:0] \__mp__12_ ,
  output [  0:0] \__mp__13_ ,
  output [  0:0] \__mp__14_ ,
  output [  0:0] \__mp__15_ ,
  output [  0:0] \__mp__16_ ,
  output [  0:0] \__mp__17_ ,
  output [  0:0] \__po_data_dn ,
  output [  0:0] \__po_data_dp ,
  output [  0:0] \__po_datain_5bis7 ,
  output [  5:0] \__po_dataout ,
  output [  0:0] \__po_only_5b
);
endmodule
module \gate.test4 (
  input  [  0:0] \__pi_clk ,
  input  [  4:0] \__pi_datain ,
  input  [  0:0] \__pi_ena ,
  input  [  0:0] \__pi_reset_n ,
  output [  0:0] \__mp__00_ ,
  output [  0:0] \__mp__01_ ,
  output [  5:0] \__mp__02_ ,
  output [  0:0] \__mp__03_ ,
  output [  0:0] \__mp__04_ ,
  output [  0:0] \__mp__05_ ,
  output [  0:0] \__mp__06_ ,
  output [  0:0] \__mp__07_ ,
  output [  0:0] \__mp__08_ ,
  output [  0:0] \__mp__09_ ,
  output [  0:0] \__mp__10_ ,
  output [  0:0] \__mp__11_ ,
  output [  0:0] \__mp__12_ ,
  output [  0:0] \__mp__13_ ,
  output [  0:0] \__mp__14_ ,
  output [  0:0] \__mp__15_ ,
  output [  0:0] \__mp__16_ ,
  output [  0:0] \__mp__17_ ,
  output [  0:0] \__po_data_dn ,
  output [  0:0] \__po_data_dp ,
  output [  0:0] \__po_datain_5bis7 ,
  output [  5:0] \__po_dataout ,
  output [  0:0] \__po_only_5b
);
endmodule
