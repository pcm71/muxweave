module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__113_ ,
  input  [  0:0] \__pi__114_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q3__9 ,
  input  [  0:0] \__pi_q5__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__115___gold ,
  output [  0:0] \__po__115___gate
);
  \gold.test1._115_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__113_ (\__pi__113_ ),
    .\__pi__114_ (\__pi__114_ ),
    .\__pi_i2__9 (\__pi_i2__9 ),
    .\__pi_i4__0 (\__pi_i4__0 ),
    .\__pi_q3__9 (\__pi_q3__9 ),
    .\__pi_q5__0 (\__pi_q5__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__115_ (\__po__115___gold )
  );
  \gate.test1._115_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__113_ (\__pi__113_ ),
    .\__pi__114_ (\__pi__114_ ),
    .\__pi_i2__9 (\__pi_i2__9 ),
    .\__pi_i4__0 (\__pi_i4__0 ),
    .\__pi_q3__9 (\__pi_q3__9 ),
    .\__pi_q5__0 (\__pi_q5__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__115_ (\__po__115___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__113___assume (\__pi__113_ );
  miter_def_prop #(1, "assume") \__pi__114___assume (\__pi__114_ );
  miter_def_prop #(1, "assume") \__pi_i2__9__assume (\__pi_i2__9 );
  miter_def_prop #(1, "assume") \__pi_i4__0__assume (\__pi_i4__0 );
  miter_def_prop #(1, "assume") \__pi_q3__9__assume (\__pi_q3__9 );
  miter_def_prop #(1, "assume") \__pi_q5__0__assume (\__pi_q5__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__115___assert (\__po__115___gold , \__po__115___gate );
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
  miter_def_prop #(1, "cover") \__po__115___gold_cover (\__po__115___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__115___gate_cover (\__po__115___gate );
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
module \gold.test1._115_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__113_ ,
  input  [  0:0] \__pi__114_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q3__9 ,
  input  [  0:0] \__pi_q5__0 ,
  output [  0:0] \__po__115_
);
endmodule
module \gate.test1._115_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__113_ ,
  input  [  0:0] \__pi__114_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_i4__0 ,
  input  [  0:0] \__pi_q3__9 ,
  input  [  0:0] \__pi_q5__0 ,
  output [  0:0] \__po__115_
);
endmodule
