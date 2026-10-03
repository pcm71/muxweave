module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__222_ ,
  input  [  0:0] \__pi__223_ ,
  input  [  0:0] \__pi__224_ ,
  input  [  0:0] \__pi__225_ ,
  input  [  0:0] \__pi_i6__5 ,
  input  [  0:0] \__pi_q5__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__221___gold ,
  output [  0:0] \__po__221___gate
);
  \gold.test1._221_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__222_ (\__pi__222_ ),
    .\__pi__223_ (\__pi__223_ ),
    .\__pi__224_ (\__pi__224_ ),
    .\__pi__225_ (\__pi__225_ ),
    .\__pi_i6__5 (\__pi_i6__5 ),
    .\__pi_q5__5 (\__pi_q5__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__221_ (\__po__221___gold )
  );
  \gate.test1._221_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__222_ (\__pi__222_ ),
    .\__pi__223_ (\__pi__223_ ),
    .\__pi__224_ (\__pi__224_ ),
    .\__pi__225_ (\__pi__225_ ),
    .\__pi_i6__5 (\__pi_i6__5 ),
    .\__pi_q5__5 (\__pi_q5__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__221_ (\__po__221___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__222___assume (\__pi__222_ );
  miter_def_prop #(1, "assume") \__pi__223___assume (\__pi__223_ );
  miter_def_prop #(1, "assume") \__pi__224___assume (\__pi__224_ );
  miter_def_prop #(1, "assume") \__pi__225___assume (\__pi__225_ );
  miter_def_prop #(1, "assume") \__pi_i6__5__assume (\__pi_i6__5 );
  miter_def_prop #(1, "assume") \__pi_q5__5__assume (\__pi_q5__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__221___assert (\__po__221___gold , \__po__221___gate );
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
  miter_def_prop #(1, "cover") \__po__221___gold_cover (\__po__221___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__221___gate_cover (\__po__221___gate );
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
module \gold.test1._221_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__222_ ,
  input  [  0:0] \__pi__223_ ,
  input  [  0:0] \__pi__224_ ,
  input  [  0:0] \__pi__225_ ,
  input  [  0:0] \__pi_i6__5 ,
  input  [  0:0] \__pi_q5__5 ,
  output [  0:0] \__po__221_
);
endmodule
module \gate.test1._221_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__222_ ,
  input  [  0:0] \__pi__223_ ,
  input  [  0:0] \__pi__224_ ,
  input  [  0:0] \__pi__225_ ,
  input  [  0:0] \__pi_i6__5 ,
  input  [  0:0] \__pi_q5__5 ,
  output [  0:0] \__po__221_
);
endmodule
