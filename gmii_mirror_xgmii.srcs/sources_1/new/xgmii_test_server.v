
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details


module xgmii_test_server(
input CLK,
input RESET,
input [47:0] LOCAL_MAC,
input [31:0] LOCAL_IP,
input CLOCK_EN,
input [63:0] RXD_IN,
input [3:0] RXLEN_IN,
output [63:0] TXD_OUT,
output [3:0] TXLEN_OUT,
output [3:0] ECHO_TXLEN_DBG,
output [63:0] ECHO_TXD_DBG,
output [3:0] ARP_TXLEN_DBG,
output [63:0] ARP_TXD_DBG
);

wire [3:0] echo_txlen;
wire [63:0] echo_txd;
wire [3:0] arp_txlen;
wire [63:0] arp_txd;

assign ECHO_TXLEN_DBG = echo_txlen;
assign ECHO_TXD_DBG = echo_txd;
assign ECHO_TXLEN_DBG = echo_txlen;
assign ECHO_TXD_DBG = echo_txd;
assign ARP_TXLEN_DBG = arp_txlen;
assign ARP_TXD_DBG = arp_txd;

xgmii_udp_echo_test echo(.CLK(CLK), .RESET(RESET), .LOCAL_MAC(LOCAL_MAC),
    .LOCAL_IP(LOCAL_IP), .CLOCK_EN(CLOCK_EN), .RXLEN_IN(RXLEN_IN),
    .RXD_IN(RXD_IN), .TXLEN_OUT(echo_txlen), .TXD_OUT(echo_txd));
xgmii_arp_resp arp(.CLK(CLK), .RESET(RESET), .LOCAL_MAC(LOCAL_MAC),
    .LOCAL_IP(LOCAL_IP), .CLOCK_EN(CLOCK_EN), .RXLEN_IN(RXLEN_IN),
    .RXD_IN(RXD_IN), .TXLEN_OUT(arp_txlen), .TXD_OUT(arp_txd));
xgmii_arbiter_exclusive arb(.LEN0_IN(arp_txlen), .D0_IN(arp_txd),
    .LEN1_IN(echo_txlen), .D1_IN(echo_txd), .LEN_OUT(TXLEN_OUT),
    .D_OUT(TXD_OUT));

endmodule

