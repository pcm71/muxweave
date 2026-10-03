module miter (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__9 ,
  input  [  0:0] \__pi_i1__6 ,
  input  [  0:0] \__pi_q0__6 ,
  input  [  0:0] \__pi_q1__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__040___gold ,
  output [  0:0] \__po__040___gate
);
  \gold.test1._040_ gold (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__9 (\__pi_i0__9 ),
    .\__pi_i1__6 (\__pi_i1__6 ),
    .\__pi_q0__6 (\__pi_q0__6 ),
    .\__pi_q1__9 (\__pi_q1__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__040_ (\__po__040___gold )
  );
  \gate.test1._040_ gate (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__9 (\__pi_i0__9 ),
    .\__pi_i1__6 (\__pi_i1__6 ),
    .\__pi_q0__6 (\__pi_q0__6 ),
    .\__pi_q1__9 (\__pi_q1__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__040_ (\__po__040___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__029___assume (\__pi__029_ );
  miter_def_prop #(1, "assume") \__pi__030___assume (\__pi__030_ );
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi_i0__9__assume (\__pi_i0__9 );
  miter_def_prop #(1, "assume") \__pi_i1__6__assume (\__pi_i1__6 );
  miter_def_prop #(1, "assume") \__pi_q0__6__assume (\__pi_q0__6 );
  miter_def_prop #(1, "assume") \__pi_q1__9__assume (\__pi_q1__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__040___assert (\__po__040___gold , \__po__040___gate );
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
  miter_def_prop #(1, "cover") \__po__040___gold_cover (\__po__040___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__040___gate_cover (\__po__040___gate );
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
module \gold.test1._040_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__9 ,
  input  [  0:0] \__pi_i1__6 ,
  input  [  0:0] \__pi_q0__6 ,
  input  [  0:0] \__pi_q1__9 ,
  output [  0:0] \__po__040_
);
endmodule
module \gate.test1._040_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__9 ,
  input  [  0:0] \__pi_i1__6 ,
  input  [  0:0] \__pi_q0__6 ,
  input  [  0:0] \__pi_q1__9 ,
  output [  0:0] \__po__040_
);
endmodule
