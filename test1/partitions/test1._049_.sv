module miter (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__040_ ,
  input  [  0:0] \__pi__041_ ,
  input  [  0:0] \__pi__044_ ,
  input  [  0:0] \__pi__045_ ,
  input  [  0:0] \__pi_i7__5 ,
  input  [  0:0] \__pi_q6__5 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__049___gold ,
  output [  0:0] \__po__049___gate
);
  \gold.test1._049_ gold (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__040_ (\__pi__040_ ),
    .\__pi__041_ (\__pi__041_ ),
    .\__pi__044_ (\__pi__044_ ),
    .\__pi__045_ (\__pi__045_ ),
    .\__pi_i7__5 (\__pi_i7__5 ),
    .\__pi_q6__5 (\__pi_q6__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__049_ (\__po__049___gold )
  );
  \gate.test1._049_ gate (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__040_ (\__pi__040_ ),
    .\__pi__041_ (\__pi__041_ ),
    .\__pi__044_ (\__pi__044_ ),
    .\__pi__045_ (\__pi__045_ ),
    .\__pi_i7__5 (\__pi_i7__5 ),
    .\__pi_q6__5 (\__pi_q6__5 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__049_ (\__po__049___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__040___assume (\__pi__040_ );
  miter_def_prop #(1, "assume") \__pi__041___assume (\__pi__041_ );
  miter_def_prop #(1, "assume") \__pi__044___assume (\__pi__044_ );
  miter_def_prop #(1, "assume") \__pi__045___assume (\__pi__045_ );
  miter_def_prop #(1, "assume") \__pi_i7__5__assume (\__pi_i7__5 );
  miter_def_prop #(1, "assume") \__pi_q6__5__assume (\__pi_q6__5 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__049___assert (\__po__049___gold , \__po__049___gate );
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
  miter_def_prop #(1, "cover") \__po__049___gold_cover (\__po__049___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__049___gate_cover (\__po__049___gate );
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
module \gold.test1._049_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__040_ ,
  input  [  0:0] \__pi__041_ ,
  input  [  0:0] \__pi__044_ ,
  input  [  0:0] \__pi__045_ ,
  input  [  0:0] \__pi_i7__5 ,
  input  [  0:0] \__pi_q6__5 ,
  output [  0:0] \__po__049_
);
endmodule
module \gate.test1._049_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__040_ ,
  input  [  0:0] \__pi__041_ ,
  input  [  0:0] \__pi__044_ ,
  input  [  0:0] \__pi__045_ ,
  input  [  0:0] \__pi_i7__5 ,
  input  [  0:0] \__pi_q6__5 ,
  output [  0:0] \__po__049_
);
endmodule
