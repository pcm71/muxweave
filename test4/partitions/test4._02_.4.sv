module miter (
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi__09_ ,
  input  [  0:0] \__pi__10_ ,
  input  [  0:0] \__pi__11_ ,
  input  [  0:0] \__pi_datain__4 ,
  input  [  0:0] \__pi_ena ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__02___4__gold ,
  output [  0:0] \__po__02___4__gate
);
  \gold.test4._02_.4 gold (
    .\__pi__06_ (\__pi__06_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi__09_ (\__pi__09_ ),
    .\__pi__10_ (\__pi__10_ ),
    .\__pi__11_ (\__pi__11_ ),
    .\__pi_datain__4 (\__pi_datain__4 ),
    .\__pi_ena (\__pi_ena ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__02___4 (\__po__02___4__gold )
  );
  \gate.test4._02_.4 gate (
    .\__pi__06_ (\__pi__06_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi__09_ (\__pi__09_ ),
    .\__pi__10_ (\__pi__10_ ),
    .\__pi__11_ (\__pi__11_ ),
    .\__pi_datain__4 (\__pi_datain__4 ),
    .\__pi_ena (\__pi_ena ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__02___4 (\__po__02___4__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__06___assume (\__pi__06_ );
  miter_def_prop #(1, "assume") \__pi__07___assume (\__pi__07_ );
  miter_def_prop #(1, "assume") \__pi__09___assume (\__pi__09_ );
  miter_def_prop #(1, "assume") \__pi__10___assume (\__pi__10_ );
  miter_def_prop #(1, "assume") \__pi__11___assume (\__pi__11_ );
  miter_def_prop #(1, "assume") \__pi_datain__4__assume (\__pi_datain__4 );
  miter_def_prop #(1, "assume") \__pi_ena__assume (\__pi_ena );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__02___4__assert (\__po__02___4__gold , \__po__02___4__gate );
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
  miter_def_prop #(1, "cover") \__po__02___4__gold_cover (\__po__02___4__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__02___4__gate_cover (\__po__02___4__gate );
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
module \gold.test4._02_.4 (
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi__09_ ,
  input  [  0:0] \__pi__10_ ,
  input  [  0:0] \__pi__11_ ,
  input  [  0:0] \__pi_datain__4 ,
  input  [  0:0] \__pi_ena ,
  output [  0:0] \__po__02___4
);
endmodule
module \gate.test4._02_.4 (
  input  [  0:0] \__pi__06_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi__09_ ,
  input  [  0:0] \__pi__10_ ,
  input  [  0:0] \__pi__11_ ,
  input  [  0:0] \__pi_datain__4 ,
  input  [  0:0] \__pi_ena ,
  output [  0:0] \__po__02___4
);
endmodule
