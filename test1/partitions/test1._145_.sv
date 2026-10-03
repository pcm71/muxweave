module miter (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__136_ ,
  input  [  0:0] \__pi__137_ ,
  input  [  0:0] \__pi__140_ ,
  input  [  0:0] \__pi__141_ ,
  input  [  0:0] \__pi_i2__6 ,
  input  [  0:0] \__pi_q3__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__145___gold ,
  output [  0:0] \__po__145___gate
);
  \gold.test1._145_ gold (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__136_ (\__pi__136_ ),
    .\__pi__137_ (\__pi__137_ ),
    .\__pi__140_ (\__pi__140_ ),
    .\__pi__141_ (\__pi__141_ ),
    .\__pi_i2__6 (\__pi_i2__6 ),
    .\__pi_q3__6 (\__pi_q3__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__145_ (\__po__145___gold )
  );
  \gate.test1._145_ gate (
    .\__pi__016_ (\__pi__016_ ),
    .\__pi__017_ (\__pi__017_ ),
    .\__pi__136_ (\__pi__136_ ),
    .\__pi__137_ (\__pi__137_ ),
    .\__pi__140_ (\__pi__140_ ),
    .\__pi__141_ (\__pi__141_ ),
    .\__pi_i2__6 (\__pi_i2__6 ),
    .\__pi_q3__6 (\__pi_q3__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__145_ (\__po__145___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__016___assume (\__pi__016_ );
  miter_def_prop #(1, "assume") \__pi__017___assume (\__pi__017_ );
  miter_def_prop #(1, "assume") \__pi__136___assume (\__pi__136_ );
  miter_def_prop #(1, "assume") \__pi__137___assume (\__pi__137_ );
  miter_def_prop #(1, "assume") \__pi__140___assume (\__pi__140_ );
  miter_def_prop #(1, "assume") \__pi__141___assume (\__pi__141_ );
  miter_def_prop #(1, "assume") \__pi_i2__6__assume (\__pi_i2__6 );
  miter_def_prop #(1, "assume") \__pi_q3__6__assume (\__pi_q3__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__145___assert (\__po__145___gold , \__po__145___gate );
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
  miter_def_prop #(1, "cover") \__po__145___gold_cover (\__po__145___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__145___gate_cover (\__po__145___gate );
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
module \gold.test1._145_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__136_ ,
  input  [  0:0] \__pi__137_ ,
  input  [  0:0] \__pi__140_ ,
  input  [  0:0] \__pi__141_ ,
  input  [  0:0] \__pi_i2__6 ,
  input  [  0:0] \__pi_q3__6 ,
  output [  0:0] \__po__145_
);
endmodule
module \gate.test1._145_ (
  input  [  0:0] \__pi__016_ ,
  input  [  0:0] \__pi__017_ ,
  input  [  0:0] \__pi__136_ ,
  input  [  0:0] \__pi__137_ ,
  input  [  0:0] \__pi__140_ ,
  input  [  0:0] \__pi__141_ ,
  input  [  0:0] \__pi_i2__6 ,
  input  [  0:0] \__pi_q3__6 ,
  output [  0:0] \__po__145_
);
endmodule
