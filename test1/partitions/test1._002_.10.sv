module miter (
  input  [  0:0] \__pi__068_ ,
  input  [  0:0] \__pi__069_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__106_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__002___10__gold ,
  output [  0:0] \__po__002___10__gate
);
  \gold.test1._002_.10 gold (
    .\__pi__068_ (\__pi__068_ ),
    .\__pi__069_ (\__pi__069_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__106_ (\__pi__106_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___10 (\__po__002___10__gold )
  );
  \gate.test1._002_.10 gate (
    .\__pi__068_ (\__pi__068_ ),
    .\__pi__069_ (\__pi__069_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__106_ (\__pi__106_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___10 (\__po__002___10__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__068___assume (\__pi__068_ );
  miter_def_prop #(1, "assume") \__pi__069___assume (\__pi__069_ );
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__106___assume (\__pi__106_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__002___10__assert (\__po__002___10__gold , \__po__002___10__gate );
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
  miter_def_prop #(1, "cover") \__po__002___10__gold_cover (\__po__002___10__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__002___10__gate_cover (\__po__002___10__gate );
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
module \gold.test1._002_.10 (
  input  [  0:0] \__pi__068_ ,
  input  [  0:0] \__pi__069_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__106_ ,
  output [  0:0] \__po__002___10
);
endmodule
module \gate.test1._002_.10 (
  input  [  0:0] \__pi__068_ ,
  input  [  0:0] \__pi__069_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__106_ ,
  output [  0:0] \__po__002___10
);
endmodule
