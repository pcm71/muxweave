module miter (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__10 ,
  input  [  0:0] \__pi_i1__4 ,
  input  [  0:0] \__pi_q0__4 ,
  input  [  0:0] \__pi_q1__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__060___gold ,
  output [  0:0] \__po__060___gate
);
  \gold.test1._060_ gold (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__10 (\__pi_i0__10 ),
    .\__pi_i1__4 (\__pi_i1__4 ),
    .\__pi_q0__4 (\__pi_q0__4 ),
    .\__pi_q1__10 (\__pi_q1__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__060_ (\__po__060___gold )
  );
  \gate.test1._060_ gate (
    .\__pi__029_ (\__pi__029_ ),
    .\__pi__030_ (\__pi__030_ ),
    .\__pi__101_ (\__pi__101_ ),
    .\__pi__102_ (\__pi__102_ ),
    .\__pi_i0__10 (\__pi_i0__10 ),
    .\__pi_i1__4 (\__pi_i1__4 ),
    .\__pi_q0__4 (\__pi_q0__4 ),
    .\__pi_q1__10 (\__pi_q1__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__060_ (\__po__060___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__029___assume (\__pi__029_ );
  miter_def_prop #(1, "assume") \__pi__030___assume (\__pi__030_ );
  miter_def_prop #(1, "assume") \__pi__101___assume (\__pi__101_ );
  miter_def_prop #(1, "assume") \__pi__102___assume (\__pi__102_ );
  miter_def_prop #(1, "assume") \__pi_i0__10__assume (\__pi_i0__10 );
  miter_def_prop #(1, "assume") \__pi_i1__4__assume (\__pi_i1__4 );
  miter_def_prop #(1, "assume") \__pi_q0__4__assume (\__pi_q0__4 );
  miter_def_prop #(1, "assume") \__pi_q1__10__assume (\__pi_q1__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__060___assert (\__po__060___gold , \__po__060___gate );
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
  miter_def_prop #(1, "cover") \__po__060___gold_cover (\__po__060___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__060___gate_cover (\__po__060___gate );
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
module \gold.test1._060_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__10 ,
  input  [  0:0] \__pi_i1__4 ,
  input  [  0:0] \__pi_q0__4 ,
  input  [  0:0] \__pi_q1__10 ,
  output [  0:0] \__po__060_
);
endmodule
module \gate.test1._060_ (
  input  [  0:0] \__pi__029_ ,
  input  [  0:0] \__pi__030_ ,
  input  [  0:0] \__pi__101_ ,
  input  [  0:0] \__pi__102_ ,
  input  [  0:0] \__pi_i0__10 ,
  input  [  0:0] \__pi_i1__4 ,
  input  [  0:0] \__pi_q0__4 ,
  input  [  0:0] \__pi_q1__10 ,
  output [  0:0] \__po__060_
);
endmodule
