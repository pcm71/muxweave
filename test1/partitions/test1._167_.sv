module miter (
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__2 ,
  input  [  0:0] \__pi_i5__4 ,
  input  [  0:0] \__pi_q1__2 ,
  input  [  0:0] \__pi_q6__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__167___gold ,
  output [  0:0] \__po__167___gate
);
  \gold.test1._167_ gold (
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__2 (\__pi_i2__2 ),
    .\__pi_i5__4 (\__pi_i5__4 ),
    .\__pi_q1__2 (\__pi_q1__2 ),
    .\__pi_q6__4 (\__pi_q6__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__167_ (\__po__167___gold )
  );
  \gate.test1._167_ gate (
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__2 (\__pi_i2__2 ),
    .\__pi_i5__4 (\__pi_i5__4 ),
    .\__pi_q1__2 (\__pi_q1__2 ),
    .\__pi_q6__4 (\__pi_q6__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__167_ (\__po__167___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__020___assume (\__pi__020_ );
  miter_def_prop #(1, "assume") \__pi__021___assume (\__pi__021_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i2__2__assume (\__pi_i2__2 );
  miter_def_prop #(1, "assume") \__pi_i5__4__assume (\__pi_i5__4 );
  miter_def_prop #(1, "assume") \__pi_q1__2__assume (\__pi_q1__2 );
  miter_def_prop #(1, "assume") \__pi_q6__4__assume (\__pi_q6__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__167___assert (\__po__167___gold , \__po__167___gate );
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
  miter_def_prop #(1, "cover") \__po__167___gold_cover (\__po__167___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__167___gate_cover (\__po__167___gate );
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
module \gold.test1._167_ (
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__2 ,
  input  [  0:0] \__pi_i5__4 ,
  input  [  0:0] \__pi_q1__2 ,
  input  [  0:0] \__pi_q6__4 ,
  output [  0:0] \__po__167_
);
endmodule
module \gate.test1._167_ (
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__2 ,
  input  [  0:0] \__pi_i5__4 ,
  input  [  0:0] \__pi_q1__2 ,
  input  [  0:0] \__pi_q6__4 ,
  output [  0:0] \__po__167_
);
endmodule
