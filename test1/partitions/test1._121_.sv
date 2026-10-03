module miter (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi__123_ ,
  input  [  0:0] \__pi__124_ ,
  input  [  0:0] \__pi__125_ ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q7__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__121___gold ,
  output [  0:0] \__po__121___gate
);
  \gold.test1._121_ gold (
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi__123_ (\__pi__123_ ),
    .\__pi__124_ (\__pi__124_ ),
    .\__pi__125_ (\__pi__125_ ),
    .\__pi_i6__0 (\__pi_i6__0 ),
    .\__pi_q7__0 (\__pi_q7__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__121_ (\__po__121___gold )
  );
  \gate.test1._121_ gate (
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi__122_ (\__pi__122_ ),
    .\__pi__123_ (\__pi__123_ ),
    .\__pi__124_ (\__pi__124_ ),
    .\__pi__125_ (\__pi__125_ ),
    .\__pi_i6__0 (\__pi_i6__0 ),
    .\__pi_q7__0 (\__pi_q7__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__121_ (\__po__121___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi__122___assume (\__pi__122_ );
  miter_def_prop #(1, "assume") \__pi__123___assume (\__pi__123_ );
  miter_def_prop #(1, "assume") \__pi__124___assume (\__pi__124_ );
  miter_def_prop #(1, "assume") \__pi__125___assume (\__pi__125_ );
  miter_def_prop #(1, "assume") \__pi_i6__0__assume (\__pi_i6__0 );
  miter_def_prop #(1, "assume") \__pi_q7__0__assume (\__pi_q7__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__121___assert (\__po__121___gold , \__po__121___gate );
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
  miter_def_prop #(1, "cover") \__po__121___gold_cover (\__po__121___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__121___gate_cover (\__po__121___gate );
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
module \gold.test1._121_ (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi__123_ ,
  input  [  0:0] \__pi__124_ ,
  input  [  0:0] \__pi__125_ ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q7__0 ,
  output [  0:0] \__po__121_
);
endmodule
module \gate.test1._121_ (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__122_ ,
  input  [  0:0] \__pi__123_ ,
  input  [  0:0] \__pi__124_ ,
  input  [  0:0] \__pi__125_ ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q7__0 ,
  output [  0:0] \__po__121_
);
endmodule
