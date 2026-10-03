module miter (
  input  [  0:0] \__pi__141_ ,
  input  [  0:0] \__pi__146_ ,
  input  [  0:0] \__pi__254_ ,
  input  [  0:0] \__pi__255_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__002___6__gold ,
  output [  0:0] \__po__002___6__gate
);
  \gold.test1._002_.6 gold (
    .\__pi__141_ (\__pi__141_ ),
    .\__pi__146_ (\__pi__146_ ),
    .\__pi__254_ (\__pi__254_ ),
    .\__pi__255_ (\__pi__255_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___6 (\__po__002___6__gold )
  );
  \gate.test1._002_.6 gate (
    .\__pi__141_ (\__pi__141_ ),
    .\__pi__146_ (\__pi__146_ ),
    .\__pi__254_ (\__pi__254_ ),
    .\__pi__255_ (\__pi__255_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__002___6 (\__po__002___6__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__141___assume (\__pi__141_ );
  miter_def_prop #(1, "assume") \__pi__146___assume (\__pi__146_ );
  miter_def_prop #(1, "assume") \__pi__254___assume (\__pi__254_ );
  miter_def_prop #(1, "assume") \__pi__255___assume (\__pi__255_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__002___6__assert (\__po__002___6__gold , \__po__002___6__gate );
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
  miter_def_prop #(1, "cover") \__po__002___6__gold_cover (\__po__002___6__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__002___6__gate_cover (\__po__002___6__gate );
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
module \gold.test1._002_.6 (
  input  [  0:0] \__pi__141_ ,
  input  [  0:0] \__pi__146_ ,
  input  [  0:0] \__pi__254_ ,
  input  [  0:0] \__pi__255_ ,
  output [  0:0] \__po__002___6
);
endmodule
module \gate.test1._002_.6 (
  input  [  0:0] \__pi__141_ ,
  input  [  0:0] \__pi__146_ ,
  input  [  0:0] \__pi__254_ ,
  input  [  0:0] \__pi__255_ ,
  output [  0:0] \__po__002___6
);
endmodule
