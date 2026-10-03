module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__217_ ,
  input  [  0:0] \__pi__218_ ,
  input  [  0:0] \__pi__219_ ,
  input  [  0:0] \__pi__220_ ,
  input  [  0:0] \__pi_i1__5 ,
  input  [  0:0] \__pi_q0__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__216___gold ,
  output [  0:0] \__po__216___gate
);
  \gold.test1._216_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__217_ (\__pi__217_ ),
    .\__pi__218_ (\__pi__218_ ),
    .\__pi__219_ (\__pi__219_ ),
    .\__pi__220_ (\__pi__220_ ),
    .\__pi_i1__5 (\__pi_i1__5 ),
    .\__pi_q0__5 (\__pi_q0__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__216_ (\__po__216___gold )
  );
  \gate.test1._216_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__217_ (\__pi__217_ ),
    .\__pi__218_ (\__pi__218_ ),
    .\__pi__219_ (\__pi__219_ ),
    .\__pi__220_ (\__pi__220_ ),
    .\__pi_i1__5 (\__pi_i1__5 ),
    .\__pi_q0__5 (\__pi_q0__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__216_ (\__po__216___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__217___assume (\__pi__217_ );
  miter_def_prop #(1, "assume") \__pi__218___assume (\__pi__218_ );
  miter_def_prop #(1, "assume") \__pi__219___assume (\__pi__219_ );
  miter_def_prop #(1, "assume") \__pi__220___assume (\__pi__220_ );
  miter_def_prop #(1, "assume") \__pi_i1__5__assume (\__pi_i1__5 );
  miter_def_prop #(1, "assume") \__pi_q0__5__assume (\__pi_q0__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__216___assert (\__po__216___gold , \__po__216___gate );
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
  miter_def_prop #(1, "cover") \__po__216___gold_cover (\__po__216___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__216___gate_cover (\__po__216___gate );
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
module \gold.test1._216_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__217_ ,
  input  [  0:0] \__pi__218_ ,
  input  [  0:0] \__pi__219_ ,
  input  [  0:0] \__pi__220_ ,
  input  [  0:0] \__pi_i1__5 ,
  input  [  0:0] \__pi_q0__5 ,
  output [  0:0] \__po__216_
);
endmodule
module \gate.test1._216_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__217_ ,
  input  [  0:0] \__pi__218_ ,
  input  [  0:0] \__pi__219_ ,
  input  [  0:0] \__pi__220_ ,
  input  [  0:0] \__pi_i1__5 ,
  input  [  0:0] \__pi_q0__5 ,
  output [  0:0] \__po__216_
);
endmodule
