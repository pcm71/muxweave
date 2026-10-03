module miter (
  input  [  4:0] \__pi_sr__4_0 ,
  input  [  1:0] \__pi_sr__7_6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__04___gold ,
  output [  0:0] \__po__04___gate
);
  \gold.test3._04_ gold (
    .\__pi_sr__4_0 (\__pi_sr__4_0 ),
    .\__pi_sr__7_6 (\__pi_sr__7_6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__04_ (\__po__04___gold )
  );
  \gate.test3._04_ gate (
    .\__pi_sr__4_0 (\__pi_sr__4_0 ),
    .\__pi_sr__7_6 (\__pi_sr__7_6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__04_ (\__po__04___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(5, "assume") \__pi_sr__4_0__assume (\__pi_sr__4_0 );
  miter_def_prop #(2, "assume") \__pi_sr__7_6__assume (\__pi_sr__7_6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__04___assert (\__po__04___gold , \__po__04___gate );
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
  miter_def_prop #(1, "cover") \__po__04___gold_cover (\__po__04___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__04___gate_cover (\__po__04___gate );
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
module \gold.test3._04_ (
  input  [  4:0] \__pi_sr__4_0 ,
  input  [  1:0] \__pi_sr__7_6 ,
  output [  0:0] \__po__04_
);
endmodule
module \gate.test3._04_ (
  input  [  4:0] \__pi_sr__4_0 ,
  input  [  1:0] \__pi_sr__7_6 ,
  output [  0:0] \__po__04_
);
endmodule
