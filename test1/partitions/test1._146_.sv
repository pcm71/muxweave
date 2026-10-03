module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__147_ ,
  input  [  0:0] \__pi__148_ ,
  input  [  0:0] \__pi__149_ ,
  input  [  0:0] \__pi__150_ ,
  input  [  0:0] \__pi_i0__1 ,
  input  [  0:0] \__pi_q1__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__146___gold ,
  output [  0:0] \__po__146___gate
);
  \gold.test1._146_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__147_ (\__pi__147_ ),
    .\__pi__148_ (\__pi__148_ ),
    .\__pi__149_ (\__pi__149_ ),
    .\__pi__150_ (\__pi__150_ ),
    .\__pi_i0__1 (\__pi_i0__1 ),
    .\__pi_q1__1 (\__pi_q1__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__146_ (\__po__146___gold )
  );
  \gate.test1._146_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__147_ (\__pi__147_ ),
    .\__pi__148_ (\__pi__148_ ),
    .\__pi__149_ (\__pi__149_ ),
    .\__pi__150_ (\__pi__150_ ),
    .\__pi_i0__1 (\__pi_i0__1 ),
    .\__pi_q1__1 (\__pi_q1__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__146_ (\__po__146___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__147___assume (\__pi__147_ );
  miter_def_prop #(1, "assume") \__pi__148___assume (\__pi__148_ );
  miter_def_prop #(1, "assume") \__pi__149___assume (\__pi__149_ );
  miter_def_prop #(1, "assume") \__pi__150___assume (\__pi__150_ );
  miter_def_prop #(1, "assume") \__pi_i0__1__assume (\__pi_i0__1 );
  miter_def_prop #(1, "assume") \__pi_q1__1__assume (\__pi_q1__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__146___assert (\__po__146___gold , \__po__146___gate );
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
  miter_def_prop #(1, "cover") \__po__146___gold_cover (\__po__146___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__146___gate_cover (\__po__146___gate );
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
module \gold.test1._146_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__147_ ,
  input  [  0:0] \__pi__148_ ,
  input  [  0:0] \__pi__149_ ,
  input  [  0:0] \__pi__150_ ,
  input  [  0:0] \__pi_i0__1 ,
  input  [  0:0] \__pi_q1__1 ,
  output [  0:0] \__po__146_
);
endmodule
module \gate.test1._146_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__147_ ,
  input  [  0:0] \__pi__148_ ,
  input  [  0:0] \__pi__149_ ,
  input  [  0:0] \__pi__150_ ,
  input  [  0:0] \__pi_i0__1 ,
  input  [  0:0] \__pi_q1__1 ,
  output [  0:0] \__po__146_
);
endmodule
