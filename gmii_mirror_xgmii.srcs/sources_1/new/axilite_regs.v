
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
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
RD_ADDR_EN, RD_ADDR, RD_DATA_EN, RD_DATA,
WR_EN, WR_ADDR, WR_DATA
);
parameter ADDR_WIDTH = 8;
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
output RD_ADDR_EN;
output [ADDR_WIDTH-1:0] RD_ADDR;
input RD_DATA_EN;
input [31:0] RD_DATA;
output WR_EN;
output [ADDR_WIDTH-1:0] WR_ADDR;
output [31:0] WR_DATA;

reg [1:0] rstate;
reg [7:0] raddr;
reg rd_addr_en;
reg [31:0] rd_data;
reg [1:0] wstate;
reg [7:0] waddr;
reg [31:0] wr_data;
reg wr_en;

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
assign s_axi_AXILiteS_RDATA = rd_data;
assign s_axi_AXILiteS_RRESP = 0;
assign s_axi_AXILiteS_BVALID = (wstate == wstate_resp);
assign s_axi_AXILiteS_BRESP = 0;

assign WR_EN = wr_en;
assign WR_ADDR = waddr;
assign WR_DATA = wr_data;
assign RD_ADDR_EN = rd_addr_en;
assign RD_ADDR = raddr;

integer j;
always @(posedge CLK) begin
  if (!RESETN) begin
    wstate <= wstate_idle;
    rstate <= rstate_idle;
    waddr <= 0;
    rd_addr_en <= 0;
    raddr <= 0;
    rd_data <= 0;
    wr_en <= 0;
  end else begin
    rd_addr_en <= 0;
    wr_en <= 0;
    if (wstate == wstate_idle && s_axi_AXILiteS_AWVALID) begin
      waddr <= s_axi_AXILiteS_AWADDR / 4;
      wstate <= wstate_data;
    end else if (wstate == wstate_data && s_axi_AXILiteS_WVALID) begin
      if (waddr < (1 << ADDR_WIDTH)) begin
        wr_data = s_axi_AXILiteS_WDATA;
        wr_en <= 1;
      end
      wstate <= wstate_resp;
    end else if (wstate == wstate_resp && s_axi_AXILiteS_BREADY) begin
      wstate <= wstate_idle;
    end
    if (rstate == rstate_idle && s_axi_AXILiteS_ARVALID) begin
      raddr <= s_axi_AXILiteS_ARADDR / 4;
      rd_addr_en <= 1;
      rd_data <= 0;
      rstate <= rstate_busy;
    end else if (rstate == rstate_busy) begin
      if (raddr < (1 << ADDR_WIDTH)) begin
        if (RD_DATA_EN) begin
          rd_data <= RD_DATA;
          rstate <= rstate_data;
        end
      end else begin
        rstate <= rstate_data;
      end
    end else if (rstate == rstate_data && s_axi_AXILiteS_RREADY) begin
      rstate <= rstate_idle;
    end
  end
end

endmodule

