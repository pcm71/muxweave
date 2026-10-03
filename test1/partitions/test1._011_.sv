module miter (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__7 ,
  input  [  0:0] \__pi_q2__7 ,
  input  [  3:0] \__pi_state ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__011___gold ,
  output [  0:0] \__po__011___gate
);
  \gold.test1._011_ gold (
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i1__7 (\__pi_i1__7 ),
    .\__pi_q2__7 (\__pi_q2__7 ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__011_ (\__po__011___gold )
  );
  \gate.test1._011_ gate (
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i1__7 (\__pi_i1__7 ),
    .\__pi_q2__7 (\__pi_q2__7 ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__011_ (\__po__011___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i1__7__assume (\__pi_i1__7 );
  miter_def_prop #(1, "assume") \__pi_q2__7__assume (\__pi_q2__7 );
  miter_def_prop #(4, "assume") \__pi_state__assume (\__pi_state );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__011___assert (\__po__011___gold , \__po__011___gate );
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
  miter_def_prop #(1, "cover") \__po__011___gold_cover (\__po__011___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__011___gate_cover (\__po__011___gate );
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
module \gold.test1._011_ (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__7 ,
  input  [  0:0] \__pi_q2__7 ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__011_
);
endmodule
module \gate.test1._011_ (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__7 ,
  input  [  0:0] \__pi_q2__7 ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__011_
);
endmodule
