module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__062_ ,
  input  [  0:0] \__pi__063_ ,
  input  [  0:0] \__pi__066_ ,
  input  [  0:0] \__pi__067_ ,
  input  [  0:0] \__pi_i4__3 ,
  input  [  0:0] \__pi_q3__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__068___gold ,
  output [  0:0] \__po__068___gate
);
  \gold.test1._068_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__062_ (\__pi__062_ ),
    .\__pi__063_ (\__pi__063_ ),
    .\__pi__066_ (\__pi__066_ ),
    .\__pi__067_ (\__pi__067_ ),
    .\__pi_i4__3 (\__pi_i4__3 ),
    .\__pi_q3__3 (\__pi_q3__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__068_ (\__po__068___gold )
  );
  \gate.test1._068_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__062_ (\__pi__062_ ),
    .\__pi__063_ (\__pi__063_ ),
    .\__pi__066_ (\__pi__066_ ),
    .\__pi__067_ (\__pi__067_ ),
    .\__pi_i4__3 (\__pi_i4__3 ),
    .\__pi_q3__3 (\__pi_q3__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__068_ (\__po__068___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__062___assume (\__pi__062_ );
  miter_def_prop #(1, "assume") \__pi__063___assume (\__pi__063_ );
  miter_def_prop #(1, "assume") \__pi__066___assume (\__pi__066_ );
  miter_def_prop #(1, "assume") \__pi__067___assume (\__pi__067_ );
  miter_def_prop #(1, "assume") \__pi_i4__3__assume (\__pi_i4__3 );
  miter_def_prop #(1, "assume") \__pi_q3__3__assume (\__pi_q3__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__068___assert (\__po__068___gold , \__po__068___gate );
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
  miter_def_prop #(1, "cover") \__po__068___gold_cover (\__po__068___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__068___gate_cover (\__po__068___gate );
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
module \gold.test1._068_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__062_ ,
  input  [  0:0] \__pi__063_ ,
  input  [  0:0] \__pi__066_ ,
  input  [  0:0] \__pi__067_ ,
  input  [  0:0] \__pi_i4__3 ,
  input  [  0:0] \__pi_q3__3 ,
  output [  0:0] \__po__068_
);
endmodule
module \gate.test1._068_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__062_ ,
  input  [  0:0] \__pi__063_ ,
  input  [  0:0] \__pi__066_ ,
  input  [  0:0] \__pi__067_ ,
  input  [  0:0] \__pi_i4__3 ,
  input  [  0:0] \__pi_q3__3 ,
  output [  0:0] \__po__068_
);
endmodule
