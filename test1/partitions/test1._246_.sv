module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__6 ,
  input  [  0:0] \__pi_i2__11 ,
  input  [  0:0] \__pi_q1__6 ,
  input  [  0:0] \__pi_q3__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__246___gold ,
  output [  0:0] \__po__246___gate
);
  \gold.test1._246_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__6 (\__pi_i0__6 ),
    .\__pi_i2__11 (\__pi_i2__11 ),
    .\__pi_q1__6 (\__pi_q1__6 ),
    .\__pi_q3__11 (\__pi_q3__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__246_ (\__po__246___gold )
  );
  \gate.test1._246_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__6 (\__pi_i0__6 ),
    .\__pi_i2__11 (\__pi_i2__11 ),
    .\__pi_q1__6 (\__pi_q1__6 ),
    .\__pi_q3__11 (\__pi_q3__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__246_ (\__po__246___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi_i0__6__assume (\__pi_i0__6 );
  miter_def_prop #(1, "assume") \__pi_i2__11__assume (\__pi_i2__11 );
  miter_def_prop #(1, "assume") \__pi_q1__6__assume (\__pi_q1__6 );
  miter_def_prop #(1, "assume") \__pi_q3__11__assume (\__pi_q3__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__246___assert (\__po__246___gold , \__po__246___gate );
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
  miter_def_prop #(1, "cover") \__po__246___gold_cover (\__po__246___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__246___gate_cover (\__po__246___gate );
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
module \gold.test1._246_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__6 ,
  input  [  0:0] \__pi_i2__11 ,
  input  [  0:0] \__pi_q1__6 ,
  input  [  0:0] \__pi_q3__11 ,
  output [  0:0] \__po__246_
);
endmodule
module \gate.test1._246_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__6 ,
  input  [  0:0] \__pi_i2__11 ,
  input  [  0:0] \__pi_q1__6 ,
  input  [  0:0] \__pi_q3__11 ,
  output [  0:0] \__po__246_
);
endmodule
