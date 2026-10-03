module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__182_ ,
  input  [  0:0] \__pi__183_ ,
  input  [  0:0] \__pi__184_ ,
  input  [  0:0] \__pi__185_ ,
  input  [  0:0] \__pi_i5__3 ,
  input  [  0:0] \__pi_q6__3 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__181___gold ,
  output [  0:0] \__po__181___gate
);
  \gold.test1._181_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__182_ (\__pi__182_ ),
    .\__pi__183_ (\__pi__183_ ),
    .\__pi__184_ (\__pi__184_ ),
    .\__pi__185_ (\__pi__185_ ),
    .\__pi_i5__3 (\__pi_i5__3 ),
    .\__pi_q6__3 (\__pi_q6__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__181_ (\__po__181___gold )
  );
  \gate.test1._181_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__182_ (\__pi__182_ ),
    .\__pi__183_ (\__pi__183_ ),
    .\__pi__184_ (\__pi__184_ ),
    .\__pi__185_ (\__pi__185_ ),
    .\__pi_i5__3 (\__pi_i5__3 ),
    .\__pi_q6__3 (\__pi_q6__3 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__181_ (\__po__181___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__182___assume (\__pi__182_ );
  miter_def_prop #(1, "assume") \__pi__183___assume (\__pi__183_ );
  miter_def_prop #(1, "assume") \__pi__184___assume (\__pi__184_ );
  miter_def_prop #(1, "assume") \__pi__185___assume (\__pi__185_ );
  miter_def_prop #(1, "assume") \__pi_i5__3__assume (\__pi_i5__3 );
  miter_def_prop #(1, "assume") \__pi_q6__3__assume (\__pi_q6__3 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__181___assert (\__po__181___gold , \__po__181___gate );
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
  miter_def_prop #(1, "cover") \__po__181___gold_cover (\__po__181___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__181___gate_cover (\__po__181___gate );
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
module \gold.test1._181_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__182_ ,
  input  [  0:0] \__pi__183_ ,
  input  [  0:0] \__pi__184_ ,
  input  [  0:0] \__pi__185_ ,
  input  [  0:0] \__pi_i5__3 ,
  input  [  0:0] \__pi_q6__3 ,
  output [  0:0] \__po__181_
);
endmodule
module \gate.test1._181_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__182_ ,
  input  [  0:0] \__pi__183_ ,
  input  [  0:0] \__pi__184_ ,
  input  [  0:0] \__pi__185_ ,
  input  [  0:0] \__pi_i5__3 ,
  input  [  0:0] \__pi_q6__3 ,
  output [  0:0] \__po__181_
);
endmodule
