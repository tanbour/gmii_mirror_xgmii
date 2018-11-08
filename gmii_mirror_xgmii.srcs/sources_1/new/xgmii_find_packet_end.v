
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module xgmii_find_packet_end(
input CLK,
input RESETN,
input [63:0] XGMII_D,
input [3:0] XGMII_LEN,
input XGMII_EN,
input XGMII_LAST,
output [63:0] OVAL_TDATA,
output [3:0] OVAL_TUSER,
output OVAL_TLAST,
output OVAL_TVALID,
output PACKET_END
);

reg [63:0] xgmii_d;
reg [3:0] xgmii_len;
reg xgmii_last;
reg xgmii_en;

assign OVAL_TDATA = xgmii_d;
assign OVAL_TUSER = xgmii_len;
assign OVAL_TLAST = xgmii_last;
assign OVAL_TVALID = xgmii_en;
assign PACKET_END = xgmii_last && xgmii_en;

always @(posedge CLK) begin
    xgmii_d <= XGMII_D;
    xgmii_len <= XGMII_LEN;
    xgmii_last <= XGMII_LAST;
    xgmii_en <= XGMII_EN;
end

endmodule
