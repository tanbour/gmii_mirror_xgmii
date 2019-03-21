
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module axis_fork(
CLK, RESETN,
IV_TVALID, IV_TREADY, IV_TDATA, IV_TLAST, IV_TKEEP, IV_TUSER, IV_TID,
OV0_TVALID, OV0_TREADY, OV0_TDATA, OV0_TLAST, OV0_TKEEP, OV0_TUSER, OV0_TID,
OV1_TVALID, OV1_TREADY, OV1_TDATA, OV1_TLAST, OV1_TKEEP, OV1_TUSER, OV1_TID
);
parameter WIDTH_DATA = 64;
parameter WIDTH_LAST = 1;
parameter WIDTH_KEEP = 0;
parameter WIDTH_USER = 0;
parameter WIDTH_ID = 0;
input CLK;
input RESETN;
input IV_TVALID;
output IV_TREADY;
input [WIDTH_DATA-1:0] IV_TDATA;
input [WIDTH_LAST-1:0] IV_TLAST;
input [WIDTH_KEEP-1:0] IV_TKEEP;
input [WIDTH_USER-1:0] IV_TUSER;
input [WIDTH_ID-1:0] IV_TID;
output OV0_TVALID;
input OV0_TREADY;
output [WIDTH_DATA-1:0] OV0_TDATA;
output [WIDTH_LAST-1:0] OV0_TLAST;
output [WIDTH_KEEP-1:0] OV0_TKEEP;
output [WIDTH_USER-1:0] OV0_TUSER;
output [WIDTH_ID-1:0] OV0_TID;
output OV1_TVALID;
input OV1_TREADY;
output [WIDTH_DATA-1:0] OV1_TDATA;
output [WIDTH_LAST-1:0] OV1_TLAST;
output [WIDTH_KEEP-1:0] OV1_TKEEP;
output [WIDTH_USER-1:0] OV1_TUSER;
output [WIDTH_ID-1:0] OV1_TID;

reg ov0_tvalid;
reg [(WIDTH_DATA>0?WIDTH_DATA-1:0):0] ov0_tdata;
reg [(WIDTH_LAST>0?WIDTH_LAST-1:0):0] ov0_tlast;
reg [(WIDTH_KEEP>0?WIDTH_KEEP-1:0):0] ov0_tkeep;
reg [(WIDTH_USER>0?WIDTH_USER-1:0):0] ov0_tuser;
reg [(WIDTH_ID>0?WIDTH_ID-1:0):0] ov0_tid;
reg ov1_tvalid;
reg [(WIDTH_DATA>0?WIDTH_DATA-1:0):0] ov1_tdata;
reg [(WIDTH_LAST>0?WIDTH_LAST-1:0):0] ov1_tlast;
reg [(WIDTH_KEEP>0?WIDTH_KEEP-1:0):0] ov1_tkeep;
reg [(WIDTH_USER>0?WIDTH_USER-1:0):0] ov1_tuser;
reg [(WIDTH_ID>0?WIDTH_ID-1:0):0] ov1_tid;

wire ov0_we = (OV0_TVALID == 0) || (OV0_TREADY && OV0_TVALID);
wire ov1_we = (OV1_TVALID == 0) || (OV1_TREADY && OV1_TVALID);
wire ov_we = ov0_we && ov1_we;

assign IV_TREADY = ov_we;
assign OV0_TVALID = ov0_tvalid;
assign OV0_TDATA = ov0_tdata;
assign OV0_TLAST = ov0_tlast;
assign OV0_TKEEP = ov0_tkeep;
assign OV0_TUSER = ov0_tuser;
assign OV0_TID = ov0_tid;
assign OV1_TVALID = ov1_tvalid;
assign OV1_TDATA = ov1_tdata;
assign OV1_TLAST = ov1_tlast;
assign OV1_TKEEP = ov1_tkeep;
assign OV1_TUSER = ov1_tuser;
assign OV1_TID = ov1_tid;

always @(posedge CLK) begin
    if (!RESETN) begin
        ov0_tvalid <= 0;
        ov1_tvalid <= 0;
    end else begin
        if (OV0_TVALID && OV0_TREADY) ov0_tvalid <= 0;
        if (OV1_TVALID && OV1_TREADY) ov1_tvalid <= 0;
        if (IV_TVALID && IV_TREADY) begin
            ov0_tvalid <= 1;
            ov0_tdata <= IV_TDATA;
            ov0_tlast <= IV_TLAST;
            ov0_tkeep <= IV_TKEEP;
            ov0_tuser <= IV_TUSER;
            ov0_tid <= IV_TID;
            ov1_tvalid <= 1;
            ov1_tdata <= IV_TDATA;
            ov1_tlast <= IV_TLAST;
            ov1_tkeep <= IV_TKEEP;
            ov1_tuser <= IV_TUSER;
            ov1_tid <= IV_TID;
        end
    end
end

endmodule
