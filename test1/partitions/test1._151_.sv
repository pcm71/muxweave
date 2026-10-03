module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__152_ ,
  input  [  0:0] \__pi__153_ ,
  input  [  0:0] \__pi__154_ ,
  input  [  0:0] \__pi__155_ ,
  input  [  0:0] \__pi_i5__1 ,
  input  [  0:0] \__pi_q6__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__151___gold ,
  output [  0:0] \__po__151___gate
);
  \gold.test1._151_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__152_ (\__pi__152_ ),
    .\__pi__153_ (\__pi__153_ ),
    .\__pi__154_ (\__pi__154_ ),
    .\__pi__155_ (\__pi__155_ ),
    .\__pi_i5__1 (\__pi_i5__1 ),
    .\__pi_q6__1 (\__pi_q6__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__151_ (\__po__151___gold )
  );
  \gate.test1._151_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__152_ (\__pi__152_ ),
    .\__pi__153_ (\__pi__153_ ),
    .\__pi__154_ (\__pi__154_ ),
    .\__pi__155_ (\__pi__155_ ),
    .\__pi_i5__1 (\__pi_i5__1 ),
    .\__pi_q6__1 (\__pi_q6__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__151_ (\__po__151___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__152___assume (\__pi__152_ );
  miter_def_prop #(1, "assume") \__pi__153___assume (\__pi__153_ );
  miter_def_prop #(1, "assume") \__pi__154___assume (\__pi__154_ );
  miter_def_prop #(1, "assume") \__pi__155___assume (\__pi__155_ );
  miter_def_prop #(1, "assume") \__pi_i5__1__assume (\__pi_i5__1 );
  miter_def_prop #(1, "assume") \__pi_q6__1__assume (\__pi_q6__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__151___assert (\__po__151___gold , \__po__151___gate );
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
  miter_def_prop #(1, "cover") \__po__151___gold_cover (\__po__151___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__151___gate_cover (\__po__151___gate );
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
module \gold.test1._151_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__152_ ,
  input  [  0:0] \__pi__153_ ,
  input  [  0:0] \__pi__154_ ,
  input  [  0:0] \__pi__155_ ,
  input  [  0:0] \__pi_i5__1 ,
  input  [  0:0] \__pi_q6__1 ,
  output [  0:0] \__po__151_
);
endmodule
module \gate.test1._151_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__152_ ,
  input  [  0:0] \__pi__153_ ,
  input  [  0:0] \__pi__154_ ,
  input  [  0:0] \__pi__155_ ,
  input  [  0:0] \__pi_i5__1 ,
  input  [  0:0] \__pi_q6__1 ,
  output [  0:0] \__po__151_
);
endmodule
