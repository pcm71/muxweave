module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__227_ ,
  input  [  0:0] \__pi__228_ ,
  input  [  0:0] \__pi__229_ ,
  input  [  0:0] \__pi__230_ ,
  input  [  0:0] \__pi_i0__5 ,
  input  [  0:0] \__pi_q1__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__226___gold ,
  output [  0:0] \__po__226___gate
);
  \gold.test1._226_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__227_ (\__pi__227_ ),
    .\__pi__228_ (\__pi__228_ ),
    .\__pi__229_ (\__pi__229_ ),
    .\__pi__230_ (\__pi__230_ ),
    .\__pi_i0__5 (\__pi_i0__5 ),
    .\__pi_q1__5 (\__pi_q1__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__226_ (\__po__226___gold )
  );
  \gate.test1._226_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__227_ (\__pi__227_ ),
    .\__pi__228_ (\__pi__228_ ),
    .\__pi__229_ (\__pi__229_ ),
    .\__pi__230_ (\__pi__230_ ),
    .\__pi_i0__5 (\__pi_i0__5 ),
    .\__pi_q1__5 (\__pi_q1__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__226_ (\__po__226___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__227___assume (\__pi__227_ );
  miter_def_prop #(1, "assume") \__pi__228___assume (\__pi__228_ );
  miter_def_prop #(1, "assume") \__pi__229___assume (\__pi__229_ );
  miter_def_prop #(1, "assume") \__pi__230___assume (\__pi__230_ );
  miter_def_prop #(1, "assume") \__pi_i0__5__assume (\__pi_i0__5 );
  miter_def_prop #(1, "assume") \__pi_q1__5__assume (\__pi_q1__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__226___assert (\__po__226___gold , \__po__226___gate );
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
  miter_def_prop #(1, "cover") \__po__226___gold_cover (\__po__226___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__226___gate_cover (\__po__226___gate );
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
module \gold.test1._226_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__227_ ,
  input  [  0:0] \__pi__228_ ,
  input  [  0:0] \__pi__229_ ,
  input  [  0:0] \__pi__230_ ,
  input  [  0:0] \__pi_i0__5 ,
  input  [  0:0] \__pi_q1__5 ,
  output [  0:0] \__po__226_
);
endmodule
module \gate.test1._226_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__227_ ,
  input  [  0:0] \__pi__228_ ,
  input  [  0:0] \__pi__229_ ,
  input  [  0:0] \__pi__230_ ,
  input  [  0:0] \__pi_i0__5 ,
  input  [  0:0] \__pi_q1__5 ,
  output [  0:0] \__po__226_
);
endmodule
