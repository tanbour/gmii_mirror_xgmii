
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module get_word_count(
CLK, RESETN,
IV_TDATA, IV_TVALID, IV_TLAST, IV_TREADY,
OV_TDATA, OV_TVALID, OV_TLAST, OV_TREADY,
WORDCNT_TDATA, WORDCNT_TVALID, WORDCNT_TREADY
);
parameter WORD_SIZE_L2 = 3;
parameter WORDCNT_WORD_SIZE_L2 = 4;
input CLK;
input RESETN;
input [(1<<WORD_SIZE_L2)*8-1:0] IV_TDATA;
input IV_TVALID;
input IV_TLAST;
output IV_TREADY;
output [(1<<WORD_SIZE_L2)*8-1:0] OV_TDATA;
output OV_TVALID;
output OV_TLAST;
input OV_TREADY;
output [15:0] WORDCNT_TDATA;
output WORDCNT_TVALID;
input WORDCNT_TREADY;

reg pkt_cont;
reg [15:0] wordcnt;

assign OV_TDATA = IV_TDATA;
assign OV_TVALID = IV_TVALID && WORDCNT_TREADY;
assign OV_TLAST = IV_TLAST;
assign IV_TREADY = OV_TREADY && WORDCNT_TREADY;
assign WORDCNT_TDATA = wordcnt;
assign WORDCNT_TVALID = wordcnt != 0;

always @(posedge CLK) begin
    if (!RESETN) begin
        pkt_cont <= 0;
        wordcnt <= 0;
    end else begin
        if (WORDCNT_TVALID && WORDCNT_TREADY) begin
            wordcnt <= 0;
        end
        if (IV_TVALID && IV_TREADY) begin
            if (!pkt_cont) begin
                wordcnt <= ((IV_TDATA[15:0] + 7) >> WORDCNT_WORD_SIZE_L2) + 1;
                pkt_cont <= 1;
            end
            if (IV_TLAST) begin
                pkt_cont <= 0;
            end
        end
    end
end

endmodule
