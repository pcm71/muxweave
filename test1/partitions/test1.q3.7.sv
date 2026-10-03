module miter (
  input  [  0:0] \__pi_Q3__11 ,
  input  [  0:0] \__pi__005_ ,
  input  [  0:0] \__pi__261_ ,
  input  [  0:0] \__pi_clock ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_q3__7__gold ,
  output [  0:0] \__po_q3__7__gate
);
  \gold.test1.q3.7 gold (
    .\__pi_Q3__11 (\__pi_Q3__11 ),
    .\__pi__005_ (\__pi__005_ ),
    .\__pi__261_ (\__pi__261_ ),
    .\__pi_clock (\__pi_clock ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_q3__7 (\__po_q3__7__gold )
  );
  \gate.test1.q3.7 gate (
    .\__pi_Q3__11 (\__pi_Q3__11 ),
    .\__pi__005_ (\__pi__005_ ),
    .\__pi__261_ (\__pi__261_ ),
    .\__pi_clock (\__pi_clock ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_q3__7 (\__po_q3__7__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_Q3__11__assume (\__pi_Q3__11 );
  miter_def_prop #(1, "assume") \__pi__005___assume (\__pi__005_ );
  miter_def_prop #(1, "assume") \__pi__261___assume (\__pi__261_ );
  miter_def_prop #(1, "assume") \__pi_clock__assume (\__pi_clock );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_q3__7__assert (\__po_q3__7__gold , \__po_q3__7__gate );
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
  miter_def_prop #(1, "cover") \__po_q3__7__gold_cover (\__po_q3__7__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_q3__7__gate_cover (\__po_q3__7__gate );
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
module \gold.test1.q3.7 (
  input  [  0:0] \__pi_Q3__11 ,
  input  [  0:0] \__pi__005_ ,
  input  [  0:0] \__pi__261_ ,
  input  [  0:0] \__pi_clock ,
  output [  0:0] \__po_q3__7
);
endmodule
module \gate.test1.q3.7 (
  input  [  0:0] \__pi_Q3__11 ,
  input  [  0:0] \__pi__005_ ,
  input  [  0:0] \__pi__261_ ,
  input  [  0:0] \__pi_clock ,
  output [  0:0] \__po_q3__7
);
endmodule
