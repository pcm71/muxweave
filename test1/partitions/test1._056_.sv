module miter (
  input  [  0:0] \__pi__057_ ,
  input  [  0:0] \__pi__058_ ,
  input  [  0:0] \__pi__059_ ,
  input  [  0:0] \__pi__060_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__9 ,
  input  [  0:0] \__pi_q6__9 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__056___gold ,
  output [  0:0] \__po__056___gate
);
  \gold.test1._056_ gold (
    .\__pi__057_ (\__pi__057_ ),
    .\__pi__058_ (\__pi__058_ ),
    .\__pi__059_ (\__pi__059_ ),
    .\__pi__060_ (\__pi__060_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__9 (\__pi_i7__9 ),
    .\__pi_q6__9 (\__pi_q6__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__056_ (\__po__056___gold )
  );
  \gate.test1._056_ gate (
    .\__pi__057_ (\__pi__057_ ),
    .\__pi__058_ (\__pi__058_ ),
    .\__pi__059_ (\__pi__059_ ),
    .\__pi__060_ (\__pi__060_ ),
    .\__pi__119_ (\__pi__119_ ),
    .\__pi__120_ (\__pi__120_ ),
    .\__pi_i7__9 (\__pi_i7__9 ),
    .\__pi_q6__9 (\__pi_q6__9 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__056_ (\__po__056___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__057___assume (\__pi__057_ );
  miter_def_prop #(1, "assume") \__pi__058___assume (\__pi__058_ );
  miter_def_prop #(1, "assume") \__pi__059___assume (\__pi__059_ );
  miter_def_prop #(1, "assume") \__pi__060___assume (\__pi__060_ );
  miter_def_prop #(1, "assume") \__pi__119___assume (\__pi__119_ );
  miter_def_prop #(1, "assume") \__pi__120___assume (\__pi__120_ );
  miter_def_prop #(1, "assume") \__pi_i7__9__assume (\__pi_i7__9 );
  miter_def_prop #(1, "assume") \__pi_q6__9__assume (\__pi_q6__9 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__056___assert (\__po__056___gold , \__po__056___gate );
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
  miter_def_prop #(1, "cover") \__po__056___gold_cover (\__po__056___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__056___gate_cover (\__po__056___gate );
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
module \gold.test1._056_ (
  input  [  0:0] \__pi__057_ ,
  input  [  0:0] \__pi__058_ ,
  input  [  0:0] \__pi__059_ ,
  input  [  0:0] \__pi__060_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__9 ,
  input  [  0:0] \__pi_q6__9 ,
  output [  0:0] \__po__056_
);
endmodule
module \gate.test1._056_ (
  input  [  0:0] \__pi__057_ ,
  input  [  0:0] \__pi__058_ ,
  input  [  0:0] \__pi__059_ ,
  input  [  0:0] \__pi__060_ ,
  input  [  0:0] \__pi__119_ ,
  input  [  0:0] \__pi__120_ ,
  input  [  0:0] \__pi_i7__9 ,
  input  [  0:0] \__pi_q6__9 ,
  output [  0:0] \__po__056_
);
endmodule
