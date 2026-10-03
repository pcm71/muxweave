module miter (
  input  [  0:0] \__pi__052_ ,
  input  [  0:0] \__pi__053_ ,
  input  [  0:0] \__pi__054_ ,
  input  [  0:0] \__pi__055_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_q1__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__051___gold ,
  output [  0:0] \__po__051___gate
);
  \gold.test1._051_ gold (
    .\__pi__052_ (\__pi__052_ ),
    .\__pi__053_ (\__pi__053_ ),
    .\__pi__054_ (\__pi__054_ ),
    .\__pi__055_ (\__pi__055_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__9 (\__pi_i2__9 ),
    .\__pi_q1__9 (\__pi_q1__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__051_ (\__po__051___gold )
  );
  \gate.test1._051_ gate (
    .\__pi__052_ (\__pi__052_ ),
    .\__pi__053_ (\__pi__053_ ),
    .\__pi__054_ (\__pi__054_ ),
    .\__pi__055_ (\__pi__055_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__9 (\__pi_i2__9 ),
    .\__pi_q1__9 (\__pi_q1__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__051_ (\__po__051___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__052___assume (\__pi__052_ );
  miter_def_prop #(1, "assume") \__pi__053___assume (\__pi__053_ );
  miter_def_prop #(1, "assume") \__pi__054___assume (\__pi__054_ );
  miter_def_prop #(1, "assume") \__pi__055___assume (\__pi__055_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i2__9__assume (\__pi_i2__9 );
  miter_def_prop #(1, "assume") \__pi_q1__9__assume (\__pi_q1__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__051___assert (\__po__051___gold , \__po__051___gate );
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
  miter_def_prop #(1, "cover") \__po__051___gold_cover (\__po__051___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__051___gate_cover (\__po__051___gate );
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
module \gold.test1._051_ (
  input  [  0:0] \__pi__052_ ,
  input  [  0:0] \__pi__053_ ,
  input  [  0:0] \__pi__054_ ,
  input  [  0:0] \__pi__055_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_q1__9 ,
  output [  0:0] \__po__051_
);
endmodule
module \gate.test1._051_ (
  input  [  0:0] \__pi__052_ ,
  input  [  0:0] \__pi__053_ ,
  input  [  0:0] \__pi__054_ ,
  input  [  0:0] \__pi__055_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__9 ,
  input  [  0:0] \__pi_q1__9 ,
  output [  0:0] \__po__051_
);
endmodule
