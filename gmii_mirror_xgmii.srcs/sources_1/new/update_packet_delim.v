
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module update_packet_delim(
  CLK, RESETN,
  IWCMD_TDATA, IWCMD_TVALID, IWCMD_TREADY,
  IWDATA_TDATA, IWDATA_TVALID, IWDATA_TREADY, IWDATA_TLAST,
  OWDATA_TDATA, OWDATA_TVALID, OWDATA_TREADY, OWDATA_TLAST,
  ERR_DELIM);
parameter ADDR_WIDTH = 64;
parameter WIDTH_DATA = 128;
localparam WORD_SIZE = WIDTH_DATA / 8;
input CLK;
input RESETN;
input [ADDR_WIDTH+40-1:0] IWCMD_TDATA;
input IWCMD_TVALID;
output IWCMD_TREADY;
input [WIDTH_DATA-1:0] IWDATA_TDATA;
input IWDATA_TVALID;
output IWDATA_TREADY;
input IWDATA_TLAST;
output [WIDTH_DATA-1:0] OWDATA_TDATA;
output OWDATA_TVALID;
input OWDATA_TREADY;
output OWDATA_TLAST;
output ERR_DELIM;

reg [WIDTH_DATA-1:0] owdata_tdata;
reg owdata_tvalid;
reg owdata_tlast;
reg [15:0] wcnt;
reg err_delim;

wire owdata_hs = OWDATA_TREADY && OWDATA_TVALID;
wire owdata_writable = owdata_hs || (owdata_tvalid == 0);
wire iwdata_hs = IWDATA_TREADY && IWDATA_TVALID;
wire iwcmd_hs = IWCMD_TREADY && IWCMD_TVALID;

assign IWCMD_TREADY = (wcnt == 0);
assign IWDATA_TREADY = owdata_writable && (wcnt != 0);
assign OWDATA_TDATA = owdata_tdata;
assign OWDATA_TVALID = owdata_tvalid;
assign OWDATA_TLAST = owdata_tlast;
assign ERR_DELIM = err_delim;

always @(posedge CLK) begin
  if (!RESETN) begin
    owdata_tdata <= 0;
    owdata_tvalid <= 0;
    owdata_tlast <= 0;
    wcnt <= 0;
    err_delim <= 0;
  end else begin
    if (owdata_hs) begin
      owdata_tvalid <= 0;
    end
    if (iwdata_hs) begin
      owdata_tvalid <= 1;
      owdata_tdata <= IWDATA_TDATA;
      owdata_tlast <= (wcnt == 1);
      if (wcnt == 1 && IWDATA_TLAST == 0) begin
        // err_delim <= 1; // FIXME: アドレスが一周したときはここにくる
      end
      wcnt <= wcnt - 1;
    end
    if (iwcmd_hs) begin
      wcnt <= { IWCMD_TDATA[22:0] } / WORD_SIZE;
    end
  end
end

endmodule

