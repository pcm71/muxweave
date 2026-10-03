module miter (
  input  [  0:0] \__pi__012_ ,
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__019_ ,
  input  [  0:0] \__pi__022_ ,
  input  [  0:0] \__pi__025_ ,
  input  [  0:0] \__pi__028_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__018___gold ,
  output [  0:0] \__po__018___gate
);
  \gold.test1._018_ gold (
    .\__pi__012_ (\__pi__012_ ),
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__019_ (\__pi__019_ ),
    .\__pi__022_ (\__pi__022_ ),
    .\__pi__025_ (\__pi__025_ ),
    .\__pi__028_ (\__pi__028_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__018_ (\__po__018___gold )
  );
  \gate.test1._018_ gate (
    .\__pi__012_ (\__pi__012_ ),
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__019_ (\__pi__019_ ),
    .\__pi__022_ (\__pi__022_ ),
    .\__pi__025_ (\__pi__025_ ),
    .\__pi__028_ (\__pi__028_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__018_ (\__po__018___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__012___assume (\__pi__012_ );
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__019___assume (\__pi__019_ );
  miter_def_prop #(1, "assume") \__pi__022___assume (\__pi__022_ );
  miter_def_prop #(1, "assume") \__pi__025___assume (\__pi__025_ );
  miter_def_prop #(1, "assume") \__pi__028___assume (\__pi__028_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__018___assert (\__po__018___gold , \__po__018___gate );
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
  miter_def_prop #(1, "cover") \__po__018___gold_cover (\__po__018___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__018___gate_cover (\__po__018___gate );
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
module \gold.test1._018_ (
  input  [  0:0] \__pi__012_ ,
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__019_ ,
  input  [  0:0] \__pi__022_ ,
  input  [  0:0] \__pi__025_ ,
  input  [  0:0] \__pi__028_ ,
  output [  0:0] \__po__018_
);
endmodule
module \gate.test1._018_ (
  input  [  0:0] \__pi__012_ ,
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__019_ ,
  input  [  0:0] \__pi__022_ ,
  input  [  0:0] \__pi__025_ ,
  input  [  0:0] \__pi__028_ ,
  output [  0:0] \__po__018_
);
endmodule
