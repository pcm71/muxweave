module miter (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__050_ ,
  input  [  0:0] \__pi__051_ ,
  input  [  0:0] \__pi__054_ ,
  input  [  0:0] \__pi__055_ ,
  input  [  0:0] \__pi_i7__4 ,
  input  [  0:0] \__pi_q6__4 ,
`ifdef DIRECT_CROSS_POINTS
`else
`endif
  output [  0:0] \__po__059___gold ,
  output [  0:0] \__po__059___gate
);
  \gold.test1._059_ gold (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__050_ (\__pi__050_ ),
    .\__pi__051_ (\__pi__051_ ),
    .\__pi__054_ (\__pi__054_ ),
    .\__pi__055_ (\__pi__055_ ),
    .\__pi_i7__4 (\__pi_i7__4 ),
    .\__pi_q6__4 (\__pi_q6__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__059_ (\__po__059___gold )
  );
  \gate.test1._059_ gate (
    .\__pi__026_ (\__pi__026_ ),
    .\__pi__027_ (\__pi__027_ ),
    .\__pi__050_ (\__pi__050_ ),
    .\__pi__051_ (\__pi__051_ ),
    .\__pi__054_ (\__pi__054_ ),
    .\__pi__055_ (\__pi__055_ ),
    .\__pi_i7__4 (\__pi_i7__4 ),
    .\__pi_q6__4 (\__pi_q6__4 ),
`ifdef DIRECT_CROSS_POINTS
`else
`endif
    .\__po__059_ (\__po__059___gate )
  );
`ifdef ASSUME_DEFINED_INPUTS
  miter_def_prop #(1, "assume") \__pi__026___assume (\__pi__026_ );
  miter_def_prop #(1, "assume") \__pi__027___assume (\__pi__027_ );
  miter_def_prop #(1, "assume") \__pi__050___assume (\__pi__050_ );
  miter_def_prop #(1, "assume") \__pi__051___assume (\__pi__051_ );
  miter_def_prop #(1, "assume") \__pi__054___assume (\__pi__054_ );
  miter_def_prop #(1, "assume") \__pi__055___assume (\__pi__055_ );
  miter_def_prop #(1, "assume") \__pi_i7__4__assume (\__pi_i7__4 );
  miter_def_prop #(1, "assume") \__pi_q6__4__assume (\__pi_q6__4 );
`endif
`ifndef DIRECT_CROSS_POINTS
`endif
`ifdef CHECK_MATCH_POINTS
`endif
`ifdef CHECK_OUTPUTS
  miter_cmp_prop #(1, "assert") \__po__059___assert (\__po__059___gold , \__po__059___gate );
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
  miter_def_prop #(1, "cover") \__po__059___gold_cover (\__po__059___gold );
`endif
`ifdef COVER_DEF_GATE_OUTPUTS
  miter_def_prop #(1, "cover") \__po__059___gate_cover (\__po__059___gate );
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
module \gold.test1._059_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__050_ ,
  input  [  0:0] \__pi__051_ ,
  input  [  0:0] \__pi__054_ ,
  input  [  0:0] \__pi__055_ ,
  input  [  0:0] \__pi_i7__4 ,
  input  [  0:0] \__pi_q6__4 ,
  output [  0:0] \__po__059_
);
endmodule
module \gate.test1._059_ (
  input  [  0:0] \__pi__026_ ,
  input  [  0:0] \__pi__027_ ,
  input  [  0:0] \__pi__050_ ,
  input  [  0:0] \__pi__051_ ,
  input  [  0:0] \__pi__054_ ,
  input  [  0:0] \__pi__055_ ,
  input  [  0:0] \__pi_i7__4 ,
  input  [  0:0] \__pi_q6__4 ,
  output [  0:0] \__po__059_
);
endmodule
