module miter (
  input  [  0:0] \__pi__051_ ,
  input  [  0:0] \__pi__056_ ,
  input  [  0:0] \__pi__214_ ,
  input  [  0:0] \__pi__215_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__001___4__gold ,
  output [  0:0] \__po__001___4__gate
);
  \gold.test1._001_.4 gold (
    .\__pi__051_ (\__pi__051_ ),
    .\__pi__056_ (\__pi__056_ ),
    .\__pi__214_ (\__pi__214_ ),
    .\__pi__215_ (\__pi__215_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___4 (\__po__001___4__gold )
  );
  \gate.test1._001_.4 gate (
    .\__pi__051_ (\__pi__051_ ),
    .\__pi__056_ (\__pi__056_ ),
    .\__pi__214_ (\__pi__214_ ),
    .\__pi__215_ (\__pi__215_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___4 (\__po__001___4__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__051___assume (\__pi__051_ );
  miter_def_prop #(1, "assume") \__pi__056___assume (\__pi__056_ );
  miter_def_prop #(1, "assume") \__pi__214___assume (\__pi__214_ );
  miter_def_prop #(1, "assume") \__pi__215___assume (\__pi__215_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__001___4__assert (\__po__001___4__gold , \__po__001___4__gate );
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
  miter_def_prop #(1, "cover") \__po__001___4__gold_cover (\__po__001___4__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__001___4__gate_cover (\__po__001___4__gate );
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
module \gold.test1._001_.4 (
  input  [  0:0] \__pi__051_ ,
  input  [  0:0] \__pi__056_ ,
  input  [  0:0] \__pi__214_ ,
  input  [  0:0] \__pi__215_ ,
  output [  0:0] \__po__001___4
);
endmodule
module \gate.test1._001_.4 (
  input  [  0:0] \__pi__051_ ,
  input  [  0:0] \__pi__056_ ,
  input  [  0:0] \__pi__214_ ,
  input  [  0:0] \__pi__215_ ,
  output [  0:0] \__po__001___4
);
endmodule
