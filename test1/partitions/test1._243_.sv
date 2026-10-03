module miter (
  input  [  0:0] \__pi_I0__10 ,
  input  [  0:0] \__pi_Q0__15 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i7__11 ,
  input  [  0:0] \__pi_q7__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__243___gold ,
  output [  0:0] \__po__243___gate
);
  \gold.test1._243_ gold (
    .\__pi_I0__10 (\__pi_I0__10 ),
    .\__pi_Q0__15 (\__pi_Q0__15 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i7__11 (\__pi_i7__11 ),
    .\__pi_q7__6 (\__pi_q7__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__243_ (\__po__243___gold )
  );
  \gate.test1._243_ gate (
    .\__pi_I0__10 (\__pi_I0__10 ),
    .\__pi_Q0__15 (\__pi_Q0__15 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi_i7__11 (\__pi_i7__11 ),
    .\__pi_q7__6 (\__pi_q7__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__243_ (\__po__243___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_I0__10__assume (\__pi_I0__10 );
  miter_def_prop #(1, "assume") \__pi_Q0__15__assume (\__pi_Q0__15 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__008___assume (\__pi__008_ );
  miter_def_prop #(1, "assume") \__pi__122___assume (\__pi__122_ );
  miter_def_prop #(1, "assume") \__pi_i7__11__assume (\__pi_i7__11 );
  miter_def_prop #(1, "assume") \__pi_q7__6__assume (\__pi_q7__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__243___assert (\__po__243___gold , \__po__243___gate );
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
  miter_def_prop #(1, "cover") \__po__243___gold_cover (\__po__243___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__243___gate_cover (\__po__243___gate );
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
module \gold.test1._243_ (
  input  [  0:0] \__pi_I0__10 ,
  input  [  0:0] \__pi_Q0__15 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i7__11 ,
  input  [  0:0] \__pi_q7__6 ,
  output [  0:0] \__po__243_
);
endmodule
module \gate.test1._243_ (
  input  [  0:0] \__pi_I0__10 ,
  input  [  0:0] \__pi_Q0__15 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi_i7__11 ,
  input  [  0:0] \__pi_q7__6 ,
  output [  0:0] \__po__243_
);
endmodule
