module miter (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__060_ ,
  input  [  0:0] \__pi__061_ ,
  input  [  0:0] \__pi__064_ ,
  input  [  0:0] \__pi__065_ ,
  input  [  0:0] \__pi_i7__3 ,
  input  [  0:0] \__pi_q6__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__069___gold ,
  output [  0:0] \__po__069___gate
);
  \gold.test1._069_ gold (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__060_ (\__pi__060_ ),
    .\__pi__061_ (\__pi__061_ ),
    .\__pi__064_ (\__pi__064_ ),
    .\__pi__065_ (\__pi__065_ ),
    .\__pi_i7__3 (\__pi_i7__3 ),
    .\__pi_q6__3 (\__pi_q6__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__069_ (\__po__069___gold )
  );
  \gate.test1._069_ gate (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__060_ (\__pi__060_ ),
    .\__pi__061_ (\__pi__061_ ),
    .\__pi__064_ (\__pi__064_ ),
    .\__pi__065_ (\__pi__065_ ),
    .\__pi_i7__3 (\__pi_i7__3 ),
    .\__pi_q6__3 (\__pi_q6__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__069_ (\__po__069___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__060___assume (\__pi__060_ );
  miter_def_prop #(1, "assume") \__pi__061___assume (\__pi__061_ );
  miter_def_prop #(1, "assume") \__pi__064___assume (\__pi__064_ );
  miter_def_prop #(1, "assume") \__pi__065___assume (\__pi__065_ );
  miter_def_prop #(1, "assume") \__pi_i7__3__assume (\__pi_i7__3 );
  miter_def_prop #(1, "assume") \__pi_q6__3__assume (\__pi_q6__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__069___assert (\__po__069___gold , \__po__069___gate );
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
  miter_def_prop #(1, "cover") \__po__069___gold_cover (\__po__069___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__069___gate_cover (\__po__069___gate );
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
module \gold.test1._069_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__060_ ,
  input  [  0:0] \__pi__061_ ,
  input  [  0:0] \__pi__064_ ,
  input  [  0:0] \__pi__065_ ,
  input  [  0:0] \__pi_i7__3 ,
  input  [  0:0] \__pi_q6__3 ,
  output [  0:0] \__po__069_
);
endmodule
module \gate.test1._069_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__060_ ,
  input  [  0:0] \__pi__061_ ,
  input  [  0:0] \__pi__064_ ,
  input  [  0:0] \__pi__065_ ,
  input  [  0:0] \__pi_i7__3 ,
  input  [  0:0] \__pi_q6__3 ,
  output [  0:0] \__po__069_
);
endmodule
