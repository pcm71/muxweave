module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__216_ ,
  input  [  0:0] \__pi__217_ ,
  input  [  0:0] \__pi__220_ ,
  input  [  0:0] \__pi__221_ ,
  input  [  0:0] \__pi_i3__10 ,
  input  [  0:0] \__pi_q2__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__225___gold ,
  output [  0:0] \__po__225___gate
);
  \gold.test1._225_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__216_ (\__pi__216_ ),
    .\__pi__217_ (\__pi__217_ ),
    .\__pi__220_ (\__pi__220_ ),
    .\__pi__221_ (\__pi__221_ ),
    .\__pi_i3__10 (\__pi_i3__10 ),
    .\__pi_q2__10 (\__pi_q2__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__225_ (\__po__225___gold )
  );
  \gate.test1._225_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__216_ (\__pi__216_ ),
    .\__pi__217_ (\__pi__217_ ),
    .\__pi__220_ (\__pi__220_ ),
    .\__pi__221_ (\__pi__221_ ),
    .\__pi_i3__10 (\__pi_i3__10 ),
    .\__pi_q2__10 (\__pi_q2__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__225_ (\__po__225___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__216___assume (\__pi__216_ );
  miter_def_prop #(1, "assume") \__pi__217___assume (\__pi__217_ );
  miter_def_prop #(1, "assume") \__pi__220___assume (\__pi__220_ );
  miter_def_prop #(1, "assume") \__pi__221___assume (\__pi__221_ );
  miter_def_prop #(1, "assume") \__pi_i3__10__assume (\__pi_i3__10 );
  miter_def_prop #(1, "assume") \__pi_q2__10__assume (\__pi_q2__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__225___assert (\__po__225___gold , \__po__225___gate );
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
  miter_def_prop #(1, "cover") \__po__225___gold_cover (\__po__225___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__225___gate_cover (\__po__225___gate );
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
module \gold.test1._225_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__216_ ,
  input  [  0:0] \__pi__217_ ,
  input  [  0:0] \__pi__220_ ,
  input  [  0:0] \__pi__221_ ,
  input  [  0:0] \__pi_i3__10 ,
  input  [  0:0] \__pi_q2__10 ,
  output [  0:0] \__po__225_
);
endmodule
module \gate.test1._225_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__216_ ,
  input  [  0:0] \__pi__217_ ,
  input  [  0:0] \__pi__220_ ,
  input  [  0:0] \__pi__221_ ,
  input  [  0:0] \__pi_i3__10 ,
  input  [  0:0] \__pi_q2__10 ,
  output [  0:0] \__po__225_
);
endmodule
