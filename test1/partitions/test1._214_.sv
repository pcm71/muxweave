module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__208_ ,
  input  [  0:0] \__pi__209_ ,
  input  [  0:0] \__pi__212_ ,
  input  [  0:0] \__pi__213_ ,
  input  [  0:0] \__pi_i5__9 ,
  input  [  0:0] \__pi_q4__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__214___gold ,
  output [  0:0] \__po__214___gate
);
  \gold.test1._214_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__208_ (\__pi__208_ ),
    .\__pi__209_ (\__pi__209_ ),
    .\__pi__212_ (\__pi__212_ ),
    .\__pi__213_ (\__pi__213_ ),
    .\__pi_i5__9 (\__pi_i5__9 ),
    .\__pi_q4__9 (\__pi_q4__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__214_ (\__po__214___gold )
  );
  \gate.test1._214_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__208_ (\__pi__208_ ),
    .\__pi__209_ (\__pi__209_ ),
    .\__pi__212_ (\__pi__212_ ),
    .\__pi__213_ (\__pi__213_ ),
    .\__pi_i5__9 (\__pi_i5__9 ),
    .\__pi_q4__9 (\__pi_q4__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__214_ (\__po__214___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__208___assume (\__pi__208_ );
  miter_def_prop #(1, "assume") \__pi__209___assume (\__pi__209_ );
  miter_def_prop #(1, "assume") \__pi__212___assume (\__pi__212_ );
  miter_def_prop #(1, "assume") \__pi__213___assume (\__pi__213_ );
  miter_def_prop #(1, "assume") \__pi_i5__9__assume (\__pi_i5__9 );
  miter_def_prop #(1, "assume") \__pi_q4__9__assume (\__pi_q4__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__214___assert (\__po__214___gold , \__po__214___gate );
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
  miter_def_prop #(1, "cover") \__po__214___gold_cover (\__po__214___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__214___gate_cover (\__po__214___gate );
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
module \gold.test1._214_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__208_ ,
  input  [  0:0] \__pi__209_ ,
  input  [  0:0] \__pi__212_ ,
  input  [  0:0] \__pi__213_ ,
  input  [  0:0] \__pi_i5__9 ,
  input  [  0:0] \__pi_q4__9 ,
  output [  0:0] \__po__214_
);
endmodule
module \gate.test1._214_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__208_ ,
  input  [  0:0] \__pi__209_ ,
  input  [  0:0] \__pi__212_ ,
  input  [  0:0] \__pi__213_ ,
  input  [  0:0] \__pi_i5__9 ,
  input  [  0:0] \__pi_q4__9 ,
  output [  0:0] \__po__214_
);
endmodule
