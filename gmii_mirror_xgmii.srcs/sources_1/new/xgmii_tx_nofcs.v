
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_tx_nofcs(
input CLK,
input RESET,
input CLOCK_EN,
input [3:0] TXLEN_IN,
input [63:0] TXD_IN,
input TXHD_IN,
output [63:0] TXD_OUT,
output [7:0] TXC_OUT
);

reg [63:0] txd_out;
reg [7:0] txc_out;
reg [63:0] txd_rem;
reg [7:0] txc_rem;
reg [1:0] state;
reg txhd_out;
reg txhd_out_1;
reg [63:0] txd_out_1;
reg [7:0] txc_out_1;
reg [63:0] txd_out_2;
reg [7:0] txc_out_2;
reg [63:0] txd_out_3;
reg [7:0] txc_out_3;

assign TXD_OUT = txd_out_3;
assign TXC_OUT = txc_out_3;

function [127:0] txd_trailing;
input [63:0] txd;
input [3:0] txlen; /* txlen <= 8 */
begin
    if (txlen == 8) begin
        txd_trailing = { 64'h07070707070707fd, txd[63:0] };
    end else begin
        txd = txd << ((8 - txlen[2:0]) * 8);
        txd_trailing = { 128'h070707070707070707070707070707fd, txd[63:0] } >> ((8 - txlen[2:0]) * 8);
    end
end
endfunction

function [15:0] txc_trailing;
input [3:0] txlen;  /* txlen <= 8 */
begin
    if (txlen == 8) begin
        txc_trailing = 16'hff00;
    end else begin
        txc_trailing = 16'hffff << txlen[2:0];
    end
end
endfunction

always @(posedge CLK) begin
    if (RESET) begin
        txd_out <= 64'h0707070707070707;
        txc_out <= 8'hff;
        txd_rem <= 0;
        txc_rem <= 0;
        state <= 0;
    end else if (!CLOCK_EN) begin
        // noop
    end else begin
        if (state == 0) begin
            txd_out <= 64'h0707070707070707;
            txc_out <= 8'hff;
            if (TXLEN_IN == 8) begin
                txd_out <= TXD_IN;
                txc_out <= 8'h00;
                state <= 1;
            end
        end else if (state == 1) begin
            txd_out <= txd_trailing(TXD_IN, TXLEN_IN);
            txc_out <= txc_trailing(TXLEN_IN);
            txd_rem <= txd_trailing(TXD_IN, TXLEN_IN) >> 64;
            txc_rem <= txc_trailing(TXLEN_IN) >> 8;
            if (TXLEN_IN < 8) begin
                state <= 2;
            end
        end else if (state == 2) begin
            txd_out <= txd_rem;
            txc_out <= txc_rem;
            state <= 0;
        end
    end
    txhd_out <= TXHD_IN;
    txd_out_1 <= (state == 0 && TXLEN_IN == 8) ? 64'hd5555555555555fb : txd_out;
    txc_out_1 <= (state == 0 && TXLEN_IN == 8) ? 8'h01 : txc_out;
    txhd_out_1 <= txhd_out;
    txd_out_2 <= txd_out_1;
    txc_out_2 <= txc_out_1;
    txd_out_3 <= txhd_out ? { txd_out_1[31:0], txd_out_2[63:32] } : txd_out_1;
    txc_out_3 <= txhd_out ? { txc_out_1[3:0], txc_out_2[7:4] } : txc_out_1;
end

endmodule
