
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module axis_reg(
  CLK, RESETN,
  IV_TDATA, IV_TVALID, IV_TREADY, IV_TLAST, IV_TKEEP, IV_TUSER, IV_TID,
  OV_TDATA, OV_TVALID, OV_TREADY, OV_TLAST, OV_TKEEP, OV_TUSER, OV_TID,
  CAP_PUSH, CAP_POP);
parameter WIDTH_DATA = 64;
parameter WIDTH_LAST = 1;
parameter WIDTH_KEEP = 8;
parameter WIDTH_USER = 1;
parameter WIDTH_ID = 4;
parameter FIFO_SIZE = 5;
localparam FIFO_SIZE_L2 = $clog2(FIFO_SIZE);
input CLK;
input RESETN;
input [WIDTH_DATA-1:0] IV_TDATA;
input [WIDTH_LAST-1:0] IV_TLAST;
input [WIDTH_KEEP-1:0] IV_TKEEP;
input [WIDTH_USER-1:0] IV_TUSER;
input [WIDTH_ID-1:0] IV_TID;
input IV_TVALID;
output IV_TREADY;
output [WIDTH_DATA-1:0] OV_TDATA;
output [WIDTH_LAST-1:0] OV_TLAST;
output [WIDTH_KEEP-1:0] OV_TKEEP;
output [WIDTH_USER-1:0] OV_TUSER;
output [WIDTH_ID-1:0] OV_TID;
output OV_TVALID;
input OV_TREADY;
output [$clog2(FIFO_SIZE)-1:0] CAP_PUSH;
output [$clog2(FIFO_SIZE)-1:0] CAP_POP;

reg [WIDTH_DATA-1:0] arr_data[0:FIFO_SIZE-1];
reg [WIDTH_LAST-1:0] arr_last[0:FIFO_SIZE-1];
reg [WIDTH_KEEP-1:0] arr_keep[0:FIFO_SIZE-1];
reg [WIDTH_USER-1:0] arr_user[0:FIFO_SIZE-1];
reg [WIDTH_ID-1:0] arr_id[0:FIFO_SIZE-1];
reg [FIFO_SIZE_L2-1:0] widx;

wire IV_HS = (IV_TREADY && IV_TVALID);
wire OV_HS = (OV_TREADY && OV_TVALID);

assign IV_TREADY = widx < FIFO_SIZE - 1;
assign OV_TVALID = widx > 0;
assign OV_TDATA = arr_data[0];
assign OV_TLAST = arr_last[0];
assign OV_TKEEP = arr_keep[0];
assign OV_TUSER = arr_user[0];
assign OV_TID = arr_id[0];
assign CAP_PUSH = FIFO_SIZE - 1 - widx;
assign CAP_POP = widx;

integer i;
always @(posedge CLK) begin
  if (!RESETN) begin
    widx <= 0;
    for (i = 0; i < FIFO_SIZE; i = i + 1) begin
      arr_data[i] <= 0;
      arr_last[i] <= 0;
      arr_keep[i] <= 0;
      arr_user[i] <= 0;
      arr_id[i] <= 0;
    end
  end else begin
    if (OV_HS) begin
      for (i = 0; i < FIFO_SIZE - 1; i = i + 1) begin
        arr_data[i] <= arr_data[i + 1];
        arr_last[i] <= arr_last[i + 1];
        arr_keep[i] <= arr_keep[i + 1];
        arr_user[i] <= arr_user[i + 1];
        arr_id[i] <= arr_id[i + 1];
      end
    end
    if (IV_HS) begin
      arr_data[widx - OV_HS] <= IV_TDATA;
      arr_last[widx - OV_HS] <= IV_TLAST;
      arr_keep[widx - OV_HS] <= IV_TKEEP;
      arr_user[widx - OV_HS] <= IV_TUSER;
      arr_id[widx - OV_HS] <= IV_TID;
    end
    widx <= widx + IV_HS - OV_HS;
  end
end

endmodule
