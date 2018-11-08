
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


// Copyright (C) 2017 Akira Higuchi. All rights reserved.
// See COPYRIGHT.txt for details.

module fanctrl_init(
input wire CLK,
input wire RESET_N,
input wire I2CM_READY,
output wire I2CM_VALID,
output wire [6:0] I2CM_DEVADDR,
output wire [7:0] I2CM_REGADDR,
output wire [31:0] I2CM_WDATA,
output wire [2:0] I2CM_WBYTES,
input wire [31:0] I2CM_RDATA,
output wire [2:0] I2CM_RBYTES,
output wire I2CM_SEND_NACK,
input wire [2:0] I2CM_ERR
);

reg [4:0] idx;
reg [3:0] state;
reg i2cm_valid;
reg [7:0] i2cm_devaddr;
reg [7:0] i2cm_regaddr;
reg [7:0] i2cm_wdata;

assign I2CM_VALID = i2cm_valid;
assign I2CM_DEVADDR = i2cm_devaddr;
assign I2CM_REGADDR = i2cm_regaddr;
assign I2CM_WDATA = i2cm_wdata;
assign I2CM_WBYTES = 1;
assign I2CM_RBYTES = 0;
assign I2CM_SEND_NACK = 1;

function [23:0] init_reg(input [4:0] idx);
begin
    init_reg = 0;
    case (idx)
    00: init_reg = 24'h74e808;
    01: init_reg = 24'h4c4a30;
    02: init_reg = 24'h4c4c3f;
    03: init_reg = 24'h4c5000;
    04: init_reg = 24'h4c510e;
    05: init_reg = 24'h4c5232;
    06: init_reg = 24'h4c5317;
    07: init_reg = 24'h4c5446;
    08: init_reg = 24'h4c551e;
    09: init_reg = 24'h4c5650;
    10: init_reg = 24'h4c5750;
    11: init_reg = 24'h4c585a;
    12: init_reg = 24'h4c592e;
    13: init_reg = 24'h4c4a10;
    14: init_reg = 24'h4c0306;
    15: init_reg = 24'h4c1960;
    endcase
end
endfunction

always @(posedge CLK) begin
    if (!RESET_N) begin
        state <= 0;
        idx <= 0;
        i2cm_valid <= 0;
        i2cm_devaddr <= 0;
        i2cm_regaddr <= 0;
        i2cm_wdata <= 0;
    end
    if (state == 0 && I2CM_READY) begin
        state <= 1;
        i2cm_valid <= 1;
        i2cm_devaddr <= init_reg(idx) >> 16;
        i2cm_regaddr <= init_reg(idx) >> 8;
        i2cm_wdata <= init_reg(idx);
    end
    if (state == 1 && !I2CM_READY) begin
        i2cm_valid <= 0;
        if ((init_reg(idx + 1) >> 16) != 0) begin
            state <= 0;
            idx <= idx + 1;
        end else begin
            state <= 2;
        end
    end
end

endmodule

