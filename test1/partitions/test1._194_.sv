module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__188_ ,
  input  [  0:0] \__pi__189_ ,
  input  [  0:0] \__pi__192_ ,
  input  [  0:0] \__pi__193_ ,
  input  [  0:0] \__pi_i4__1 ,
  input  [  0:0] \__pi_q5__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__194___gold ,
  output [  0:0] \__po__194___gate
);
  \gold.test1._194_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__188_ (\__pi__188_ ),
    .\__pi__189_ (\__pi__189_ ),
    .\__pi__192_ (\__pi__192_ ),
    .\__pi__193_ (\__pi__193_ ),
    .\__pi_i4__1 (\__pi_i4__1 ),
    .\__pi_q5__1 (\__pi_q5__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__194_ (\__po__194___gold )
  );
  \gate.test1._194_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__188_ (\__pi__188_ ),
    .\__pi__189_ (\__pi__189_ ),
    .\__pi__192_ (\__pi__192_ ),
    .\__pi__193_ (\__pi__193_ ),
    .\__pi_i4__1 (\__pi_i4__1 ),
    .\__pi_q5__1 (\__pi_q5__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__194_ (\__po__194___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__188___assume (\__pi__188_ );
  miter_def_prop #(1, "assume") \__pi__189___assume (\__pi__189_ );
  miter_def_prop #(1, "assume") \__pi__192___assume (\__pi__192_ );
  miter_def_prop #(1, "assume") \__pi__193___assume (\__pi__193_ );
  miter_def_prop #(1, "assume") \__pi_i4__1__assume (\__pi_i4__1 );
  miter_def_prop #(1, "assume") \__pi_q5__1__assume (\__pi_q5__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__194___assert (\__po__194___gold , \__po__194___gate );
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
  miter_def_prop #(1, "cover") \__po__194___gold_cover (\__po__194___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__194___gate_cover (\__po__194___gate );
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
module \gold.test1._194_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__188_ ,
  input  [  0:0] \__pi__189_ ,
  input  [  0:0] \__pi__192_ ,
  input  [  0:0] \__pi__193_ ,
  input  [  0:0] \__pi_i4__1 ,
  input  [  0:0] \__pi_q5__1 ,
  output [  0:0] \__po__194_
);
endmodule
module \gate.test1._194_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__188_ ,
  input  [  0:0] \__pi__189_ ,
  input  [  0:0] \__pi__192_ ,
  input  [  0:0] \__pi__193_ ,
  input  [  0:0] \__pi_i4__1 ,
  input  [  0:0] \__pi_q5__1 ,
  output [  0:0] \__po__194_
);
endmodule
