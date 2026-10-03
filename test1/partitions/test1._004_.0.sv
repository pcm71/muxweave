module miter (
  input  [  0:0] \__pi__100_ ,
  input  [  0:0] \__pi__231_ ,
  input  [  0:0] \__pi_state__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__004___0__gold ,
  output [  0:0] \__po__004___0__gate
);
  \gold.test1._004_.0 gold (
    .\__pi__100_ (\__pi__100_ ),
    .\__pi__231_ (\__pi__231_ ),
    .\__pi_state__0 (\__pi_state__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__004___0 (\__po__004___0__gold )
  );
  \gate.test1._004_.0 gate (
    .\__pi__100_ (\__pi__100_ ),
    .\__pi__231_ (\__pi__231_ ),
    .\__pi_state__0 (\__pi_state__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__004___0 (\__po__004___0__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__100___assume (\__pi__100_ );
  miter_def_prop #(1, "assume") \__pi__231___assume (\__pi__231_ );
  miter_def_prop #(1, "assume") \__pi_state__0__assume (\__pi_state__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__004___0__assert (\__po__004___0__gold , \__po__004___0__gate );
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
  miter_def_prop #(1, "cover") \__po__004___0__gold_cover (\__po__004___0__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__004___0__gate_cover (\__po__004___0__gate );
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
module \gold.test1._004_.0 (
  input  [  0:0] \__pi__100_ ,
  input  [  0:0] \__pi__231_ ,
  input  [  0:0] \__pi_state__0 ,
  output [  0:0] \__po__004___0
);
endmodule
module \gate.test1._004_.0 (
  input  [  0:0] \__pi__100_ ,
  input  [  0:0] \__pi__231_ ,
  input  [  0:0] \__pi_state__0 ,
  output [  0:0] \__po__004___0
);
endmodule
