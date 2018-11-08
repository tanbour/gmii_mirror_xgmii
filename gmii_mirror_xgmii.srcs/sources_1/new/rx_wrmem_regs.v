
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module rx_wrmem_regs(
input CLK,
input RESETN,
output [255:0] RD_DATA,
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
output CLEAR_ERR,
output TEST_PKT,
output [15:0] TEST_PKT_SIZE
);

reg [15:0] cap_pkt;
reg [15:0] cap_wdata;
reg [3:0] cap_wordcnt;
reg [3:0] cap_wcmd;
reg [3:0] cap_cnt;
reg [3:0] cap_delim;

reg test_pkt;
reg [15:0] test_pkt_size;

wire clear_err = (WR_EN && (WR_ADDR == 0) && WR_DATA[0]) || VIO_CLEAR;

wire [31:0] rd0 = { ERR_FULL[7:0], ERR_LONG[7:0], ERR_STS[7:0], 5'b0, ERR_DELIM, ERR_WCMD, ERR_S2MM };
wire [31:0] rd1 = { 24'b0, ERR_FCS[7:0] };
wire [31:0] rd2 = { WADDR_PRE[35:4] };
wire [31:0] rd3 = { 4'b0, WADDR_PRE[63:36] };
wire [31:0] rd4 = { WADDR_POST[35:4] };
wire [31:0] rd5 = { 4'b0, WADDR_POST[63:36] };
wire [31:0] rd6 = { cap_pkt[15:0], 1'b0, cap_wdata[14:0] };
wire [31:0] rd7 = { 16'b0, cap_delim, cap_cnt, cap_wcmd, cap_wordcnt };

assign RD_DATA = { rd7, rd6, rd5, rd4, rd3, rd2, rd1, rd0 };
assign CLEAR_ERR = clear_err;
assign TEST_PKT = test_pkt;
assign TEST_PKT_SIZE = test_pkt_size;

always @(posedge CLK) begin
    if (!RESETN) begin
        cap_pkt <= 16'hffff;
        cap_wdata <= 16'hffff;
        cap_wordcnt <= 4'hf;
        cap_wcmd <= 4'hf;
        cap_cnt <= 4'hf;
        cap_delim <= 4'hf;
        test_pkt <= 0;
        test_pkt_size <= 0;
    end else begin
        if (WR_EN && (WR_ADDR == 1)) begin
            test_pkt <= WR_DATA[15:0] != 0;
            test_pkt_size <= WR_DATA[15:0];
        end
        if (VIO_PKT) begin
            test_pkt <= VIO_PKT_SIZE != 0;
            test_pkt_size <= VIO_PKT_SIZE;
        end
        if (clear_err) begin
            cap_pkt <= 16'hffff;
            cap_wdata <= 16'hffff;
            cap_wordcnt <= 4'hf;
            cap_wcmd <= 4'hf;
            cap_cnt <= 4'hf;
            cap_delim <= 4'hf;
            test_pkt <= 0;
            test_pkt_size <= 0;
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
