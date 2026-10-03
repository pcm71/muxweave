module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__192_ ,
  input  [  0:0] \__pi__193_ ,
  input  [  0:0] \__pi__194_ ,
  input  [  0:0] \__pi__195_ ,
  input  [  0:0] \__pi_i6__3 ,
  input  [  0:0] \__pi_q5__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__191___gold ,
  output [  0:0] \__po__191___gate
);
  \gold.test1._191_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__192_ (\__pi__192_ ),
    .\__pi__193_ (\__pi__193_ ),
    .\__pi__194_ (\__pi__194_ ),
    .\__pi__195_ (\__pi__195_ ),
    .\__pi_i6__3 (\__pi_i6__3 ),
    .\__pi_q5__3 (\__pi_q5__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__191_ (\__po__191___gold )
  );
  \gate.test1._191_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__192_ (\__pi__192_ ),
    .\__pi__193_ (\__pi__193_ ),
    .\__pi__194_ (\__pi__194_ ),
    .\__pi__195_ (\__pi__195_ ),
    .\__pi_i6__3 (\__pi_i6__3 ),
    .\__pi_q5__3 (\__pi_q5__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__191_ (\__po__191___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__192___assume (\__pi__192_ );
  miter_def_prop #(1, "assume") \__pi__193___assume (\__pi__193_ );
  miter_def_prop #(1, "assume") \__pi__194___assume (\__pi__194_ );
  miter_def_prop #(1, "assume") \__pi__195___assume (\__pi__195_ );
  miter_def_prop #(1, "assume") \__pi_i6__3__assume (\__pi_i6__3 );
  miter_def_prop #(1, "assume") \__pi_q5__3__assume (\__pi_q5__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__191___assert (\__po__191___gold , \__po__191___gate );
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
  miter_def_prop #(1, "cover") \__po__191___gold_cover (\__po__191___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__191___gate_cover (\__po__191___gate );
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
module \gold.test1._191_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__192_ ,
  input  [  0:0] \__pi__193_ ,
  input  [  0:0] \__pi__194_ ,
  input  [  0:0] \__pi__195_ ,
  input  [  0:0] \__pi_i6__3 ,
  input  [  0:0] \__pi_q5__3 ,
  output [  0:0] \__po__191_
);
endmodule
module \gate.test1._191_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__192_ ,
  input  [  0:0] \__pi__193_ ,
  input  [  0:0] \__pi__194_ ,
  input  [  0:0] \__pi__195_ ,
  input  [  0:0] \__pi_i6__3 ,
  input  [  0:0] \__pi_q5__3 ,
  output [  0:0] \__po__191_
);
endmodule
