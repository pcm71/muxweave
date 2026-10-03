module miter (
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_sr__2 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po_gpioout__5__gold ,
  output [  0:0] \__po_gpioout__5__gate
);
  \gold.test3.gpioout.5 gold (
    .\__pi__01_ (\__pi__01_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi_clk (\__pi_clk ),
    .\__pi_sr__2 (\__pi_sr__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_gpioout__5 (\__po_gpioout__5__gold )
  );
  \gate.test3.gpioout.5 gate (
    .\__pi__01_ (\__pi__01_ ),
    .\__pi__07_ (\__pi__07_ ),
    .\__pi_clk (\__pi_clk ),
    .\__pi_sr__2 (\__pi_sr__2 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po_gpioout__5 (\__po_gpioout__5__gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__01___assume (\__pi__01_ );
  miter_def_prop #(1, "assume") \__pi__07___assume (\__pi__07_ );
  miter_def_prop #(1, "assume") \__pi_clk__assume (\__pi_clk );
  miter_def_prop #(1, "assume") \__pi_sr__2__assume (\__pi_sr__2 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po_gpioout__5__assert (\__po_gpioout__5__gold , \__po_gpioout__5__gate );
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
  miter_def_prop #(1, "cover") \__po_gpioout__5__gold_cover (\__po_gpioout__5__gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po_gpioout__5__gate_cover (\__po_gpioout__5__gate );
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
module \gold.test3.gpioout.5 (
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_sr__2 ,
  output [  0:0] \__po_gpioout__5
);
endmodule
module \gate.test3.gpioout.5 (
  input  [  0:0] \__pi__01_ ,
  input  [  0:0] \__pi__07_ ,
  input  [  0:0] \__pi_clk ,
  input  [  0:0] \__pi_sr__2 ,
  output [  0:0] \__po_gpioout__5
);
endmodule
