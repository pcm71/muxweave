module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__142_ ,
  input  [  0:0] \__pi__143_ ,
  input  [  0:0] \__pi__144_ ,
  input  [  0:0] \__pi__145_ ,
  input  [  0:0] \__pi_i6__1 ,
  input  [  0:0] \__pi_q5__1 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__141___gold ,
  output [  0:0] \__po__141___gate
);
  \gold.test1._141_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__142_ (\__pi__142_ ),
    .\__pi__143_ (\__pi__143_ ),
    .\__pi__144_ (\__pi__144_ ),
    .\__pi__145_ (\__pi__145_ ),
    .\__pi_i6__1 (\__pi_i6__1 ),
    .\__pi_q5__1 (\__pi_q5__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__141_ (\__po__141___gold )
  );
  \gate.test1._141_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__142_ (\__pi__142_ ),
    .\__pi__143_ (\__pi__143_ ),
    .\__pi__144_ (\__pi__144_ ),
    .\__pi__145_ (\__pi__145_ ),
    .\__pi_i6__1 (\__pi_i6__1 ),
    .\__pi_q5__1 (\__pi_q5__1 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__141_ (\__po__141___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__142___assume (\__pi__142_ );
  miter_def_prop #(1, "assume") \__pi__143___assume (\__pi__143_ );
  miter_def_prop #(1, "assume") \__pi__144___assume (\__pi__144_ );
  miter_def_prop #(1, "assume") \__pi__145___assume (\__pi__145_ );
  miter_def_prop #(1, "assume") \__pi_i6__1__assume (\__pi_i6__1 );
  miter_def_prop #(1, "assume") \__pi_q5__1__assume (\__pi_q5__1 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__141___assert (\__po__141___gold , \__po__141___gate );
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
  miter_def_prop #(1, "cover") \__po__141___gold_cover (\__po__141___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__141___gate_cover (\__po__141___gate );
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
module \gold.test1._141_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__142_ ,
  input  [  0:0] \__pi__143_ ,
  input  [  0:0] \__pi__144_ ,
  input  [  0:0] \__pi__145_ ,
  input  [  0:0] \__pi_i6__1 ,
  input  [  0:0] \__pi_q5__1 ,
  output [  0:0] \__po__141_
);
endmodule
module \gate.test1._141_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__142_ ,
  input  [  0:0] \__pi__143_ ,
  input  [  0:0] \__pi__144_ ,
  input  [  0:0] \__pi__145_ ,
  input  [  0:0] \__pi_i6__1 ,
  input  [  0:0] \__pi_q5__1 ,
  output [  0:0] \__po__141_
);
endmodule
