module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__172_ ,
  input  [  0:0] \__pi__173_ ,
  input  [  0:0] \__pi__174_ ,
  input  [  0:0] \__pi__175_ ,
  input  [  0:0] \__pi_i6__2 ,
  input  [  0:0] \__pi_q5__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__171___gold ,
  output [  0:0] \__po__171___gate
);
  \gold.test1._171_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__172_ (\__pi__172_ ),
    .\__pi__173_ (\__pi__173_ ),
    .\__pi__174_ (\__pi__174_ ),
    .\__pi__175_ (\__pi__175_ ),
    .\__pi_i6__2 (\__pi_i6__2 ),
    .\__pi_q5__2 (\__pi_q5__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__171_ (\__po__171___gold )
  );
  \gate.test1._171_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__172_ (\__pi__172_ ),
    .\__pi__173_ (\__pi__173_ ),
    .\__pi__174_ (\__pi__174_ ),
    .\__pi__175_ (\__pi__175_ ),
    .\__pi_i6__2 (\__pi_i6__2 ),
    .\__pi_q5__2 (\__pi_q5__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__171_ (\__po__171___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__172___assume (\__pi__172_ );
  miter_def_prop #(1, "assume") \__pi__173___assume (\__pi__173_ );
  miter_def_prop #(1, "assume") \__pi__174___assume (\__pi__174_ );
  miter_def_prop #(1, "assume") \__pi__175___assume (\__pi__175_ );
  miter_def_prop #(1, "assume") \__pi_i6__2__assume (\__pi_i6__2 );
  miter_def_prop #(1, "assume") \__pi_q5__2__assume (\__pi_q5__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__171___assert (\__po__171___gold , \__po__171___gate );
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
  miter_def_prop #(1, "cover") \__po__171___gold_cover (\__po__171___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__171___gate_cover (\__po__171___gate );
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
module \gold.test1._171_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__172_ ,
  input  [  0:0] \__pi__173_ ,
  input  [  0:0] \__pi__174_ ,
  input  [  0:0] \__pi__175_ ,
  input  [  0:0] \__pi_i6__2 ,
  input  [  0:0] \__pi_q5__2 ,
  output [  0:0] \__po__171_
);
endmodule
module \gate.test1._171_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__172_ ,
  input  [  0:0] \__pi__173_ ,
  input  [  0:0] \__pi__174_ ,
  input  [  0:0] \__pi__175_ ,
  input  [  0:0] \__pi_i6__2 ,
  input  [  0:0] \__pi_q5__2 ,
  output [  0:0] \__po__171_
);
endmodule
