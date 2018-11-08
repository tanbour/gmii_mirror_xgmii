
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module axis_fifo_packed(
  CLK, RESETN,
  IV_TVALID, IV_TREADY, IV_TDATA,
  OV_TVALID, OV_TREADY, OV_TDATA,
  CAP_PUSH, CAP_POP);

// この実装はOV_TREADYが1になってしばらくしてからOV_TVALIDを1にするので
// axi-streamに準拠していない。準拠させるには後ろにaxis_regを入れる。

parameter WIDTH_DATA = 64;
parameter FIFO_SIZE_L2 = 16;
parameter FIFO_DELAY = 2;
localparam FIFO_SIZE = (1 << FIFO_SIZE_L2);
localparam FIFO_SIZE_L2_M1 = FIFO_SIZE_L2 > 0 ? (FIFO_SIZE_L2 - 1) : 0;
localparam WIDTH_DATA_M1 = WIDTH_DATA > 0 ? (WIDTH_DATA - 1) : 0;
localparam FIFO_DELAY_M1 = FIFO_DELAY > 0 ? (FIFO_DELAY - 1) : 0;
localparam WIDTH_DATA_DELAY_M1 =
  (WIDTH_DATA * FIFO_DELAY > 0) ? (WIDTH_DATA * FIFO_DELAY - 1) : 0;

always @(posedge CLK) begin
  if (WIDTH_DATA < 1 || FIFO_SIZE_L2 < 1) begin
    $display("%m invalid param: WIDTH_DATA=%1d FIFO_SIZE_L2=%1d",
        WIDTH_DATA, FIFO_SIZE_L2);
    $stop;
  end
end

input CLK;
input RESETN;
input IV_TVALID;
output IV_TREADY;
input [WIDTH_DATA_M1:0] IV_TDATA;
output OV_TVALID;
input OV_TREADY;
output [WIDTH_DATA_M1:0] OV_TDATA;
output [FIFO_SIZE_L2_M1:0] CAP_PUSH;
output [FIFO_SIZE_L2_M1:0] CAP_POP;

// BRAMは読み出しをリクエストしてから結果が帰ってくるまで遅延があるので
// 読み出しリクエスト位置(ipeek)と読み出しコミット位置(ipop)の2つのオフ
// セットを管理する必要がある。

reg [WIDTH_DATA_M1:0] ram[0:FIFO_SIZE-1]; // BRAMに推論される
reg [WIDTH_DATA_M1:0] ram_wd;
reg ram_wr;
reg [FIFO_SIZE_L2_M1:0] ipush; // 次にpushするオフセット
reg [FIFO_SIZE_L2_M1:0] ipeek; // 次にpeekするオフセット
reg [FIFO_SIZE_L2_M1:0] ipop;  // 次にpopするオフセット
reg [WIDTH_DATA_M1:0] rdata_oreg[0:FIFO_DELAY_M1]; // 出力レジスタ
reg [FIFO_DELAY_M1:0] rvalid_oreg; // 出力レジスタの各エントリが有効かどうか

wire [FIFO_SIZE_L2_M1:0] cap_push = (ipop - 1) - ipush; // push可能な量
wire [FIFO_SIZE_L2_M1:0] cap_peek = ipush - ipeek; // peek可能な量
wire [FIFO_SIZE_L2_M1:0] cap_pop = ipush - ipop; // pop可能な量

assign IV_TREADY = (cap_push > 1);
assign OV_TVALID = rvalid_oreg[0];
assign OV_TDATA = rdata_oreg[0];
assign CAP_PUSH = cap_push;
assign CAP_POP = cap_pop;

integer i;
always @(posedge CLK) begin
  if (!RESETN) begin
    ram_wd <= 0;
    ram_wr <= 0;
    ipush <= 0;
    ipeek <= 0;
    ipop <= 0;
  end else begin
    ram_wd <= IV_TDATA;
    ram_wr <= (IV_TREADY && IV_TVALID);
    ipush <= ipush + ram_wr;
    ipeek <= OV_TREADY ? (ipeek + (cap_peek != 0)) : ipop;
    ipop <= ipop + (OV_TREADY && OV_TVALID);
  end
  if (ram_wr) ram[ipush] <= ram_wd;
  rdata_oreg[FIFO_DELAY_M1] <= ram[ipeek];
  rvalid_oreg[FIFO_DELAY_M1] <= ((cap_peek != 0) && OV_TREADY);
  for (i = 0; i < FIFO_DELAY - 1; i = i + 1) begin
    rdata_oreg[i] <= rdata_oreg[i + 1];
    rvalid_oreg[i] <= rvalid_oreg[i + 1] && OV_TREADY;
  end
end

endmodule
