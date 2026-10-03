module miter (
  input  [  0:0] \__pi_I0__9 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i2__10 ,
  input  [  0:0] \__pi_q1__10 ,
  input  [  0:0] \__pi_q7__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__223___gold ,
  output [  0:0] \__po__223___gate
);
  \gold.test1._223_ gold (
    .\__pi_I0__9 (\__pi_I0__9 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i2__10 (\__pi_i2__10 ),
    .\__pi_q1__10 (\__pi_q1__10 ),
    .\__pi_q7__5 (\__pi_q7__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__223_ (\__po__223___gold )
  );
  \gate.test1._223_ gate (
    .\__pi_I0__9 (\__pi_I0__9 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i2__10 (\__pi_i2__10 ),
    .\__pi_q1__10 (\__pi_q1__10 ),
    .\__pi_q7__5 (\__pi_q7__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__223_ (\__po__223___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_I0__9__assume (\__pi_I0__9 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__010___assume (\__pi__010_ );
  miter_def_prop #(1, "assume") \__pi__011___assume (\__pi__011_ );
  miter_def_prop #(1, "assume") \__pi__122___assume (\__pi__122_ );
  miter_def_prop #(1, "assume") \__pi_i2__10__assume (\__pi_i2__10 );
  miter_def_prop #(1, "assume") \__pi_q1__10__assume (\__pi_q1__10 );
  miter_def_prop #(1, "assume") \__pi_q7__5__assume (\__pi_q7__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__223___assert (\__po__223___gold , \__po__223___gate );
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
  miter_def_prop #(1, "cover") \__po__223___gold_cover (\__po__223___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__223___gate_cover (\__po__223___gate );
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
module \gold.test1._223_ (
  input  [  0:0] \__pi_I0__9 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i2__10 ,
  input  [  0:0] \__pi_q1__10 ,
  input  [  0:0] \__pi_q7__5 ,
  output [  0:0] \__po__223_
);
endmodule
module \gate.test1._223_ (
  input  [  0:0] \__pi_I0__9 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i2__10 ,
  input  [  0:0] \__pi_q1__10 ,
  input  [  0:0] \__pi_q7__5 ,
  output [  0:0] \__po__223_
);
endmodule
