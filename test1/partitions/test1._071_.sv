module miter (
  input  [  0:0] \__pi__072_ ,
  input  [  0:0] \__pi__073_ ,
  input  [  0:0] \__pi__074_ ,
  input  [  0:0] \__pi__075_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__10 ,
  input  [  0:0] \__pi_q1__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__071___gold ,
  output [  0:0] \__po__071___gate
);
  \gold.test1._071_ gold (
    .\__pi__072_ (\__pi__072_ ),
    .\__pi__073_ (\__pi__073_ ),
    .\__pi__074_ (\__pi__074_ ),
    .\__pi__075_ (\__pi__075_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__10 (\__pi_i2__10 ),
    .\__pi_q1__10 (\__pi_q1__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__071_ (\__po__071___gold )
  );
  \gate.test1._071_ gate (
    .\__pi__072_ (\__pi__072_ ),
    .\__pi__073_ (\__pi__073_ ),
    .\__pi__074_ (\__pi__074_ ),
    .\__pi__075_ (\__pi__075_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__10 (\__pi_i2__10 ),
    .\__pi_q1__10 (\__pi_q1__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__071_ (\__po__071___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__072___assume (\__pi__072_ );
  miter_def_prop #(1, "assume") \__pi__073___assume (\__pi__073_ );
  miter_def_prop #(1, "assume") \__pi__074___assume (\__pi__074_ );
  miter_def_prop #(1, "assume") \__pi__075___assume (\__pi__075_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i2__10__assume (\__pi_i2__10 );
  miter_def_prop #(1, "assume") \__pi_q1__10__assume (\__pi_q1__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__071___assert (\__po__071___gold , \__po__071___gate );
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
  miter_def_prop #(1, "cover") \__po__071___gold_cover (\__po__071___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__071___gate_cover (\__po__071___gate );
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
module \gold.test1._071_ (
  input  [  0:0] \__pi__072_ ,
  input  [  0:0] \__pi__073_ ,
  input  [  0:0] \__pi__074_ ,
  input  [  0:0] \__pi__075_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__10 ,
  input  [  0:0] \__pi_q1__10 ,
  output [  0:0] \__po__071_
);
endmodule
module \gate.test1._071_ (
  input  [  0:0] \__pi__072_ ,
  input  [  0:0] \__pi__073_ ,
  input  [  0:0] \__pi__074_ ,
  input  [  0:0] \__pi__075_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__10 ,
  input  [  0:0] \__pi_q1__10 ,
  output [  0:0] \__po__071_
);
endmodule
