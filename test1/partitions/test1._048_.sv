module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__042_ ,
  input  [  0:0] \__pi__043_ ,
  input  [  0:0] \__pi__046_ ,
  input  [  0:0] \__pi__047_ ,
  input  [  0:0] \__pi_i4__5 ,
  input  [  0:0] \__pi_q3__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__048___gold ,
  output [  0:0] \__po__048___gate
);
  \gold.test1._048_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__042_ (\__pi__042_ ),
    .\__pi__043_ (\__pi__043_ ),
    .\__pi__046_ (\__pi__046_ ),
    .\__pi__047_ (\__pi__047_ ),
    .\__pi_i4__5 (\__pi_i4__5 ),
    .\__pi_q3__5 (\__pi_q3__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__048_ (\__po__048___gold )
  );
  \gate.test1._048_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__042_ (\__pi__042_ ),
    .\__pi__043_ (\__pi__043_ ),
    .\__pi__046_ (\__pi__046_ ),
    .\__pi__047_ (\__pi__047_ ),
    .\__pi_i4__5 (\__pi_i4__5 ),
    .\__pi_q3__5 (\__pi_q3__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__048_ (\__po__048___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__042___assume (\__pi__042_ );
  miter_def_prop #(1, "assume") \__pi__043___assume (\__pi__043_ );
  miter_def_prop #(1, "assume") \__pi__046___assume (\__pi__046_ );
  miter_def_prop #(1, "assume") \__pi__047___assume (\__pi__047_ );
  miter_def_prop #(1, "assume") \__pi_i4__5__assume (\__pi_i4__5 );
  miter_def_prop #(1, "assume") \__pi_q3__5__assume (\__pi_q3__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__048___assert (\__po__048___gold , \__po__048___gate );
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
  miter_def_prop #(1, "cover") \__po__048___gold_cover (\__po__048___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__048___gate_cover (\__po__048___gate );
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
module \gold.test1._048_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__042_ ,
  input  [  0:0] \__pi__043_ ,
  input  [  0:0] \__pi__046_ ,
  input  [  0:0] \__pi__047_ ,
  input  [  0:0] \__pi_i4__5 ,
  input  [  0:0] \__pi_q3__5 ,
  output [  0:0] \__po__048_
);
endmodule
module \gate.test1._048_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__042_ ,
  input  [  0:0] \__pi__043_ ,
  input  [  0:0] \__pi__046_ ,
  input  [  0:0] \__pi__047_ ,
  input  [  0:0] \__pi_i4__5 ,
  input  [  0:0] \__pi_q3__5 ,
  output [  0:0] \__po__048_
);
endmodule
