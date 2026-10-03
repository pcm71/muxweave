module miter (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__082_ ,
  input  [  0:0] \__pi__083_ ,
  input  [  0:0] \__pi__086_ ,
  input  [  0:0] \__pi__087_ ,
  input  [  0:0] \__pi_i4__1 ,
  input  [  0:0] \__pi_q3__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__088___gold ,
  output [  0:0] \__po__088___gate
);
  \gold.test1._088_ gold (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__082_ (\__pi__082_ ),
    .\__pi__083_ (\__pi__083_ ),
    .\__pi__086_ (\__pi__086_ ),
    .\__pi__087_ (\__pi__087_ ),
    .\__pi_i4__1 (\__pi_i4__1 ),
    .\__pi_q3__1 (\__pi_q3__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__088_ (\__po__088___gold )
  );
  \gate.test1._088_ gate (
    .\__pi__023_ (\__pi__023_ ),
    .\__pi__024_ (\__pi__024_ ),
    .\__pi__082_ (\__pi__082_ ),
    .\__pi__083_ (\__pi__083_ ),
    .\__pi__086_ (\__pi__086_ ),
    .\__pi__087_ (\__pi__087_ ),
    .\__pi_i4__1 (\__pi_i4__1 ),
    .\__pi_q3__1 (\__pi_q3__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__088_ (\__po__088___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__023___assume (\__pi__023_ );
  miter_def_prop #(1, "assume") \__pi__024___assume (\__pi__024_ );
  miter_def_prop #(1, "assume") \__pi__082___assume (\__pi__082_ );
  miter_def_prop #(1, "assume") \__pi__083___assume (\__pi__083_ );
  miter_def_prop #(1, "assume") \__pi__086___assume (\__pi__086_ );
  miter_def_prop #(1, "assume") \__pi__087___assume (\__pi__087_ );
  miter_def_prop #(1, "assume") \__pi_i4__1__assume (\__pi_i4__1 );
  miter_def_prop #(1, "assume") \__pi_q3__1__assume (\__pi_q3__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__088___assert (\__po__088___gold , \__po__088___gate );
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
  miter_def_prop #(1, "cover") \__po__088___gold_cover (\__po__088___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__088___gate_cover (\__po__088___gate );
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
module \gold.test1._088_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__082_ ,
  input  [  0:0] \__pi__083_ ,
  input  [  0:0] \__pi__086_ ,
  input  [  0:0] \__pi__087_ ,
  input  [  0:0] \__pi_i4__1 ,
  input  [  0:0] \__pi_q3__1 ,
  output [  0:0] \__po__088_
);
endmodule
module \gate.test1._088_ (
  input  [  0:0] \__pi__023_ ,
  input  [  0:0] \__pi__024_ ,
  input  [  0:0] \__pi__082_ ,
  input  [  0:0] \__pi__083_ ,
  input  [  0:0] \__pi__086_ ,
  input  [  0:0] \__pi__087_ ,
  input  [  0:0] \__pi_i4__1 ,
  input  [  0:0] \__pi_q3__1 ,
  output [  0:0] \__po__088_
);
endmodule
