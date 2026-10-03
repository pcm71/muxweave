module miter (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__233_ ,
  input  [  0:0] \__pi__234_ ,
  input  [  0:0] \__pi__235_ ,
  input  [  0:0] \__pi__236_ ,
  input  [  0:0] \__pi_i6__5 ,
  input  [  0:0] \__pi_q7__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__232___gold ,
  output [  0:0] \__po__232___gate
);
  \gold.test1._232_ gold (
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi__233_ (\__pi__233_ ),
    .\__pi__234_ (\__pi__234_ ),
    .\__pi__235_ (\__pi__235_ ),
    .\__pi__236_ (\__pi__236_ ),
    .\__pi_i6__5 (\__pi_i6__5 ),
    .\__pi_q7__5 (\__pi_q7__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__232_ (\__po__232___gold )
  );
  \gate.test1._232_ gate (
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi__233_ (\__pi__233_ ),
    .\__pi__234_ (\__pi__234_ ),
    .\__pi__235_ (\__pi__235_ ),
    .\__pi__236_ (\__pi__236_ ),
    .\__pi_i6__5 (\__pi_i6__5 ),
    .\__pi_q7__5 (\__pi_q7__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__232_ (\__po__232___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi__233___assume (\__pi__233_ );
  miter_def_prop #(1, "assume") \__pi__234___assume (\__pi__234_ );
  miter_def_prop #(1, "assume") \__pi__235___assume (\__pi__235_ );
  miter_def_prop #(1, "assume") \__pi__236___assume (\__pi__236_ );
  miter_def_prop #(1, "assume") \__pi_i6__5__assume (\__pi_i6__5 );
  miter_def_prop #(1, "assume") \__pi_q7__5__assume (\__pi_q7__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__232___assert (\__po__232___gold , \__po__232___gate );
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
  miter_def_prop #(1, "cover") \__po__232___gold_cover (\__po__232___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__232___gate_cover (\__po__232___gate );
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
module \gold.test1._232_ (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__233_ ,
  input  [  0:0] \__pi__234_ ,
  input  [  0:0] \__pi__235_ ,
  input  [  0:0] \__pi__236_ ,
  input  [  0:0] \__pi_i6__5 ,
  input  [  0:0] \__pi_q7__5 ,
  output [  0:0] \__po__232_
);
endmodule
module \gate.test1._232_ (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__233_ ,
  input  [  0:0] \__pi__234_ ,
  input  [  0:0] \__pi__235_ ,
  input  [  0:0] \__pi__236_ ,
  input  [  0:0] \__pi_i6__5 ,
  input  [  0:0] \__pi_q7__5 ,
  output [  0:0] \__po__232_
);
endmodule
