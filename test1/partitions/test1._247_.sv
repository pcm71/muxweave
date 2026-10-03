module miter (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi__248_ ,
  input  [  0:0] \__pi__249_ ,
  input  [  0:0] \__pi__250_ ,
  input  [  0:0] \__pi__251_ ,
  input  [  0:0] \__pi_i1__6 ,
  input  [  0:0] \__pi_q2__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__247___gold ,
  output [  0:0] \__po__247___gate
);
  \gold.test1._247_ gold (
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi__248_ (\__pi__248_ ),
    .\__pi__249_ (\__pi__249_ ),
    .\__pi__250_ (\__pi__250_ ),
    .\__pi__251_ (\__pi__251_ ),
    .\__pi_i1__6 (\__pi_i1__6 ),
    .\__pi_q2__6 (\__pi_q2__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__247_ (\__po__247___gold )
  );
  \gate.test1._247_ gate (
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi__248_ (\__pi__248_ ),
    .\__pi__249_ (\__pi__249_ ),
    .\__pi__250_ (\__pi__250_ ),
    .\__pi__251_ (\__pi__251_ ),
    .\__pi_i1__6 (\__pi_i1__6 ),
    .\__pi_q2__6 (\__pi_q2__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__247_ (\__po__247___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi__248___assume (\__pi__248_ );
  miter_def_prop #(1, "assume") \__pi__249___assume (\__pi__249_ );
  miter_def_prop #(1, "assume") \__pi__250___assume (\__pi__250_ );
  miter_def_prop #(1, "assume") \__pi__251___assume (\__pi__251_ );
  miter_def_prop #(1, "assume") \__pi_i1__6__assume (\__pi_i1__6 );
  miter_def_prop #(1, "assume") \__pi_q2__6__assume (\__pi_q2__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__247___assert (\__po__247___gold , \__po__247___gate );
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
  miter_def_prop #(1, "cover") \__po__247___gold_cover (\__po__247___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__247___gate_cover (\__po__247___gate );
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
module \gold.test1._247_ (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi__248_ ,
  input  [  0:0] \__pi__249_ ,
  input  [  0:0] \__pi__250_ ,
  input  [  0:0] \__pi__251_ ,
  input  [  0:0] \__pi_i1__6 ,
  input  [  0:0] \__pi_q2__6 ,
  output [  0:0] \__po__247_
);
endmodule
module \gate.test1._247_ (
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi__248_ ,
  input  [  0:0] \__pi__249_ ,
  input  [  0:0] \__pi__250_ ,
  input  [  0:0] \__pi__251_ ,
  input  [  0:0] \__pi_i1__6 ,
  input  [  0:0] \__pi_q2__6 ,
  output [  0:0] \__po__247_
);
endmodule
