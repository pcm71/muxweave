module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__7 ,
  input  [  0:0] \__pi_i5__7 ,
  input  [  0:0] \__pi_q2__7 ,
  input  [  0:0] \__pi_q6__7 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__015___gold ,
  output [  0:0] \__po__015___gate
);
  \gold.test1._015_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__7 (\__pi_i3__7 ),
    .\__pi_i5__7 (\__pi_i5__7 ),
    .\__pi_q2__7 (\__pi_q2__7 ),
    .\__pi_q6__7 (\__pi_q6__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__015_ (\__po__015___gold )
  );
  \gate.test1._015_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__7 (\__pi_i3__7 ),
    .\__pi_i5__7 (\__pi_i5__7 ),
    .\__pi_q2__7 (\__pi_q2__7 ),
    .\__pi_q6__7 (\__pi_q6__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__015_ (\__po__015___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi_i3__7__assume (\__pi_i3__7 );
  miter_def_prop #(1, "assume") \__pi_i5__7__assume (\__pi_i5__7 );
  miter_def_prop #(1, "assume") \__pi_q2__7__assume (\__pi_q2__7 );
  miter_def_prop #(1, "assume") \__pi_q6__7__assume (\__pi_q6__7 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__015___assert (\__po__015___gold , \__po__015___gate );
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
  miter_def_prop #(1, "cover") \__po__015___gold_cover (\__po__015___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__015___gate_cover (\__po__015___gate );
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
module \gold.test1._015_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__7 ,
  input  [  0:0] \__pi_i5__7 ,
  input  [  0:0] \__pi_q2__7 ,
  input  [  0:0] \__pi_q6__7 ,
  output [  0:0] \__po__015_
);
endmodule
module \gate.test1._015_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__7 ,
  input  [  0:0] \__pi_i5__7 ,
  input  [  0:0] \__pi_q2__7 ,
  input  [  0:0] \__pi_q6__7 ,
  output [  0:0] \__po__015_
);
endmodule
