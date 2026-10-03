module miter (
  input  [  0:0] \__pi__032_ ,
  input  [  0:0] \__pi__033_ ,
  input  [  0:0] \__pi__034_ ,
  input  [  0:0] \__pi__035_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q1__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__031___gold ,
  output [  0:0] \__po__031___gate
);
  \gold.test1._031_ gold (
    .\__pi__032_ (\__pi__032_ ),
    .\__pi__033_ (\__pi__033_ ),
    .\__pi__034_ (\__pi__034_ ),
    .\__pi__035_ (\__pi__035_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__8 (\__pi_i2__8 ),
    .\__pi_q1__8 (\__pi_q1__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__031_ (\__po__031___gold )
  );
  \gate.test1._031_ gate (
    .\__pi__032_ (\__pi__032_ ),
    .\__pi__033_ (\__pi__033_ ),
    .\__pi__034_ (\__pi__034_ ),
    .\__pi__035_ (\__pi__035_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__8 (\__pi_i2__8 ),
    .\__pi_q1__8 (\__pi_q1__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__031_ (\__po__031___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__032___assume (\__pi__032_ );
  miter_def_prop #(1, "assume") \__pi__033___assume (\__pi__033_ );
  miter_def_prop #(1, "assume") \__pi__034___assume (\__pi__034_ );
  miter_def_prop #(1, "assume") \__pi__035___assume (\__pi__035_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i2__8__assume (\__pi_i2__8 );
  miter_def_prop #(1, "assume") \__pi_q1__8__assume (\__pi_q1__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__031___assert (\__po__031___gold , \__po__031___gate );
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
  miter_def_prop #(1, "cover") \__po__031___gold_cover (\__po__031___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__031___gate_cover (\__po__031___gate );
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
module \gold.test1._031_ (
  input  [  0:0] \__pi__032_ ,
  input  [  0:0] \__pi__033_ ,
  input  [  0:0] \__pi__034_ ,
  input  [  0:0] \__pi__035_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q1__8 ,
  output [  0:0] \__po__031_
);
endmodule
module \gate.test1._031_ (
  input  [  0:0] \__pi__032_ ,
  input  [  0:0] \__pi__033_ ,
  input  [  0:0] \__pi__034_ ,
  input  [  0:0] \__pi__035_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__8 ,
  input  [  0:0] \__pi_q1__8 ,
  output [  0:0] \__po__031_
);
endmodule
