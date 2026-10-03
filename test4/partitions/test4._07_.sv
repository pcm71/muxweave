module miter (
  input  [  0:0] \__pi__05_ ,
  input  [  4:0] \__pi_datain ,
  input  [  0:0] \__pi_ena ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__07___gold ,
  output [  0:0] \__po__07___gate
);
  \gold.test4._07_ gold (
    .\__pi__05_ (\__pi__05_ ),
    .\__pi_datain (\__pi_datain ),
    .\__pi_ena (\__pi_ena ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__07_ (\__po__07___gold )
  );
  \gate.test4._07_ gate (
    .\__pi__05_ (\__pi__05_ ),
    .\__pi_datain (\__pi_datain ),
    .\__pi_ena (\__pi_ena ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__07_ (\__po__07___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__05___assume (\__pi__05_ );
  miter_def_prop #(5, "assume") \__pi_datain__assume (\__pi_datain );
  miter_def_prop #(1, "assume") \__pi_ena__assume (\__pi_ena );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__07___assert (\__po__07___gold , \__po__07___gate );
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
  miter_def_prop #(1, "cover") \__po__07___gold_cover (\__po__07___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__07___gate_cover (\__po__07___gate );
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
module \gold.test4._07_ (
  input  [  0:0] \__pi__05_ ,
  input  [  4:0] \__pi_datain ,
  input  [  0:0] \__pi_ena ,
  output [  0:0] \__po__07_
);
endmodule
module \gate.test4._07_ (
  input  [  0:0] \__pi__05_ ,
  input  [  4:0] \__pi_datain ,
  input  [  0:0] \__pi_ena ,
  output [  0:0] \__po__07_
);
endmodule
