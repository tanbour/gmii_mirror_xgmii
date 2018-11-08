
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_arbiter_exclusive(
input [3:0] LEN0_IN,
input [63:0] D0_IN,
input [3:0] LEN1_IN,
input [63:0] D1_IN,
output [3:0] LEN_OUT,
output [63:0] D_OUT
);

assign LEN_OUT = LEN0_IN | LEN1_IN;
assign D_OUT = D0_IN | D1_IN;

endmodule
