
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module get_packet_info(
  CLK, RESETN, XGMII_D, XGMII_LEN, FCS_EN, FCS_CORRECT,
  DATA_TDATA, DATA_TVALID, DATA_TREADY, INFO_TDATA, INFO_TVALID, INFO_TREADY,
  ERR_DROP, ERR_INCOMPLETE, ERR_FCS);
input CLK;
input RESETN;
(* mark_debug = "true" *) input [63:0] XGMII_D;
(* mark_debug = "true" *) input [3:0] XGMII_LEN;
(* mark_debug = "true" *) input FCS_EN;
(* mark_debug = "true" *) input FCS_CORRECT;
(* mark_debug = "true" *) output [63:0] DATA_TDATA;
(* mark_debug = "true" *) output DATA_TVALID;
(* mark_debug = "true" *) input DATA_TREADY;
(* mark_debug = "true" *) output [23:0] INFO_TDATA;
(* mark_debug = "true" *) output INFO_TVALID;
(* mark_debug = "true" *) input INFO_TREADY;
(* mark_debug = "true" *) output ERR_DROP;
(* mark_debug = "true" *) output ERR_INCOMPLETE;
(* mark_debug = "true" *) output ERR_FCS;

reg [63:0] xgmii_d_r;
reg [3:0] xgmii_len_r;
reg [3:0] xgmii_len_rr;
reg packet_drop;       // INFOが詰まってパケット丸ごと落とした
reg [15:0] packet_len; // DATAに送られたパケット長
reg packet_incomplete; // DATAが詰まって不完全になった
reg data_tvalid;
reg [63:0] data_tdata;
reg info_tvalid;
reg [17:0] info_tdata;
reg err_drop;
reg err_incomplete;
reg err_fcs;

wire is_packet_head = xgmii_len_rr != 8 && xgmii_len_r == 8;
wire is_packet_tail = xgmii_len_rr == 8 && xgmii_len_r != 8;
wire fcs_correct = FCS_EN && FCS_CORRECT;
wire data_out_ready = (!data_tvalid) || (DATA_TVALID && DATA_TREADY);
wire info_out_ready = (!info_tvalid) || (INFO_TVALID && INFO_TREADY);
wire [15:0] packet_len_next = packet_len + (data_out_ready ? xgmii_len_r : 0);
wire packet_incomplete_next = packet_incomplete && data_out_ready;

assign DATA_TDATA = data_tdata;
assign DATA_TVALID = data_tvalid;
assign INFO_TDATA = { 6'b0, info_tdata };
assign INFO_TVALID = info_tvalid;
assign ERR_DROP = err_drop;
assign ERR_INCOMPLETE = err_incomplete;
assign ERR_FCS = err_fcs;

always @(posedge CLK) begin
  err_drop <= 0;
  err_incomplete <= 0;
  err_fcs <= 0;
  if (!RESETN) begin
    xgmii_d_r <= 0;
    xgmii_len_r <= 0;
    xgmii_len_rr <= 0;
    packet_drop <= 1;
    packet_len <= 0;
    packet_incomplete <= 0;
    data_tvalid <= 0;
    data_tdata <= 0;
    info_tvalid <= 0;
    info_tdata <= 0;
  end else begin
    xgmii_d_r <= XGMII_D;
    xgmii_len_r <= XGMII_LEN;
    xgmii_len_rr <= xgmii_len_r;
    if (DATA_TVALID && DATA_TREADY) begin
      data_tvalid <= 0;
    end
    if (INFO_TVALID && INFO_TREADY) begin
      info_tvalid <= 0;
    end
    if (is_packet_head) begin
      if (!info_out_ready || !data_out_ready) begin
        err_drop <= 1;
        packet_drop <= 1;
        packet_len <= 0;
        packet_incomplete <= 1;
      end else begin
        packet_drop <= 0;
        packet_len <= xgmii_len_r;
        packet_incomplete <= 0;
        data_tvalid <= 1;
        data_tdata <= xgmii_d_r;
      end
    end else if (is_packet_tail) begin
      if (!packet_drop) begin
        // assert(info_out_ready);
        info_tvalid <= 1;
        info_tdata <= { !packet_incomplete_next, fcs_correct, packet_len_next };
        err_incomplete <= packet_incomplete_next;
        err_fcs <= !fcs_correct;
        if (data_out_ready && xgmii_len_r != 0) begin
          data_tvalid <= 1;
          data_tdata <= xgmii_d_r;
        end
      end
      packet_drop <= 1;
    end else if (!packet_drop) begin
      if (data_out_ready) begin
        packet_len <= packet_len + xgmii_len_r;
        data_tvalid <= 1;
        data_tdata <= xgmii_d_r;
      end else begin
        packet_incomplete <= 1;
      end
    end
  end
end
endmodule

