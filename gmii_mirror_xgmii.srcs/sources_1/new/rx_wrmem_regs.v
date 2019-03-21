
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module rx_wrmem_regs(
input CLK,
input RESETN,
input RD_ADDR_EN,
input [7:0] RD_ADDR,
output RD_DATA_EN,
output [31:0] RD_DATA,
input WR_EN,
input [7:0] WR_ADDR,
input [31:0] WR_DATA,
input ERR_S2MM,
input ERR_WCMD,
input ERR_DELIM,
input [7:0] ERR_STS,
input [63:0] WADDR_PRE,
input [63:0] WADDR_POST,
input [7:0] ERR_LONG,
input [7:0] ERR_FCS,
input [7:0] ERR_FULL,
input [11:0] CAP_PKT,
input [14:0] CAP_WDATA,
input [4:0] CAP_WORDCNT,
input [3:0] CAP_WCMD,
input [3:0] CAP_CNT,
input [3:0] CAP_DELIM,
input VIO_CLEAR,
input VIO_PKT,
input [15:0] VIO_PKT_SIZE,
input [15:0] VIO_GAP_SIZE,
input VIO_KEEP_ERROR_PACKET,
output CLEAR_ERR,
output TEST_PKT,
output [15:0] TEST_PKT_SIZE,
output [15:0] TEST_GAP_SIZE,
output KEEP_ERROR_PACKET
);

reg rd_data_en;
reg [31:0] rd_data;

reg [63:0] waddr_pre;
reg [63:0] waddr_post;

reg [15:0] cap_pkt;
reg [15:0] cap_wdata;
reg [3:0] cap_wordcnt;
reg [3:0] cap_wcmd;
reg [3:0] cap_cnt;
reg [3:0] cap_delim;

reg test_pkt;
reg [15:0] test_pkt_size;
reg [15:0] test_gap_size;
reg keep_error_packet;

wire clear_err = (WR_EN && (WR_ADDR == 0) && WR_DATA[0]) || VIO_CLEAR;

function [31:0] get_rd;
input [255:0] addr;
case (addr)
8'h00: get_rd = { ERR_FULL[7:0], ERR_LONG[7:0], ERR_STS[7:0], 5'b0, ERR_DELIM, ERR_WCMD, ERR_S2MM };
8'h01: get_rd = { 24'b0, ERR_FCS[7:0] };
8'h02: get_rd = { WADDR_PRE[35:4] };
8'h03: get_rd = { 4'b0, waddr_pre[63:36] };
8'h04: get_rd = { WADDR_POST[35:4] };
8'h05: get_rd = { 4'b0, waddr_post[63:36] };
8'h06: get_rd = { cap_pkt[15:0], 1'b0, cap_wdata[14:0] };
8'h07: get_rd = { 16'b0, cap_delim, cap_cnt, cap_wcmd, cap_wordcnt };
default: get_rd = 0;
endcase
endfunction

assign RD_DATA = rd_data;
assign RD_DATA_EN = rd_data_en;
assign CLEAR_ERR = clear_err;
assign TEST_PKT = test_pkt;
assign TEST_PKT_SIZE = test_pkt_size;
assign TEST_GAP_SIZE = test_gap_size;
assign KEEP_ERROR_PACKET = keep_error_packet;

always @(posedge CLK) begin
    if (!RESETN) begin
        rd_data_en <= 0;
        rd_data <= 0;
        waddr_pre <= 0;
        waddr_post <= 0;
        cap_pkt <= 16'hffff;
        cap_wdata <= 16'hffff;
        cap_wordcnt <= 4'hf;
        cap_wcmd <= 4'hf;
        cap_cnt <= 4'hf;
        cap_delim <= 4'hf;
        test_pkt <= 0;
        test_pkt_size <= 0;
        test_gap_size <= 0;
        keep_error_packet <= 0;
    end else begin
        if (WR_EN && (WR_ADDR == 1)) begin
            test_pkt <= WR_DATA[15:0] != 0;
            test_pkt_size <= WR_DATA[15:0];
            test_gap_size <= WR_DATA[31:15];
        end
        if (WR_EN && (WR_ADDR == 2)) begin
            keep_error_packet <= WR_DATA[0];
        end
        rd_data_en <= 0;
        rd_data <= 0;
        if (RD_ADDR_EN) begin
            rd_data <= get_rd(RD_ADDR);
            rd_data_en <= 1;
            // latch 64bit values
            if (RD_ADDR == 2) waddr_pre <= WADDR_PRE;
            if (RD_ADDR == 4) waddr_post <= WADDR_POST;
        end
        if (VIO_PKT) begin
            test_pkt <= VIO_PKT_SIZE != 0;
            test_pkt_size <= VIO_PKT_SIZE;
            test_gap_size <= VIO_GAP_SIZE;
        end
        if (VIO_KEEP_ERROR_PACKET) begin
            keep_error_packet <= 1;
        end
        if (VIO_CLEAR) begin
            test_pkt <= 0;
            test_pkt_size <= 0;
            test_gap_size <= 0;
            keep_error_packet <= 0;
        end
        if (clear_err) begin
            cap_pkt <= 16'hffff;
            cap_wdata <= 16'hffff;
            cap_wordcnt <= 4'hf;
            cap_wcmd <= 4'hf;
            cap_cnt <= 4'hf;
            cap_delim <= 4'hf;
        end else begin
            if (CAP_PKT < cap_pkt) cap_pkt <= CAP_PKT;
            if (CAP_WDATA < cap_wdata) cap_wdata <= CAP_WORDCNT;
            if (CAP_WORDCNT < cap_wordcnt) cap_wordcnt <= CAP_WORDCNT;
            if (CAP_WCMD < cap_wcmd) cap_wcmd <= CAP_WCMD;
            if (CAP_CNT < cap_cnt) cap_cnt <= CAP_CNT;
            if (CAP_DELIM < cap_delim) cap_delim <= CAP_DELIM;
        end
    end
end

endmodule
