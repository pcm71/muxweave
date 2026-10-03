module miter (
  input  [  2:0] \__pi_state__2_0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__004___2__gold ,
  output [  0:0] \__po__004___2__gate
);
  \gold.test1._004_.2 gold (
    .\__pi_state__2_0 (\__pi_state__2_0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__004___2 (\__po__004___2__gold )
  );
  \gate.test1._004_.2 gate (
    .\__pi_state__2_0 (\__pi_state__2_0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__004___2 (\__po__004___2__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(3, "assume") \__pi_state__2_0__assume (\__pi_state__2_0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__004___2__assert (\__po__004___2__gold , \__po__004___2__gate );
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
  miter_def_prop #(1, "cover") \__po__004___2__gold_cover (\__po__004___2__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__004___2__gate_cover (\__po__004___2__gate );
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
module \gold.test1._004_.2 (
  input  [  2:0] \__pi_state__2_0 ,
  output [  0:0] \__po__004___2
);
endmodule
module \gate.test1._004_.2 (
  input  [  2:0] \__pi_state__2_0 ,
  output [  0:0] \__po__004___2
);
endmodule
