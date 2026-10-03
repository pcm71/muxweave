module miter (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__080_ ,
  input  [  0:0] \__pi__081_ ,
  input  [  0:0] \__pi__084_ ,
  input  [  0:0] \__pi__085_ ,
  input  [  0:0] \__pi_i7__1 ,
  input  [  0:0] \__pi_q6__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__089___gold ,
  output [  0:0] \__po__089___gate
);
  \gold.test1._089_ gold (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__080_ (\__pi__080_ ),
    .\__pi__081_ (\__pi__081_ ),
    .\__pi__084_ (\__pi__084_ ),
    .\__pi__085_ (\__pi__085_ ),
    .\__pi_i7__1 (\__pi_i7__1 ),
    .\__pi_q6__1 (\__pi_q6__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__089_ (\__po__089___gold )
  );
  \gate.test1._089_ gate (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__080_ (\__pi__080_ ),
    .\__pi__081_ (\__pi__081_ ),
    .\__pi__084_ (\__pi__084_ ),
    .\__pi__085_ (\__pi__085_ ),
    .\__pi_i7__1 (\__pi_i7__1 ),
    .\__pi_q6__1 (\__pi_q6__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__089_ (\__po__089___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__080___assume (\__pi__080_ );
  miter_def_prop #(1, "assume") \__pi__081___assume (\__pi__081_ );
  miter_def_prop #(1, "assume") \__pi__084___assume (\__pi__084_ );
  miter_def_prop #(1, "assume") \__pi__085___assume (\__pi__085_ );
  miter_def_prop #(1, "assume") \__pi_i7__1__assume (\__pi_i7__1 );
  miter_def_prop #(1, "assume") \__pi_q6__1__assume (\__pi_q6__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__089___assert (\__po__089___gold , \__po__089___gate );
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
  miter_def_prop #(1, "cover") \__po__089___gold_cover (\__po__089___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__089___gate_cover (\__po__089___gate );
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
module \gold.test1._089_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__080_ ,
  input  [  0:0] \__pi__081_ ,
  input  [  0:0] \__pi__084_ ,
  input  [  0:0] \__pi__085_ ,
  input  [  0:0] \__pi_i7__1 ,
  input  [  0:0] \__pi_q6__1 ,
  output [  0:0] \__po__089_
);
endmodule
module \gate.test1._089_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__080_ ,
  input  [  0:0] \__pi__081_ ,
  input  [  0:0] \__pi__084_ ,
  input  [  0:0] \__pi__085_ ,
  input  [  0:0] \__pi_i7__1 ,
  input  [  0:0] \__pi_q6__1 ,
  output [  0:0] \__po__089_
);
endmodule
