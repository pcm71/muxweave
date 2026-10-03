module miter (
  input  [  0:0] \__pi__047_ ,
  input  [  0:0] \__pi__048_ ,
  input  [  0:0] \__pi__049_ ,
  input  [  0:0] \__pi__050_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i6__9 ,
  input  [  0:0] \__pi_q7__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__046___gold ,
  output [  0:0] \__po__046___gate
);
  \gold.test1._046_ gold (
    .\__pi__047_ (\__pi__047_ ),
    .\__pi__048_ (\__pi__048_ ),
    .\__pi__049_ (\__pi__049_ ),
    .\__pi__050_ (\__pi__050_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i6__9 (\__pi_i6__9 ),
    .\__pi_q7__9 (\__pi_q7__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__046_ (\__po__046___gold )
  );
  \gate.test1._046_ gate (
    .\__pi__047_ (\__pi__047_ ),
    .\__pi__048_ (\__pi__048_ ),
    .\__pi__049_ (\__pi__049_ ),
    .\__pi__050_ (\__pi__050_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i6__9 (\__pi_i6__9 ),
    .\__pi_q7__9 (\__pi_q7__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__046_ (\__po__046___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__047___assume (\__pi__047_ );
  miter_def_prop #(1, "assume") \__pi__048___assume (\__pi__048_ );
  miter_def_prop #(1, "assume") \__pi__049___assume (\__pi__049_ );
  miter_def_prop #(1, "assume") \__pi__050___assume (\__pi__050_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi_i6__9__assume (\__pi_i6__9 );
  miter_def_prop #(1, "assume") \__pi_q7__9__assume (\__pi_q7__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__046___assert (\__po__046___gold , \__po__046___gate );
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
  miter_def_prop #(1, "cover") \__po__046___gold_cover (\__po__046___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__046___gate_cover (\__po__046___gate );
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
module \gold.test1._046_ (
  input  [  0:0] \__pi__047_ ,
  input  [  0:0] \__pi__048_ ,
  input  [  0:0] \__pi__049_ ,
  input  [  0:0] \__pi__050_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i6__9 ,
  input  [  0:0] \__pi_q7__9 ,
  output [  0:0] \__po__046_
);
endmodule
module \gate.test1._046_ (
  input  [  0:0] \__pi__047_ ,
  input  [  0:0] \__pi__048_ ,
  input  [  0:0] \__pi__049_ ,
  input  [  0:0] \__pi__050_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i6__9 ,
  input  [  0:0] \__pi_q7__9 ,
  output [  0:0] \__po__046_
);
endmodule
