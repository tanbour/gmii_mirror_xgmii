
module sim_gap_fcs();

reg clk;
reg resetn;

initial begin
    clk = 0;
    forever clk = #1 !clk;
end
initial begin
    resetn = 0;
    #10;
    resetn = 1;
end

reg [15:0] packet_len;
reg [63:0] tdata;
reg [3:0] tuser;
reg tlast;
reg tvalid;
reg found_packet_end;

wire tready;
wire [63:0] tdata_f;
wire [3:0] tuser_f;
wire tlast_f;
wire tvalid_f;
wire tready_f;

always @(posedge clk) begin
    if (!resetn) begin
        packet_len <= 0;
        tdata <= 0;
        tuser <= 0;
        tlast <= 0;
        tvalid <= 0;
        found_packet_end <= 0;
    end else begin
        tvalid <= 1;
        found_packet_end <= 0;
        if (tready) begin
            if (packet_len == 0) begin
                packet_len = $unsigned($random) % 32 + 8; /* blocking */
                tuser = 8; /* blocking */
                tdata <= packet_len + tuser;
                tlast <= 0;
                found_packet_end <= 1;
            end else begin
                tuser <= (packet_len >= 8) ? 8 : packet_len;
                tlast <= (packet_len <= 8);
                packet_len <= (packet_len <= 8) ? 0 : (packet_len - 8);
            end
        end
    end
end

axis_fifo #(.WIDTH_DATA(64), .WIDTH_USER(4), .WIDTH_LAST(1), .FIFO_SIZE_L2(0)) axis_fifo_0(
    .CLK(clk), .RESETN(resetn),
    .IV_TDATA(tdata), .IV_TUSER(tuser), .IV_TLAST(tlast), .IV_TVALID(tvalid), .IV_TREADY(tready),
    .OV_TDATA(tdata_f), .OV_TUSER(tuser_f), .OV_TLAST(tlast_f), .OV_TVALID(tvalid_f), .OV_TREADY(tready_f));

wire [63:0] txd_c;
wire [3:0] txlen_c;
wire txhd_c;

xgmii_make_contiguous #(.INTERFRAME_GAP(16)) xgmii_make_contiguous_0(
    .CLK(clk), .RESETN(resetn), .PACKET_END(found_packet_end),
    .IVAL_TDATA(tdata_f), .IVAL_TUSER(tuser_f), .IVAL_TLAST(tlast_f), .IVAL_TVALID(tvalid_f), .IVAL_TREADY(tready_f),
    .OVAL_XGMII_D(txd_c), .OVAL_XGMII_LEN(txlen_c), .OVAL_XGMII_HALFDELAY(txhd_c));

wire [63:0] txd_o;
wire [7:0] txc_o;

xgmii_tx_fcs xg_tx_fcs_0(
    .CLK(clk), .RESET(!resetn), .TXLEN_IN(txlen_c), .TXD_IN(txd_c), .TXHD_IN(txhd_c),
    .TXC_OUT(txc_o), .TXD_OUT(txd_o));

endmodule
