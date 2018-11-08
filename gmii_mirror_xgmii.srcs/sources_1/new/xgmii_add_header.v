
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co., Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module xgmii_add_header(
  CLK, RESETN, XGMII_D, XGMII_LEN, FCS_EN, FCS_CORRECT,
  PKT_TDATA, PKT_TVALID, PKT_TLAST, PKT_CAP_PUSH,
  ERR_LONG, ERR_FCS, ERR_FULL, CLEAR_ERR, DBG_HIDX, DBG_HDATA);
input CLK;
input RESETN;
input [63:0] XGMII_D; // XGMII RXD or TXD
input [3:0] XGMII_LEN; // XGMII_D のうち有効なバイト数
input FCS_EN; // FCS計算が完了
input FCS_CORRECT; // FCS_ENが真のときFCSが正しかったかどうかを示す
output [63:0] PKT_TDATA; // ヘッダ付きパケット出力 (axis)
output PKT_TVALID; // パケット末尾までは連続で真になることが保証される (axis)
output PKT_TLAST; // パケットの末尾のとき真 (axis)
input [11:0] PKT_CAP_PUSH;
output [7:0] ERR_LONG;
output [7:0] ERR_FCS;
output [7:0] ERR_FULL;
input CLEAR_ERR;
output [10:0] DBG_HIDX;
output [15:0] DBG_HDATA;

reg [63:0] xgmii_d_r; // XGMII_D一回レジスタ
reg [63:0] xgmii_d_rr;
reg [3:0] xgmii_len_r; // XGMII_LEN一回レジスタ
reg [3:0] xgmii_len_rr;
reg rx_fcs_match_r;
reg [10:0] rd_offset; // フレームデータを読み出すオフセット
reg [10:0] wr_offset; // フレームデータを書き込むオフセット
reg [10:0] hdr_offset; // 現在処理中のフレームのヘッダを書き込むべきオフセット
reg enable_out; // リングバッファ一周したかどうか
reg [13:0] pkt_size; // 現在処理中のフレームのサイズ
reg [10:0] buf_widx; // 次サイクルでbufferに書き込む位置
reg [65:0] buf_wdata; // 次サイクルでbufferに書き込む内容
reg [65:0] buffer[0:2047]; // フレームを保存するリングバッファ(BRAM)
reg [10:0] hbuf_widx; // 次サイクルでhbufferに書き込む位置
reg [15:0] hbuf_wdata; // 次サイクルでhbufferに書き込む内容
reg [15:0] hbuffer[0:2047]; // ヘッダを保存するリングバッファ(BRAM)
reg [65:0] buf_rdata[0:2]; // bufferから読み出し後のシフトレジスタ
reg [15:0] buf_rhdr[0:2]; // hbufferから読み出し後のシフトレジスタ
reg enable_pkt; // フレームを出力するか落とすか
reg [63:0] pkt_tdata;
reg pkt_tvalid;
reg pkt_tlast;
reg [7:0] err_long;
reg [7:0] err_fcs;
reg [7:0] err_full;

wire is_rr_rxlast =
  (xgmii_len_rr > 0 && xgmii_len_rr < 8) ? 1 : (xgmii_len_rr == 8 && xgmii_len_r == 0);
  // 今のxgmii_d_rrがフレームの末尾
wire is_rr_gaplast = (xgmii_len_rr == 0 && xgmii_len_r != 0);
  // 今のxgmii_d_rrがgapの末尾で次がフレームの先頭
wire [13:0] pkt_size_next = pkt_size + xgmii_len_rr;
wire [65:0] rdata1 = buf_rdata[1];
wire [65:0] rdata2 = buf_rdata[2];
wire [15:0] rhdr1 = buf_rhdr[1];
wire rdata1_valid = rdata1[64];
wire rdata2_valid = rdata2[64];
wire pkt_cap_ready = (PKT_CAP_PUSH > 2000);

assign PKT_TDATA = pkt_tdata;
assign PKT_TVALID = pkt_tvalid;
assign PKT_TLAST = pkt_tlast;
assign ERR_LONG = err_long;
assign ERR_FCS = err_fcs;
assign ERR_FULL = err_full;
assign DBG_HIDX = hbuf_widx;
assign DBG_HDATA = hbuf_wdata;

integer i;
always @(posedge CLK) begin
  if (!RESETN) begin
    xgmii_d_r <= 0;
    xgmii_d_rr <= 0;
    xgmii_len_r <= 0;
    xgmii_len_rr <= 0;
    rx_fcs_match_r <= 0;
    rd_offset <= 2;
    wr_offset <= 1;
    hdr_offset <= 0;
    enable_out <= 0;
    pkt_size <= 0;
    buf_widx <= 0;
    buf_wdata <= 0;
    hbuf_widx <= 0;
    hbuf_wdata <= 0;
    buf_rdata[0] <= 0;
    buf_rdata[1] <= 0;
    buf_rdata[2] <= 0;
    buf_rhdr[0] <= 0;
    buf_rhdr[1] <= 0;
    buf_rhdr[2] <= 0;
    enable_pkt <= 0;
    pkt_tdata <= 0;
    pkt_tvalid <= 0;
    pkt_tlast <= 0;
    err_long <= 0;
    err_fcs <= 0;
    err_full <= 0;
  end else begin
    xgmii_d_r <= XGMII_D;
    xgmii_d_rr <= xgmii_d_r;
    xgmii_len_r <= XGMII_LEN;
    xgmii_len_rr <= xgmii_len_r;
    rx_fcs_match_r <= FCS_EN && FCS_CORRECT;
    rd_offset <= rd_offset + 1;
    wr_offset <= rd_offset; // 常にrd_offsetのひとつ後ろ
    buf_widx <= wr_offset;
    buf_wdata <= { is_rr_rxlast, (xgmii_len_rr != 0), xgmii_d_rr[63:0] };
    buffer[buf_widx] <= buf_wdata;
    pkt_size <= pkt_size_next;
    if (is_rr_gaplast) begin
      hdr_offset <= rd_offset; // == wr_offset + 1
      hbuf_widx <= rd_offset;
      hbuf_wdata <= 0; // ヘッダを0クリア
      pkt_size <= 0;
    end else if (is_rr_rxlast) begin
      hbuf_widx <= hdr_offset;
      hbuf_wdata <= pkt_size_next;
      if (!rx_fcs_match_r) begin
        hbuf_wdata <= 16'hffff;
      end
    end
    hbuffer[hbuf_widx] <= hbuf_wdata;
    enable_out <= enable_out | (wr_offset == 0); // 一周してから出力開始する
    buffer[buf_widx] <= buf_wdata;
    buf_rdata[0] <= buffer[rd_offset];
    buf_rhdr[0] <= hbuffer[rd_offset];
    buf_rdata[1] <= buf_rdata[0];
    buf_rhdr[1] <= buf_rhdr[0];
    buf_rdata[2] <= buf_rdata[1];
    buf_rhdr[2] <= buf_rhdr[1];
    if (!rdata2_valid && rdata1_valid) begin // packet head
      pkt_tdata <= 0;
      pkt_tvalid <= 0;
      pkt_tlast <= 0;
      enable_pkt <= 0;
      if (rhdr1[15:0] == 0) begin
        err_long <= (err_long < 255) ? err_long + 1 : 255;
      end else  if (rhdr1[15:0] == 16'hffff) begin
        err_fcs <= (err_fcs < 255) ? err_fcs + 1 : 255;
      end else if (!pkt_cap_ready) begin
        err_full <= (err_full < 255) ? err_full + 1 : 255;
      end else if (enable_out) begin
        pkt_tdata <= { 48'hdeadbeef0000, rhdr1[15:0] };
        pkt_tvalid <= 1;
        enable_pkt <= 1;
      end
    end else if (enable_pkt) begin // packet body, enabled
      pkt_tdata <= rdata2[63:0];
      pkt_tvalid <= rdata2[64];
      pkt_tlast <= rdata2[65];
    end else begin // packet body, disabled
      pkt_tdata <= 0;
      pkt_tvalid <= 0;
      pkt_tlast <= 0;
    end
    if (CLEAR_ERR) begin
      err_long <= 0;
      err_fcs <= 0;
      err_full <= 0;
    end
  end
end

endmodule
