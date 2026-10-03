module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__197_ ,
  input  [  0:0] \__pi__198_ ,
  input  [  0:0] \__pi__199_ ,
  input  [  0:0] \__pi__200_ ,
  input  [  0:0] \__pi_i0__4 ,
  input  [  0:0] \__pi_q1__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__196___gold ,
  output [  0:0] \__po__196___gate
);
  \gold.test1._196_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__197_ (\__pi__197_ ),
    .\__pi__198_ (\__pi__198_ ),
    .\__pi__199_ (\__pi__199_ ),
    .\__pi__200_ (\__pi__200_ ),
    .\__pi_i0__4 (\__pi_i0__4 ),
    .\__pi_q1__4 (\__pi_q1__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__196_ (\__po__196___gold )
  );
  \gate.test1._196_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__197_ (\__pi__197_ ),
    .\__pi__198_ (\__pi__198_ ),
    .\__pi__199_ (\__pi__199_ ),
    .\__pi__200_ (\__pi__200_ ),
    .\__pi_i0__4 (\__pi_i0__4 ),
    .\__pi_q1__4 (\__pi_q1__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__196_ (\__po__196___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__197___assume (\__pi__197_ );
  miter_def_prop #(1, "assume") \__pi__198___assume (\__pi__198_ );
  miter_def_prop #(1, "assume") \__pi__199___assume (\__pi__199_ );
  miter_def_prop #(1, "assume") \__pi__200___assume (\__pi__200_ );
  miter_def_prop #(1, "assume") \__pi_i0__4__assume (\__pi_i0__4 );
  miter_def_prop #(1, "assume") \__pi_q1__4__assume (\__pi_q1__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__196___assert (\__po__196___gold , \__po__196___gate );
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
  miter_def_prop #(1, "cover") \__po__196___gold_cover (\__po__196___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__196___gate_cover (\__po__196___gate );
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
module \gold.test1._196_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__197_ ,
  input  [  0:0] \__pi__198_ ,
  input  [  0:0] \__pi__199_ ,
  input  [  0:0] \__pi__200_ ,
  input  [  0:0] \__pi_i0__4 ,
  input  [  0:0] \__pi_q1__4 ,
  output [  0:0] \__po__196_
);
endmodule
module \gate.test1._196_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__197_ ,
  input  [  0:0] \__pi__198_ ,
  input  [  0:0] \__pi__199_ ,
  input  [  0:0] \__pi__200_ ,
  input  [  0:0] \__pi_i0__4 ,
  input  [  0:0] \__pi_q1__4 ,
  output [  0:0] \__po__196_
);
endmodule
