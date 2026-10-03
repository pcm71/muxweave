module miter (
  input  [  0:0] \__pi_I0__12 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q5__6 ,
  input  [  0:0] \__pi_q7__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__037___gold ,
  output [  0:0] \__po__037___gate
);
  \gold.test1._037_ gold (
    .\__pi_I0__12 (\__pi_I0__12 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i6__6 (\__pi_i6__6 ),
    .\__pi_q5__6 (\__pi_q5__6 ),
    .\__pi_q7__8 (\__pi_q7__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__037_ (\__po__037___gold )
  );
  \gate.test1._037_ gate (
    .\__pi_I0__12 (\__pi_I0__12 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i6__6 (\__pi_i6__6 ),
    .\__pi_q5__6 (\__pi_q5__6 ),
    .\__pi_q7__8 (\__pi_q7__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__037_ (\__po__037___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_I0__12__assume (\__pi_I0__12 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__020___assume (\__pi__020_ );
  miter_def_prop #(1, "assume") \__pi__021___assume (\__pi__021_ );
  miter_def_prop #(1, "assume") \__pi__122___assume (\__pi__122_ );
  miter_def_prop #(1, "assume") \__pi_i6__6__assume (\__pi_i6__6 );
  miter_def_prop #(1, "assume") \__pi_q5__6__assume (\__pi_q5__6 );
  miter_def_prop #(1, "assume") \__pi_q7__8__assume (\__pi_q7__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__037___assert (\__po__037___gold , \__po__037___gate );
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
  miter_def_prop #(1, "cover") \__po__037___gold_cover (\__po__037___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__037___gate_cover (\__po__037___gate );
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
module \gold.test1._037_ (
  input  [  0:0] \__pi_I0__12 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q5__6 ,
  input  [  0:0] \__pi_q7__8 ,
  output [  0:0] \__po__037_
);
endmodule
module \gate.test1._037_ (
  input  [  0:0] \__pi_I0__12 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q5__6 ,
  input  [  0:0] \__pi_q7__8 ,
  output [  0:0] \__po__037_
);
endmodule
