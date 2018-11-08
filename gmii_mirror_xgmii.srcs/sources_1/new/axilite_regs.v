
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module axilite_regs(
CLK, RESETN,
s_axi_AXILiteS_AWVALID,
s_axi_AXILiteS_AWREADY,
s_axi_AXILiteS_AWADDR,
s_axi_AXILiteS_WVALID,
s_axi_AXILiteS_WREADY,
s_axi_AXILiteS_WDATA,
s_axi_AXILiteS_WSTRB,
s_axi_AXILiteS_ARVALID,
s_axi_AXILiteS_ARREADY,
s_axi_AXILiteS_ARADDR,
s_axi_AXILiteS_RVALID,
s_axi_AXILiteS_RREADY,
s_axi_AXILiteS_RDATA,
s_axi_AXILiteS_RRESP,
s_axi_AXILiteS_BVALID,
s_axi_AXILiteS_BREADY,
s_axi_AXILiteS_BRESP,
RD_DATA,
WR_EN, WR_ADDR, WR_DATA
);
parameter WIDTH_RD = 256;
parameter WIDTH_WR = 256;
input CLK;
input RESETN;
input s_axi_AXILiteS_AWVALID;
output s_axi_AXILiteS_AWREADY;
input [7:0] s_axi_AXILiteS_AWADDR;
input s_axi_AXILiteS_WVALID;
output s_axi_AXILiteS_WREADY;
input [31:0] s_axi_AXILiteS_WDATA;
input [3:0] s_axi_AXILiteS_WSTRB;
input s_axi_AXILiteS_ARVALID;
output s_axi_AXILiteS_ARREADY;
input [7:0] s_axi_AXILiteS_ARADDR;
output s_axi_AXILiteS_RVALID;
input s_axi_AXILiteS_RREADY;
output [31:0] s_axi_AXILiteS_RDATA;
output [1:0] s_axi_AXILiteS_RRESP;
output s_axi_AXILiteS_BVALID;
input s_axi_AXILiteS_BREADY;
output [1:0] s_axi_AXILiteS_BRESP;
input [WIDTH_RD-1:0] RD_DATA;
output WR_EN;
output [WIDTH_WR/32-1:0] WR_ADDR;
output [31:0] WR_DATA;

reg [1:0] rstate;
reg [1:0] wstate;
reg [7:0] waddr;
reg [7:0] raddr;
reg [31:0] rdata;
reg [31:0] wr_data;
reg wr_en;

wire [31:0] rd_data[0:WIDTH_RD/32-1];

localparam wstate_idle = 2'd0;
localparam wstate_data = 2'd1;
localparam wstate_resp = 2'd2;
localparam rstate_idle = 2'd0;
localparam rstate_busy = 2'd1;
localparam rstate_data = 2'd2;

assign s_axi_AXILiteS_AWREADY = (wstate == wstate_idle);
assign s_axi_AXILiteS_WREADY = (wstate == wstate_data);
assign s_axi_AXILiteS_ARREADY = (rstate == rstate_idle);
assign s_axi_AXILiteS_RVALID = (rstate == rstate_data);
assign s_axi_AXILiteS_RDATA = rdata;
assign s_axi_AXILiteS_RRESP = 0;
assign s_axi_AXILiteS_BVALID = (wstate == wstate_resp);
assign s_axi_AXILiteS_BRESP = 0;

generate
genvar i;
for (i = 0; i < WIDTH_RD / 32; i = i + 1) begin: b1
  assign rd_data[i] = RD_DATA[i*32+31:i*32];
end
endgenerate

assign WR_EN = wr_en;
assign WR_ADDR = waddr;
assign WR_DATA = wr_data;

integer j;
always @(posedge CLK) begin
  if (!RESETN) begin
    wstate <= wstate_idle;
    rstate <= rstate_idle;
    waddr <= 0;
    raddr <= 0;
    rdata <= 0;
    for (j = 0; j < WIDTH_WR / 32; j = j + 1) begin
      wr_data[j] <= 0;
    end
    wr_en <= 0;
  end else begin
    wr_en <= 0;
    if (wstate == wstate_idle && s_axi_AXILiteS_AWVALID) begin
      waddr <= s_axi_AXILiteS_AWADDR / 4;
      wstate <= wstate_data;
    end else if (wstate == wstate_data && s_axi_AXILiteS_WVALID) begin
      if (waddr < WIDTH_WR / 32) begin
        wr_data = s_axi_AXILiteS_WDATA;
        wr_en <= 1;
      end
      wstate <= wstate_resp;
    end else if (wstate == wstate_resp && s_axi_AXILiteS_BREADY) begin
      wstate <= wstate_idle;
    end
    if (rstate == rstate_idle && s_axi_AXILiteS_ARVALID) begin
      raddr <= s_axi_AXILiteS_ARADDR / 4;
      rdata <= 0;
      rstate <= rstate_busy;
    end else if (rstate == rstate_busy) begin
      if (raddr < WIDTH_RD / 32) begin
        rdata <= rd_data[raddr];
      end
      rstate <= rstate_data;
    end else if (rstate == rstate_data && s_axi_AXILiteS_RREADY) begin
      rstate <= rstate_idle;
    end
  end
end

endmodule

