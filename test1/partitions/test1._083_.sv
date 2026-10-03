module miter (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i2__1 ,
  input  [  0:0] \__pi_i3__11 ,
  input  [  0:0] \__pi_q1__1 ,
  input  [  0:0] \__pi_q4__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__083___gold ,
  output [  0:0] \__po__083___gate
);
  \gold.test1._083_ gold (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i2__1 (\__pi_i2__1 ),
    .\__pi_i3__11 (\__pi_i3__11 ),
    .\__pi_q1__1 (\__pi_q1__1 ),
    .\__pi_q4__11 (\__pi_q4__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__083_ (\__po__083___gold )
  );
  \gate.test1._083_ gate (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i2__1 (\__pi_i2__1 ),
    .\__pi_i3__11 (\__pi_i3__11 ),
    .\__pi_q1__1 (\__pi_q1__1 ),
    .\__pi_q4__11 (\__pi_q4__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__083_ (\__po__083___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__010___assume (\__pi__010_ );
  miter_def_prop #(1, "assume") \__pi__011___assume (\__pi__011_ );
  miter_def_prop #(1, "assume") \__pi__110___assume (\__pi__110_ );
  miter_def_prop #(1, "assume") \__pi__111___assume (\__pi__111_ );
  miter_def_prop #(1, "assume") \__pi_i2__1__assume (\__pi_i2__1 );
  miter_def_prop #(1, "assume") \__pi_i3__11__assume (\__pi_i3__11 );
  miter_def_prop #(1, "assume") \__pi_q1__1__assume (\__pi_q1__1 );
  miter_def_prop #(1, "assume") \__pi_q4__11__assume (\__pi_q4__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__083___assert (\__po__083___gold , \__po__083___gate );
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
  miter_def_prop #(1, "cover") \__po__083___gold_cover (\__po__083___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__083___gate_cover (\__po__083___gate );
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
module \gold.test1._083_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i2__1 ,
  input  [  0:0] \__pi_i3__11 ,
  input  [  0:0] \__pi_q1__1 ,
  input  [  0:0] \__pi_q4__11 ,
  output [  0:0] \__po__083_
);
endmodule
module \gate.test1._083_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i2__1 ,
  input  [  0:0] \__pi_i3__11 ,
  input  [  0:0] \__pi_q1__1 ,
  input  [  0:0] \__pi_q4__11 ,
  output [  0:0] \__po__083_
);
endmodule
