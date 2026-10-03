module miter (
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi_cs ,
  input  [  3:0] \__pi_sr__7_4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__00___gold ,
  output [  0:0] \__po__00___gate
);
  \gold.test3._00_ gold (
    .\__pi__06_ (\__pi__06_ ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_sr__7_4 (\__pi_sr__7_4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__00_ (\__po__00___gold )
  );
  \gate.test3._00_ gate (
    .\__pi__06_ (\__pi__06_ ),
    .\__pi_cs (\__pi_cs ),
    .\__pi_sr__7_4 (\__pi_sr__7_4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__00_ (\__po__00___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__06___assume (\__pi__06_ );
  miter_def_prop #(1, "assume") \__pi_cs__assume (\__pi_cs );
  miter_def_prop #(4, "assume") \__pi_sr__7_4__assume (\__pi_sr__7_4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__00___assert (\__po__00___gold , \__po__00___gate );
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
  miter_def_prop #(1, "cover") \__po__00___gold_cover (\__po__00___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__00___gate_cover (\__po__00___gate );
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
module \gold.test3._00_ (
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi_cs ,
  input  [  3:0] \__pi_sr__7_4 ,
  output [  0:0] \__po__00_
);
endmodule
module \gate.test3._00_ (
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi_cs ,
  input  [  3:0] \__pi_sr__7_4 ,
  output [  0:0] \__po__00_
);
endmodule
