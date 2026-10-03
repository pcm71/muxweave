module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__218_ ,
  input  [  0:0] \__pi__219_ ,
  input  [  0:0] \__pi__222_ ,
  input  [  0:0] \__pi__223_ ,
  input  [  0:0] \__pi_i5__10 ,
  input  [  0:0] \__pi_q4__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__224___gold ,
  output [  0:0] \__po__224___gate
);
  \gold.test1._224_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__218_ (\__pi__218_ ),
    .\__pi__219_ (\__pi__219_ ),
    .\__pi__222_ (\__pi__222_ ),
    .\__pi__223_ (\__pi__223_ ),
    .\__pi_i5__10 (\__pi_i5__10 ),
    .\__pi_q4__10 (\__pi_q4__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__224_ (\__po__224___gold )
  );
  \gate.test1._224_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__218_ (\__pi__218_ ),
    .\__pi__219_ (\__pi__219_ ),
    .\__pi__222_ (\__pi__222_ ),
    .\__pi__223_ (\__pi__223_ ),
    .\__pi_i5__10 (\__pi_i5__10 ),
    .\__pi_q4__10 (\__pi_q4__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__224_ (\__po__224___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__218___assume (\__pi__218_ );
  miter_def_prop #(1, "assume") \__pi__219___assume (\__pi__219_ );
  miter_def_prop #(1, "assume") \__pi__222___assume (\__pi__222_ );
  miter_def_prop #(1, "assume") \__pi__223___assume (\__pi__223_ );
  miter_def_prop #(1, "assume") \__pi_i5__10__assume (\__pi_i5__10 );
  miter_def_prop #(1, "assume") \__pi_q4__10__assume (\__pi_q4__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__224___assert (\__po__224___gold , \__po__224___gate );
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
  miter_def_prop #(1, "cover") \__po__224___gold_cover (\__po__224___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__224___gate_cover (\__po__224___gate );
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
module \gold.test1._224_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__218_ ,
  input  [  0:0] \__pi__219_ ,
  input  [  0:0] \__pi__222_ ,
  input  [  0:0] \__pi__223_ ,
  input  [  0:0] \__pi_i5__10 ,
  input  [  0:0] \__pi_q4__10 ,
  output [  0:0] \__po__224_
);
endmodule
module \gate.test1._224_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__218_ ,
  input  [  0:0] \__pi__219_ ,
  input  [  0:0] \__pi__222_ ,
  input  [  0:0] \__pi__223_ ,
  input  [  0:0] \__pi_i5__10 ,
  input  [  0:0] \__pi_q4__10 ,
  output [  0:0] \__po__224_
);
endmodule
