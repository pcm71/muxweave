module miter (
  input  [  0:0] \__pi__001___9 ,
  input  [  0:0] \__pi_clock ,
  input  [  0:0] \__pi_reset ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_inter0008_out__9__gold ,
  output [  0:0] \__po_inter0008_out__9__gate
);
  \gold.test1.inter0008_out.9 gold (
    .\__pi__001___9 (\__pi__001___9 ),
    .\__pi_clock (\__pi_clock ),
    .\__pi_reset (\__pi_reset ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_inter0008_out__9 (\__po_inter0008_out__9__gold )
  );
  \gate.test1.inter0008_out.9 gate (
    .\__pi__001___9 (\__pi__001___9 ),
    .\__pi_clock (\__pi_clock ),
    .\__pi_reset (\__pi_reset ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_inter0008_out__9 (\__po_inter0008_out__9__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__001___9__assume (\__pi__001___9 );
  miter_def_prop #(1, "assume") \__pi_clock__assume (\__pi_clock );
  miter_def_prop #(1, "assume") \__pi_reset__assume (\__pi_reset );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_inter0008_out__9__assert (\__po_inter0008_out__9__gold , \__po_inter0008_out__9__gate );
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
  miter_def_prop #(1, "cover") \__po_inter0008_out__9__gold_cover (\__po_inter0008_out__9__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_inter0008_out__9__gate_cover (\__po_inter0008_out__9__gate );
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
module \gold.test1.inter0008_out.9 (
  input  [  0:0] \__pi__001___9 ,
  input  [  0:0] \__pi_clock ,
  input  [  0:0] \__pi_reset ,
  output [  0:0] \__po_inter0008_out__9
);
endmodule
module \gate.test1.inter0008_out.9 (
  input  [  0:0] \__pi__001___9 ,
  input  [  0:0] \__pi_clock ,
  input  [  0:0] \__pi_reset ,
  output [  0:0] \__po_inter0008_out__9
);
endmodule
