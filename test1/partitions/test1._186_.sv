module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__187_ ,
  input  [  0:0] \__pi__188_ ,
  input  [  0:0] \__pi__189_ ,
  input  [  0:0] \__pi__190_ ,
  input  [  0:0] \__pi_i1__3 ,
  input  [  0:0] \__pi_q0__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__186___gold ,
  output [  0:0] \__po__186___gate
);
  \gold.test1._186_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__187_ (\__pi__187_ ),
    .\__pi__188_ (\__pi__188_ ),
    .\__pi__189_ (\__pi__189_ ),
    .\__pi__190_ (\__pi__190_ ),
    .\__pi_i1__3 (\__pi_i1__3 ),
    .\__pi_q0__3 (\__pi_q0__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__186_ (\__po__186___gold )
  );
  \gate.test1._186_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__187_ (\__pi__187_ ),
    .\__pi__188_ (\__pi__188_ ),
    .\__pi__189_ (\__pi__189_ ),
    .\__pi__190_ (\__pi__190_ ),
    .\__pi_i1__3 (\__pi_i1__3 ),
    .\__pi_q0__3 (\__pi_q0__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__186_ (\__po__186___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__187___assume (\__pi__187_ );
  miter_def_prop #(1, "assume") \__pi__188___assume (\__pi__188_ );
  miter_def_prop #(1, "assume") \__pi__189___assume (\__pi__189_ );
  miter_def_prop #(1, "assume") \__pi__190___assume (\__pi__190_ );
  miter_def_prop #(1, "assume") \__pi_i1__3__assume (\__pi_i1__3 );
  miter_def_prop #(1, "assume") \__pi_q0__3__assume (\__pi_q0__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__186___assert (\__po__186___gold , \__po__186___gate );
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
  miter_def_prop #(1, "cover") \__po__186___gold_cover (\__po__186___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__186___gate_cover (\__po__186___gate );
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
module \gold.test1._186_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__187_ ,
  input  [  0:0] \__pi__188_ ,
  input  [  0:0] \__pi__189_ ,
  input  [  0:0] \__pi__190_ ,
  input  [  0:0] \__pi_i1__3 ,
  input  [  0:0] \__pi_q0__3 ,
  output [  0:0] \__po__186_
);
endmodule
module \gate.test1._186_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__187_ ,
  input  [  0:0] \__pi__188_ ,
  input  [  0:0] \__pi__189_ ,
  input  [  0:0] \__pi__190_ ,
  input  [  0:0] \__pi_i1__3 ,
  input  [  0:0] \__pi_q0__3 ,
  output [  0:0] \__po__186_
);
endmodule
