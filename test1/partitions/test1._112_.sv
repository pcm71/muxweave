module miter (
  input  [  0:0] \__pi_Q0__13 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i3__0 ,
  input  [  0:0] \__pi_i7__9 ,
  input  [  0:0] \__pi_q4__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__112___gold ,
  output [  0:0] \__po__112___gate
);
  \gold.test1._112_ gold (
    .\__pi_Q0__13 (\__pi_Q0__13 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i3__0 (\__pi_i3__0 ),
    .\__pi_i7__9 (\__pi_i7__9 ),
    .\__pi_q4__0 (\__pi_q4__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__112_ (\__po__112___gold )
  );
  \gate.test1._112_ gate (
    .\__pi_Q0__13 (\__pi_Q0__13 ),
    .\__pi__003_ (\__pi__003_ ),
    .\__pi__008_ (\__pi__008_ ),
    .\__pi__110_ (\__pi__110_ ),
    .\__pi__111_ (\__pi__111_ ),
    .\__pi_i3__0 (\__pi_i3__0 ),
    .\__pi_i7__9 (\__pi_i7__9 ),
    .\__pi_q4__0 (\__pi_q4__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__112_ (\__po__112___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi_Q0__13__assume (\__pi_Q0__13 );
  miter_def_prop #(1, "assume") \__pi__003___assume (\__pi__003_ );
  miter_def_prop #(1, "assume") \__pi__008___assume (\__pi__008_ );
  miter_def_prop #(1, "assume") \__pi__110___assume (\__pi__110_ );
  miter_def_prop #(1, "assume") \__pi__111___assume (\__pi__111_ );
  miter_def_prop #(1, "assume") \__pi_i3__0__assume (\__pi_i3__0 );
  miter_def_prop #(1, "assume") \__pi_i7__9__assume (\__pi_i7__9 );
  miter_def_prop #(1, "assume") \__pi_q4__0__assume (\__pi_q4__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__112___assert (\__po__112___gold , \__po__112___gate );
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
  miter_def_prop #(1, "cover") \__po__112___gold_cover (\__po__112___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__112___gate_cover (\__po__112___gate );
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
module \gold.test1._112_ (
  input  [  0:0] \__pi_Q0__13 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i3__0 ,
  input  [  0:0] \__pi_i7__9 ,
  input  [  0:0] \__pi_q4__0 ,
  output [  0:0] \__po__112_
);
endmodule
module \gate.test1._112_ (
  input  [  0:0] \__pi_Q0__13 ,
  input  [  0:0] \__pi__003_ ,
  input  [  0:0] \__pi__008_ ,
  input  [  0:0] \__pi__110_ ,
  input  [  0:0] \__pi__111_ ,
  input  [  0:0] \__pi_i3__0 ,
  input  [  0:0] \__pi_i7__9 ,
  input  [  0:0] \__pi_q4__0 ,
  output [  0:0] \__po__112_
);
endmodule
