module miter (
  input  [  0:0] \__pi__092_ ,
  input  [  0:0] \__pi__093_ ,
  input  [  0:0] \__pi__094_ ,
  input  [  0:0] \__pi__095_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__11 ,
  input  [  0:0] \__pi_q1__11 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__091___gold ,
  output [  0:0] \__po__091___gate
);
  \gold.test1._091_ gold (
    .\__pi__092_ (\__pi__092_ ),
    .\__pi__093_ (\__pi__093_ ),
    .\__pi__094_ (\__pi__094_ ),
    .\__pi__095_ (\__pi__095_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__11 (\__pi_i2__11 ),
    .\__pi_q1__11 (\__pi_q1__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__091_ (\__po__091___gold )
  );
  \gate.test1._091_ gate (
    .\__pi__092_ (\__pi__092_ ),
    .\__pi__093_ (\__pi__093_ ),
    .\__pi__094_ (\__pi__094_ ),
    .\__pi__095_ (\__pi__095_ ),
    .\__pi__104_ (\__pi__104_ ),
    .\__pi__105_ (\__pi__105_ ),
    .\__pi_i2__11 (\__pi_i2__11 ),
    .\__pi_q1__11 (\__pi_q1__11 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__091_ (\__po__091___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__092___assume (\__pi__092_ );
  miter_def_prop #(1, "assume") \__pi__093___assume (\__pi__093_ );
  miter_def_prop #(1, "assume") \__pi__094___assume (\__pi__094_ );
  miter_def_prop #(1, "assume") \__pi__095___assume (\__pi__095_ );
  miter_def_prop #(1, "assume") \__pi__104___assume (\__pi__104_ );
  miter_def_prop #(1, "assume") \__pi__105___assume (\__pi__105_ );
  miter_def_prop #(1, "assume") \__pi_i2__11__assume (\__pi_i2__11 );
  miter_def_prop #(1, "assume") \__pi_q1__11__assume (\__pi_q1__11 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__091___assert (\__po__091___gold , \__po__091___gate );
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
  miter_def_prop #(1, "cover") \__po__091___gold_cover (\__po__091___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__091___gate_cover (\__po__091___gate );
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
module \gold.test1._091_ (
  input  [  0:0] \__pi__092_ ,
  input  [  0:0] \__pi__093_ ,
  input  [  0:0] \__pi__094_ ,
  input  [  0:0] \__pi__095_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__11 ,
  input  [  0:0] \__pi_q1__11 ,
  output [  0:0] \__po__091_
);
endmodule
module \gate.test1._091_ (
  input  [  0:0] \__pi__092_ ,
  input  [  0:0] \__pi__093_ ,
  input  [  0:0] \__pi__094_ ,
  input  [  0:0] \__pi__095_ ,
  input  [  0:0] \__pi__104_ ,
  input  [  0:0] \__pi__105_ ,
  input  [  0:0] \__pi_i2__11 ,
  input  [  0:0] \__pi_q1__11 ,
  output [  0:0] \__po__091_
);
endmodule
