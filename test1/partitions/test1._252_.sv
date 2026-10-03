module miter (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__253_ ,
  input  [  0:0] \__pi__254_ ,
  input  [  0:0] \__pi__255_ ,
  input  [  0:0] \__pi__256_ ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q7__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__252___gold ,
  output [  0:0] \__po__252___gate
);
  \gold.test1._252_ gold (
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi__253_ (\__pi__253_ ),
    .\__pi__254_ (\__pi__254_ ),
    .\__pi__255_ (\__pi__255_ ),
    .\__pi__256_ (\__pi__256_ ),
    .\__pi_i6__6 (\__pi_i6__6 ),
    .\__pi_q7__6 (\__pi_q7__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__252_ (\__po__252___gold )
  );
  \gate.test1._252_ gate (
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi__253_ (\__pi__253_ ),
    .\__pi__254_ (\__pi__254_ ),
    .\__pi__255_ (\__pi__255_ ),
    .\__pi__256_ (\__pi__256_ ),
    .\__pi_i6__6 (\__pi_i6__6 ),
    .\__pi_q7__6 (\__pi_q7__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__252_ (\__po__252___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi__253___assume (\__pi__253_ );
  miter_def_prop #(1, "assume") \__pi__254___assume (\__pi__254_ );
  miter_def_prop #(1, "assume") \__pi__255___assume (\__pi__255_ );
  miter_def_prop #(1, "assume") \__pi__256___assume (\__pi__256_ );
  miter_def_prop #(1, "assume") \__pi_i6__6__assume (\__pi_i6__6 );
  miter_def_prop #(1, "assume") \__pi_q7__6__assume (\__pi_q7__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__252___assert (\__po__252___gold , \__po__252___gate );
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
  miter_def_prop #(1, "cover") \__po__252___gold_cover (\__po__252___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__252___gate_cover (\__po__252___gate );
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
module \gold.test1._252_ (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__253_ ,
  input  [  0:0] \__pi__254_ ,
  input  [  0:0] \__pi__255_ ,
  input  [  0:0] \__pi__256_ ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q7__6 ,
  output [  0:0] \__po__252_
);
endmodule
module \gate.test1._252_ (
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi__253_ ,
  input  [  0:0] \__pi__254_ ,
  input  [  0:0] \__pi__255_ ,
  input  [  0:0] \__pi__256_ ,
  input  [  0:0] \__pi_i6__6 ,
  input  [  0:0] \__pi_q7__6 ,
  output [  0:0] \__po__252_
);
endmodule
