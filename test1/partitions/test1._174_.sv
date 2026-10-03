module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__168_ ,
  input  [  0:0] \__pi__169_ ,
  input  [  0:0] \__pi__172_ ,
  input  [  0:0] \__pi__173_ ,
  input  [  0:0] \__pi_i4__3 ,
  input  [  0:0] \__pi_q5__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__174___gold ,
  output [  0:0] \__po__174___gate
);
  \gold.test1._174_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__168_ (\__pi__168_ ),
    .\__pi__169_ (\__pi__169_ ),
    .\__pi__172_ (\__pi__172_ ),
    .\__pi__173_ (\__pi__173_ ),
    .\__pi_i4__3 (\__pi_i4__3 ),
    .\__pi_q5__3 (\__pi_q5__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__174_ (\__po__174___gold )
  );
  \gate.test1._174_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__168_ (\__pi__168_ ),
    .\__pi__169_ (\__pi__169_ ),
    .\__pi__172_ (\__pi__172_ ),
    .\__pi__173_ (\__pi__173_ ),
    .\__pi_i4__3 (\__pi_i4__3 ),
    .\__pi_q5__3 (\__pi_q5__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__174_ (\__po__174___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__168___assume (\__pi__168_ );
  miter_def_prop #(1, "assume") \__pi__169___assume (\__pi__169_ );
  miter_def_prop #(1, "assume") \__pi__172___assume (\__pi__172_ );
  miter_def_prop #(1, "assume") \__pi__173___assume (\__pi__173_ );
  miter_def_prop #(1, "assume") \__pi_i4__3__assume (\__pi_i4__3 );
  miter_def_prop #(1, "assume") \__pi_q5__3__assume (\__pi_q5__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__174___assert (\__po__174___gold , \__po__174___gate );
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
  miter_def_prop #(1, "cover") \__po__174___gold_cover (\__po__174___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__174___gate_cover (\__po__174___gate );
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
module \gold.test1._174_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__168_ ,
  input  [  0:0] \__pi__169_ ,
  input  [  0:0] \__pi__172_ ,
  input  [  0:0] \__pi__173_ ,
  input  [  0:0] \__pi_i4__3 ,
  input  [  0:0] \__pi_q5__3 ,
  output [  0:0] \__po__174_
);
endmodule
module \gate.test1._174_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__168_ ,
  input  [  0:0] \__pi__169_ ,
  input  [  0:0] \__pi__172_ ,
  input  [  0:0] \__pi__173_ ,
  input  [  0:0] \__pi_i4__3 ,
  input  [  0:0] \__pi_q5__3 ,
  output [  0:0] \__po__174_
);
endmodule
