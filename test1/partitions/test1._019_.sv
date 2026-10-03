module miter (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__015_ ,
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi_i6__7 ,
  input  [  0:0] \__pi_q5__7 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__019___gold ,
  output [  0:0] \__po__019___gate
);
  \gold.test1._019_ gold (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__015_ (\__pi__015_ ),
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi_i6__7 (\__pi_i6__7 ),
    .\__pi_q5__7 (\__pi_q5__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__019_ (\__po__019___gold )
  );
  \gate.test1._019_ gate (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__015_ (\__pi__015_ ),
    .\__pi__020_ (\__pi__020_ ),
    .\__pi__021_ (\__pi__021_ ),
    .\__pi_i6__7 (\__pi_i6__7 ),
    .\__pi_q5__7 (\__pi_q5__7 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__019_ (\__po__019___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__010___assume (\__pi__010_ );
  miter_def_prop #(1, "assume") \__pi__011___assume (\__pi__011_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__015___assume (\__pi__015_ );
  miter_def_prop #(1, "assume") \__pi__020___assume (\__pi__020_ );
  miter_def_prop #(1, "assume") \__pi__021___assume (\__pi__021_ );
  miter_def_prop #(1, "assume") \__pi_i6__7__assume (\__pi_i6__7 );
  miter_def_prop #(1, "assume") \__pi_q5__7__assume (\__pi_q5__7 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__019___assert (\__po__019___gold , \__po__019___gate );
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
  miter_def_prop #(1, "cover") \__po__019___gold_cover (\__po__019___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__019___gate_cover (\__po__019___gate );
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
module \gold.test1._019_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__015_ ,
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi_i6__7 ,
  input  [  0:0] \__pi_q5__7 ,
  output [  0:0] \__po__019_
);
endmodule
module \gate.test1._019_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__015_ ,
  input  [  0:0] \__pi__020_ ,
  input  [  0:0] \__pi__021_ ,
  input  [  0:0] \__pi_i6__7 ,
  input  [  0:0] \__pi_q5__7 ,
  output [  0:0] \__po__019_
);
endmodule
