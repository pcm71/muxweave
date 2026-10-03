module miter (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi__258_ ,
  input  [  0:0] \__pi__259_ ,
  input  [  0:0] \__pi__260_ ,
  input  [  0:0] \__pi__261_ ,
  input  [  0:0] \__pi_i2__7 ,
  input  [  0:0] \__pi_q1__7 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__257___gold ,
  output [  0:0] \__po__257___gate
);
  \gold.test1._257_ gold (
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi__258_ (\__pi__258_ ),
    .\__pi__259_ (\__pi__259_ ),
    .\__pi__260_ (\__pi__260_ ),
    .\__pi__261_ (\__pi__261_ ),
    .\__pi_i2__7 (\__pi_i2__7 ),
    .\__pi_q1__7 (\__pi_q1__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__257_ (\__po__257___gold )
  );
  \gate.test1._257_ gate (
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi__258_ (\__pi__258_ ),
    .\__pi__259_ (\__pi__259_ ),
    .\__pi__260_ (\__pi__260_ ),
    .\__pi__261_ (\__pi__261_ ),
    .\__pi_i2__7 (\__pi_i2__7 ),
    .\__pi_q1__7 (\__pi_q1__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__257_ (\__po__257___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi__258___assume (\__pi__258_ );
  miter_def_prop #(1, "assume") \__pi__259___assume (\__pi__259_ );
  miter_def_prop #(1, "assume") \__pi__260___assume (\__pi__260_ );
  miter_def_prop #(1, "assume") \__pi__261___assume (\__pi__261_ );
  miter_def_prop #(1, "assume") \__pi_i2__7__assume (\__pi_i2__7 );
  miter_def_prop #(1, "assume") \__pi_q1__7__assume (\__pi_q1__7 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__257___assert (\__po__257___gold , \__po__257___gate );
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
  miter_def_prop #(1, "cover") \__po__257___gold_cover (\__po__257___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__257___gate_cover (\__po__257___gate );
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
module \gold.test1._257_ (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi__258_ ,
  input  [  0:0] \__pi__259_ ,
  input  [  0:0] \__pi__260_ ,
  input  [  0:0] \__pi__261_ ,
  input  [  0:0] \__pi_i2__7 ,
  input  [  0:0] \__pi_q1__7 ,
  output [  0:0] \__po__257_
);
endmodule
module \gate.test1._257_ (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi__258_ ,
  input  [  0:0] \__pi__259_ ,
  input  [  0:0] \__pi__260_ ,
  input  [  0:0] \__pi__261_ ,
  input  [  0:0] \__pi_i2__7 ,
  input  [  0:0] \__pi_q1__7 ,
  output [  0:0] \__po__257_
);
endmodule
