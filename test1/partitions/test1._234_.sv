module miter (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__228_ ,
  input  [  0:0] \__pi__229_ ,
  input  [  0:0] \__pi__232_ ,
  input  [  0:0] \__pi__233_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q1__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__234___gold ,
  output [  0:0] \__po__234___gate
);
  \gold.test1._234_ gold (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__228_ (\__pi__228_ ),
    .\__pi__229_ (\__pi__229_ ),
    .\__pi__232_ (\__pi__232_ ),
    .\__pi__233_ (\__pi__233_ ),
    .\__pi_i2__8 (\__pi_i2__8 ),
    .\__pi_q1__8 (\__pi_q1__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__234_ (\__po__234___gold )
  );
  \gate.test1._234_ gate (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__228_ (\__pi__228_ ),
    .\__pi__229_ (\__pi__229_ ),
    .\__pi__232_ (\__pi__232_ ),
    .\__pi__233_ (\__pi__233_ ),
    .\__pi_i2__8 (\__pi_i2__8 ),
    .\__pi_q1__8 (\__pi_q1__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__234_ (\__po__234___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__010___assume (\__pi__010_ );
  miter_def_prop #(1, "assume") \__pi__011___assume (\__pi__011_ );
  miter_def_prop #(1, "assume") \__pi__228___assume (\__pi__228_ );
  miter_def_prop #(1, "assume") \__pi__229___assume (\__pi__229_ );
  miter_def_prop #(1, "assume") \__pi__232___assume (\__pi__232_ );
  miter_def_prop #(1, "assume") \__pi__233___assume (\__pi__233_ );
  miter_def_prop #(1, "assume") \__pi_i2__8__assume (\__pi_i2__8 );
  miter_def_prop #(1, "assume") \__pi_q1__8__assume (\__pi_q1__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__234___assert (\__po__234___gold , \__po__234___gate );
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
  miter_def_prop #(1, "cover") \__po__234___gold_cover (\__po__234___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__234___gate_cover (\__po__234___gate );
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
module \gold.test1._234_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__228_ ,
  input  [  0:0] \__pi__229_ ,
  input  [  0:0] \__pi__232_ ,
  input  [  0:0] \__pi__233_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q1__8 ,
  output [  0:0] \__po__234_
);
endmodule
module \gate.test1._234_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__228_ ,
  input  [  0:0] \__pi__229_ ,
  input  [  0:0] \__pi__232_ ,
  input  [  0:0] \__pi__233_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q1__8 ,
  output [  0:0] \__po__234_
);
endmodule
