module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__178_ ,
  input  [  0:0] \__pi__179_ ,
  input  [  0:0] \__pi__182_ ,
  input  [  0:0] \__pi__183_ ,
  input  [  0:0] \__pi_i4__2 ,
  input  [  0:0] \__pi_q5__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__184___gold ,
  output [  0:0] \__po__184___gate
);
  \gold.test1._184_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__178_ (\__pi__178_ ),
    .\__pi__179_ (\__pi__179_ ),
    .\__pi__182_ (\__pi__182_ ),
    .\__pi__183_ (\__pi__183_ ),
    .\__pi_i4__2 (\__pi_i4__2 ),
    .\__pi_q5__2 (\__pi_q5__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__184_ (\__po__184___gold )
  );
  \gate.test1._184_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__178_ (\__pi__178_ ),
    .\__pi__179_ (\__pi__179_ ),
    .\__pi__182_ (\__pi__182_ ),
    .\__pi__183_ (\__pi__183_ ),
    .\__pi_i4__2 (\__pi_i4__2 ),
    .\__pi_q5__2 (\__pi_q5__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__184_ (\__po__184___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__178___assume (\__pi__178_ );
  miter_def_prop #(1, "assume") \__pi__179___assume (\__pi__179_ );
  miter_def_prop #(1, "assume") \__pi__182___assume (\__pi__182_ );
  miter_def_prop #(1, "assume") \__pi__183___assume (\__pi__183_ );
  miter_def_prop #(1, "assume") \__pi_i4__2__assume (\__pi_i4__2 );
  miter_def_prop #(1, "assume") \__pi_q5__2__assume (\__pi_q5__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__184___assert (\__po__184___gold , \__po__184___gate );
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
  miter_def_prop #(1, "cover") \__po__184___gold_cover (\__po__184___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__184___gate_cover (\__po__184___gate );
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
module \gold.test1._184_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__178_ ,
  input  [  0:0] \__pi__179_ ,
  input  [  0:0] \__pi__182_ ,
  input  [  0:0] \__pi__183_ ,
  input  [  0:0] \__pi_i4__2 ,
  input  [  0:0] \__pi_q5__2 ,
  output [  0:0] \__po__184_
);
endmodule
module \gate.test1._184_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__178_ ,
  input  [  0:0] \__pi__179_ ,
  input  [  0:0] \__pi__182_ ,
  input  [  0:0] \__pi__183_ ,
  input  [  0:0] \__pi_i4__2 ,
  input  [  0:0] \__pi_q5__2 ,
  output [  0:0] \__po__184_
);
endmodule
