
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_make_contiguous(
input CLK,
input RESETN,
input [63:0] IVAL_TDATA, // XGMII_D
input [3:0] IVAL_TUSER, // XGMII_LEN
input IVAL_TLAST,
input IVAL_TVALID,
output IVAL_TREADY,
input PACKET_END,
output [63:0] OVAL_XGMII_D,
output [3:0] OVAL_XGMII_LEN,
output OVAL_XGMII_HALFDELAY,
output ERR_CONT,
output [15:0] DBG_PCNT,
output [4:0] DBG_IFG);
parameter INTERFRAME_GAP = 12;
    // should be 16 if fcs is added later, 12 otherwise
localparam PACKET_CNT_WIDTH = 16;

reg [PACKET_CNT_WIDTH-1:0] packet_cnt;
reg [4:0] gap_rem;
reg ival_tready;
reg halfdelay;
reg err_cont;

wire IVAL_HS = IVAL_TREADY && IVAL_TVALID;

assign IVAL_TREADY = ival_tready;
assign OVAL_XGMII_D = IVAL_TDATA;
assign OVAL_XGMII_LEN = IVAL_HS ? IVAL_TUSER : 0;
assign OVAL_XGMII_HALFDELAY = halfdelay;
assign ERR_CONT = err_cont;
assign DBG_PCNT = packet_cnt;
assign DBG_IFG = gap_rem;

always @(posedge CLK) begin
    if (!RESETN) begin
        packet_cnt <= 0;
        gap_rem <= 0;
        ival_tready <= 0;
        halfdelay <= 0;
        err_cont <= 0;
    end else begin
        packet_cnt <= packet_cnt + PACKET_END - (IVAL_HS && IVAL_TLAST);
        gap_rem <= (gap_rem > 8) ? (gap_rem - 8) : 0;
        if (ival_tready == 0 && packet_cnt != 0 && gap_rem <= 12) begin
            ival_tready <= 1;
            gap_rem <= 0;
            halfdelay <= gap_rem > 8;
        end
        if (IVAL_HS && IVAL_TLAST) begin
            ival_tready <= 0;
            gap_rem <= (halfdelay << 2) + IVAL_TUSER + INTERFRAME_GAP;
        end
        if (ival_tready && !IVAL_TVALID) begin
            err_cont <= 1; // failed to make contiguous
        end
    end
end

endmodule
