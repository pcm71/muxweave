module miter (
  input  [  0:0] \__pi__098_ ,
  input  [  0:0] \__pi__099_ ,
  input  [  0:0] \__pi__252_ ,
  input  [  0:0] \__pi__257_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__001___11__gold ,
  output [  0:0] \__po__001___11__gate
);
  \gold.test1._001_.11 gold (
    .\__pi__098_ (\__pi__098_ ),
    .\__pi__099_ (\__pi__099_ ),
    .\__pi__252_ (\__pi__252_ ),
    .\__pi__257_ (\__pi__257_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___11 (\__po__001___11__gold )
  );
  \gate.test1._001_.11 gate (
    .\__pi__098_ (\__pi__098_ ),
    .\__pi__099_ (\__pi__099_ ),
    .\__pi__252_ (\__pi__252_ ),
    .\__pi__257_ (\__pi__257_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___11 (\__po__001___11__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__098___assume (\__pi__098_ );
  miter_def_prop #(1, "assume") \__pi__099___assume (\__pi__099_ );
  miter_def_prop #(1, "assume") \__pi__252___assume (\__pi__252_ );
  miter_def_prop #(1, "assume") \__pi__257___assume (\__pi__257_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__001___11__assert (\__po__001___11__gold , \__po__001___11__gate );
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
  miter_def_prop #(1, "cover") \__po__001___11__gold_cover (\__po__001___11__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__001___11__gate_cover (\__po__001___11__gate );
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
module \gold.test1._001_.11 (
  input  [  0:0] \__pi__098_ ,
  input  [  0:0] \__pi__099_ ,
  input  [  0:0] \__pi__252_ ,
  input  [  0:0] \__pi__257_ ,
  output [  0:0] \__po__001___11
);
endmodule
module \gate.test1._001_.11 (
  input  [  0:0] \__pi__098_ ,
  input  [  0:0] \__pi__099_ ,
  input  [  0:0] \__pi__252_ ,
  input  [  0:0] \__pi__257_ ,
  output [  0:0] \__po__001___11
);
endmodule
