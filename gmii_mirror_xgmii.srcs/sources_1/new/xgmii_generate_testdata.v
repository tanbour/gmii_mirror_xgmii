
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module xgmii_generate_testdata(
input CLK,
input RESET,
input CE,
output [63:0] RXD_OUT,
output [3:0] RXLEN_OUT
);

reg [63:0] rxd;
reg [3:0] rxlen;
reg [11:0] cnt;

assign RXD_OUT = rxd;
assign RXLEN_OUT = rxlen;

always @(posedge CLK) begin
    if (RESET) begin
        rxd <= 0;
        rxlen <= 0;
        cnt <= 0;
    end else if (!CE) begin
    end else begin
        cnt <= cnt + 1;
        if (cnt < 16) begin
            rxlen <= 8;
        end else begin
            rxlen <= 0;
        end
        if (cnt == 0) begin
            rxd <= rxd + 1;
        end
    end
end

endmodule
