module miter (
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__103_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  3:0] \__pi_state ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__101___gold ,
  output [  0:0] \__po__101___gate
);
  \gold.test1._101_ gold (
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__103_ (\__pi__103_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__101_ (\__po__101___gold )
  );
  \gate.test1._101_ gate (
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__103_ (\__pi__103_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__101_ (\__po__101___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__103___assume (\__pi__103_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(4, "assume") \__pi_state__assume (\__pi_state );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__101___assert (\__po__101___gold , \__po__101___gate );
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
  miter_def_prop #(1, "cover") \__po__101___gold_cover (\__po__101___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__101___gate_cover (\__po__101___gate );
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
module \gold.test1._101_ (
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__103_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__101_
);
endmodule
module \gate.test1._101_ (
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__103_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__101_
);
endmodule
