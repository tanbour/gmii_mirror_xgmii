
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module gmii_to_xgmil(
input CLK,
input RESETN,
input GMII_CTRL,
input [7:0] GMII_D,
output [3:0] XGMII_LEN,
output [63:0] XGMII_D,
output XGMII_EN,
output XGMII_LAST
);

reg gmii_ctrl;
reg [7:0] gmii_d;
reg [3:0] xgmii_len;
reg [63:0] xgmii_d;
reg xgmii_en;
reg xgmii_last;
reg [2:0] offset;
reg [1:0] state;

assign XGMII_LEN = xgmii_len;
assign XGMII_D = xgmii_d;
assign XGMII_EN = xgmii_en;
assign XGMII_LAST = xgmii_last;

always @(posedge CLK) begin
    if (!RESETN) begin
        gmii_ctrl <= 0;
        gmii_d <= 0;
        xgmii_len <= 0;
        xgmii_d <= 0;
        xgmii_last <= 0;
        offset <= 0;
        state <= 0;
    end else begin
        gmii_ctrl <= GMII_CTRL;
        gmii_d <= GMII_D;
        if (state == 0) begin
            xgmii_d <= 0;
            xgmii_len <= 0;
            xgmii_last <= 0;
	    xgmii_en <= 0;
            offset <= 0;
            if (gmii_ctrl == 1 && gmii_d == 8'hd5) begin
                state <= 1;
            end
        end else if (state == 1) begin
	    offset <= offset + 1; // mod 8
            if (offset == 0) begin
                xgmii_d <= { gmii_d[7:0], 56'h0 };
                xgmii_len <= gmii_ctrl;
            end else begin
                xgmii_d <= { gmii_d[7:0], xgmii_d[63:8] };
                xgmii_len <= xgmii_len + gmii_ctrl;
            end
            xgmii_en <= (offset == 7);
            if (offset == 7 && xgmii_len + gmii_ctrl != 8) begin
                xgmii_last <= 1;
                state <= 0;
            end
        end
    end
end

endmodule
