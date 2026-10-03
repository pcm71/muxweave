module miter (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__132_ ,
  input  [  0:0] \__pi__133_ ,
  input  [  0:0] \__pi__134_ ,
  input  [  0:0] \__pi__135_ ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q5__0 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__131___gold ,
  output [  0:0] \__po__131___gate
);
  \gold.test1._131_ gold (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__132_ (\__pi__132_ ),
    .\__pi__133_ (\__pi__133_ ),
    .\__pi__134_ (\__pi__134_ ),
    .\__pi__135_ (\__pi__135_ ),
    .\__pi_i6__0 (\__pi_i6__0 ),
    .\__pi_q5__0 (\__pi_q5__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__131_ (\__po__131___gold )
  );
  \gate.test1._131_ gate (
    .\__pi__116_ (\__pi__116_ ),
    .\__pi__117_ (\__pi__117_ ),
    .\__pi__132_ (\__pi__132_ ),
    .\__pi__133_ (\__pi__133_ ),
    .\__pi__134_ (\__pi__134_ ),
    .\__pi__135_ (\__pi__135_ ),
    .\__pi_i6__0 (\__pi_i6__0 ),
    .\__pi_q5__0 (\__pi_q5__0 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__131_ (\__po__131___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__116___assume (\__pi__116_ );
  miter_def_prop #(1, "assume") \__pi__117___assume (\__pi__117_ );
  miter_def_prop #(1, "assume") \__pi__132___assume (\__pi__132_ );
  miter_def_prop #(1, "assume") \__pi__133___assume (\__pi__133_ );
  miter_def_prop #(1, "assume") \__pi__134___assume (\__pi__134_ );
  miter_def_prop #(1, "assume") \__pi__135___assume (\__pi__135_ );
  miter_def_prop #(1, "assume") \__pi_i6__0__assume (\__pi_i6__0 );
  miter_def_prop #(1, "assume") \__pi_q5__0__assume (\__pi_q5__0 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__131___assert (\__po__131___gold , \__po__131___gate );
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
  miter_def_prop #(1, "cover") \__po__131___gold_cover (\__po__131___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__131___gate_cover (\__po__131___gate );
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
module \gold.test1._131_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__132_ ,
  input  [  0:0] \__pi__133_ ,
  input  [  0:0] \__pi__134_ ,
  input  [  0:0] \__pi__135_ ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q5__0 ,
  output [  0:0] \__po__131_
);
endmodule
module \gate.test1._131_ (
  input  [  0:0] \__pi__116_ ,
  input  [  0:0] \__pi__117_ ,
  input  [  0:0] \__pi__132_ ,
  input  [  0:0] \__pi__133_ ,
  input  [  0:0] \__pi__134_ ,
  input  [  0:0] \__pi__135_ ,
  input  [  0:0] \__pi_i6__0 ,
  input  [  0:0] \__pi_q5__0 ,
  output [  0:0] \__po__131_
);
endmodule
