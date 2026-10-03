module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__162_ ,
  input  [  0:0] \__pi__163_ ,
  input  [  0:0] \__pi__164_ ,
  input  [  0:0] \__pi__165_ ,
  input  [  0:0] \__pi_i5__2 ,
  input  [  0:0] \__pi_q6__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__161___gold ,
  output [  0:0] \__po__161___gate
);
  \gold.test1._161_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__162_ (\__pi__162_ ),
    .\__pi__163_ (\__pi__163_ ),
    .\__pi__164_ (\__pi__164_ ),
    .\__pi__165_ (\__pi__165_ ),
    .\__pi_i5__2 (\__pi_i5__2 ),
    .\__pi_q6__2 (\__pi_q6__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__161_ (\__po__161___gold )
  );
  \gate.test1._161_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__162_ (\__pi__162_ ),
    .\__pi__163_ (\__pi__163_ ),
    .\__pi__164_ (\__pi__164_ ),
    .\__pi__165_ (\__pi__165_ ),
    .\__pi_i5__2 (\__pi_i5__2 ),
    .\__pi_q6__2 (\__pi_q6__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__161_ (\__po__161___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__162___assume (\__pi__162_ );
  miter_def_prop #(1, "assume") \__pi__163___assume (\__pi__163_ );
  miter_def_prop #(1, "assume") \__pi__164___assume (\__pi__164_ );
  miter_def_prop #(1, "assume") \__pi__165___assume (\__pi__165_ );
  miter_def_prop #(1, "assume") \__pi_i5__2__assume (\__pi_i5__2 );
  miter_def_prop #(1, "assume") \__pi_q6__2__assume (\__pi_q6__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__161___assert (\__po__161___gold , \__po__161___gate );
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
  miter_def_prop #(1, "cover") \__po__161___gold_cover (\__po__161___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__161___gate_cover (\__po__161___gate );
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
module \gold.test1._161_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__162_ ,
  input  [  0:0] \__pi__163_ ,
  input  [  0:0] \__pi__164_ ,
  input  [  0:0] \__pi__165_ ,
  input  [  0:0] \__pi_i5__2 ,
  input  [  0:0] \__pi_q6__2 ,
  output [  0:0] \__po__161_
);
endmodule
module \gate.test1._161_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__162_ ,
  input  [  0:0] \__pi__163_ ,
  input  [  0:0] \__pi__164_ ,
  input  [  0:0] \__pi__165_ ,
  input  [  0:0] \__pi_i5__2 ,
  input  [  0:0] \__pi_q6__2 ,
  output [  0:0] \__po__161_
);
endmodule
