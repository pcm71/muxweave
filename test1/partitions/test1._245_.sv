module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__236_ ,
  input  [  0:0] \__pi__237_ ,
  input  [  0:0] \__pi__240_ ,
  input  [  0:0] \__pi__241_ ,
  input  [  0:0] \__pi_i4__11 ,
  input  [  0:0] \__pi_q5__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__245___gold ,
  output [  0:0] \__po__245___gate
);
  \gold.test1._245_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__236_ (\__pi__236_ ),
    .\__pi__237_ (\__pi__237_ ),
    .\__pi__240_ (\__pi__240_ ),
    .\__pi__241_ (\__pi__241_ ),
    .\__pi_i4__11 (\__pi_i4__11 ),
    .\__pi_q5__11 (\__pi_q5__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__245_ (\__po__245___gold )
  );
  \gate.test1._245_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__236_ (\__pi__236_ ),
    .\__pi__237_ (\__pi__237_ ),
    .\__pi__240_ (\__pi__240_ ),
    .\__pi__241_ (\__pi__241_ ),
    .\__pi_i4__11 (\__pi_i4__11 ),
    .\__pi_q5__11 (\__pi_q5__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__245_ (\__po__245___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__236___assume (\__pi__236_ );
  miter_def_prop #(1, "assume") \__pi__237___assume (\__pi__237_ );
  miter_def_prop #(1, "assume") \__pi__240___assume (\__pi__240_ );
  miter_def_prop #(1, "assume") \__pi__241___assume (\__pi__241_ );
  miter_def_prop #(1, "assume") \__pi_i4__11__assume (\__pi_i4__11 );
  miter_def_prop #(1, "assume") \__pi_q5__11__assume (\__pi_q5__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__245___assert (\__po__245___gold , \__po__245___gate );
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
  miter_def_prop #(1, "cover") \__po__245___gold_cover (\__po__245___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__245___gate_cover (\__po__245___gate );
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
module \gold.test1._245_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__236_ ,
  input  [  0:0] \__pi__237_ ,
  input  [  0:0] \__pi__240_ ,
  input  [  0:0] \__pi__241_ ,
  input  [  0:0] \__pi_i4__11 ,
  input  [  0:0] \__pi_q5__11 ,
  output [  0:0] \__po__245_
);
endmodule
module \gate.test1._245_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__236_ ,
  input  [  0:0] \__pi__237_ ,
  input  [  0:0] \__pi__240_ ,
  input  [  0:0] \__pi__241_ ,
  input  [  0:0] \__pi_i4__11 ,
  input  [  0:0] \__pi_q5__11 ,
  output [  0:0] \__po__245_
);
endmodule
