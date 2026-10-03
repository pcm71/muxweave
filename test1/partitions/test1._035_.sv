module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__6 ,
  input  [  0:0] \__pi_i6__8 ,
  input  [  0:0] \__pi_q2__6 ,
  input  [  0:0] \__pi_q5__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__035___gold ,
  output [  0:0] \__po__035___gate
);
  \gold.test1._035_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__6 (\__pi_i3__6 ),
    .\__pi_i6__8 (\__pi_i6__8 ),
    .\__pi_q2__6 (\__pi_q2__6 ),
    .\__pi_q5__8 (\__pi_q5__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__035_ (\__po__035___gold )
  );
  \gate.test1._035_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__6 (\__pi_i3__6 ),
    .\__pi_i6__8 (\__pi_i6__8 ),
    .\__pi_q2__6 (\__pi_q2__6 ),
    .\__pi_q5__8 (\__pi_q5__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__035_ (\__po__035___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi_i3__6__assume (\__pi_i3__6 );
  miter_def_prop #(1, "assume") \__pi_i6__8__assume (\__pi_i6__8 );
  miter_def_prop #(1, "assume") \__pi_q2__6__assume (\__pi_q2__6 );
  miter_def_prop #(1, "assume") \__pi_q5__8__assume (\__pi_q5__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__035___assert (\__po__035___gold , \__po__035___gate );
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
  miter_def_prop #(1, "cover") \__po__035___gold_cover (\__po__035___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__035___gate_cover (\__po__035___gate );
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
module \gold.test1._035_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__6 ,
  input  [  0:0] \__pi_i6__8 ,
  input  [  0:0] \__pi_q2__6 ,
  input  [  0:0] \__pi_q5__8 ,
  output [  0:0] \__po__035_
);
endmodule
module \gate.test1._035_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__6 ,
  input  [  0:0] \__pi_i6__8 ,
  input  [  0:0] \__pi_q2__6 ,
  input  [  0:0] \__pi_q5__8 ,
  output [  0:0] \__po__035_
);
endmodule
