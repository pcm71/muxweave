module miter (
  input  [  0:0] \__pi__006_ ,
  input  [  0:0] \__pi__007_ ,
  input  [  0:0] \__pi__258_ ,
  input  [  0:0] \__pi__259_ ,
  input  [  3:0] \__pi_state ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__008___gold ,
  output [  0:0] \__po__008___gate
);
  \gold.test1._008_ gold (
    .\__pi__006_ (\__pi__006_ ),
    .\__pi__007_ (\__pi__007_ ),
    .\__pi__258_ (\__pi__258_ ),
    .\__pi__259_ (\__pi__259_ ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__008_ (\__po__008___gold )
  );
  \gate.test1._008_ gate (
    .\__pi__006_ (\__pi__006_ ),
    .\__pi__007_ (\__pi__007_ ),
    .\__pi__258_ (\__pi__258_ ),
    .\__pi__259_ (\__pi__259_ ),
    .\__pi_state (\__pi_state ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__008_ (\__po__008___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__006___assume (\__pi__006_ );
  miter_def_prop #(1, "assume") \__pi__007___assume (\__pi__007_ );
  miter_def_prop #(1, "assume") \__pi__258___assume (\__pi__258_ );
  miter_def_prop #(1, "assume") \__pi__259___assume (\__pi__259_ );
  miter_def_prop #(4, "assume") \__pi_state__assume (\__pi_state );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__008___assert (\__po__008___gold , \__po__008___gate );
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
  miter_def_prop #(1, "cover") \__po__008___gold_cover (\__po__008___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__008___gate_cover (\__po__008___gate );
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
module \gold.test1._008_ (
  input  [  0:0] \__pi__006_ ,
  input  [  0:0] \__pi__007_ ,
  input  [  0:0] \__pi__258_ ,
  input  [  0:0] \__pi__259_ ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__008_
);
endmodule
module \gate.test1._008_ (
  input  [  0:0] \__pi__006_ ,
  input  [  0:0] \__pi__007_ ,
  input  [  0:0] \__pi__258_ ,
  input  [  0:0] \__pi__259_ ,
  input  [  3:0] \__pi_state ,
  output [  0:0] \__po__008_
);
endmodule
