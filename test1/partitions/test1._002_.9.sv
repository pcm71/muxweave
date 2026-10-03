module miter (
  input  [  0:0] \__pi__048_ ,
  input  [  0:0] \__pi__049_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi__116_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__002___9__gold ,
  output [  0:0] \__po__002___9__gate
);
  \gold.test1._002_.9 gold (
    .\__pi__048_ (\__pi__048_ ),
    .\__pi__049_ (\__pi__049_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi__116_ (\__pi__116_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___9 (\__po__002___9__gold )
  );
  \gate.test1._002_.9 gate (
    .\__pi__048_ (\__pi__048_ ),
    .\__pi__049_ (\__pi__049_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi__116_ (\__pi__116_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___9 (\__po__002___9__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__048___assume (\__pi__048_ );
  miter_def_prop #(1, "assume") \__pi__049___assume (\__pi__049_ );
  miter_def_prop #(1, "assume") \__pi__111___assume (\__pi__111_ );
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__002___9__assert (\__po__002___9__gold , \__po__002___9__gate );
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
  miter_def_prop #(1, "cover") \__po__002___9__gold_cover (\__po__002___9__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__002___9__gate_cover (\__po__002___9__gate );
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
module \gold.test1._002_.9 (
  input  [  0:0] \__pi__048_ ,
  input  [  0:0] \__pi__049_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi__116_ ,
  output [  0:0] \__po__002___9
);
endmodule
module \gate.test1._002_.9 (
  input  [  0:0] \__pi__048_ ,
  input  [  0:0] \__pi__049_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi__116_ ,
  output [  0:0] \__po__002___9
);
endmodule
