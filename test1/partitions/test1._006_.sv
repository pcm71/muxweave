module miter (
  input  [  0:0] \__pi__007_ ,
  input  [  0:0] \__pi__009_ ,
  input  [  0:0] \__pi__012_ ,
  input  [  0:0] \__pi__015_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__7 ,
  input  [  0:0] \__pi_q6__7 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__006___gold ,
  output [  0:0] \__po__006___gate
);
  \gold.test1._006_ gold (
    .\__pi__007_ (\__pi__007_ ),
    .\__pi__009_ (\__pi__009_ ),
    .\__pi__012_ (\__pi__012_ ),
    .\__pi__015_ (\__pi__015_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__7 (\__pi_i7__7 ),
    .\__pi_q6__7 (\__pi_q6__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__006_ (\__po__006___gold )
  );
  \gate.test1._006_ gate (
    .\__pi__007_ (\__pi__007_ ),
    .\__pi__009_ (\__pi__009_ ),
    .\__pi__012_ (\__pi__012_ ),
    .\__pi__015_ (\__pi__015_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__7 (\__pi_i7__7 ),
    .\__pi_q6__7 (\__pi_q6__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__006_ (\__po__006___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__007___assume (\__pi__007_ );
  miter_def_prop #(1, "assume") \__pi__009___assume (\__pi__009_ );
  miter_def_prop #(1, "assume") \__pi__012___assume (\__pi__012_ );
  miter_def_prop #(1, "assume") \__pi__015___assume (\__pi__015_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi_i7__7__assume (\__pi_i7__7 );
  miter_def_prop #(1, "assume") \__pi_q6__7__assume (\__pi_q6__7 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__006___assert (\__po__006___gold , \__po__006___gate );
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
  miter_def_prop #(1, "cover") \__po__006___gold_cover (\__po__006___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__006___gate_cover (\__po__006___gate );
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
module \gold.test1._006_ (
  input  [  0:0] \__pi__007_ ,
  input  [  0:0] \__pi__009_ ,
  input  [  0:0] \__pi__012_ ,
  input  [  0:0] \__pi__015_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__7 ,
  input  [  0:0] \__pi_q6__7 ,
  output [  0:0] \__po__006_
);
endmodule
module \gate.test1._006_ (
  input  [  0:0] \__pi__007_ ,
  input  [  0:0] \__pi__009_ ,
  input  [  0:0] \__pi__012_ ,
  input  [  0:0] \__pi__015_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__7 ,
  input  [  0:0] \__pi_q6__7 ,
  output [  0:0] \__po__006_
);
endmodule
