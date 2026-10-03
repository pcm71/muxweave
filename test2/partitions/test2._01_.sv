module miter (
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_d ,
  input  [  0:0] \__pi_datac__3 ,
  input  [  0:0] \__pi_datad__0 ,
  input  [  0:0] \__pi_datad__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__01___gold ,
  output [  0:0] \__po__01___gate
);
  \gold.test2._01_ gold (
    .\__pi_c (\__pi_c ),
    .\__pi_d (\__pi_d ),
    .\__pi_datac__3 (\__pi_datac__3 ),
    .\__pi_datad__0 (\__pi_datad__0 ),
    .\__pi_datad__3 (\__pi_datad__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__01_ (\__po__01___gold )
  );
  \gate.test2._01_ gate (
    .\__pi_c (\__pi_c ),
    .\__pi_d (\__pi_d ),
    .\__pi_datac__3 (\__pi_datac__3 ),
    .\__pi_datad__0 (\__pi_datad__0 ),
    .\__pi_datad__3 (\__pi_datad__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__01_ (\__po__01___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_c__assume (\__pi_c );
  miter_def_prop #(1, "assume") \__pi_d__assume (\__pi_d );
  miter_def_prop #(1, "assume") \__pi_datac__3__assume (\__pi_datac__3 );
  miter_def_prop #(1, "assume") \__pi_datad__0__assume (\__pi_datad__0 );
  miter_def_prop #(1, "assume") \__pi_datad__3__assume (\__pi_datad__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__01___assert (\__po__01___gold , \__po__01___gate );
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
  miter_def_prop #(1, "cover") \__po__01___gold_cover (\__po__01___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__01___gate_cover (\__po__01___gate );
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
module \gold.test2._01_ (
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_d ,
  input  [  0:0] \__pi_datac__3 ,
  input  [  0:0] \__pi_datad__0 ,
  input  [  0:0] \__pi_datad__3 ,
  output [  0:0] \__po__01_
);
endmodule
module \gate.test2._01_ (
  input  [  0:0] \__pi_c ,
  input  [  0:0] \__pi_d ,
  input  [  0:0] \__pi_datac__3 ,
  input  [  0:0] \__pi_datad__0 ,
  input  [  0:0] \__pi_datad__3 ,
  output [  0:0] \__po__01_
);
endmodule
