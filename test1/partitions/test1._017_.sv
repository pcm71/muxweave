module miter (
  input  [  0:0] \__pi_Q0__11 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i7__7 ,
  input  [  3:0] \__pi_state ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__017___gold ,
  output [  0:0] \__po__017___gate
);
  \gold.test1._017_ gold (
    .\__pi_Q0__11 (\__pi_Q0__11 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i7__7 (\__pi_i7__7 ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__017_ (\__po__017___gold )
  );
  \gate.test1._017_ gate (
    .\__pi_Q0__11 (\__pi_Q0__11 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i7__7 (\__pi_i7__7 ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__017_ (\__po__017___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_Q0__11__assume (\__pi_Q0__11 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__122___assume (\__pi__122_ );
  miter_def_prop #(1, "assume") \__pi_i7__7__assume (\__pi_i7__7 );
  miter_def_prop #(4, "assume") \__pi_state__assume (\__pi_state );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__017___assert (\__po__017___gold , \__po__017___gate );
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
  miter_def_prop #(1, "cover") \__po__017___gold_cover (\__po__017___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__017___gate_cover (\__po__017___gate );
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
module \gold.test1._017_ (
  input  [  0:0] \__pi_Q0__11 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i7__7 ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__017_
);
endmodule
module \gate.test1._017_ (
  input  [  0:0] \__pi_Q0__11 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i7__7 ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__017_
);
endmodule
