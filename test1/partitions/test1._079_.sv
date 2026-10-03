module miter (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__070_ ,
  input  [  0:0] \__pi__071_ ,
  input  [  0:0] \__pi__074_ ,
  input  [  0:0] \__pi__075_ ,
  input  [  0:0] \__pi_i7__2 ,
  input  [  0:0] \__pi_q6__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__079___gold ,
  output [  0:0] \__po__079___gate
);
  \gold.test1._079_ gold (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__070_ (\__pi__070_ ),
    .\__pi__071_ (\__pi__071_ ),
    .\__pi__074_ (\__pi__074_ ),
    .\__pi__075_ (\__pi__075_ ),
    .\__pi_i7__2 (\__pi_i7__2 ),
    .\__pi_q6__2 (\__pi_q6__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__079_ (\__po__079___gold )
  );
  \gate.test1._079_ gate (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__070_ (\__pi__070_ ),
    .\__pi__071_ (\__pi__071_ ),
    .\__pi__074_ (\__pi__074_ ),
    .\__pi__075_ (\__pi__075_ ),
    .\__pi_i7__2 (\__pi_i7__2 ),
    .\__pi_q6__2 (\__pi_q6__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__079_ (\__po__079___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__070___assume (\__pi__070_ );
  miter_def_prop #(1, "assume") \__pi__071___assume (\__pi__071_ );
  miter_def_prop #(1, "assume") \__pi__074___assume (\__pi__074_ );
  miter_def_prop #(1, "assume") \__pi__075___assume (\__pi__075_ );
  miter_def_prop #(1, "assume") \__pi_i7__2__assume (\__pi_i7__2 );
  miter_def_prop #(1, "assume") \__pi_q6__2__assume (\__pi_q6__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__079___assert (\__po__079___gold , \__po__079___gate );
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
  miter_def_prop #(1, "cover") \__po__079___gold_cover (\__po__079___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__079___gate_cover (\__po__079___gate );
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
module \gold.test1._079_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__070_ ,
  input  [  0:0] \__pi__071_ ,
  input  [  0:0] \__pi__074_ ,
  input  [  0:0] \__pi__075_ ,
  input  [  0:0] \__pi_i7__2 ,
  input  [  0:0] \__pi_q6__2 ,
  output [  0:0] \__po__079_
);
endmodule
module \gate.test1._079_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__070_ ,
  input  [  0:0] \__pi__071_ ,
  input  [  0:0] \__pi__074_ ,
  input  [  0:0] \__pi__075_ ,
  input  [  0:0] \__pi_i7__2 ,
  input  [  0:0] \__pi_q6__2 ,
  output [  0:0] \__po__079_
);
endmodule
