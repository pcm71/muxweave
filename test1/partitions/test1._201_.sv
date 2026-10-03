module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__202_ ,
  input  [  0:0] \__pi__203_ ,
  input  [  0:0] \__pi__204_ ,
  input  [  0:0] \__pi__205_ ,
  input  [  0:0] \__pi_i5__4 ,
  input  [  0:0] \__pi_q6__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__201___gold ,
  output [  0:0] \__po__201___gate
);
  \gold.test1._201_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__202_ (\__pi__202_ ),
    .\__pi__203_ (\__pi__203_ ),
    .\__pi__204_ (\__pi__204_ ),
    .\__pi__205_ (\__pi__205_ ),
    .\__pi_i5__4 (\__pi_i5__4 ),
    .\__pi_q6__4 (\__pi_q6__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__201_ (\__po__201___gold )
  );
  \gate.test1._201_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__202_ (\__pi__202_ ),
    .\__pi__203_ (\__pi__203_ ),
    .\__pi__204_ (\__pi__204_ ),
    .\__pi__205_ (\__pi__205_ ),
    .\__pi_i5__4 (\__pi_i5__4 ),
    .\__pi_q6__4 (\__pi_q6__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__201_ (\__po__201___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__202___assume (\__pi__202_ );
  miter_def_prop #(1, "assume") \__pi__203___assume (\__pi__203_ );
  miter_def_prop #(1, "assume") \__pi__204___assume (\__pi__204_ );
  miter_def_prop #(1, "assume") \__pi__205___assume (\__pi__205_ );
  miter_def_prop #(1, "assume") \__pi_i5__4__assume (\__pi_i5__4 );
  miter_def_prop #(1, "assume") \__pi_q6__4__assume (\__pi_q6__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__201___assert (\__po__201___gold , \__po__201___gate );
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
  miter_def_prop #(1, "cover") \__po__201___gold_cover (\__po__201___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__201___gate_cover (\__po__201___gate );
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
module \gold.test1._201_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__202_ ,
  input  [  0:0] \__pi__203_ ,
  input  [  0:0] \__pi__204_ ,
  input  [  0:0] \__pi__205_ ,
  input  [  0:0] \__pi_i5__4 ,
  input  [  0:0] \__pi_q6__4 ,
  output [  0:0] \__po__201_
);
endmodule
module \gate.test1._201_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__202_ ,
  input  [  0:0] \__pi__203_ ,
  input  [  0:0] \__pi__204_ ,
  input  [  0:0] \__pi__205_ ,
  input  [  0:0] \__pi_i5__4 ,
  input  [  0:0] \__pi_q6__4 ,
  output [  0:0] \__po__201_
);
endmodule
