module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__206_ ,
  input  [  0:0] \__pi__207_ ,
  input  [  0:0] \__pi__210_ ,
  input  [  0:0] \__pi__211_ ,
  input  [  0:0] \__pi_i3__9 ,
  input  [  0:0] \__pi_q2__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__215___gold ,
  output [  0:0] \__po__215___gate
);
  \gold.test1._215_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__206_ (\__pi__206_ ),
    .\__pi__207_ (\__pi__207_ ),
    .\__pi__210_ (\__pi__210_ ),
    .\__pi__211_ (\__pi__211_ ),
    .\__pi_i3__9 (\__pi_i3__9 ),
    .\__pi_q2__9 (\__pi_q2__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__215_ (\__po__215___gold )
  );
  \gate.test1._215_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__206_ (\__pi__206_ ),
    .\__pi__207_ (\__pi__207_ ),
    .\__pi__210_ (\__pi__210_ ),
    .\__pi__211_ (\__pi__211_ ),
    .\__pi_i3__9 (\__pi_i3__9 ),
    .\__pi_q2__9 (\__pi_q2__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__215_ (\__po__215___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__206___assume (\__pi__206_ );
  miter_def_prop #(1, "assume") \__pi__207___assume (\__pi__207_ );
  miter_def_prop #(1, "assume") \__pi__210___assume (\__pi__210_ );
  miter_def_prop #(1, "assume") \__pi__211___assume (\__pi__211_ );
  miter_def_prop #(1, "assume") \__pi_i3__9__assume (\__pi_i3__9 );
  miter_def_prop #(1, "assume") \__pi_q2__9__assume (\__pi_q2__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__215___assert (\__po__215___gold , \__po__215___gate );
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
  miter_def_prop #(1, "cover") \__po__215___gold_cover (\__po__215___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__215___gate_cover (\__po__215___gate );
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
module \gold.test1._215_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__206_ ,
  input  [  0:0] \__pi__207_ ,
  input  [  0:0] \__pi__210_ ,
  input  [  0:0] \__pi__211_ ,
  input  [  0:0] \__pi_i3__9 ,
  input  [  0:0] \__pi_q2__9 ,
  output [  0:0] \__po__215_
);
endmodule
module \gate.test1._215_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__206_ ,
  input  [  0:0] \__pi__207_ ,
  input  [  0:0] \__pi__210_ ,
  input  [  0:0] \__pi__211_ ,
  input  [  0:0] \__pi_i3__9 ,
  input  [  0:0] \__pi_q2__9 ,
  output [  0:0] \__po__215_
);
endmodule
