module miter (
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__04_ ,
  input  [  0:0] \__pi__05_ ,
  input  [  0:0] \__pi_sr__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__09___gold ,
  output [  0:0] \__po__09___gate
);
  \gold.test3._09_ gold (
    .\__pi__03_ (\__pi__03_ ),
    .\__pi__04_ (\__pi__04_ ),
    .\__pi__05_ (\__pi__05_ ),
    .\__pi_sr__0 (\__pi_sr__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__09_ (\__po__09___gold )
  );
  \gate.test3._09_ gate (
    .\__pi__03_ (\__pi__03_ ),
    .\__pi__04_ (\__pi__04_ ),
    .\__pi__05_ (\__pi__05_ ),
    .\__pi_sr__0 (\__pi_sr__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__09_ (\__po__09___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__03___assume (\__pi__03_ );
  miter_def_prop #(1, "assume") \__pi__04___assume (\__pi__04_ );
  miter_def_prop #(1, "assume") \__pi__05___assume (\__pi__05_ );
  miter_def_prop #(1, "assume") \__pi_sr__0__assume (\__pi_sr__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__09___assert (\__po__09___gold , \__po__09___gate );
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
  miter_def_prop #(1, "cover") \__po__09___gold_cover (\__po__09___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__09___gate_cover (\__po__09___gate );
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
module \gold.test3._09_ (
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__04_ ,
  input  [  0:0] \__pi__05_ ,
  input  [  0:0] \__pi_sr__0 ,
  output [  0:0] \__po__09_
);
endmodule
module \gate.test3._09_ (
  input  [  0:0] \__pi__03_ ,
  input  [  0:0] \__pi__04_ ,
  input  [  0:0] \__pi__05_ ,
  input  [  0:0] \__pi_sr__0 ,
  output [  0:0] \__po__09_
);
endmodule
