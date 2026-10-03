module miter (
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__5 ,
  input  [  0:0] \__pi_i6__10 ,
  input  [  0:0] \__pi_q2__5 ,
  input  [  0:0] \__pi_q5__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__227___gold ,
  output [  0:0] \__po__227___gate
);
  \gold.test1._227_ gold (
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i1__5 (\__pi_i1__5 ),
    .\__pi_i6__10 (\__pi_i6__10 ),
    .\__pi_q2__5 (\__pi_q2__5 ),
    .\__pi_q5__10 (\__pi_q5__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__227_ (\__po__227___gold )
  );
  \gate.test1._227_ gate (
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i1__5 (\__pi_i1__5 ),
    .\__pi_i6__10 (\__pi_i6__10 ),
    .\__pi_q2__5 (\__pi_q2__5 ),
    .\__pi_q5__10 (\__pi_q5__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__227_ (\__po__227___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__020___assume (\__pi__020_ );
  miter_def_prop #(1, "assume") \__pi__021___assume (\__pi__021_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i1__5__assume (\__pi_i1__5 );
  miter_def_prop #(1, "assume") \__pi_i6__10__assume (\__pi_i6__10 );
  miter_def_prop #(1, "assume") \__pi_q2__5__assume (\__pi_q2__5 );
  miter_def_prop #(1, "assume") \__pi_q5__10__assume (\__pi_q5__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__227___assert (\__po__227___gold , \__po__227___gate );
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
  miter_def_prop #(1, "cover") \__po__227___gold_cover (\__po__227___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__227___gate_cover (\__po__227___gate );
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
module \gold.test1._227_ (
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__5 ,
  input  [  0:0] \__pi_i6__10 ,
  input  [  0:0] \__pi_q2__5 ,
  input  [  0:0] \__pi_q5__10 ,
  output [  0:0] \__po__227_
);
endmodule
module \gate.test1._227_ (
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__5 ,
  input  [  0:0] \__pi_i6__10 ,
  input  [  0:0] \__pi_q2__5 ,
  input  [  0:0] \__pi_q5__10 ,
  output [  0:0] \__po__227_
);
endmodule
