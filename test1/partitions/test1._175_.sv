module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__166_ ,
  input  [  0:0] \__pi__167_ ,
  input  [  0:0] \__pi__170_ ,
  input  [  0:0] \__pi__171_ ,
  input  [  0:0] \__pi_i2__3 ,
  input  [  0:0] \__pi_q3__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__175___gold ,
  output [  0:0] \__po__175___gate
);
  \gold.test1._175_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__166_ (\__pi__166_ ),
    .\__pi__167_ (\__pi__167_ ),
    .\__pi__170_ (\__pi__170_ ),
    .\__pi__171_ (\__pi__171_ ),
    .\__pi_i2__3 (\__pi_i2__3 ),
    .\__pi_q3__3 (\__pi_q3__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__175_ (\__po__175___gold )
  );
  \gate.test1._175_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__166_ (\__pi__166_ ),
    .\__pi__167_ (\__pi__167_ ),
    .\__pi__170_ (\__pi__170_ ),
    .\__pi__171_ (\__pi__171_ ),
    .\__pi_i2__3 (\__pi_i2__3 ),
    .\__pi_q3__3 (\__pi_q3__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__175_ (\__po__175___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__166___assume (\__pi__166_ );
  miter_def_prop #(1, "assume") \__pi__167___assume (\__pi__167_ );
  miter_def_prop #(1, "assume") \__pi__170___assume (\__pi__170_ );
  miter_def_prop #(1, "assume") \__pi__171___assume (\__pi__171_ );
  miter_def_prop #(1, "assume") \__pi_i2__3__assume (\__pi_i2__3 );
  miter_def_prop #(1, "assume") \__pi_q3__3__assume (\__pi_q3__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__175___assert (\__po__175___gold , \__po__175___gate );
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
  miter_def_prop #(1, "cover") \__po__175___gold_cover (\__po__175___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__175___gate_cover (\__po__175___gate );
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
module \gold.test1._175_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__166_ ,
  input  [  0:0] \__pi__167_ ,
  input  [  0:0] \__pi__170_ ,
  input  [  0:0] \__pi__171_ ,
  input  [  0:0] \__pi_i2__3 ,
  input  [  0:0] \__pi_q3__3 ,
  output [  0:0] \__po__175_
);
endmodule
module \gate.test1._175_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__166_ ,
  input  [  0:0] \__pi__167_ ,
  input  [  0:0] \__pi__170_ ,
  input  [  0:0] \__pi__171_ ,
  input  [  0:0] \__pi_i2__3 ,
  input  [  0:0] \__pi_q3__3 ,
  output [  0:0] \__po__175_
);
endmodule
