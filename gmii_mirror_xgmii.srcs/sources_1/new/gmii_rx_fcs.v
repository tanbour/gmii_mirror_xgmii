
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module gmii_rx_fcs(
input CLK,
input RESETN,
input RXC_IN,
input [7:0] RXD_IN,
output RXC_OUT,
output [7:0] RXD_OUT,
output [31:0] FCS_OUT,
output [31:0] CRC32VAL_OUT,
output [1:0] DEBUG_OUT,
output [31:0] DEBUG_OUT2
);

reg [31:0] rxd_shiftreg;
reg [3:0] shiftreg_len;
reg [31:0] crc32val;
reg [31:0] fcs_recv;
reg [1:0] state;

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

function [31:0] bswap4;
input [31:0] value;
integer i;
integer j;
begin
    bswap4 = 0;
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 8; j = j + 1) begin
            bswap4[i*8+j] = value[(3-i)*8+j];
        end
    end
end
endfunction

assign RXC_OUT = (shiftreg_len == 4) && (RXC_IN == 1);
assign RXD_OUT = RXC_OUT ? rxd_shiftreg[31:24] : 8'h00;
assign FCS_OUT = fcs_recv;
assign CRC32VAL_OUT = revert32(crc32val) ^ 32'hffffffff;
assign DEBUG_OUT = state;
assign DEBUG_OUT2 = rxd_shiftreg;

always @(posedge CLK) begin
    if (!RESETN) begin
        rxd_shiftreg <= 0;
        shiftreg_len <= 0;
        fcs_recv <= 0;
        crc32val <= 32'hffffffff;
        state <= 0;
    end else begin
        rxd_shiftreg <= { rxd_shiftreg, RXD_IN };
        if (state == 0) begin
            shiftreg_len <= 0;
            if (RXC_IN == 1) begin
                fcs_recv <= 0;
                crc32val <= 32'hffffffff;
                state <= 1;
            end
        end else if (RXC_IN == 0) begin
            fcs_recv <= bswap4(rxd_shiftreg);
            state <= 0;
        end else if (state == 1) begin
            if (RXD_IN == 8'hd5) begin
                state <= 2;
            end
        end else if (state == 2) begin
            shiftreg_len <= (shiftreg_len != 4) ? (shiftreg_len + 1) : 4;
            if (shiftreg_len == 4) begin
                crc32val <= crc32_8(crc32val, rxd_shiftreg[31:24]);
            end
        end
    end
end

endmodule
