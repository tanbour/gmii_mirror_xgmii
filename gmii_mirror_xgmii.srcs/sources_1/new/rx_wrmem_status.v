
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module rx_wrmem_status(
input CLK,
input RESETN,
input [7:0] STS_TDATA,
input STS_TVALID,
output STS_TREADY,
input [103:0] WCMD_TDATA,
input WCMD_TVALID,
output WCMD_TREADY,
output [7:0] ERR_STS,
output [63:0] CUR_WADDR
);
parameter ADDR_MOD_WIDTH = 32;
reg [7:0] err_sts;
reg [103:0] wcmd_tdata;
reg wcmd_tvalid;
reg [63:0] cur_waddr;

assign STS_TREADY = WCMD_TVALID;
assign WCMD_TREADY = STS_TVALID;
assign ERR_STS = err_sts;
assign CUR_WADDR = cur_waddr;

wire [63:0] wcmd_waddr_next = wcmd_tdata[95:32] + wcmd_tdata[22:0];

always @(posedge CLK) begin
    if (!RESETN) begin
        err_sts <= 0;
        wcmd_tdata <= 0;
        wcmd_tvalid <= 0;
        cur_waddr <= 0;
    end else begin
        wcmd_tdata <= 0;
        wcmd_tvalid <= 0;
        if (STS_TVALID && WCMD_TVALID) begin
            wcmd_tdata <= WCMD_TDATA;
            wcmd_tvalid <= 1;
            if (STS_TDATA[7] != 1) begin
                err_sts <= STS_TDATA;
            end
        end
        if (wcmd_tvalid) begin
            cur_waddr[ADDR_MOD_WIDTH-1:0] <= wcmd_waddr_next[ADDR_MOD_WIDTH-1:0];
            if (wcmd_waddr_next[ADDR_MOD_WIDTH-1:0] < cur_waddr[ADDR_MOD_WIDTH-1:0]) begin
                // wraparound
                cur_waddr[63:ADDR_MOD_WIDTH] <= cur_waddr[63:ADDR_MOD_WIDTH] + 1;
            end
        end
    end
end

endmodule
