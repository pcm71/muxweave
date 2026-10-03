module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__3 ,
  input  [  0:0] \__pi_i5__10 ,
  input  [  0:0] \__pi_q2__3 ,
  input  [  0:0] \__pi_q6__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__065___gold ,
  output [  0:0] \__po__065___gate
);
  \gold.test1._065_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__3 (\__pi_i3__3 ),
    .\__pi_i5__10 (\__pi_i5__10 ),
    .\__pi_q2__3 (\__pi_q2__3 ),
    .\__pi_q6__10 (\__pi_q6__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__065_ (\__po__065___gold )
  );
  \gate.test1._065_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__3 (\__pi_i3__3 ),
    .\__pi_i5__10 (\__pi_i5__10 ),
    .\__pi_q2__3 (\__pi_q2__3 ),
    .\__pi_q6__10 (\__pi_q6__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__065_ (\__po__065___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi_i3__3__assume (\__pi_i3__3 );
  miter_def_prop #(1, "assume") \__pi_i5__10__assume (\__pi_i5__10 );
  miter_def_prop #(1, "assume") \__pi_q2__3__assume (\__pi_q2__3 );
  miter_def_prop #(1, "assume") \__pi_q6__10__assume (\__pi_q6__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__065___assert (\__po__065___gold , \__po__065___gate );
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
  miter_def_prop #(1, "cover") \__po__065___gold_cover (\__po__065___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__065___gate_cover (\__po__065___gate );
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
module \gold.test1._065_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__3 ,
  input  [  0:0] \__pi_i5__10 ,
  input  [  0:0] \__pi_q2__3 ,
  input  [  0:0] \__pi_q6__10 ,
  output [  0:0] \__po__065_
);
endmodule
module \gate.test1._065_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__3 ,
  input  [  0:0] \__pi_i5__10 ,
  input  [  0:0] \__pi_q2__3 ,
  input  [  0:0] \__pi_q6__10 ,
  output [  0:0] \__po__065_
);
endmodule
