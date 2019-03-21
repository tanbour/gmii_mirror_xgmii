
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module gmii_tx_fcs(
input CLK,
input RESETN,
input TXCTRL_IN,
input [7:0] TXD_IN,
output GMII_TX_CTRL,
output GMII_TX_ERR,
output [7:0] GMII_TX_D,
output [7:0] DEBUG_OUT
);

reg [31:0] crc32val;
reg [1:0] state;
reg [63:0] txd_shiftreg;
reg [7:0] txc_shiftreg;
reg [7:0] gmii_tx_d;
reg gmii_tx_ctrl;
reg [2:0] cnt;

wire [7:0] txd_s8 = txd_shiftreg[63:56];
wire txc_s8 = txc_shiftreg[7];

assign GMII_TX_CTRL = gmii_tx_ctrl;
assign GMII_TX_ERR = 0;
assign GMII_TX_D = gmii_tx_d;
assign DEBUG_OUT = crc32val;

function [31:0] crc32_8;
input [31:0] crc;
input [7:0] data;
integer i;
begin
    for (i = 0; i < 8; i = i + 1) begin
        crc = ({32{crc[31] ^ data[0]}} & 32'h04c11db7) ^ {crc[30:0], 1'b0};
        data = data >> 1;
    end
    crc32_8 = crc;
end
endfunction

function [7:0] revert8;
input [7:0] value;
integer i;
begin
    revert8 = 0;
    for (i = 0; i < 8; i = i + 1) begin
        revert8[i] = value[7 - i];
    end
end
endfunction

always @(posedge CLK) begin
    if (!RESETN) begin
        crc32val <= 32'hffffffff;
        gmii_tx_d <= 8'hdd;
        gmii_tx_ctrl <= 0;
        cnt <= 0;
        state <= 0;
    end else begin
        txd_shiftreg <= { txd_shiftreg, TXD_IN };
        txc_shiftreg <= { txc_shiftreg, TXCTRL_IN };
        if (state == 0) begin
            crc32val <= 32'hffffffff;
            if (TXCTRL_IN) begin
                gmii_tx_d <= 8'h55;
                gmii_tx_ctrl <= 1;
                cnt <= 0;
                state <= 1;
            end
        end else if (state == 1) begin
            cnt <= cnt + 1;
            if (cnt == 6) begin
                gmii_tx_d <= 8'hd5;
                state <= 2;
            end
        end else if (state == 2) begin
            gmii_tx_d <= txd_s8;
            gmii_tx_ctrl <= txc_s8;
            crc32val <= crc32_8(crc32val, txd_s8);
            if (txc_s8 == 0) begin
                crc32val <= { crc32val, 8'b0 };
                gmii_tx_d <= revert8(crc32val[31:24]) ^ 8'hff;
                gmii_tx_ctrl <= 1;
                cnt <= 0;
                state <= 3;
            end
        end else if (state == 3) begin
            crc32val <= { crc32val, 8'b0 };
            gmii_tx_d <= revert8(crc32val[31:24]) ^ 8'hff;
            gmii_tx_ctrl <= 1;
            cnt <= cnt + 1;
            if (cnt == 3) begin
                gmii_tx_d <= 8'hdd;
                gmii_tx_ctrl <= 0;
                state <= 0;
            end
        end
    end
end

endmodule
