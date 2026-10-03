module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__226_ ,
  input  [  0:0] \__pi__227_ ,
  input  [  0:0] \__pi__230_ ,
  input  [  0:0] \__pi__231_ ,
  input  [  0:0] \__pi_i5__8 ,
  input  [  0:0] \__pi_q4__8 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__235___gold ,
  output [  0:0] \__po__235___gate
);
  \gold.test1._235_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__226_ (\__pi__226_ ),
    .\__pi__227_ (\__pi__227_ ),
    .\__pi__230_ (\__pi__230_ ),
    .\__pi__231_ (\__pi__231_ ),
    .\__pi_i5__8 (\__pi_i5__8 ),
    .\__pi_q4__8 (\__pi_q4__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__235_ (\__po__235___gold )
  );
  \gate.test1._235_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__226_ (\__pi__226_ ),
    .\__pi__227_ (\__pi__227_ ),
    .\__pi__230_ (\__pi__230_ ),
    .\__pi__231_ (\__pi__231_ ),
    .\__pi_i5__8 (\__pi_i5__8 ),
    .\__pi_q4__8 (\__pi_q4__8 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__235_ (\__po__235___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__226___assume (\__pi__226_ );
  miter_def_prop #(1, "assume") \__pi__227___assume (\__pi__227_ );
  miter_def_prop #(1, "assume") \__pi__230___assume (\__pi__230_ );
  miter_def_prop #(1, "assume") \__pi__231___assume (\__pi__231_ );
  miter_def_prop #(1, "assume") \__pi_i5__8__assume (\__pi_i5__8 );
  miter_def_prop #(1, "assume") \__pi_q4__8__assume (\__pi_q4__8 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__235___assert (\__po__235___gold , \__po__235___gate );
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
  miter_def_prop #(1, "cover") \__po__235___gold_cover (\__po__235___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__235___gate_cover (\__po__235___gate );
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
module \gold.test1._235_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__226_ ,
  input  [  0:0] \__pi__227_ ,
  input  [  0:0] \__pi__230_ ,
  input  [  0:0] \__pi__231_ ,
  input  [  0:0] \__pi_i5__8 ,
  input  [  0:0] \__pi_q4__8 ,
  output [  0:0] \__po__235_
);
endmodule
module \gate.test1._235_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__226_ ,
  input  [  0:0] \__pi__227_ ,
  input  [  0:0] \__pi__230_ ,
  input  [  0:0] \__pi__231_ ,
  input  [  0:0] \__pi_i5__8 ,
  input  [  0:0] \__pi_q4__8 ,
  output [  0:0] \__po__235_
);
endmodule
