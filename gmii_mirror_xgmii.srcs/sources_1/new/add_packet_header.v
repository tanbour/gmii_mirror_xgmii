
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

// dataとinfoを読んでheaderを付けて出力する。
module add_packet_header(
  CLK, RESETN, KEEP_ERROR_PACKET,
  DATA_TDATA, DATA_TVALID, DATA_TREADY,
  INFO_TDATA, INFO_TVALID, INFO_TREADY,
  PKT_TDATA, PKT_TVALID, PKT_TREADY, PKT_TLAST);
input CLK;
input RESETN;
input KEEP_ERROR_PACKET;
(* mark_debug = "true" *) input [63:0] DATA_TDATA;
(* mark_debug = "true" *) input DATA_TVALID;
(* mark_debug = "true" *) output DATA_TREADY;
(* mark_debug = "true" *) input [23:0] INFO_TDATA;
(* mark_debug = "true" *) input INFO_TVALID;
(* mark_debug = "true" *) output INFO_TREADY;
(* mark_debug = "true" *) output [63:0] PKT_TDATA;
(* mark_debug = "true" *) output PKT_TVALID;
(* mark_debug = "true" *) input PKT_TREADY;
(* mark_debug = "true" *) output PKT_TLAST;

reg pkt_tvalid;
reg [63:0] pkt_tdata;
reg pkt_tlast;
reg [15:0] len_rest;
reg drop_flag;

wire pkt_out_ready = (!pkt_tvalid) || (PKT_TVALID && PKT_TREADY);

assign INFO_TREADY = (len_rest == 0) && pkt_out_ready;
assign DATA_TREADY = (len_rest != 0) && pkt_out_ready;
assign PKT_TDATA = pkt_tdata;
assign PKT_TVALID = pkt_tvalid;
assign PKT_TLAST = pkt_tlast;

always @(posedge CLK) begin
  if (!RESETN) begin
    pkt_tvalid <= 0;
    pkt_tdata <= 0;
    pkt_tlast <= 0;
    len_rest <= 0;
    drop_flag <= 0;
  end else begin
    if (PKT_TVALID && PKT_TREADY) begin
      pkt_tvalid <= 0;
    end
    if (INFO_TREADY && INFO_TVALID) begin
      len_rest <= INFO_TDATA[15:0];
      if (!KEEP_ERROR_PACKET && INFO_TDATA[17:16] != 3) begin
        // INFO_TDATA[17] : packet complete
        // INFO_TDATA[16] : fcs correct
        drop_flag <= 1; // incomplete or fcs mismatch
      end else begin
        drop_flag <= 0;
        pkt_tvalid <= 1;
        pkt_tdata <= { 32'hdeadbeef, 14'b0, INFO_TDATA[17:0] };
        pkt_tlast <= 0;
      end
    end
    if (DATA_TREADY && DATA_TVALID) begin
      len_rest <= (len_rest >= 8) ? (len_rest - 8) : 0;
      if (!drop_flag) begin
        pkt_tvalid <= 1;
        pkt_tdata <= DATA_TDATA;
        pkt_tlast <= len_rest <= 8;
      end
    end
  end
end

endmodule

