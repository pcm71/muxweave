module miter (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__138_ ,
  input  [  0:0] \__pi__139_ ,
  input  [  0:0] \__pi__142_ ,
  input  [  0:0] \__pi__143_ ,
  input  [  0:0] \__pi_i4__6 ,
  input  [  0:0] \__pi_q5__6 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__144___gold ,
  output [  0:0] \__po__144___gate
);
  \gold.test1._144_ gold (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__138_ (\__pi__138_ ),
    .\__pi__139_ (\__pi__139_ ),
    .\__pi__142_ (\__pi__142_ ),
    .\__pi__143_ (\__pi__143_ ),
    .\__pi_i4__6 (\__pi_i4__6 ),
    .\__pi_q5__6 (\__pi_q5__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__144_ (\__po__144___gold )
  );
  \gate.test1._144_ gate (
    .\__pi__013_ (\__pi__013_ ),
    .\__pi__014_ (\__pi__014_ ),
    .\__pi__138_ (\__pi__138_ ),
    .\__pi__139_ (\__pi__139_ ),
    .\__pi__142_ (\__pi__142_ ),
    .\__pi__143_ (\__pi__143_ ),
    .\__pi_i4__6 (\__pi_i4__6 ),
    .\__pi_q5__6 (\__pi_q5__6 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__144_ (\__po__144___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__013___assume (\__pi__013_ );
  miter_def_prop #(1, "assume") \__pi__014___assume (\__pi__014_ );
  miter_def_prop #(1, "assume") \__pi__138___assume (\__pi__138_ );
  miter_def_prop #(1, "assume") \__pi__139___assume (\__pi__139_ );
  miter_def_prop #(1, "assume") \__pi__142___assume (\__pi__142_ );
  miter_def_prop #(1, "assume") \__pi__143___assume (\__pi__143_ );
  miter_def_prop #(1, "assume") \__pi_i4__6__assume (\__pi_i4__6 );
  miter_def_prop #(1, "assume") \__pi_q5__6__assume (\__pi_q5__6 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__144___assert (\__po__144___gold , \__po__144___gate );
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
  miter_def_prop #(1, "cover") \__po__144___gold_cover (\__po__144___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__144___gate_cover (\__po__144___gate );
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
module \gold.test1._144_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__138_ ,
  input  [  0:0] \__pi__139_ ,
  input  [  0:0] \__pi__142_ ,
  input  [  0:0] \__pi__143_ ,
  input  [  0:0] \__pi_i4__6 ,
  input  [  0:0] \__pi_q5__6 ,
  output [  0:0] \__po__144_
);
endmodule
module \gate.test1._144_ (
  input  [  0:0] \__pi__013_ ,
  input  [  0:0] \__pi__014_ ,
  input  [  0:0] \__pi__138_ ,
  input  [  0:0] \__pi__139_ ,
  input  [  0:0] \__pi__142_ ,
  input  [  0:0] \__pi__143_ ,
  input  [  0:0] \__pi_i4__6 ,
  input  [  0:0] \__pi_q5__6 ,
  output [  0:0] \__po__144_
);
endmodule
