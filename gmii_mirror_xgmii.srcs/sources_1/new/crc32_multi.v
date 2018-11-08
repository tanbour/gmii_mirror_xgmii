
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module crc32_multi(CRC32_IN, DATA_IN, DATA_IN_BYTES, CRC32_OUT);
localparam DATA_bytes = 64;
input wire [31:0] CRC32_IN;
input wire [DATA_bytes-1:0] DATA_IN;
input wire [3:0] DATA_IN_BYTES; // bytes <= 8
output wire [31:0] CRC32_OUT;

function [31:0] crc32_r;
input [31:0] crc;
input [DATA_bytes-1:0] data;
input [3:0] bytes;
integer i;
begin
    if (bytes == 8) begin
        for (i = 0; i < 64; i = i + 1) begin
            crc = ({32{crc[31] ^ data[0]}} & 32'h04c11db7)
                ^ {crc[30:0], 1'b0};
            data = data >> 1;
        end
    end else begin
        if (bytes >= 4) begin
            for (i = 0; i < 32; i = i + 1) begin
                crc = ({32{crc[31] ^ data[0]}} & 32'h04c11db7)
                    ^ {crc[30:0], 1'b0};
                data = data >> 1;
            end
            bytes = bytes - 4;
        end
        if (bytes >= 2) begin
            for (i = 0; i < 16; i = i + 1) begin
                crc = ({32{crc[31] ^ data[0]}} & 32'h04c11db7)
                    ^ {crc[30:0], 1'b0};
                data = data >> 1;
            end
            bytes = bytes - 2;
        end
        if (bytes >= 1) begin
            for (i = 0; i < 8; i = i + 1) begin
                crc = ({32{crc[31] ^ data[0]}} & 32'h04c11db7)
                    ^ {crc[30:0], 1'b0};
                data = data >> 1;
            end
            bytes = bytes - 1;
        end
    end
    crc32_r = crc;
end
endfunction

assign CRC32_OUT = crc32_r(CRC32_IN, DATA_IN, DATA_IN_BYTES);

endmodule
