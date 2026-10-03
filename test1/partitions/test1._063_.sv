module miter (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i2__3 ,
  input  [  0:0] \__pi_i3__10 ,
  input  [  0:0] \__pi_q1__3 ,
  input  [  0:0] \__pi_q4__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__063___gold ,
  output [  0:0] \__po__063___gate
);
  \gold.test1._063_ gold (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i2__3 (\__pi_i2__3 ),
    .\__pi_i3__10 (\__pi_i3__10 ),
    .\__pi_q1__3 (\__pi_q1__3 ),
    .\__pi_q4__10 (\__pi_q4__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__063_ (\__po__063___gold )
  );
  \gate.test1._063_ gate (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i2__3 (\__pi_i2__3 ),
    .\__pi_i3__10 (\__pi_i3__10 ),
    .\__pi_q1__3 (\__pi_q1__3 ),
    .\__pi_q4__10 (\__pi_q4__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__063_ (\__po__063___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__010___assume (\__pi__010_ );
  miter_def_prop #(1, "assume") \__pi__011___assume (\__pi__011_ );
  miter_def_prop #(1, "assume") \__pi__110___assume (\__pi__110_ );
  miter_def_prop #(1, "assume") \__pi__111___assume (\__pi__111_ );
  miter_def_prop #(1, "assume") \__pi_i2__3__assume (\__pi_i2__3 );
  miter_def_prop #(1, "assume") \__pi_i3__10__assume (\__pi_i3__10 );
  miter_def_prop #(1, "assume") \__pi_q1__3__assume (\__pi_q1__3 );
  miter_def_prop #(1, "assume") \__pi_q4__10__assume (\__pi_q4__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__063___assert (\__po__063___gold , \__po__063___gate );
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
  miter_def_prop #(1, "cover") \__po__063___gold_cover (\__po__063___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__063___gate_cover (\__po__063___gate );
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
module \gold.test1._063_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i2__3 ,
  input  [  0:0] \__pi_i3__10 ,
  input  [  0:0] \__pi_q1__3 ,
  input  [  0:0] \__pi_q4__10 ,
  output [  0:0] \__po__063_
);
endmodule
module \gate.test1._063_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i2__3 ,
  input  [  0:0] \__pi_i3__10 ,
  input  [  0:0] \__pi_q1__3 ,
  input  [  0:0] \__pi_q4__10 ,
  output [  0:0] \__po__063_
);
endmodule
