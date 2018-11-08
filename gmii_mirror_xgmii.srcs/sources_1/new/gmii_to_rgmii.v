
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module gmii_to_rgmii(
input CLK,
input RESET,
input [7:0] TX_D_IN,
input TX_CTRL_IN,
input TX_ERR_IN,
output [3:0] TX_D_OUT,
output TX_CTRL_OUT
);

ODDRE1 oddr0(.Q(TX_D_OUT[0]), .C(CLK), .SR(RESET), .D1(TX_D_IN[0]), .D2(TX_D_IN[4]));
ODDRE1 oddr1(.Q(TX_D_OUT[1]), .C(CLK), .SR(RESET), .D1(TX_D_IN[1]), .D2(TX_D_IN[5]));
ODDRE1 oddr2(.Q(TX_D_OUT[2]), .C(CLK), .SR(RESET), .D1(TX_D_IN[2]), .D2(TX_D_IN[6]));
ODDRE1 oddr3(.Q(TX_D_OUT[3]), .C(CLK), .SR(RESET), .D1(TX_D_IN[3]), .D2(TX_D_IN[7]));

ODDRE1 oddrc(.Q(TX_CTRL_OUT), .C(CLK), .SR(RESET), .D1(TX_CTRL_IN), .D2(TX_CTRL_IN ^ TX_ERR_IN));

endmodule
