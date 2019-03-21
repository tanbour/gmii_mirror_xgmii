
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module groupify_wordcnt(
  CLK, RESETN,
  IV_TDATA, IV_TVALID, IV_TREADY,
  OV_TDATA, OV_TVALID, OV_TREADY);
parameter WIDTH = 16;
localparam TIMER_THR = 16384;
input CLK;
input RESETN;
input [WIDTH-1:0] IV_TDATA;
input IV_TVALID;
output IV_TREADY;
output [WIDTH-1:0] OV_TDATA;
output OV_TVALID;
input OV_TREADY;

reg [WIDTH-1:0] ov_tdata;
reg ov_tvalid;
reg iv_tready;
reg [WIDTH-1:0] wordcnt_sum;
reg [WIDTH-1:0] timer;

assign OV_TDATA = ov_tdata;
assign OV_TVALID = ov_tvalid;
wire ov_hs = OV_TREADY && OV_TVALID;
wire ov_writable = ov_hs || (ov_tvalid == 0);
assign IV_TREADY = iv_tready;
wire iv_hs = IV_TREADY && IV_TVALID;

always @(posedge CLK) begin
  if (!RESETN) begin
    ov_tdata <= 0;
    ov_tvalid <= 0;
    iv_tready <= 0;
    wordcnt_sum <= 0;
    timer <= 0;
  end else begin
    if (ov_hs) begin
      ov_tvalid <= 0;
    end
    if (iv_hs) begin
      wordcnt_sum <= wordcnt_sum + IV_TDATA; // FIXME: check overflow
    end
    if (wordcnt_sum != 0) begin
      timer <= timer < 16'hffff ? timer + 1 : 16'hffff;
    end
    iv_tready <= 1;
    if (timer >= TIMER_THR) begin
      iv_tready <= 0;
      if (ov_writable) begin
        iv_tready <= 1;
        timer <= 0;
        ov_tvalid <= 1;
        ov_tdata <= wordcnt_sum;
        wordcnt_sum <= iv_hs ? IV_TDATA : 0;
      end
    end
  end
end

endmodule
