
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module testpat_rx(
input CLK,
input RESETN,
input STARTBTN,
input [15:0] PKTLEN,
input [63:0] IN_RXD,
input [3:0] IN_RXLEN,
input IN_FCS_EN,
input IN_FCS_CORRECT,
output [63:0] OUT_RXD,
output [3:0] OUT_RXLEN,
output OUT_FCS_EN,
output OUT_FCS_CORRECT
);

reg [63:0] rxd;
reg [3:0] rxlen;
reg fcs_en;
reg fcs_correct;
reg [15:0] len_rem;
reg [3:0] gap;
reg [63:0] cnt;

assign OUT_RXD = rxd;
assign OUT_RXLEN = rxlen;
assign OUT_FCS_EN = fcs_en;
assign OUT_FCS_CORRECT = fcs_correct;

always @(posedge CLK) begin
    if (!RESETN) begin
        rxd <= 0;
        rxlen <= 0;
        fcs_en <= 0;
        fcs_correct <= 0;
        len_rem <= 0;
        gap <= 0;
        cnt <= 0;
    end else begin
        rxd <= 0;
        rxlen <= 0;
        if (STARTBTN) begin
            if (gap != 0) begin
                gap <= gap - 1;
                if (gap == 1) begin
                    len_rem <= PKTLEN == 0 ? 64 : PKTLEN;
                end
            end else begin
                if (len_rem > 8) begin
                    len_rem <= len_rem - 8;
                    rxlen <= 8;
                    rxd <= 64'hdeadbeefdeadbeef;
                end else begin
                    len_rem <= 0;
                    rxlen <= len_rem;
                    rxd <= cnt;
                    cnt <= cnt + 1;
                    gap <= 1;
                end
            end
            fcs_en <= 1;
            fcs_correct <= 1;
        end else begin
            rxd <= IN_RXD;
            rxlen <= IN_RXLEN;
            fcs_en <= IN_FCS_EN;
            fcs_correct <= IN_FCS_CORRECT;
        end
    end
end


endmodule
