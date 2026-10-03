module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__156_ ,
  input  [  0:0] \__pi__157_ ,
  input  [  0:0] \__pi__160_ ,
  input  [  0:0] \__pi__161_ ,
  input  [  0:0] \__pi_i2__4 ,
  input  [  0:0] \__pi_q3__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__165___gold ,
  output [  0:0] \__po__165___gate
);
  \gold.test1._165_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__156_ (\__pi__156_ ),
    .\__pi__157_ (\__pi__157_ ),
    .\__pi__160_ (\__pi__160_ ),
    .\__pi__161_ (\__pi__161_ ),
    .\__pi_i2__4 (\__pi_i2__4 ),
    .\__pi_q3__4 (\__pi_q3__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__165_ (\__po__165___gold )
  );
  \gate.test1._165_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__156_ (\__pi__156_ ),
    .\__pi__157_ (\__pi__157_ ),
    .\__pi__160_ (\__pi__160_ ),
    .\__pi__161_ (\__pi__161_ ),
    .\__pi_i2__4 (\__pi_i2__4 ),
    .\__pi_q3__4 (\__pi_q3__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__165_ (\__po__165___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__156___assume (\__pi__156_ );
  miter_def_prop #(1, "assume") \__pi__157___assume (\__pi__157_ );
  miter_def_prop #(1, "assume") \__pi__160___assume (\__pi__160_ );
  miter_def_prop #(1, "assume") \__pi__161___assume (\__pi__161_ );
  miter_def_prop #(1, "assume") \__pi_i2__4__assume (\__pi_i2__4 );
  miter_def_prop #(1, "assume") \__pi_q3__4__assume (\__pi_q3__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__165___assert (\__po__165___gold , \__po__165___gate );
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
  miter_def_prop #(1, "cover") \__po__165___gold_cover (\__po__165___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__165___gate_cover (\__po__165___gate );
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
module \gold.test1._165_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__156_ ,
  input  [  0:0] \__pi__157_ ,
  input  [  0:0] \__pi__160_ ,
  input  [  0:0] \__pi__161_ ,
  input  [  0:0] \__pi_i2__4 ,
  input  [  0:0] \__pi_q3__4 ,
  output [  0:0] \__po__165_
);
endmodule
module \gate.test1._165_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__156_ ,
  input  [  0:0] \__pi__157_ ,
  input  [  0:0] \__pi__160_ ,
  input  [  0:0] \__pi__161_ ,
  input  [  0:0] \__pi_i2__4 ,
  input  [  0:0] \__pi_q3__4 ,
  output [  0:0] \__po__165_
);
endmodule
