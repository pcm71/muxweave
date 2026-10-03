module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__176_ ,
  input  [  0:0] \__pi__177_ ,
  input  [  0:0] \__pi__180_ ,
  input  [  0:0] \__pi__181_ ,
  input  [  0:0] \__pi_i2__2 ,
  input  [  0:0] \__pi_q3__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__185___gold ,
  output [  0:0] \__po__185___gate
);
  \gold.test1._185_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__176_ (\__pi__176_ ),
    .\__pi__177_ (\__pi__177_ ),
    .\__pi__180_ (\__pi__180_ ),
    .\__pi__181_ (\__pi__181_ ),
    .\__pi_i2__2 (\__pi_i2__2 ),
    .\__pi_q3__2 (\__pi_q3__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__185_ (\__po__185___gold )
  );
  \gate.test1._185_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__176_ (\__pi__176_ ),
    .\__pi__177_ (\__pi__177_ ),
    .\__pi__180_ (\__pi__180_ ),
    .\__pi__181_ (\__pi__181_ ),
    .\__pi_i2__2 (\__pi_i2__2 ),
    .\__pi_q3__2 (\__pi_q3__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__185_ (\__po__185___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__176___assume (\__pi__176_ );
  miter_def_prop #(1, "assume") \__pi__177___assume (\__pi__177_ );
  miter_def_prop #(1, "assume") \__pi__180___assume (\__pi__180_ );
  miter_def_prop #(1, "assume") \__pi__181___assume (\__pi__181_ );
  miter_def_prop #(1, "assume") \__pi_i2__2__assume (\__pi_i2__2 );
  miter_def_prop #(1, "assume") \__pi_q3__2__assume (\__pi_q3__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__185___assert (\__po__185___gold , \__po__185___gate );
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
  miter_def_prop #(1, "cover") \__po__185___gold_cover (\__po__185___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__185___gate_cover (\__po__185___gate );
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
module \gold.test1._185_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__176_ ,
  input  [  0:0] \__pi__177_ ,
  input  [  0:0] \__pi__180_ ,
  input  [  0:0] \__pi__181_ ,
  input  [  0:0] \__pi_i2__2 ,
  input  [  0:0] \__pi_q3__2 ,
  output [  0:0] \__po__185_
);
endmodule
module \gate.test1._185_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__176_ ,
  input  [  0:0] \__pi__177_ ,
  input  [  0:0] \__pi__180_ ,
  input  [  0:0] \__pi__181_ ,
  input  [  0:0] \__pi_i2__2 ,
  input  [  0:0] \__pi_q3__2 ,
  output [  0:0] \__po__185_
);
endmodule
