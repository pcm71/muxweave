module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__092_ ,
  input  [  0:0] \__pi__093_ ,
  input  [  0:0] \__pi__096_ ,
  input  [  0:0] \__pi__097_ ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q3__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__098___gold ,
  output [  0:0] \__po__098___gate
);
  \gold.test1._098_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__092_ (\__pi__092_ ),
    .\__pi__093_ (\__pi__093_ ),
    .\__pi__096_ (\__pi__096_ ),
    .\__pi__097_ (\__pi__097_ ),
    .\__pi_i4__0 (\__pi_i4__0 ),
    .\__pi_q3__0 (\__pi_q3__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__098_ (\__po__098___gold )
  );
  \gate.test1._098_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__092_ (\__pi__092_ ),
    .\__pi__093_ (\__pi__093_ ),
    .\__pi__096_ (\__pi__096_ ),
    .\__pi__097_ (\__pi__097_ ),
    .\__pi_i4__0 (\__pi_i4__0 ),
    .\__pi_q3__0 (\__pi_q3__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__098_ (\__po__098___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__092___assume (\__pi__092_ );
  miter_def_prop #(1, "assume") \__pi__093___assume (\__pi__093_ );
  miter_def_prop #(1, "assume") \__pi__096___assume (\__pi__096_ );
  miter_def_prop #(1, "assume") \__pi__097___assume (\__pi__097_ );
  miter_def_prop #(1, "assume") \__pi_i4__0__assume (\__pi_i4__0 );
  miter_def_prop #(1, "assume") \__pi_q3__0__assume (\__pi_q3__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__098___assert (\__po__098___gold , \__po__098___gate );
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
  miter_def_prop #(1, "cover") \__po__098___gold_cover (\__po__098___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__098___gate_cover (\__po__098___gate );
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
module \gold.test1._098_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__092_ ,
  input  [  0:0] \__pi__093_ ,
  input  [  0:0] \__pi__096_ ,
  input  [  0:0] \__pi__097_ ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q3__0 ,
  output [  0:0] \__po__098_
);
endmodule
module \gate.test1._098_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__092_ ,
  input  [  0:0] \__pi__093_ ,
  input  [  0:0] \__pi__096_ ,
  input  [  0:0] \__pi__097_ ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q3__0 ,
  output [  0:0] \__po__098_
);
endmodule
