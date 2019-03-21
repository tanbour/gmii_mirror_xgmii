
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module axis_fifo(
  CLK, RESETN,
  IV_TVALID, IV_TREADY, IV_TDATA, IV_TLAST, IV_TKEEP, IV_TUSER, IV_TID,
  OV_TVALID, OV_TREADY, OV_TDATA, OV_TLAST, OV_TKEEP, OV_TUSER, OV_TID,
  CAP_PUSH, CAP_POP);
parameter WIDTH_DATA = 64;
parameter WIDTH_LAST = 1;
parameter WIDTH_KEEP = 0;
parameter WIDTH_USER = 0;
parameter WIDTH_ID = 0;
parameter FIFO_SIZE_L2 = 16;
parameter FIFO_REG = 5;
parameter FIFO_DELAY = 2;
localparam IDX_LAST = WIDTH_DATA;
localparam IDX_KEEP = IDX_LAST + WIDTH_LAST;
localparam IDX_USER = IDX_KEEP + WIDTH_KEEP;
localparam IDX_ID = IDX_USER + WIDTH_USER;
localparam WIDTH = IDX_ID + WIDTH_ID;
localparam FIFO_SIZE = (1 << FIFO_SIZE_L2);
localparam HAS_DATA = WIDTH_DATA > 0;
localparam HAS_LAST = WIDTH_LAST > 0;
localparam HAS_KEEP = WIDTH_KEEP > 0;
localparam HAS_USER = WIDTH_USER > 0;
localparam HAS_ID = WIDTH_ID > 0;
localparam WIDTH_DATA_M1 = WIDTH_DATA > 0 ? WIDTH_DATA - 1 : 0;
localparam WIDTH_LAST_M1 = WIDTH_LAST > 0 ? WIDTH_LAST - 1 : 0;
localparam WIDTH_KEEP_M1 = WIDTH_KEEP > 0 ? WIDTH_KEEP - 1 : 0;
localparam WIDTH_USER_M1 = WIDTH_USER > 0 ? WIDTH_USER - 1 : 0;
localparam WIDTH_ID_M1 = WIDTH_ID > 0 ? WIDTH_ID - 1 : 0;
input CLK;
input RESETN;
input IV_TVALID;
output IV_TREADY;
input [WIDTH_DATA-1:0] IV_TDATA;
input [WIDTH_LAST-1:0] IV_TLAST;
input [WIDTH_KEEP-1:0] IV_TKEEP;
input [WIDTH_USER-1:0] IV_TUSER;
input [WIDTH_ID-1:0] IV_TID;
output OV_TVALID;
input OV_TREADY;
output [WIDTH_DATA-1:0] OV_TDATA;
output [WIDTH_LAST-1:0] OV_TLAST;
output [WIDTH_KEEP-1:0] OV_TKEEP;
output [WIDTH_USER-1:0] OV_TUSER;
output [WIDTH_ID-1:0] OV_TID;
output [$clog2(FIFO_REG+(1<<FIFO_SIZE_L2))-1:0] CAP_PUSH;
output [$clog2(FIFO_REG+(1<<FIFO_SIZE_L2))-1:0] CAP_POP;

wire PIV_TVALID;
wire PIV_TREADY;
wire [WIDTH-1:0] PIV_TDATA;
wire PRV_TVALID;
wire PRV_TREADY;
wire [WIDTH-1:0] PRV_TDATA;
wire POV_TVALID;
wire POV_TREADY;
wire [WIDTH-1:0] POV_TDATA;
wire [FIFO_SIZE_L2-1:0] CAP_PUSH_RAM;
wire [FIFO_SIZE_L2-1:0] CAP_POP_RAM;
wire [$clog2(FIFO_REG)-1:0] CAP_PUSH_REG;
wire [$clog2(FIFO_REG)-1:0] CAP_POP_REG;

assign PIV_TVALID = IV_TVALID;
assign IV_TREADY = PIV_TREADY;
assign OV_TVALID = POV_TVALID;
assign POV_TREADY = OV_TREADY;
assign CAP_PUSH = CAP_PUSH_RAM + CAP_PUSH_REG;
assign CAP_POP = CAP_POP_RAM + CAP_POP_REG;

if (WIDTH_DATA > 0) begin
  assign PIV_TDATA[WIDTH_DATA-1:0] = IV_TDATA;
  assign OV_TDATA = POV_TDATA[WIDTH_DATA_M1:0];
end
if (WIDTH_LAST > 0) begin
  assign PIV_TDATA[IDX_LAST+WIDTH_LAST-1:IDX_LAST] = IV_TLAST;
  assign OV_TLAST = POV_TDATA[IDX_LAST+WIDTH_LAST_M1:IDX_LAST];
end
if (WIDTH_KEEP > 0) begin
  assign PIV_TDATA[IDX_KEEP+WIDTH_KEEP-1:IDX_KEEP] = IV_TKEEP;
  assign OV_TKEEP = POV_TDATA[IDX_KEEP+WIDTH_KEEP_M1:IDX_KEEP];
end
if (WIDTH_USER > 0) begin
  assign PIV_TDATA[IDX_USER+WIDTH_USER-1:IDX_USER] = IV_TUSER;
  assign OV_TUSER = POV_TDATA[IDX_USER+WIDTH_USER_M1:IDX_USER];
end
if (WIDTH_ID > 0) begin
  assign PIV_TDATA[IDX_ID+WIDTH_ID-1:IDX_ID] = IV_TID;
  assign OV_TID = POV_TDATA[IDX_ID+WIDTH_ID_M1:IDX_ID];
end

generate
if (FIFO_SIZE_L2 > 0) begin
    axis_fifo_packed
        #(.WIDTH_DATA(WIDTH), .FIFO_SIZE_L2(FIFO_SIZE_L2), .FIFO_DELAY(FIFO_DELAY))
        ififo(.CLK(CLK), .RESETN(RESETN),
            .IV_TVALID(PIV_TVALID), .IV_TREADY(PIV_TREADY), .IV_TDATA(PIV_TDATA),
            .OV_TVALID(PRV_TVALID), .OV_TREADY(PRV_TREADY), .OV_TDATA(PRV_TDATA),
            .CAP_PUSH(CAP_PUSH_RAM), .CAP_POP(CAP_POP_RAM));
end else begin
    assign PRV_TVALID = PIV_TVALID;
    assign PIV_TREADY = PRV_TREADY;
    assign PRV_TDATA = PIV_TDATA;
    assign CAP_PUSH_RAM = 0;
    assign CAP_POP_RAM = 0;
end
endgenerate

generate
if (FIFO_REG > 1) begin
    axis_reg
        #(.WIDTH_DATA(WIDTH), .FIFO_SIZE(FIFO_REG))
        rfifo(.CLK(CLK), .RESETN(RESETN),
            .IV_TVALID(PRV_TVALID), .IV_TREADY(PRV_TREADY), .IV_TDATA(PRV_TDATA),
            .OV_TVALID(POV_TVALID), .OV_TREADY(POV_TREADY), .OV_TDATA(POV_TDATA),
            .CAP_PUSH(CAP_PUSH_REG), .CAP_POP(CAP_POP_REG));
end else begin
    assign POV_TVALID = PRV_TVALID;
    assign PRV_TREADY = POV_TREADY;
    assign POV_TDATA = PRV_TDATA;
    assign CAP_PUSH_REG = 0;
    assign CAP_POP_REG = 0;
end
endgenerate

endmodule
