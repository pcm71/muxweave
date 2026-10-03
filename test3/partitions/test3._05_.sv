module miter (
  input  [  0:0] \__pi__00_ ,
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__04_ ,
  input  [  2:0] \__pi_sr__4_2 ,
  input  [  0:0] \__pi_sr__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__05___gold ,
  output [  0:0] \__po__05___gate
);
  \gold.test3._05_ gold (
    .\__pi__00_ (\__pi__00_ ),
    .\__pi__01_ (\__pi__01_ ),
    .\__pi__02_ (\__pi__02_ ),
    .\__pi__04_ (\__pi__04_ ),
    .\__pi_sr__4_2 (\__pi_sr__4_2 ),
    .\__pi_sr__6 (\__pi_sr__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__05_ (\__po__05___gold )
  );
  \gate.test3._05_ gate (
    .\__pi__00_ (\__pi__00_ ),
    .\__pi__01_ (\__pi__01_ ),
    .\__pi__02_ (\__pi__02_ ),
    .\__pi__04_ (\__pi__04_ ),
    .\__pi_sr__4_2 (\__pi_sr__4_2 ),
    .\__pi_sr__6 (\__pi_sr__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__05_ (\__po__05___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__00___assume (\__pi__00_ );
  miter_def_prop #(1, "assume") \__pi__01___assume (\__pi__01_ );
  miter_def_prop #(1, "assume") \__pi__02___assume (\__pi__02_ );
  miter_def_prop #(1, "assume") \__pi__04___assume (\__pi__04_ );
  miter_def_prop #(3, "assume") \__pi_sr__4_2__assume (\__pi_sr__4_2 );
  miter_def_prop #(1, "assume") \__pi_sr__6__assume (\__pi_sr__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__05___assert (\__po__05___gold , \__po__05___gate );
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
  miter_def_prop #(1, "cover") \__po__05___gold_cover (\__po__05___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__05___gate_cover (\__po__05___gate );
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
module \gold.test3._05_ (
  input  [  0:0] \__pi__00_ ,
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__04_ ,
  input  [  2:0] \__pi_sr__4_2 ,
  input  [  0:0] \__pi_sr__6 ,
  output [  0:0] \__po__05_
);
endmodule
module \gate.test3._05_ (
  input  [  0:0] \__pi__00_ ,
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__02_ ,
  input  [  0:0] \__pi__04_ ,
  input  [  2:0] \__pi_sr__4_2 ,
  input  [  0:0] \__pi_sr__6 ,
  output [  0:0] \__po__05_
);
endmodule
