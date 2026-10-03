module miter (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__238_ ,
  input  [  0:0] \__pi__239_ ,
  input  [  0:0] \__pi__242_ ,
  input  [  0:0] \__pi__243_ ,
  input  [  0:0] \__pi_i1__11 ,
  input  [  0:0] \__pi_q2__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__244___gold ,
  output [  0:0] \__po__244___gate
);
  \gold.test1._244_ gold (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__238_ (\__pi__238_ ),
    .\__pi__239_ (\__pi__239_ ),
    .\__pi__242_ (\__pi__242_ ),
    .\__pi__243_ (\__pi__243_ ),
    .\__pi_i1__11 (\__pi_i1__11 ),
    .\__pi_q2__11 (\__pi_q2__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__244_ (\__po__244___gold )
  );
  \gate.test1._244_ gate (
    .\__pi__010_ (\__pi__010_ ),
    .\__pi__011_ (\__pi__011_ ),
    .\__pi__238_ (\__pi__238_ ),
    .\__pi__239_ (\__pi__239_ ),
    .\__pi__242_ (\__pi__242_ ),
    .\__pi__243_ (\__pi__243_ ),
    .\__pi_i1__11 (\__pi_i1__11 ),
    .\__pi_q2__11 (\__pi_q2__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__244_ (\__po__244___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__010___assume (\__pi__010_ );
  miter_def_prop #(1, "assume") \__pi__011___assume (\__pi__011_ );
  miter_def_prop #(1, "assume") \__pi__238___assume (\__pi__238_ );
  miter_def_prop #(1, "assume") \__pi__239___assume (\__pi__239_ );
  miter_def_prop #(1, "assume") \__pi__242___assume (\__pi__242_ );
  miter_def_prop #(1, "assume") \__pi__243___assume (\__pi__243_ );
  miter_def_prop #(1, "assume") \__pi_i1__11__assume (\__pi_i1__11 );
  miter_def_prop #(1, "assume") \__pi_q2__11__assume (\__pi_q2__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__244___assert (\__po__244___gold , \__po__244___gate );
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
  miter_def_prop #(1, "cover") \__po__244___gold_cover (\__po__244___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__244___gate_cover (\__po__244___gate );
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
module \gold.test1._244_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__238_ ,
  input  [  0:0] \__pi__239_ ,
  input  [  0:0] \__pi__242_ ,
  input  [  0:0] \__pi__243_ ,
  input  [  0:0] \__pi_i1__11 ,
  input  [  0:0] \__pi_q2__11 ,
  output [  0:0] \__po__244_
);
endmodule
module \gate.test1._244_ (
  input  [  0:0] \__pi__010_ ,
  input  [  0:0] \__pi__011_ ,
  input  [  0:0] \__pi__238_ ,
  input  [  0:0] \__pi__239_ ,
  input  [  0:0] \__pi__242_ ,
  input  [  0:0] \__pi__243_ ,
  input  [  0:0] \__pi_i1__11 ,
  input  [  0:0] \__pi_q2__11 ,
  output [  0:0] \__po__244_
);
endmodule
