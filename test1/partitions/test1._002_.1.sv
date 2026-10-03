module miter (
  input  [  0:0] \__pi__154_ ,
  input  [  0:0] \__pi__155_ ,
  input  [  0:0] \__pi__191_ ,
  input  [  0:0] \__pi__196_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__002___1__gold ,
  output [  0:0] \__po__002___1__gate
);
  \gold.test1._002_.1 gold (
    .\__pi__154_ (\__pi__154_ ),
    .\__pi__155_ (\__pi__155_ ),
    .\__pi__191_ (\__pi__191_ ),
    .\__pi__196_ (\__pi__196_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___1 (\__po__002___1__gold )
  );
  \gate.test1._002_.1 gate (
    .\__pi__154_ (\__pi__154_ ),
    .\__pi__155_ (\__pi__155_ ),
    .\__pi__191_ (\__pi__191_ ),
    .\__pi__196_ (\__pi__196_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___1 (\__po__002___1__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__154___assume (\__pi__154_ );
  miter_def_prop #(1, "assume") \__pi__155___assume (\__pi__155_ );
  miter_def_prop #(1, "assume") \__pi__191___assume (\__pi__191_ );
  miter_def_prop #(1, "assume") \__pi__196___assume (\__pi__196_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__002___1__assert (\__po__002___1__gold , \__po__002___1__gate );
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
  miter_def_prop #(1, "cover") \__po__002___1__gold_cover (\__po__002___1__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__002___1__gate_cover (\__po__002___1__gate );
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
module \gold.test1._002_.1 (
  input  [  0:0] \__pi__154_ ,
  input  [  0:0] \__pi__155_ ,
  input  [  0:0] \__pi__191_ ,
  input  [  0:0] \__pi__196_ ,
  output [  0:0] \__po__002___1
);
endmodule
module \gate.test1._002_.1 (
  input  [  0:0] \__pi__154_ ,
  input  [  0:0] \__pi__155_ ,
  input  [  0:0] \__pi__191_ ,
  input  [  0:0] \__pi__196_ ,
  output [  0:0] \__po__002___1
);
endmodule
