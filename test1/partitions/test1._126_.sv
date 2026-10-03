module miter (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__127_ ,
  input  [  0:0] \__pi__128_ ,
  input  [  0:0] \__pi__129_ ,
  input  [  0:0] \__pi__130_ ,
  input  [  0:0] \__pi_i1__0 ,
  input  [  0:0] \__pi_q0__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__126___gold ,
  output [  0:0] \__po__126___gate
);
  \gold.test1._126_ gold (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__127_ (\__pi__127_ ),
    .\__pi__128_ (\__pi__128_ ),
    .\__pi__129_ (\__pi__129_ ),
    .\__pi__130_ (\__pi__130_ ),
    .\__pi_i1__0 (\__pi_i1__0 ),
    .\__pi_q0__0 (\__pi_q0__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__126_ (\__po__126___gold )
  );
  \gate.test1._126_ gate (
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi__127_ (\__pi__127_ ),
    .\__pi__128_ (\__pi__128_ ),
    .\__pi__129_ (\__pi__129_ ),
    .\__pi__130_ (\__pi__130_ ),
    .\__pi_i1__0 (\__pi_i1__0 ),
    .\__pi_q0__0 (\__pi_q0__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__126_ (\__po__126___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi__127___assume (\__pi__127_ );
  miter_def_prop #(1, "assume") \__pi__128___assume (\__pi__128_ );
  miter_def_prop #(1, "assume") \__pi__129___assume (\__pi__129_ );
  miter_def_prop #(1, "assume") \__pi__130___assume (\__pi__130_ );
  miter_def_prop #(1, "assume") \__pi_i1__0__assume (\__pi_i1__0 );
  miter_def_prop #(1, "assume") \__pi_q0__0__assume (\__pi_q0__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__126___assert (\__po__126___gold , \__po__126___gate );
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
  miter_def_prop #(1, "cover") \__po__126___gold_cover (\__po__126___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__126___gate_cover (\__po__126___gate );
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
module \gold.test1._126_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__127_ ,
  input  [  0:0] \__pi__128_ ,
  input  [  0:0] \__pi__129_ ,
  input  [  0:0] \__pi__130_ ,
  input  [  0:0] \__pi_i1__0 ,
  input  [  0:0] \__pi_q0__0 ,
  output [  0:0] \__po__126_
);
endmodule
module \gate.test1._126_ (
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi__127_ ,
  input  [  0:0] \__pi__128_ ,
  input  [  0:0] \__pi__129_ ,
  input  [  0:0] \__pi__130_ ,
  input  [  0:0] \__pi_i1__0 ,
  input  [  0:0] \__pi_q0__0 ,
  output [  0:0] \__po__126_
);
endmodule
