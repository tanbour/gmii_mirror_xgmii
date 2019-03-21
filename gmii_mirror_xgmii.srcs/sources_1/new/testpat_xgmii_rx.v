
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module testpat_xgmii_rx(
input CLK,
input RESET,
input STARTBTN,
input [15:0] PKTLEN,
input [15:0] GAPLEN,
input [63:0] IN_RXD,
input [7:0] IN_RXC,
output [63:0] OUT_RXD,
output [7:0] OUT_RXC
);

reg [63:0] rxd;
reg [7:0] rxc;
reg [15:0] gap_rem;   // プリアンブルを含むギャップ長
reg first_gap;        // ギャップの先頭バイト(8'hfd)を入れる
reg [15:0] len_rem;   // フレーム長
reg half_delay;       // フレーム境界が半サイクル後ろにずれている
reg first_half_delay; // プリアンブルの残り半分を入れる
reg [63:0] cnt;

assign OUT_RXD = rxd;
assign OUT_RXC = rxc;

always @(posedge CLK) begin
    if (RESET) begin
        rxd <= 0;
        rxc <= 0;
        gap_rem <= 0;
        first_gap <= 0;
        len_rem <= 0;
        half_delay <= 0;
        first_half_delay <= 0;
        cnt <= 0;
    end else begin
        rxd <= 64'h0707070707070707;
        rxc <= 8'b11111111;
        if (STARTBTN) begin
            if (gap_rem > 0) begin
                if (gap_rem > 12) begin
                    gap_rem <= gap_rem - 8;
                end else if (gap_rem > 8) begin
                    rxd <= 64'h555555fb07070707;
                    rxc <= 8'b00011111;
                    gap_rem <= 0;
                    half_delay <= 1;
                    first_half_delay <= 1;
                    len_rem <= PKTLEN < 16 ? 20 : PKTLEN + 4;
                    cnt <= cnt + 1;
                end else begin
                    rxd <= 64'hd5555555555555fb;
                    rxc <= 8'b00000001;
                    gap_rem <= 0;
                    half_delay <= 0;
                    first_half_delay <= 0;
                    len_rem <= PKTLEN < 16 ? 16 : PKTLEN;
                    cnt <= cnt + 1;
                end
                if (first_gap) begin
                    rxd[7:0] <= 8'hfd;
                    first_gap <= 0;
                end
            end else begin
                rxd <= half_delay ? { cnt[31:0], cnt[63:32] } : cnt;
                rxc <= 8'b00000000;
                if (len_rem > 8) begin
                    len_rem <= len_rem - 8;
                end else if (len_rem > 4) begin
                    len_rem <= 0;
                    gap_rem <= GAPLEN < 4 ? 12 : GAPLEN + 8;
                    first_gap <= 1;
                end else begin
                    rxd[63:32] <= 32'h070707fd;
                    rxc[7:4]  <= 8'b1111;
                    len_rem <= 0;
                    gap_rem <= GAPLEN < 4 ? 8 : GAPLEN + 4;
                    first_gap <= 0;
                end
                if (first_half_delay) begin
                    rxd[31:0] <= 32'hd5555555;
                    first_half_delay <= 0;
                end
            end
        end else begin
            rxd <= IN_RXD;
            rxc <= IN_RXC;
        end
    end
end


endmodule
