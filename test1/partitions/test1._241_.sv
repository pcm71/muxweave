module miter (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i1__8 ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q0__8 ,
  input  [  0:0] \__pi_q5__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__241___gold ,
  output [  0:0] \__po__241___gate
);
  \gold.test1._241_ gold (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i1__8 (\__pi_i1__8 ),
    .\__pi_i6__6 (\__pi_i6__6 ),
    .\__pi_q0__8 (\__pi_q0__8 ),
    .\__pi_q5__6 (\__pi_q5__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__241_ (\__po__241___gold )
  );
  \gate.test1._241_ gate (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i1__8 (\__pi_i1__8 ),
    .\__pi_i6__6 (\__pi_i6__6 ),
    .\__pi_q0__8 (\__pi_q0__8 ),
    .\__pi_q5__6 (\__pi_q5__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__241_ (\__po__241___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__029___assume (\__pi__029_ );
  miter_def_prop #(1, "assume") \__pi__030___assume (\__pi__030_ );
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi_i1__8__assume (\__pi_i1__8 );
  miter_def_prop #(1, "assume") \__pi_i6__6__assume (\__pi_i6__6 );
  miter_def_prop #(1, "assume") \__pi_q0__8__assume (\__pi_q0__8 );
  miter_def_prop #(1, "assume") \__pi_q5__6__assume (\__pi_q5__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__241___assert (\__po__241___gold , \__po__241___gate );
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
  miter_def_prop #(1, "cover") \__po__241___gold_cover (\__po__241___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__241___gate_cover (\__po__241___gate );
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
module \gold.test1._241_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i1__8 ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q0__8 ,
  input  [  0:0] \__pi_q5__6 ,
  output [  0:0] \__po__241_
);
endmodule
module \gate.test1._241_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i1__8 ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q0__8 ,
  input  [  0:0] \__pi_q5__6 ,
  output [  0:0] \__po__241_
);
endmodule
