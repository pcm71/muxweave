module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__246_ ,
  input  [  0:0] \__pi__247_ ,
  input  [  0:0] \__pi__250_ ,
  input  [  0:0] \__pi__251_ ,
  input  [  0:0] \__pi_i5__11 ,
  input  [  0:0] \__pi_q4__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__255___gold ,
  output [  0:0] \__po__255___gate
);
  \gold.test1._255_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__246_ (\__pi__246_ ),
    .\__pi__247_ (\__pi__247_ ),
    .\__pi__250_ (\__pi__250_ ),
    .\__pi__251_ (\__pi__251_ ),
    .\__pi_i5__11 (\__pi_i5__11 ),
    .\__pi_q4__11 (\__pi_q4__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__255_ (\__po__255___gold )
  );
  \gate.test1._255_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__246_ (\__pi__246_ ),
    .\__pi__247_ (\__pi__247_ ),
    .\__pi__250_ (\__pi__250_ ),
    .\__pi__251_ (\__pi__251_ ),
    .\__pi_i5__11 (\__pi_i5__11 ),
    .\__pi_q4__11 (\__pi_q4__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__255_ (\__po__255___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__246___assume (\__pi__246_ );
  miter_def_prop #(1, "assume") \__pi__247___assume (\__pi__247_ );
  miter_def_prop #(1, "assume") \__pi__250___assume (\__pi__250_ );
  miter_def_prop #(1, "assume") \__pi__251___assume (\__pi__251_ );
  miter_def_prop #(1, "assume") \__pi_i5__11__assume (\__pi_i5__11 );
  miter_def_prop #(1, "assume") \__pi_q4__11__assume (\__pi_q4__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__255___assert (\__po__255___gold , \__po__255___gate );
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
  miter_def_prop #(1, "cover") \__po__255___gold_cover (\__po__255___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__255___gate_cover (\__po__255___gate );
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
module \gold.test1._255_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__246_ ,
  input  [  0:0] \__pi__247_ ,
  input  [  0:0] \__pi__250_ ,
  input  [  0:0] \__pi__251_ ,
  input  [  0:0] \__pi_i5__11 ,
  input  [  0:0] \__pi_q4__11 ,
  output [  0:0] \__po__255_
);
endmodule
module \gate.test1._255_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__246_ ,
  input  [  0:0] \__pi__247_ ,
  input  [  0:0] \__pi__250_ ,
  input  [  0:0] \__pi__251_ ,
  input  [  0:0] \__pi_i5__11 ,
  input  [  0:0] \__pi_q4__11 ,
  output [  0:0] \__po__255_
);
endmodule
