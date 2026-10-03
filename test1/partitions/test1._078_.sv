module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__072_ ,
  input  [  0:0] \__pi__073_ ,
  input  [  0:0] \__pi__076_ ,
  input  [  0:0] \__pi__077_ ,
  input  [  0:0] \__pi_i4__2 ,
  input  [  0:0] \__pi_q3__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__078___gold ,
  output [  0:0] \__po__078___gate
);
  \gold.test1._078_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__072_ (\__pi__072_ ),
    .\__pi__073_ (\__pi__073_ ),
    .\__pi__076_ (\__pi__076_ ),
    .\__pi__077_ (\__pi__077_ ),
    .\__pi_i4__2 (\__pi_i4__2 ),
    .\__pi_q3__2 (\__pi_q3__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__078_ (\__po__078___gold )
  );
  \gate.test1._078_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__072_ (\__pi__072_ ),
    .\__pi__073_ (\__pi__073_ ),
    .\__pi__076_ (\__pi__076_ ),
    .\__pi__077_ (\__pi__077_ ),
    .\__pi_i4__2 (\__pi_i4__2 ),
    .\__pi_q3__2 (\__pi_q3__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__078_ (\__po__078___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__072___assume (\__pi__072_ );
  miter_def_prop #(1, "assume") \__pi__073___assume (\__pi__073_ );
  miter_def_prop #(1, "assume") \__pi__076___assume (\__pi__076_ );
  miter_def_prop #(1, "assume") \__pi__077___assume (\__pi__077_ );
  miter_def_prop #(1, "assume") \__pi_i4__2__assume (\__pi_i4__2 );
  miter_def_prop #(1, "assume") \__pi_q3__2__assume (\__pi_q3__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__078___assert (\__po__078___gold , \__po__078___gate );
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
  miter_def_prop #(1, "cover") \__po__078___gold_cover (\__po__078___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__078___gate_cover (\__po__078___gate );
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
module \gold.test1._078_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__072_ ,
  input  [  0:0] \__pi__073_ ,
  input  [  0:0] \__pi__076_ ,
  input  [  0:0] \__pi__077_ ,
  input  [  0:0] \__pi_i4__2 ,
  input  [  0:0] \__pi_q3__2 ,
  output [  0:0] \__po__078_
);
endmodule
module \gate.test1._078_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__072_ ,
  input  [  0:0] \__pi__073_ ,
  input  [  0:0] \__pi__076_ ,
  input  [  0:0] \__pi__077_ ,
  input  [  0:0] \__pi_i4__2 ,
  input  [  0:0] \__pi_q3__2 ,
  output [  0:0] \__po__078_
);
endmodule
