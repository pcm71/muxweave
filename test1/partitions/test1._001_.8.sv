module miter (
  input  [  0:0] \__pi__038_ ,
  input  [  0:0] \__pi__039_ ,
  input  [  0:0] \__pi__232_ ,
  input  [  0:0] \__pi__237_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__001___8__gold ,
  output [  0:0] \__po__001___8__gate
);
  \gold.test1._001_.8 gold (
    .\__pi__038_ (\__pi__038_ ),
    .\__pi__039_ (\__pi__039_ ),
    .\__pi__232_ (\__pi__232_ ),
    .\__pi__237_ (\__pi__237_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___8 (\__po__001___8__gold )
  );
  \gate.test1._001_.8 gate (
    .\__pi__038_ (\__pi__038_ ),
    .\__pi__039_ (\__pi__039_ ),
    .\__pi__232_ (\__pi__232_ ),
    .\__pi__237_ (\__pi__237_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___8 (\__po__001___8__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__038___assume (\__pi__038_ );
  miter_def_prop #(1, "assume") \__pi__039___assume (\__pi__039_ );
  miter_def_prop #(1, "assume") \__pi__232___assume (\__pi__232_ );
  miter_def_prop #(1, "assume") \__pi__237___assume (\__pi__237_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__001___8__assert (\__po__001___8__gold , \__po__001___8__gate );
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
  miter_def_prop #(1, "cover") \__po__001___8__gold_cover (\__po__001___8__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__001___8__gate_cover (\__po__001___8__gate );
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
module \gold.test1._001_.8 (
  input  [  0:0] \__pi__038_ ,
  input  [  0:0] \__pi__039_ ,
  input  [  0:0] \__pi__232_ ,
  input  [  0:0] \__pi__237_ ,
  output [  0:0] \__po__001___8
);
endmodule
module \gate.test1._001_.8 (
  input  [  0:0] \__pi__038_ ,
  input  [  0:0] \__pi__039_ ,
  input  [  0:0] \__pi__232_ ,
  input  [  0:0] \__pi__237_ ,
  output [  0:0] \__po__001___8
);
endmodule
