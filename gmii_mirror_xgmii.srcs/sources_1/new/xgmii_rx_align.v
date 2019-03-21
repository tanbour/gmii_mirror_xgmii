
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module xgmii_rx_align(
input CLK,
input RESET,
input [7:0] XGMII_RXC,
input [63:0] XGMII_RXD,
output [3:0] ALGN_RXLEN,
output [63:0] ALGN_RXD,
output [2:0] DEBUG_OUT
);

reg out_frame;
reg half_delay;
reg first_half_delay;
reg [31:0] half_rxd;
reg [3:0] half_rxc;
reg [63:0] algn_rxd;
reg [3:0] algn_rxlen;

wire [7:0] xgmii_rxc = XGMII_RXC;
wire [63:0] xgmii_rxd = XGMII_RXD;

function [3:0] calc_rxlen(input [7:0] rxc);
begin
    if      (rxc[0] == 1) calc_rxlen = 0;
    else if (rxc[1] == 1) calc_rxlen = 1;
    else if (rxc[2] == 1) calc_rxlen = 2;
    else if (rxc[3] == 1) calc_rxlen = 3;
    else if (rxc[4] == 1) calc_rxlen = 4;
    else if (rxc[5] == 1) calc_rxlen = 5;
    else if (rxc[6] == 1) calc_rxlen = 6;
    else if (rxc[7] == 1) calc_rxlen = 7;
    else calc_rxlen = 8;
end
endfunction

assign ALGN_RXLEN = algn_rxlen;
assign ALGN_RXD = algn_rxd;
assign DEBUG_OUT = { out_frame, half_delay, first_half_delay };

always @(posedge CLK) begin
    if (RESET) begin
        out_frame <= 0;
        half_delay <= 0;
        first_half_delay <= 0;
        algn_rxd <= 0;
        algn_rxlen <= 0;
        half_rxc <= 0;
        half_rxd <= 0;
    end else begin
        if (first_half_delay) begin
            // 最初の4byteはプリアンブルの残りとSFD、
            // 後ろ4byteは次サイクルに出力
            algn_rxd <= 0;
            algn_rxlen <= 0;
            if (xgmii_rxc[3:0] == 0 && xgmii_rxd[31:0] == 32'hd5555555) begin
                out_frame <= 1;
            end
        end else if (!out_frame) begin
            // フレーム開始していない
            algn_rxd <= 0;
            algn_rxlen <= 0;
        end else if (half_delay) begin
            // 前サイクルの後ろ4byteと今サイクルの前4byteを出力
            algn_rxd <= { xgmii_rxd[31:0], half_rxd[31:0] };
            algn_rxlen <= calc_rxlen({ xgmii_rxc[3:0], half_rxc[3:0] });
            out_frame <= ({ xgmii_rxc[3:0], half_rxc[3:0] } == 0);
        end else begin
            // 今サイクルの8byteをそのまま出力
            algn_rxd <= xgmii_rxd;
            algn_rxlen <= calc_rxlen(xgmii_rxc);
            out_frame <= (xgmii_rxc == 0);
        end
        first_half_delay <= 0;
        half_rxd <= xgmii_rxd[63:32];
        half_rxc <= xgmii_rxc[7:4];
        if ((xgmii_rxc[7:0] == 8'b00000001) &&
            (xgmii_rxd[63:0] == 64'hd5555555555555fb)) begin
            // 今回の8byteが丁度プリアンブルとSFD。次サイクルからフレーム
            half_delay <= 0;
            out_frame <= 1;
        end else if (xgmii_rxc[7:4] == 4'b0001 &&
            xgmii_rxd[63:32] == 32'h555555fb) begin
            // 今回の後ろ4byteからプリアンブル
            half_delay <= 1;
            first_half_delay <= 1; // 次の4byteはプリアンブル残りとSFD
        end
    end
end

endmodule

