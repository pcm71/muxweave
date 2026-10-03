module miter (
  input  [  0:0] \__pi__061_ ,
  input  [  0:0] \__pi__066_ ,
  input  [  0:0] \__pi__194_ ,
  input  [  0:0] \__pi__195_ ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__001___3__gold ,
  output [  0:0] \__po__001___3__gate
);
  \gold.test1._001_.3 gold (
    .\__pi__061_ (\__pi__061_ ),
    .\__pi__066_ (\__pi__066_ ),
    .\__pi__194_ (\__pi__194_ ),
    .\__pi__195_ (\__pi__195_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___3 (\__po__001___3__gold )
  );
  \gate.test1._001_.3 gate (
    .\__pi__061_ (\__pi__061_ ),
    .\__pi__066_ (\__pi__066_ ),
    .\__pi__194_ (\__pi__194_ ),
    .\__pi__195_ (\__pi__195_ ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__001___3 (\__po__001___3__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__061___assume (\__pi__061_ );
  miter_def_prop #(1, "assume") \__pi__066___assume (\__pi__066_ );
  miter_def_prop #(1, "assume") \__pi__194___assume (\__pi__194_ );
  miter_def_prop #(1, "assume") \__pi__195___assume (\__pi__195_ );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__001___3__assert (\__po__001___3__gold , \__po__001___3__gate );
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
  miter_def_prop #(1, "cover") \__po__001___3__gold_cover (\__po__001___3__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__001___3__gate_cover (\__po__001___3__gate );
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
module \gold.test1._001_.3 (
  input  [  0:0] \__pi__061_ ,
  input  [  0:0] \__pi__066_ ,
  input  [  0:0] \__pi__194_ ,
  input  [  0:0] \__pi__195_ ,
  output [  0:0] \__po__001___3
);
endmodule
module \gate.test1._001_.3 (
  input  [  0:0] \__pi__061_ ,
  input  [  0:0] \__pi__066_ ,
  input  [  0:0] \__pi__194_ ,
  input  [  0:0] \__pi__195_ ,
  output [  0:0] \__po__001___3
);
endmodule
