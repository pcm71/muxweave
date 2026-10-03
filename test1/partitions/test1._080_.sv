module miter (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__11 ,
  input  [  0:0] \__pi_i1__2 ,
  input  [  0:0] \__pi_q0__2 ,
  input  [  0:0] \__pi_q1__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__080___gold ,
  output [  0:0] \__po__080___gate
);
  \gold.test1._080_ gold (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__11 (\__pi_i0__11 ),
    .\__pi_i1__2 (\__pi_i1__2 ),
    .\__pi_q0__2 (\__pi_q0__2 ),
    .\__pi_q1__11 (\__pi_q1__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__080_ (\__po__080___gold )
  );
  \gate.test1._080_ gate (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__11 (\__pi_i0__11 ),
    .\__pi_i1__2 (\__pi_i1__2 ),
    .\__pi_q0__2 (\__pi_q0__2 ),
    .\__pi_q1__11 (\__pi_q1__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__080_ (\__po__080___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__029___assume (\__pi__029_ );
  miter_def_prop #(1, "assume") \__pi__030___assume (\__pi__030_ );
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi_i0__11__assume (\__pi_i0__11 );
  miter_def_prop #(1, "assume") \__pi_i1__2__assume (\__pi_i1__2 );
  miter_def_prop #(1, "assume") \__pi_q0__2__assume (\__pi_q0__2 );
  miter_def_prop #(1, "assume") \__pi_q1__11__assume (\__pi_q1__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__080___assert (\__po__080___gold , \__po__080___gate );
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
  miter_def_prop #(1, "cover") \__po__080___gold_cover (\__po__080___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__080___gate_cover (\__po__080___gate );
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
module \gold.test1._080_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__11 ,
  input  [  0:0] \__pi_i1__2 ,
  input  [  0:0] \__pi_q0__2 ,
  input  [  0:0] \__pi_q1__11 ,
  output [  0:0] \__po__080_
);
endmodule
module \gate.test1._080_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__11 ,
  input  [  0:0] \__pi_i1__2 ,
  input  [  0:0] \__pi_q0__2 ,
  input  [  0:0] \__pi_q1__11 ,
  output [  0:0] \__po__080_
);
endmodule
