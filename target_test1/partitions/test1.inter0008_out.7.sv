module miter (
  input  [ 11:0] \__pi_I0__15_4 ,
  input  [  0:0] \__pi_clock ,
  input  [ 11:0] \__pi_i1 ,
  input  [ 11:0] \__pi_i2 ,
  input  [ 11:0] \__pi_i3 ,
  input  [ 11:0] \__pi_i4 ,
  input  [ 11:0] \__pi_i5 ,
  input  [ 11:0] \__pi_i6 ,
  input  [ 11:0] \__pi_i7 ,
  input  [  6:0] \__pi_inter0008_out__6_0 ,
  input  [  3:0] \__pi_inter0008_out__11_8 ,
  input  [ 11:0] \__pi_q0 ,
  input  [ 11:0] \__pi_q1 ,
  input  [ 11:0] \__pi_q2 ,
  input  [ 11:0] \__pi_q3 ,
  input  [ 11:0] \__pi_q4 ,
  input  [ 11:0] \__pi_q5 ,
  input  [ 11:0] \__pi_q6 ,
  input  [ 11:0] \__pi_q7 ,
  input  [  0:0] \__pi_reset ,
  input  [  3:0] \__pi_state ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_inter0008_out__7__gold ,
  output [  0:0] \__po_inter0008_out__7__gate
);
  \gold.test1.inter0008_out.7 gold (
    .\__pi_I0__15_4 (\__pi_I0__15_4 ),
    .\__pi_clock (\__pi_clock ),
    .\__pi_i1 (\__pi_i1 ),
    .\__pi_i2 (\__pi_i2 ),
    .\__pi_i3 (\__pi_i3 ),
    .\__pi_i4 (\__pi_i4 ),
    .\__pi_i5 (\__pi_i5 ),
    .\__pi_i6 (\__pi_i6 ),
    .\__pi_i7 (\__pi_i7 ),
    .\__pi_inter0008_out__6_0 (\__pi_inter0008_out__6_0 ),
    .\__pi_inter0008_out__11_8 (\__pi_inter0008_out__11_8 ),
    .\__pi_q0 (\__pi_q0 ),
    .\__pi_q1 (\__pi_q1 ),
    .\__pi_q2 (\__pi_q2 ),
    .\__pi_q3 (\__pi_q3 ),
    .\__pi_q4 (\__pi_q4 ),
    .\__pi_q5 (\__pi_q5 ),
    .\__pi_q6 (\__pi_q6 ),
    .\__pi_q7 (\__pi_q7 ),
    .\__pi_reset (\__pi_reset ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_inter0008_out__7 (\__po_inter0008_out__7__gold )
  );
  \gate.test1.inter0008_out.7 gate (
    .\__pi_I0__15_4 (\__pi_I0__15_4 ),
    .\__pi_clock (\__pi_clock ),
    .\__pi_i1 (\__pi_i1 ),
    .\__pi_i2 (\__pi_i2 ),
    .\__pi_i3 (\__pi_i3 ),
    .\__pi_i4 (\__pi_i4 ),
    .\__pi_i5 (\__pi_i5 ),
    .\__pi_i6 (\__pi_i6 ),
    .\__pi_i7 (\__pi_i7 ),
    .\__pi_inter0008_out__6_0 (\__pi_inter0008_out__6_0 ),
    .\__pi_inter0008_out__11_8 (\__pi_inter0008_out__11_8 ),
    .\__pi_q0 (\__pi_q0 ),
    .\__pi_q1 (\__pi_q1 ),
    .\__pi_q2 (\__pi_q2 ),
    .\__pi_q3 (\__pi_q3 ),
    .\__pi_q4 (\__pi_q4 ),
    .\__pi_q5 (\__pi_q5 ),
    .\__pi_q6 (\__pi_q6 ),
    .\__pi_q7 (\__pi_q7 ),
    .\__pi_reset (\__pi_reset ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_inter0008_out__7 (\__po_inter0008_out__7__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(12, "assume") \__pi_I0__15_4__assume (\__pi_I0__15_4 );
  miter_def_prop #(1, "assume") \__pi_clock__assume (\__pi_clock );
  miter_def_prop #(12, "assume") \__pi_i1__assume (\__pi_i1 );
  miter_def_prop #(12, "assume") \__pi_i2__assume (\__pi_i2 );
  miter_def_prop #(12, "assume") \__pi_i3__assume (\__pi_i3 );
  miter_def_prop #(12, "assume") \__pi_i4__assume (\__pi_i4 );
  miter_def_prop #(12, "assume") \__pi_i5__assume (\__pi_i5 );
  miter_def_prop #(12, "assume") \__pi_i6__assume (\__pi_i6 );
  miter_def_prop #(12, "assume") \__pi_i7__assume (\__pi_i7 );
  miter_def_prop #(7, "assume") \__pi_inter0008_out__6_0__assume (\__pi_inter0008_out__6_0 );
  miter_def_prop #(4, "assume") \__pi_inter0008_out__11_8__assume (\__pi_inter0008_out__11_8 );
  miter_def_prop #(12, "assume") \__pi_q0__assume (\__pi_q0 );
  miter_def_prop #(12, "assume") \__pi_q1__assume (\__pi_q1 );
  miter_def_prop #(12, "assume") \__pi_q2__assume (\__pi_q2 );
  miter_def_prop #(12, "assume") \__pi_q3__assume (\__pi_q3 );
  miter_def_prop #(12, "assume") \__pi_q4__assume (\__pi_q4 );
  miter_def_prop #(12, "assume") \__pi_q5__assume (\__pi_q5 );
  miter_def_prop #(12, "assume") \__pi_q6__assume (\__pi_q6 );
  miter_def_prop #(12, "assume") \__pi_q7__assume (\__pi_q7 );
  miter_def_prop #(1, "assume") \__pi_reset__assume (\__pi_reset );
  miter_def_prop #(4, "assume") \__pi_state__assume (\__pi_state );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_inter0008_out__7__assert (\__po_inter0008_out__7__gold , \__po_inter0008_out__7__gate );
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
  miter_def_prop #(1, "cover") \__po_inter0008_out__7__gold_cover (\__po_inter0008_out__7__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_inter0008_out__7__gate_cover (\__po_inter0008_out__7__gate );
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
module \gold.test1.inter0008_out.7 (
  input  [ 11:0] \__pi_I0__15_4 ,
  input  [  0:0] \__pi_clock ,
  input  [ 11:0] \__pi_i1 ,
  input  [ 11:0] \__pi_i2 ,
  input  [ 11:0] \__pi_i3 ,
  input  [ 11:0] \__pi_i4 ,
  input  [ 11:0] \__pi_i5 ,
  input  [ 11:0] \__pi_i6 ,
  input  [ 11:0] \__pi_i7 ,
  input  [  6:0] \__pi_inter0008_out__6_0 ,
  input  [  3:0] \__pi_inter0008_out__11_8 ,
  input  [ 11:0] \__pi_q0 ,
  input  [ 11:0] \__pi_q1 ,
  input  [ 11:0] \__pi_q2 ,
  input  [ 11:0] \__pi_q3 ,
  input  [ 11:0] \__pi_q4 ,
  input  [ 11:0] \__pi_q5 ,
  input  [ 11:0] \__pi_q6 ,
  input  [ 11:0] \__pi_q7 ,
  input  [  0:0] \__pi_reset ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po_inter0008_out__7
);
endmodule
module \gate.test1.inter0008_out.7 (
  input  [ 11:0] \__pi_I0__15_4 ,
  input  [  0:0] \__pi_clock ,
  input  [ 11:0] \__pi_i1 ,
  input  [ 11:0] \__pi_i2 ,
  input  [ 11:0] \__pi_i3 ,
  input  [ 11:0] \__pi_i4 ,
  input  [ 11:0] \__pi_i5 ,
  input  [ 11:0] \__pi_i6 ,
  input  [ 11:0] \__pi_i7 ,
  input  [  6:0] \__pi_inter0008_out__6_0 ,
  input  [  3:0] \__pi_inter0008_out__11_8 ,
  input  [ 11:0] \__pi_q0 ,
  input  [ 11:0] \__pi_q1 ,
  input  [ 11:0] \__pi_q2 ,
  input  [ 11:0] \__pi_q3 ,
  input  [ 11:0] \__pi_q4 ,
  input  [ 11:0] \__pi_q5 ,
  input  [ 11:0] \__pi_q6 ,
  input  [ 11:0] \__pi_q7 ,
  input  [  0:0] \__pi_reset ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po_inter0008_out__7
);
endmodule
