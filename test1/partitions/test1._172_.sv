module miter (
  input  [  0:0] \__pi_Q0__7 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  1:0] \__pi_i7__3_2 ,
  input  [  0:0] \__pi_q6__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__172___gold ,
  output [  0:0] \__po__172___gate
);
  \gold.test1._172_ gold (
    .\__pi_Q0__7 (\__pi_Q0__7 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__3_2 (\__pi_i7__3_2 ),
    .\__pi_q6__2 (\__pi_q6__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__172_ (\__po__172___gold )
  );
  \gate.test1._172_ gate (
    .\__pi_Q0__7 (\__pi_Q0__7 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__3_2 (\__pi_i7__3_2 ),
    .\__pi_q6__2 (\__pi_q6__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__172_ (\__po__172___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_Q0__7__assume (\__pi_Q0__7 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__008___assume (\__pi__008_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(2, "assume") \__pi_i7__3_2__assume (\__pi_i7__3_2 );
  miter_def_prop #(1, "assume") \__pi_q6__2__assume (\__pi_q6__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__172___assert (\__po__172___gold , \__po__172___gate );
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
  miter_def_prop #(1, "cover") \__po__172___gold_cover (\__po__172___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__172___gate_cover (\__po__172___gate );
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
module \gold.test1._172_ (
  input  [  0:0] \__pi_Q0__7 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  1:0] \__pi_i7__3_2 ,
  input  [  0:0] \__pi_q6__2 ,
  output [  0:0] \__po__172_
);
endmodule
module \gate.test1._172_ (
  input  [  0:0] \__pi_Q0__7 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  1:0] \__pi_i7__3_2 ,
  input  [  0:0] \__pi_q6__2 ,
  output [  0:0] \__po__172_
);
endmodule
