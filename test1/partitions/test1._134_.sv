module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__128_ ,
  input  [  0:0] \__pi__129_ ,
  input  [  0:0] \__pi__132_ ,
  input  [  0:0] \__pi__133_ ,
  input  [  0:0] \__pi_i4__7 ,
  input  [  0:0] \__pi_q5__7 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__134___gold ,
  output [  0:0] \__po__134___gate
);
  \gold.test1._134_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__128_ (\__pi__128_ ),
    .\__pi__129_ (\__pi__129_ ),
    .\__pi__132_ (\__pi__132_ ),
    .\__pi__133_ (\__pi__133_ ),
    .\__pi_i4__7 (\__pi_i4__7 ),
    .\__pi_q5__7 (\__pi_q5__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__134_ (\__po__134___gold )
  );
  \gate.test1._134_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__128_ (\__pi__128_ ),
    .\__pi__129_ (\__pi__129_ ),
    .\__pi__132_ (\__pi__132_ ),
    .\__pi__133_ (\__pi__133_ ),
    .\__pi_i4__7 (\__pi_i4__7 ),
    .\__pi_q5__7 (\__pi_q5__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__134_ (\__po__134___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__128___assume (\__pi__128_ );
  miter_def_prop #(1, "assume") \__pi__129___assume (\__pi__129_ );
  miter_def_prop #(1, "assume") \__pi__132___assume (\__pi__132_ );
  miter_def_prop #(1, "assume") \__pi__133___assume (\__pi__133_ );
  miter_def_prop #(1, "assume") \__pi_i4__7__assume (\__pi_i4__7 );
  miter_def_prop #(1, "assume") \__pi_q5__7__assume (\__pi_q5__7 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__134___assert (\__po__134___gold , \__po__134___gate );
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
  miter_def_prop #(1, "cover") \__po__134___gold_cover (\__po__134___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__134___gate_cover (\__po__134___gate );
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
module \gold.test1._134_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__128_ ,
  input  [  0:0] \__pi__129_ ,
  input  [  0:0] \__pi__132_ ,
  input  [  0:0] \__pi__133_ ,
  input  [  0:0] \__pi_i4__7 ,
  input  [  0:0] \__pi_q5__7 ,
  output [  0:0] \__po__134_
);
endmodule
module \gate.test1._134_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__128_ ,
  input  [  0:0] \__pi__129_ ,
  input  [  0:0] \__pi__132_ ,
  input  [  0:0] \__pi__133_ ,
  input  [  0:0] \__pi_i4__7 ,
  input  [  0:0] \__pi_q5__7 ,
  output [  0:0] \__po__134_
);
endmodule
