
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module xgmii_prepare_cdc(
input CLK,
input RESETN,
input [63:0] XGMII_D,
input [3:0] XGMII_LEN,
input CE,
output [71:0] OVAL_TDATA,
output OVAL_TVALID
);

assign OVAL_TDATA = { 4'b0, XGMII_LEN[3:0], XGMII_D[63:0] };
assign OVAL_TVALID = CE;

endmodule
