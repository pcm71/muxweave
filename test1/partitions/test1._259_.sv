module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i4__7 ,
  input  [  0:0] \__pi_i4__11 ,
  input  [  0:0] \__pi_q3__7 ,
  input  [  0:0] \__pi_q3__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__259___gold ,
  output [  0:0] \__po__259___gate
);
  \gold.test1._259_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i4__7 (\__pi_i4__7 ),
    .\__pi_i4__11 (\__pi_i4__11 ),
    .\__pi_q3__7 (\__pi_q3__7 ),
    .\__pi_q3__11 (\__pi_q3__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__259_ (\__po__259___gold )
  );
  \gate.test1._259_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i4__7 (\__pi_i4__7 ),
    .\__pi_i4__11 (\__pi_i4__11 ),
    .\__pi_q3__7 (\__pi_q3__7 ),
    .\__pi_q3__11 (\__pi_q3__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__259_ (\__po__259___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__110___assume (\__pi__110_ );
  miter_def_prop #(1, "assume") \__pi__111___assume (\__pi__111_ );
  miter_def_prop #(1, "assume") \__pi_i4__7__assume (\__pi_i4__7 );
  miter_def_prop #(1, "assume") \__pi_i4__11__assume (\__pi_i4__11 );
  miter_def_prop #(1, "assume") \__pi_q3__7__assume (\__pi_q3__7 );
  miter_def_prop #(1, "assume") \__pi_q3__11__assume (\__pi_q3__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__259___assert (\__po__259___gold , \__po__259___gate );
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
  miter_def_prop #(1, "cover") \__po__259___gold_cover (\__po__259___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__259___gate_cover (\__po__259___gate );
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
module \gold.test1._259_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i4__7 ,
  input  [  0:0] \__pi_i4__11 ,
  input  [  0:0] \__pi_q3__7 ,
  input  [  0:0] \__pi_q3__11 ,
  output [  0:0] \__po__259_
);
endmodule
module \gate.test1._259_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i4__7 ,
  input  [  0:0] \__pi_i4__11 ,
  input  [  0:0] \__pi_q3__7 ,
  input  [  0:0] \__pi_q3__11 ,
  output [  0:0] \__po__259_
);
endmodule
