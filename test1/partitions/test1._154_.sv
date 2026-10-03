module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__148_ ,
  input  [  0:0] \__pi__149_ ,
  input  [  0:0] \__pi__152_ ,
  input  [  0:0] \__pi__153_ ,
  input  [  0:0] \__pi_i4__5 ,
  input  [  0:0] \__pi_q5__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__154___gold ,
  output [  0:0] \__po__154___gate
);
  \gold.test1._154_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__148_ (\__pi__148_ ),
    .\__pi__149_ (\__pi__149_ ),
    .\__pi__152_ (\__pi__152_ ),
    .\__pi__153_ (\__pi__153_ ),
    .\__pi_i4__5 (\__pi_i4__5 ),
    .\__pi_q5__5 (\__pi_q5__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__154_ (\__po__154___gold )
  );
  \gate.test1._154_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__148_ (\__pi__148_ ),
    .\__pi__149_ (\__pi__149_ ),
    .\__pi__152_ (\__pi__152_ ),
    .\__pi__153_ (\__pi__153_ ),
    .\__pi_i4__5 (\__pi_i4__5 ),
    .\__pi_q5__5 (\__pi_q5__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__154_ (\__po__154___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__148___assume (\__pi__148_ );
  miter_def_prop #(1, "assume") \__pi__149___assume (\__pi__149_ );
  miter_def_prop #(1, "assume") \__pi__152___assume (\__pi__152_ );
  miter_def_prop #(1, "assume") \__pi__153___assume (\__pi__153_ );
  miter_def_prop #(1, "assume") \__pi_i4__5__assume (\__pi_i4__5 );
  miter_def_prop #(1, "assume") \__pi_q5__5__assume (\__pi_q5__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__154___assert (\__po__154___gold , \__po__154___gate );
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
  miter_def_prop #(1, "cover") \__po__154___gold_cover (\__po__154___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__154___gate_cover (\__po__154___gate );
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
module \gold.test1._154_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__148_ ,
  input  [  0:0] \__pi__149_ ,
  input  [  0:0] \__pi__152_ ,
  input  [  0:0] \__pi__153_ ,
  input  [  0:0] \__pi_i4__5 ,
  input  [  0:0] \__pi_q5__5 ,
  output [  0:0] \__po__154_
);
endmodule
module \gate.test1._154_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__148_ ,
  input  [  0:0] \__pi__149_ ,
  input  [  0:0] \__pi__152_ ,
  input  [  0:0] \__pi__153_ ,
  input  [  0:0] \__pi_i4__5 ,
  input  [  0:0] \__pi_q5__5 ,
  output [  0:0] \__po__154_
);
endmodule
