module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__107_ ,
  input  [  0:0] \__pi__108_ ,
  input  [  0:0] \__pi_i2__1 ,
  input  [  0:0] \__pi_i3__6 ,
  input  [  0:0] \__pi_q3__1 ,
  input  [  0:0] \__pi_q4__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__148___gold ,
  output [  0:0] \__po__148___gate
);
  \gold.test1._148_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__107_ (\__pi__107_ ),
    .\__pi__108_ (\__pi__108_ ),
    .\__pi_i2__1 (\__pi_i2__1 ),
    .\__pi_i3__6 (\__pi_i3__6 ),
    .\__pi_q3__1 (\__pi_q3__1 ),
    .\__pi_q4__6 (\__pi_q4__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__148_ (\__po__148___gold )
  );
  \gate.test1._148_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__107_ (\__pi__107_ ),
    .\__pi__108_ (\__pi__108_ ),
    .\__pi_i2__1 (\__pi_i2__1 ),
    .\__pi_i3__6 (\__pi_i3__6 ),
    .\__pi_q3__1 (\__pi_q3__1 ),
    .\__pi_q4__6 (\__pi_q4__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__148_ (\__po__148___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__107___assume (\__pi__107_ );
  miter_def_prop #(1, "assume") \__pi__108___assume (\__pi__108_ );
  miter_def_prop #(1, "assume") \__pi_i2__1__assume (\__pi_i2__1 );
  miter_def_prop #(1, "assume") \__pi_i3__6__assume (\__pi_i3__6 );
  miter_def_prop #(1, "assume") \__pi_q3__1__assume (\__pi_q3__1 );
  miter_def_prop #(1, "assume") \__pi_q4__6__assume (\__pi_q4__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__148___assert (\__po__148___gold , \__po__148___gate );
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
  miter_def_prop #(1, "cover") \__po__148___gold_cover (\__po__148___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__148___gate_cover (\__po__148___gate );
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
module \gold.test1._148_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__107_ ,
  input  [  0:0] \__pi__108_ ,
  input  [  0:0] \__pi_i2__1 ,
  input  [  0:0] \__pi_i3__6 ,
  input  [  0:0] \__pi_q3__1 ,
  input  [  0:0] \__pi_q4__6 ,
  output [  0:0] \__po__148_
);
endmodule
module \gate.test1._148_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__107_ ,
  input  [  0:0] \__pi__108_ ,
  input  [  0:0] \__pi_i2__1 ,
  input  [  0:0] \__pi_i3__6 ,
  input  [  0:0] \__pi_q3__1 ,
  input  [  0:0] \__pi_q4__6 ,
  output [  0:0] \__po__148_
);
endmodule
