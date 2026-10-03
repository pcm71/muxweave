module miter (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i4__4 ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q3__4 ,
  input  [  0:0] \__pi_q7__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__209___gold ,
  output [  0:0] \__po__209___gate
);
  \gold.test1._209_ gold (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i4__4 (\__pi_i4__4 ),
    .\__pi_i6__0 (\__pi_i6__0 ),
    .\__pi_q3__4 (\__pi_q3__4 ),
    .\__pi_q7__0 (\__pi_q7__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__209_ (\__po__209___gold )
  );
  \gate.test1._209_ gate (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i4__4 (\__pi_i4__4 ),
    .\__pi_i6__0 (\__pi_i6__0 ),
    .\__pi_q3__4 (\__pi_q3__4 ),
    .\__pi_q7__0 (\__pi_q7__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__209_ (\__po__209___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__110___assume (\__pi__110_ );
  miter_def_prop #(1, "assume") \__pi__111___assume (\__pi__111_ );
  miter_def_prop #(1, "assume") \__pi_i4__4__assume (\__pi_i4__4 );
  miter_def_prop #(1, "assume") \__pi_i6__0__assume (\__pi_i6__0 );
  miter_def_prop #(1, "assume") \__pi_q3__4__assume (\__pi_q3__4 );
  miter_def_prop #(1, "assume") \__pi_q7__0__assume (\__pi_q7__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__209___assert (\__po__209___gold , \__po__209___gate );
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
  miter_def_prop #(1, "cover") \__po__209___gold_cover (\__po__209___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__209___gate_cover (\__po__209___gate );
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
module \gold.test1._209_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i4__4 ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q3__4 ,
  input  [  0:0] \__pi_q7__0 ,
  output [  0:0] \__po__209_
);
endmodule
module \gate.test1._209_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i4__4 ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q3__4 ,
  input  [  0:0] \__pi_q7__0 ,
  output [  0:0] \__po__209_
);
endmodule
