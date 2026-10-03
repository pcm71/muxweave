module miter (
  input  [  0:0] \__pi_I0__9 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__107_ ,
  input  [  0:0] \__pi__108_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_q3__9 ,
  input  [  0:0] \__pi_q7__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__042___gold ,
  output [  0:0] \__po__042___gate
);
  \gold.test1._042_ gold (
    .\__pi_I0__9 (\__pi_I0__9 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__107_ (\__pi__107_ ),
    .\__pi__108_ (\__pi__108_ ),
    .\__pi_i2__9 (\__pi_i2__9 ),
    .\__pi_q3__9 (\__pi_q3__9 ),
    .\__pi_q7__5 (\__pi_q7__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__042_ (\__po__042___gold )
  );
  \gate.test1._042_ gate (
    .\__pi_I0__9 (\__pi_I0__9 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__107_ (\__pi__107_ ),
    .\__pi__108_ (\__pi__108_ ),
    .\__pi_i2__9 (\__pi_i2__9 ),
    .\__pi_q3__9 (\__pi_q3__9 ),
    .\__pi_q7__5 (\__pi_q7__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__042_ (\__po__042___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_I0__9__assume (\__pi_I0__9 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__008___assume (\__pi__008_ );
  miter_def_prop #(1, "assume") \__pi__107___assume (\__pi__107_ );
  miter_def_prop #(1, "assume") \__pi__108___assume (\__pi__108_ );
  miter_def_prop #(1, "assume") \__pi_i2__9__assume (\__pi_i2__9 );
  miter_def_prop #(1, "assume") \__pi_q3__9__assume (\__pi_q3__9 );
  miter_def_prop #(1, "assume") \__pi_q7__5__assume (\__pi_q7__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__042___assert (\__po__042___gold , \__po__042___gate );
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
  miter_def_prop #(1, "cover") \__po__042___gold_cover (\__po__042___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__042___gate_cover (\__po__042___gate );
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
module \gold.test1._042_ (
  input  [  0:0] \__pi_I0__9 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__107_ ,
  input  [  0:0] \__pi__108_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_q3__9 ,
  input  [  0:0] \__pi_q7__5 ,
  output [  0:0] \__po__042_
);
endmodule
module \gate.test1._042_ (
  input  [  0:0] \__pi_I0__9 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__107_ ,
  input  [  0:0] \__pi__108_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_q3__9 ,
  input  [  0:0] \__pi_q7__5 ,
  output [  0:0] \__po__042_
);
endmodule
