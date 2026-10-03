module miter (
  input  [  0:0] \__pi__087_ ,
  input  [  0:0] \__pi__088_ ,
  input  [  0:0] \__pi__089_ ,
  input  [  0:0] \__pi__090_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i6__11 ,
  input  [  0:0] \__pi_q7__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__086___gold ,
  output [  0:0] \__po__086___gate
);
  \gold.test1._086_ gold (
    .\__pi__087_ (\__pi__087_ ),
    .\__pi__088_ (\__pi__088_ ),
    .\__pi__089_ (\__pi__089_ ),
    .\__pi__090_ (\__pi__090_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i6__11 (\__pi_i6__11 ),
    .\__pi_q7__11 (\__pi_q7__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__086_ (\__po__086___gold )
  );
  \gate.test1._086_ gate (
    .\__pi__087_ (\__pi__087_ ),
    .\__pi__088_ (\__pi__088_ ),
    .\__pi__089_ (\__pi__089_ ),
    .\__pi__090_ (\__pi__090_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i6__11 (\__pi_i6__11 ),
    .\__pi_q7__11 (\__pi_q7__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__086_ (\__po__086___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__087___assume (\__pi__087_ );
  miter_def_prop #(1, "assume") \__pi__088___assume (\__pi__088_ );
  miter_def_prop #(1, "assume") \__pi__089___assume (\__pi__089_ );
  miter_def_prop #(1, "assume") \__pi__090___assume (\__pi__090_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi_i6__11__assume (\__pi_i6__11 );
  miter_def_prop #(1, "assume") \__pi_q7__11__assume (\__pi_q7__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__086___assert (\__po__086___gold , \__po__086___gate );
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
  miter_def_prop #(1, "cover") \__po__086___gold_cover (\__po__086___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__086___gate_cover (\__po__086___gate );
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
module \gold.test1._086_ (
  input  [  0:0] \__pi__087_ ,
  input  [  0:0] \__pi__088_ ,
  input  [  0:0] \__pi__089_ ,
  input  [  0:0] \__pi__090_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i6__11 ,
  input  [  0:0] \__pi_q7__11 ,
  output [  0:0] \__po__086_
);
endmodule
module \gate.test1._086_ (
  input  [  0:0] \__pi__087_ ,
  input  [  0:0] \__pi__088_ ,
  input  [  0:0] \__pi__089_ ,
  input  [  0:0] \__pi__090_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i6__11 ,
  input  [  0:0] \__pi_q7__11 ,
  output [  0:0] \__po__086_
);
endmodule
