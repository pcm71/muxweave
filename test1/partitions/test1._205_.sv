module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__196_ ,
  input  [  0:0] \__pi__197_ ,
  input  [  0:0] \__pi__200_ ,
  input  [  0:0] \__pi__201_ ,
  input  [  0:0] \__pi_i2__0 ,
  input  [  0:0] \__pi_q3__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__205___gold ,
  output [  0:0] \__po__205___gate
);
  \gold.test1._205_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__196_ (\__pi__196_ ),
    .\__pi__197_ (\__pi__197_ ),
    .\__pi__200_ (\__pi__200_ ),
    .\__pi__201_ (\__pi__201_ ),
    .\__pi_i2__0 (\__pi_i2__0 ),
    .\__pi_q3__0 (\__pi_q3__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__205_ (\__po__205___gold )
  );
  \gate.test1._205_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__196_ (\__pi__196_ ),
    .\__pi__197_ (\__pi__197_ ),
    .\__pi__200_ (\__pi__200_ ),
    .\__pi__201_ (\__pi__201_ ),
    .\__pi_i2__0 (\__pi_i2__0 ),
    .\__pi_q3__0 (\__pi_q3__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__205_ (\__po__205___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__196___assume (\__pi__196_ );
  miter_def_prop #(1, "assume") \__pi__197___assume (\__pi__197_ );
  miter_def_prop #(1, "assume") \__pi__200___assume (\__pi__200_ );
  miter_def_prop #(1, "assume") \__pi__201___assume (\__pi__201_ );
  miter_def_prop #(1, "assume") \__pi_i2__0__assume (\__pi_i2__0 );
  miter_def_prop #(1, "assume") \__pi_q3__0__assume (\__pi_q3__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__205___assert (\__po__205___gold , \__po__205___gate );
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
  miter_def_prop #(1, "cover") \__po__205___gold_cover (\__po__205___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__205___gate_cover (\__po__205___gate );
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
module \gold.test1._205_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__196_ ,
  input  [  0:0] \__pi__197_ ,
  input  [  0:0] \__pi__200_ ,
  input  [  0:0] \__pi__201_ ,
  input  [  0:0] \__pi_i2__0 ,
  input  [  0:0] \__pi_q3__0 ,
  output [  0:0] \__po__205_
);
endmodule
module \gate.test1._205_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__196_ ,
  input  [  0:0] \__pi__197_ ,
  input  [  0:0] \__pi__200_ ,
  input  [  0:0] \__pi__201_ ,
  input  [  0:0] \__pi_i2__0 ,
  input  [  0:0] \__pi_q3__0 ,
  output [  0:0] \__po__205_
);
endmodule
