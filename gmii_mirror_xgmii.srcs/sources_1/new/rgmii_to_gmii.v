
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module rgmii_to_gmii(
input CLK,
input RGMII_CTRL_IN,
input [3:0] RGMII_D_IN,
output GMII_CTRL_OUT,
output GMII_ERR_OUT,
output [7:0] GMII_D_OUT
);

wire Q2;
assign GMII_ERR_OUT = GMII_CTRL_OUT ^ Q2;

IDDRE1 #(.DDR_CLK_EDGE("SAME_EDGE_PIPELINED")) iddr0(.C(CLK), .CB(!CLK), .D(RGMII_D_IN[0]), .Q1(GMII_D_OUT[0]), .Q2(GMII_D_OUT[4]));
IDDRE1 #(.DDR_CLK_EDGE("SAME_EDGE_PIPELINED")) iddr1(.C(CLK), .CB(!CLK), .D(RGMII_D_IN[1]), .Q1(GMII_D_OUT[1]), .Q2(GMII_D_OUT[5]));
IDDRE1 #(.DDR_CLK_EDGE("SAME_EDGE_PIPELINED")) iddr2(.C(CLK), .CB(!CLK), .D(RGMII_D_IN[2]), .Q1(GMII_D_OUT[2]), .Q2(GMII_D_OUT[6]));
IDDRE1 #(.DDR_CLK_EDGE("SAME_EDGE_PIPELINED")) iddr3(.C(CLK), .CB(!CLK), .D(RGMII_D_IN[3]), .Q1(GMII_D_OUT[3]), .Q2(GMII_D_OUT[7]));

IDDRE1 #(.DDR_CLK_EDGE("SAME_EDGE_PIPELINED")) iddrc(.C(CLK), .CB(!CLK), .D(RGMII_CTRL_IN), .Q1(GMII_CTRL_OUT), .Q2(Q2));

endmodule
