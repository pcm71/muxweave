module miter (
  input  [  0:0] \__pi__031_ ,
  input  [  0:0] \__pi__036_ ,
  input  [  0:0] \__pi__244_ ,
  input  [  0:0] \__pi__245_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__001___6__gold ,
  output [  0:0] \__po__001___6__gate
);
  \gold.test1._001_.6 gold (
    .\__pi__031_ (\__pi__031_ ),
    .\__pi__036_ (\__pi__036_ ),
    .\__pi__244_ (\__pi__244_ ),
    .\__pi__245_ (\__pi__245_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___6 (\__po__001___6__gold )
  );
  \gate.test1._001_.6 gate (
    .\__pi__031_ (\__pi__031_ ),
    .\__pi__036_ (\__pi__036_ ),
    .\__pi__244_ (\__pi__244_ ),
    .\__pi__245_ (\__pi__245_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___6 (\__po__001___6__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__031___assume (\__pi__031_ );
  miter_def_prop #(1, "assume") \__pi__036___assume (\__pi__036_ );
  miter_def_prop #(1, "assume") \__pi__244___assume (\__pi__244_ );
  miter_def_prop #(1, "assume") \__pi__245___assume (\__pi__245_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__001___6__assert (\__po__001___6__gold , \__po__001___6__gate );
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
  miter_def_prop #(1, "cover") \__po__001___6__gold_cover (\__po__001___6__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__001___6__gate_cover (\__po__001___6__gate );
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
module \gold.test1._001_.6 (
  input  [  0:0] \__pi__031_ ,
  input  [  0:0] \__pi__036_ ,
  input  [  0:0] \__pi__244_ ,
  input  [  0:0] \__pi__245_ ,
  output [  0:0] \__po__001___6
);
endmodule
module \gate.test1._001_.6 (
  input  [  0:0] \__pi__031_ ,
  input  [  0:0] \__pi__036_ ,
  input  [  0:0] \__pi__244_ ,
  input  [  0:0] \__pi__245_ ,
  output [  0:0] \__po__001___6
);
endmodule
