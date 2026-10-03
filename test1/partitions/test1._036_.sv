module miter (
  input  [  0:0] \__pi__037_ ,
  input  [  0:0] \__pi__038_ ,
  input  [  0:0] \__pi__039_ ,
  input  [  0:0] \__pi__040_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__8 ,
  input  [  0:0] \__pi_q6__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__036___gold ,
  output [  0:0] \__po__036___gate
);
  \gold.test1._036_ gold (
    .\__pi__037_ (\__pi__037_ ),
    .\__pi__038_ (\__pi__038_ ),
    .\__pi__039_ (\__pi__039_ ),
    .\__pi__040_ (\__pi__040_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__8 (\__pi_i7__8 ),
    .\__pi_q6__8 (\__pi_q6__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__036_ (\__po__036___gold )
  );
  \gate.test1._036_ gate (
    .\__pi__037_ (\__pi__037_ ),
    .\__pi__038_ (\__pi__038_ ),
    .\__pi__039_ (\__pi__039_ ),
    .\__pi__040_ (\__pi__040_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__8 (\__pi_i7__8 ),
    .\__pi_q6__8 (\__pi_q6__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__036_ (\__po__036___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__037___assume (\__pi__037_ );
  miter_def_prop #(1, "assume") \__pi__038___assume (\__pi__038_ );
  miter_def_prop #(1, "assume") \__pi__039___assume (\__pi__039_ );
  miter_def_prop #(1, "assume") \__pi__040___assume (\__pi__040_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi_i7__8__assume (\__pi_i7__8 );
  miter_def_prop #(1, "assume") \__pi_q6__8__assume (\__pi_q6__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__036___assert (\__po__036___gold , \__po__036___gate );
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
  miter_def_prop #(1, "cover") \__po__036___gold_cover (\__po__036___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__036___gate_cover (\__po__036___gate );
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
module \gold.test1._036_ (
  input  [  0:0] \__pi__037_ ,
  input  [  0:0] \__pi__038_ ,
  input  [  0:0] \__pi__039_ ,
  input  [  0:0] \__pi__040_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__8 ,
  input  [  0:0] \__pi_q6__8 ,
  output [  0:0] \__po__036_
);
endmodule
module \gate.test1._036_ (
  input  [  0:0] \__pi__037_ ,
  input  [  0:0] \__pi__038_ ,
  input  [  0:0] \__pi__039_ ,
  input  [  0:0] \__pi__040_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__8 ,
  input  [  0:0] \__pi_q6__8 ,
  output [  0:0] \__po__036_
);
endmodule
