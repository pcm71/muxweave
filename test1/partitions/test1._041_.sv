module miter (
  input  [  0:0] \__pi__042_ ,
  input  [  0:0] \__pi__043_ ,
  input  [  0:0] \__pi__044_ ,
  input  [  0:0] \__pi__045_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__9 ,
  input  [  0:0] \__pi_q2__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__041___gold ,
  output [  0:0] \__po__041___gate
);
  \gold.test1._041_ gold (
    .\__pi__042_ (\__pi__042_ ),
    .\__pi__043_ (\__pi__043_ ),
    .\__pi__044_ (\__pi__044_ ),
    .\__pi__045_ (\__pi__045_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i1__9 (\__pi_i1__9 ),
    .\__pi_q2__9 (\__pi_q2__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__041_ (\__po__041___gold )
  );
  \gate.test1._041_ gate (
    .\__pi__042_ (\__pi__042_ ),
    .\__pi__043_ (\__pi__043_ ),
    .\__pi__044_ (\__pi__044_ ),
    .\__pi__045_ (\__pi__045_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i1__9 (\__pi_i1__9 ),
    .\__pi_q2__9 (\__pi_q2__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__041_ (\__po__041___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__042___assume (\__pi__042_ );
  miter_def_prop #(1, "assume") \__pi__043___assume (\__pi__043_ );
  miter_def_prop #(1, "assume") \__pi__044___assume (\__pi__044_ );
  miter_def_prop #(1, "assume") \__pi__045___assume (\__pi__045_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i1__9__assume (\__pi_i1__9 );
  miter_def_prop #(1, "assume") \__pi_q2__9__assume (\__pi_q2__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__041___assert (\__po__041___gold , \__po__041___gate );
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
  miter_def_prop #(1, "cover") \__po__041___gold_cover (\__po__041___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__041___gate_cover (\__po__041___gate );
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
module \gold.test1._041_ (
  input  [  0:0] \__pi__042_ ,
  input  [  0:0] \__pi__043_ ,
  input  [  0:0] \__pi__044_ ,
  input  [  0:0] \__pi__045_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__9 ,
  input  [  0:0] \__pi_q2__9 ,
  output [  0:0] \__po__041_
);
endmodule
module \gate.test1._041_ (
  input  [  0:0] \__pi__042_ ,
  input  [  0:0] \__pi__043_ ,
  input  [  0:0] \__pi__044_ ,
  input  [  0:0] \__pi__045_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i1__9 ,
  input  [  0:0] \__pi_q2__9 ,
  output [  0:0] \__po__041_
);
endmodule
