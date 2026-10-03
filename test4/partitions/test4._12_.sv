module miter (
  input  [  3:0] \__pi_datain__3_0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__12___gold ,
  output [  0:0] \__po__12___gate
);
  \gold.test4._12_ gold (
    .\__pi_datain__3_0 (\__pi_datain__3_0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__12_ (\__po__12___gold )
  );
  \gate.test4._12_ gate (
    .\__pi_datain__3_0 (\__pi_datain__3_0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__12_ (\__po__12___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(4, "assume") \__pi_datain__3_0__assume (\__pi_datain__3_0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__12___assert (\__po__12___gold , \__po__12___gate );
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
  miter_def_prop #(1, "cover") \__po__12___gold_cover (\__po__12___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__12___gate_cover (\__po__12___gate );
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
module \gold.test4._12_ (
  input  [  3:0] \__pi_datain__3_0 ,
  output [  0:0] \__po__12_
);
endmodule
module \gate.test4._12_ (
  input  [  3:0] \__pi_datain__3_0 ,
  output [  0:0] \__po__12_
);
endmodule
