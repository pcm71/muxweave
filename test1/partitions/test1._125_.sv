module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__103_ ,
  input  [  0:0] \__pi__106_ ,
  input  [  0:0] \__pi__115_ ,
  input  [  0:0] \__pi__118_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q3__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__125___gold ,
  output [  0:0] \__po__125___gate
);
  \gold.test1._125_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__103_ (\__pi__103_ ),
    .\__pi__106_ (\__pi__106_ ),
    .\__pi__115_ (\__pi__115_ ),
    .\__pi__118_ (\__pi__118_ ),
    .\__pi_i2__8 (\__pi_i2__8 ),
    .\__pi_q3__8 (\__pi_q3__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__125_ (\__po__125___gold )
  );
  \gate.test1._125_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__103_ (\__pi__103_ ),
    .\__pi__106_ (\__pi__106_ ),
    .\__pi__115_ (\__pi__115_ ),
    .\__pi__118_ (\__pi__118_ ),
    .\__pi_i2__8 (\__pi_i2__8 ),
    .\__pi_q3__8 (\__pi_q3__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__125_ (\__po__125___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__103___assume (\__pi__103_ );
  miter_def_prop #(1, "assume") \__pi__106___assume (\__pi__106_ );
  miter_def_prop #(1, "assume") \__pi__115___assume (\__pi__115_ );
  miter_def_prop #(1, "assume") \__pi__118___assume (\__pi__118_ );
  miter_def_prop #(1, "assume") \__pi_i2__8__assume (\__pi_i2__8 );
  miter_def_prop #(1, "assume") \__pi_q3__8__assume (\__pi_q3__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__125___assert (\__po__125___gold , \__po__125___gate );
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
  miter_def_prop #(1, "cover") \__po__125___gold_cover (\__po__125___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__125___gate_cover (\__po__125___gate );
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
module \gold.test1._125_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__103_ ,
  input  [  0:0] \__pi__106_ ,
  input  [  0:0] \__pi__115_ ,
  input  [  0:0] \__pi__118_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q3__8 ,
  output [  0:0] \__po__125_
);
endmodule
module \gate.test1._125_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__103_ ,
  input  [  0:0] \__pi__106_ ,
  input  [  0:0] \__pi__115_ ,
  input  [  0:0] \__pi__118_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q3__8 ,
  output [  0:0] \__po__125_
);
endmodule
