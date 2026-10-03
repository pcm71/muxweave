module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__198_ ,
  input  [  0:0] \__pi__199_ ,
  input  [  0:0] \__pi__202_ ,
  input  [  0:0] \__pi__203_ ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q5__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__204___gold ,
  output [  0:0] \__po__204___gate
);
  \gold.test1._204_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__198_ (\__pi__198_ ),
    .\__pi__199_ (\__pi__199_ ),
    .\__pi__202_ (\__pi__202_ ),
    .\__pi__203_ (\__pi__203_ ),
    .\__pi_i4__0 (\__pi_i4__0 ),
    .\__pi_q5__0 (\__pi_q5__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__204_ (\__po__204___gold )
  );
  \gate.test1._204_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__198_ (\__pi__198_ ),
    .\__pi__199_ (\__pi__199_ ),
    .\__pi__202_ (\__pi__202_ ),
    .\__pi__203_ (\__pi__203_ ),
    .\__pi_i4__0 (\__pi_i4__0 ),
    .\__pi_q5__0 (\__pi_q5__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__204_ (\__po__204___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__198___assume (\__pi__198_ );
  miter_def_prop #(1, "assume") \__pi__199___assume (\__pi__199_ );
  miter_def_prop #(1, "assume") \__pi__202___assume (\__pi__202_ );
  miter_def_prop #(1, "assume") \__pi__203___assume (\__pi__203_ );
  miter_def_prop #(1, "assume") \__pi_i4__0__assume (\__pi_i4__0 );
  miter_def_prop #(1, "assume") \__pi_q5__0__assume (\__pi_q5__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__204___assert (\__po__204___gold , \__po__204___gate );
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
  miter_def_prop #(1, "cover") \__po__204___gold_cover (\__po__204___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__204___gate_cover (\__po__204___gate );
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
module \gold.test1._204_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__198_ ,
  input  [  0:0] \__pi__199_ ,
  input  [  0:0] \__pi__202_ ,
  input  [  0:0] \__pi__203_ ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q5__0 ,
  output [  0:0] \__po__204_
);
endmodule
module \gate.test1._204_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__198_ ,
  input  [  0:0] \__pi__199_ ,
  input  [  0:0] \__pi__202_ ,
  input  [  0:0] \__pi__203_ ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q5__0 ,
  output [  0:0] \__po__204_
);
endmodule
