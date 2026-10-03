module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__177_ ,
  input  [  0:0] \__pi__178_ ,
  input  [  0:0] \__pi__179_ ,
  input  [  0:0] \__pi__180_ ,
  input  [  0:0] \__pi_i0__3 ,
  input  [  0:0] \__pi_q1__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__176___gold ,
  output [  0:0] \__po__176___gate
);
  \gold.test1._176_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__177_ (\__pi__177_ ),
    .\__pi__178_ (\__pi__178_ ),
    .\__pi__179_ (\__pi__179_ ),
    .\__pi__180_ (\__pi__180_ ),
    .\__pi_i0__3 (\__pi_i0__3 ),
    .\__pi_q1__3 (\__pi_q1__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__176_ (\__po__176___gold )
  );
  \gate.test1._176_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__177_ (\__pi__177_ ),
    .\__pi__178_ (\__pi__178_ ),
    .\__pi__179_ (\__pi__179_ ),
    .\__pi__180_ (\__pi__180_ ),
    .\__pi_i0__3 (\__pi_i0__3 ),
    .\__pi_q1__3 (\__pi_q1__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__176_ (\__po__176___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__177___assume (\__pi__177_ );
  miter_def_prop #(1, "assume") \__pi__178___assume (\__pi__178_ );
  miter_def_prop #(1, "assume") \__pi__179___assume (\__pi__179_ );
  miter_def_prop #(1, "assume") \__pi__180___assume (\__pi__180_ );
  miter_def_prop #(1, "assume") \__pi_i0__3__assume (\__pi_i0__3 );
  miter_def_prop #(1, "assume") \__pi_q1__3__assume (\__pi_q1__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__176___assert (\__po__176___gold , \__po__176___gate );
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
  miter_def_prop #(1, "cover") \__po__176___gold_cover (\__po__176___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__176___gate_cover (\__po__176___gate );
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
module \gold.test1._176_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__177_ ,
  input  [  0:0] \__pi__178_ ,
  input  [  0:0] \__pi__179_ ,
  input  [  0:0] \__pi__180_ ,
  input  [  0:0] \__pi_i0__3 ,
  input  [  0:0] \__pi_q1__3 ,
  output [  0:0] \__po__176_
);
endmodule
module \gate.test1._176_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__177_ ,
  input  [  0:0] \__pi__178_ ,
  input  [  0:0] \__pi__179_ ,
  input  [  0:0] \__pi__180_ ,
  input  [  0:0] \__pi_i0__3 ,
  input  [  0:0] \__pi_q1__3 ,
  output [  0:0] \__po__176_
);
endmodule
