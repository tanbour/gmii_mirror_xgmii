
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_rx_align_p1(
input CLK,
input RESET,
input [7:0] XGMII_RXC,
input [63:0] XGMII_RXD,
output [3:0] ALGN_RXLEN,
output [63:0] ALGN_RXD,
output [1:0] DEBUG_OUT
);

reg [3:0] half_rxc;
reg [31:0] half_rxd;
reg [1:0] state;
reg [1:0] state_next;

wire [7:0] xgmii_rxc = XGMII_RXC;
wire [63:0] xgmii_rxd = XGMII_RXD;

wire [7:0] misaligned_rxc = { xgmii_rxc[3:0], half_rxc[3:0] };
wire [63:0] misaligned_rxd = { xgmii_rxd[31:0], half_rxd[31:0] };

function [3:0] calc_rxlen(input [7:0] rxc);
begin
    if (rxc[0] == 1)  calc_rxlen = 0;
    else if (rxc[1] == 1) calc_rxlen = 1;
    else if (rxc[2] == 1) calc_rxlen = 2;
    else if (rxc[3] == 1) calc_rxlen = 3;
    else if (rxc[4] == 1) calc_rxlen = 4;
    else if (rxc[5] == 1) calc_rxlen = 5;
    else if (rxc[6] == 1) calc_rxlen = 6;
    else if (rxc[7] == 1) calc_rxlen = 7;
    else calc_rxlen = 8;
end
endfunction

wire [63:0] algn_rxd_nr =
    (state == 1) ? xgmii_rxd :
    (state == 2) ? misaligned_rxd :
    0;
wire [7:0] algn_rxlen_nr =
    (state == 1) ? calc_rxlen(xgmii_rxc) :
    (state == 2) ? calc_rxlen(misaligned_rxc) :
    0;

assign ALGN_RXLEN = algn_rxlen_nr;
assign ALGN_RXD = algn_rxd_nr;
assign DEBUG_OUT = state;

always @(posedge CLK) begin
    if (RESET) begin
        half_rxc <= 0;
        half_rxd <= 0;
        state <= 0;
        state_next <= 0;
    end else begin
        half_rxc <= xgmii_rxc[7:4];
        half_rxd <= xgmii_rxd[63:32];
        if (state == 0) begin
            if (state_next != 0) begin
                state <= state_next;
                state_next <= 0;
            end else if (xgmii_rxc[0] == 1 && xgmii_rxd[7:0] == 8'hfb) begin
                state <= 1;
            end else if (xgmii_rxc[4] == 1 && xgmii_rxd[39:32] == 8'hfb) begin
                state_next <= 2;
            end
        end else if (state == 1) begin
            if (xgmii_rxc != 0) begin
                state <= 0;
            end
        end else if (state == 2) begin
            if (misaligned_rxc != 0) begin
                state <= 0;
            end
        end
    end
end

endmodule
