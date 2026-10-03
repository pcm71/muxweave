module miter (
  input  [  0:0] \__pi__022_ ,
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi_i1__7 ,
  input  [  0:0] \__pi_q0__7 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__028___gold ,
  output [  0:0] \__po__028___gate
);
  \gold.test1._028_ gold (
    .\__pi__022_ (\__pi__022_ ),
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi_i1__7 (\__pi_i1__7 ),
    .\__pi_q0__7 (\__pi_q0__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__028_ (\__po__028___gold )
  );
  \gate.test1._028_ gate (
    .\__pi__022_ (\__pi__022_ ),
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi_i1__7 (\__pi_i1__7 ),
    .\__pi_q0__7 (\__pi_q0__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__028_ (\__po__028___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__022___assume (\__pi__022_ );
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__029___assume (\__pi__029_ );
  miter_def_prop #(1, "assume") \__pi__030___assume (\__pi__030_ );
  miter_def_prop #(1, "assume") \__pi_i1__7__assume (\__pi_i1__7 );
  miter_def_prop #(1, "assume") \__pi_q0__7__assume (\__pi_q0__7 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__028___assert (\__po__028___gold , \__po__028___gate );
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
  miter_def_prop #(1, "cover") \__po__028___gold_cover (\__po__028___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__028___gate_cover (\__po__028___gate );
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
module \gold.test1._028_ (
  input  [  0:0] \__pi__022_ ,
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi_i1__7 ,
  input  [  0:0] \__pi_q0__7 ,
  output [  0:0] \__po__028_
);
endmodule
module \gate.test1._028_ (
  input  [  0:0] \__pi__022_ ,
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi_i1__7 ,
  input  [  0:0] \__pi_q0__7 ,
  output [  0:0] \__po__028_
);
endmodule
