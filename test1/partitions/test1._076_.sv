module miter (
  input  [  0:0] \__pi__077_ ,
  input  [  0:0] \__pi__078_ ,
  input  [  0:0] \__pi__079_ ,
  input  [  0:0] \__pi__080_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__10 ,
  input  [  0:0] \__pi_q6__10 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__076___gold ,
  output [  0:0] \__po__076___gate
);
  \gold.test1._076_ gold (
    .\__pi__077_ (\__pi__077_ ),
    .\__pi__078_ (\__pi__078_ ),
    .\__pi__079_ (\__pi__079_ ),
    .\__pi__080_ (\__pi__080_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__10 (\__pi_i7__10 ),
    .\__pi_q6__10 (\__pi_q6__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__076_ (\__po__076___gold )
  );
  \gate.test1._076_ gate (
    .\__pi__077_ (\__pi__077_ ),
    .\__pi__078_ (\__pi__078_ ),
    .\__pi__079_ (\__pi__079_ ),
    .\__pi__080_ (\__pi__080_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__10 (\__pi_i7__10 ),
    .\__pi_q6__10 (\__pi_q6__10 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__076_ (\__po__076___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__077___assume (\__pi__077_ );
  miter_def_prop #(1, "assume") \__pi__078___assume (\__pi__078_ );
  miter_def_prop #(1, "assume") \__pi__079___assume (\__pi__079_ );
  miter_def_prop #(1, "assume") \__pi__080___assume (\__pi__080_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi_i7__10__assume (\__pi_i7__10 );
  miter_def_prop #(1, "assume") \__pi_q6__10__assume (\__pi_q6__10 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__076___assert (\__po__076___gold , \__po__076___gate );
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
  miter_def_prop #(1, "cover") \__po__076___gold_cover (\__po__076___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__076___gate_cover (\__po__076___gate );
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
module \gold.test1._076_ (
  input  [  0:0] \__pi__077_ ,
  input  [  0:0] \__pi__078_ ,
  input  [  0:0] \__pi__079_ ,
  input  [  0:0] \__pi__080_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__10 ,
  input  [  0:0] \__pi_q6__10 ,
  output [  0:0] \__po__076_
);
endmodule
module \gate.test1._076_ (
  input  [  0:0] \__pi__077_ ,
  input  [  0:0] \__pi__078_ ,
  input  [  0:0] \__pi__079_ ,
  input  [  0:0] \__pi__080_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__10 ,
  input  [  0:0] \__pi_q6__10 ,
  output [  0:0] \__po__076_
);
endmodule
