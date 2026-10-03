module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__137_ ,
  input  [  0:0] \__pi__138_ ,
  input  [  0:0] \__pi__139_ ,
  input  [  0:0] \__pi__140_ ,
  input  [  0:0] \__pi_i1__1 ,
  input  [  0:0] \__pi_q0__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__136___gold ,
  output [  0:0] \__po__136___gate
);
  \gold.test1._136_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__137_ (\__pi__137_ ),
    .\__pi__138_ (\__pi__138_ ),
    .\__pi__139_ (\__pi__139_ ),
    .\__pi__140_ (\__pi__140_ ),
    .\__pi_i1__1 (\__pi_i1__1 ),
    .\__pi_q0__1 (\__pi_q0__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__136_ (\__po__136___gold )
  );
  \gate.test1._136_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__137_ (\__pi__137_ ),
    .\__pi__138_ (\__pi__138_ ),
    .\__pi__139_ (\__pi__139_ ),
    .\__pi__140_ (\__pi__140_ ),
    .\__pi_i1__1 (\__pi_i1__1 ),
    .\__pi_q0__1 (\__pi_q0__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__136_ (\__po__136___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__137___assume (\__pi__137_ );
  miter_def_prop #(1, "assume") \__pi__138___assume (\__pi__138_ );
  miter_def_prop #(1, "assume") \__pi__139___assume (\__pi__139_ );
  miter_def_prop #(1, "assume") \__pi__140___assume (\__pi__140_ );
  miter_def_prop #(1, "assume") \__pi_i1__1__assume (\__pi_i1__1 );
  miter_def_prop #(1, "assume") \__pi_q0__1__assume (\__pi_q0__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__136___assert (\__po__136___gold , \__po__136___gate );
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
  miter_def_prop #(1, "cover") \__po__136___gold_cover (\__po__136___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__136___gate_cover (\__po__136___gate );
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
module \gold.test1._136_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__137_ ,
  input  [  0:0] \__pi__138_ ,
  input  [  0:0] \__pi__139_ ,
  input  [  0:0] \__pi__140_ ,
  input  [  0:0] \__pi_i1__1 ,
  input  [  0:0] \__pi_q0__1 ,
  output [  0:0] \__po__136_
);
endmodule
module \gate.test1._136_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__137_ ,
  input  [  0:0] \__pi__138_ ,
  input  [  0:0] \__pi__139_ ,
  input  [  0:0] \__pi__140_ ,
  input  [  0:0] \__pi_i1__1 ,
  input  [  0:0] \__pi_q0__1 ,
  output [  0:0] \__po__136_
);
endmodule
