
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_rx_fcs(
input wire CLK,
input wire RESET,
input [3:0] RXLEN_IN,
input [63:0] RXD_IN,
output [3:0] RXLEN_OUT,
output [63:0] RXD_OUT,
output FCS_EN,
output [31:0] FCS,
output [31:0] CRC32VAL,
output [7:0] DEBUG_OUT
);

reg [3:0] rxlen_re;
reg [63:0] rxd_re;
reg [0:0] state;
reg [31:0] crc32_val;
reg [31:0] fcs_re;

wire [127:0] rxd_concat = { RXD_IN, rxd_re };
wire [4:0] rxlen_concat = (rxlen_re < 8) ? rxlen_re : (RXLEN_IN + 8);
wire [3:0] rxlen_wo_fcs =
    (RXLEN_IN > 4) ? 8 :
    (RXLEN_IN > 0) ? (RXLEN_IN + 4) :
    (rxlen_re > 4) ? (rxlen_re - 4) :
    0;
wire fcs_en = (rxlen_concat >= 8 && rxlen_concat <= 15);
wire [31:0] fcs =
    (rxlen_concat == 15) ? rxd_concat[119:88] :
    (rxlen_concat == 14) ? rxd_concat[111:80] :
    (rxlen_concat == 13) ? rxd_concat[103:72] :
    (rxlen_concat == 12) ? rxd_concat[95:64] :
    (rxlen_concat == 11) ? rxd_concat[87:56] :
    (rxlen_concat == 10) ? rxd_concat[79:48] :
    (rxlen_concat == 9) ? rxd_concat[71:40] :
    (rxlen_concat == 8) ? rxd_concat[63:32] :
    0;

function [31:0] revert32;
input [31:0] value;
integer i;
begin
    revert32 = 0;
    for (i = 0; i < 32; i = i + 1) begin
        revert32[i] = value[31 - i];
    end
end
endfunction

wire [31:0] crc32_val_next;
crc32_multi crc32_multi_inst(crc32_val, rxd_re, rxlen_wo_fcs, crc32_val_next);

assign FCS = fcs_re;
assign FCS_EN = state == 0;
assign CRC32VAL = revert32(crc32_val) ^ 32'hffffffff;
assign RXLEN_OUT = state != 0 ? rxlen_wo_fcs : 0;
assign RXD_OUT = rxd_re;
assign DEBUG_OUT = state;

always @(posedge CLK) begin
    if (RESET) begin
        rxlen_re <= 0;
        rxd_re <= 0;
        state <= 0;
        crc32_val <= 32'hffffffff;
    end else begin
        rxlen_re <= RXLEN_IN;
        rxd_re <= RXD_IN;
        if (fcs_en) begin
            fcs_re <= fcs;
        end
        if (state == 0) begin
            if (RXLEN_IN != 0) begin
                crc32_val <= 32'hffffffff;
                state <= 1;
            end
        end else if (state == 1) begin
            crc32_val <= crc32_val_next;
            if (rxlen_wo_fcs != 8) begin
                state <= 0;
            end
        end
    end
end

endmodule
