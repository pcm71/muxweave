module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__207_ ,
  input  [  0:0] \__pi__208_ ,
  input  [  0:0] \__pi__209_ ,
  input  [  0:0] \__pi__210_ ,
  input  [  0:0] \__pi_i1__4 ,
  input  [  0:0] \__pi_q0__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__206___gold ,
  output [  0:0] \__po__206___gate
);
  \gold.test1._206_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__207_ (\__pi__207_ ),
    .\__pi__208_ (\__pi__208_ ),
    .\__pi__209_ (\__pi__209_ ),
    .\__pi__210_ (\__pi__210_ ),
    .\__pi_i1__4 (\__pi_i1__4 ),
    .\__pi_q0__4 (\__pi_q0__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__206_ (\__po__206___gold )
  );
  \gate.test1._206_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__207_ (\__pi__207_ ),
    .\__pi__208_ (\__pi__208_ ),
    .\__pi__209_ (\__pi__209_ ),
    .\__pi__210_ (\__pi__210_ ),
    .\__pi_i1__4 (\__pi_i1__4 ),
    .\__pi_q0__4 (\__pi_q0__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__206_ (\__po__206___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__207___assume (\__pi__207_ );
  miter_def_prop #(1, "assume") \__pi__208___assume (\__pi__208_ );
  miter_def_prop #(1, "assume") \__pi__209___assume (\__pi__209_ );
  miter_def_prop #(1, "assume") \__pi__210___assume (\__pi__210_ );
  miter_def_prop #(1, "assume") \__pi_i1__4__assume (\__pi_i1__4 );
  miter_def_prop #(1, "assume") \__pi_q0__4__assume (\__pi_q0__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__206___assert (\__po__206___gold , \__po__206___gate );
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
  miter_def_prop #(1, "cover") \__po__206___gold_cover (\__po__206___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__206___gate_cover (\__po__206___gate );
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
module \gold.test1._206_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__207_ ,
  input  [  0:0] \__pi__208_ ,
  input  [  0:0] \__pi__209_ ,
  input  [  0:0] \__pi__210_ ,
  input  [  0:0] \__pi_i1__4 ,
  input  [  0:0] \__pi_q0__4 ,
  output [  0:0] \__po__206_
);
endmodule
module \gate.test1._206_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__207_ ,
  input  [  0:0] \__pi__208_ ,
  input  [  0:0] \__pi__209_ ,
  input  [  0:0] \__pi__210_ ,
  input  [  0:0] \__pi_i1__4 ,
  input  [  0:0] \__pi_q0__4 ,
  output [  0:0] \__po__206_
);
endmodule
