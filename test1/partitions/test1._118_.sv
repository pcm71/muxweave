module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__9 ,
  input  [  0:0] \__pi_i5__0 ,
  input  [  0:0] \__pi_q4__9 ,
  input  [  0:0] \__pi_q6__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__118___gold ,
  output [  0:0] \__po__118___gate
);
  \gold.test1._118_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__9 (\__pi_i3__9 ),
    .\__pi_i5__0 (\__pi_i5__0 ),
    .\__pi_q4__9 (\__pi_q4__9 ),
    .\__pi_q6__0 (\__pi_q6__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__118_ (\__po__118___gold )
  );
  \gate.test1._118_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi_i3__9 (\__pi_i3__9 ),
    .\__pi_i5__0 (\__pi_i5__0 ),
    .\__pi_q4__9 (\__pi_q4__9 ),
    .\__pi_q6__0 (\__pi_q6__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__118_ (\__po__118___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi_i3__9__assume (\__pi_i3__9 );
  miter_def_prop #(1, "assume") \__pi_i5__0__assume (\__pi_i5__0 );
  miter_def_prop #(1, "assume") \__pi_q4__9__assume (\__pi_q4__9 );
  miter_def_prop #(1, "assume") \__pi_q6__0__assume (\__pi_q6__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__118___assert (\__po__118___gold , \__po__118___gate );
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
  miter_def_prop #(1, "cover") \__po__118___gold_cover (\__po__118___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__118___gate_cover (\__po__118___gate );
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
module \gold.test1._118_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__9 ,
  input  [  0:0] \__pi_i5__0 ,
  input  [  0:0] \__pi_q4__9 ,
  input  [  0:0] \__pi_q6__0 ,
  output [  0:0] \__po__118_
);
endmodule
module \gate.test1._118_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi_i3__9 ,
  input  [  0:0] \__pi_i5__0 ,
  input  [  0:0] \__pi_q4__9 ,
  input  [  0:0] \__pi_q6__0 ,
  output [  0:0] \__po__118_
);
endmodule
