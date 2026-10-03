module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i5__5 ,
  input  [  0:0] \__pi_q6__5 ,
  input  [  2:0] \__pi_state__3_1 ,
  input  [  0:0] \__pi_valid ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__231___gold ,
  output [  0:0] \__po__231___gate
);
  \gold.test1._231_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i5__5 (\__pi_i5__5 ),
    .\__pi_q6__5 (\__pi_q6__5 ),
    .\__pi_state__3_1 (\__pi_state__3_1 ),
    .\__pi_valid (\__pi_valid ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__231_ (\__po__231___gold )
  );
  \gate.test1._231_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i5__5 (\__pi_i5__5 ),
    .\__pi_q6__5 (\__pi_q6__5 ),
    .\__pi_state__3_1 (\__pi_state__3_1 ),
    .\__pi_valid (\__pi_valid ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__231_ (\__po__231___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi_i5__5__assume (\__pi_i5__5 );
  miter_def_prop #(1, "assume") \__pi_q6__5__assume (\__pi_q6__5 );
  miter_def_prop #(3, "assume") \__pi_state__3_1__assume (\__pi_state__3_1 );
  miter_def_prop #(1, "assume") \__pi_valid__assume (\__pi_valid );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__231___assert (\__po__231___gold , \__po__231___gate );
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
  miter_def_prop #(1, "cover") \__po__231___gold_cover (\__po__231___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__231___gate_cover (\__po__231___gate );
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
module \gold.test1._231_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i5__5 ,
  input  [  0:0] \__pi_q6__5 ,
  input  [  2:0] \__pi_state__3_1 ,
  input  [  0:0] \__pi_valid ,
  output [  0:0] \__po__231_
);
endmodule
module \gate.test1._231_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i5__5 ,
  input  [  0:0] \__pi_q6__5 ,
  input  [  2:0] \__pi_state__3_1 ,
  input  [  0:0] \__pi_valid ,
  output [  0:0] \__po__231_
);
endmodule
