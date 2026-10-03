module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__212_ ,
  input  [  0:0] \__pi__213_ ,
  input  [  0:0] \__pi__214_ ,
  input  [  0:0] \__pi__215_ ,
  input  [  0:0] \__pi_i6__4 ,
  input  [  0:0] \__pi_q5__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__211___gold ,
  output [  0:0] \__po__211___gate
);
  \gold.test1._211_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__212_ (\__pi__212_ ),
    .\__pi__213_ (\__pi__213_ ),
    .\__pi__214_ (\__pi__214_ ),
    .\__pi__215_ (\__pi__215_ ),
    .\__pi_i6__4 (\__pi_i6__4 ),
    .\__pi_q5__4 (\__pi_q5__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__211_ (\__po__211___gold )
  );
  \gate.test1._211_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__212_ (\__pi__212_ ),
    .\__pi__213_ (\__pi__213_ ),
    .\__pi__214_ (\__pi__214_ ),
    .\__pi__215_ (\__pi__215_ ),
    .\__pi_i6__4 (\__pi_i6__4 ),
    .\__pi_q5__4 (\__pi_q5__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__211_ (\__po__211___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__212___assume (\__pi__212_ );
  miter_def_prop #(1, "assume") \__pi__213___assume (\__pi__213_ );
  miter_def_prop #(1, "assume") \__pi__214___assume (\__pi__214_ );
  miter_def_prop #(1, "assume") \__pi__215___assume (\__pi__215_ );
  miter_def_prop #(1, "assume") \__pi_i6__4__assume (\__pi_i6__4 );
  miter_def_prop #(1, "assume") \__pi_q5__4__assume (\__pi_q5__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__211___assert (\__po__211___gold , \__po__211___gate );
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
  miter_def_prop #(1, "cover") \__po__211___gold_cover (\__po__211___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__211___gate_cover (\__po__211___gate );
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
module \gold.test1._211_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__212_ ,
  input  [  0:0] \__pi__213_ ,
  input  [  0:0] \__pi__214_ ,
  input  [  0:0] \__pi__215_ ,
  input  [  0:0] \__pi_i6__4 ,
  input  [  0:0] \__pi_q5__4 ,
  output [  0:0] \__po__211_
);
endmodule
module \gate.test1._211_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__212_ ,
  input  [  0:0] \__pi__213_ ,
  input  [  0:0] \__pi__214_ ,
  input  [  0:0] \__pi__215_ ,
  input  [  0:0] \__pi_i6__4 ,
  input  [  0:0] \__pi_q5__4 ,
  output [  0:0] \__po__211_
);
endmodule
