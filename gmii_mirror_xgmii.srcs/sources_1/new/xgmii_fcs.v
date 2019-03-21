
// Copyright (C) Akira Higuchi  ( https://github.com/ahiguti )
// Copyright (C) DeNA Co.,Ltd. ( https://dena.com )
// All rights reserved.
// See COPYRIGHT.txt for details

module xgmii_fcs(
input CLK,
input RESET,
input [7:0] XGMII_RXC,
input [63:0] XGMII_RXD,
output [7:0] XGMII_TXC,
output [63:0] XGMII_TXD,
output [3:0] RXLEN_OUT,
output [63:0] RXD_OUT,
output FCS_EN,
output FCS_CORRECT,
input [3:0] TXLEN_IN,
input [63:0] TXD_IN,
output [1:0] DEBUG_ALIGN,
output [7:0] DEBUG_RX_FCS,
output [31:0] DEBUG_TX_FCS
);

wire [3:0] rxlen;
wire [63:0] rxd;
wire [31:0] fcs;
wire [31:0] crc32val;

assign FCS_CORRECT = (fcs == crc32val);

xgmii_rx_align xg_align(.CLK(CLK), .RESET(RESET), .XGMII_RXC(XGMII_RXC),
  .XGMII_RXD(XGMII_RXD), .ALGN_RXLEN(rxlen), .ALGN_RXD(rxd),
  .DEBUG_OUT(DEBUG_ALIGN));
xgmii_rx_fcs xg_rxfcs(.CLK(CLK), .RESET(RESET), .RXLEN_IN(rxlen), .RXD_IN(rxd),
  .RXLEN_OUT(RXLEN_OUT), .RXD_OUT(RXD_OUT), .FCS_EN(FCS_EN), .FCS(fcs),
  .CRC32VAL(crc32val), .DEBUG_OUT(DEBUG_RX_FCS));
xgmii_tx_fcs xg_txfcs(.CLK(CLK), .RESET(RESET), .CLOCK_EN(1), .TXLEN_IN(TXLEN_IN),
  .TXD_IN(TXD_IN), .TXHD_IN(0), .TXC_OUT(XGMII_TXC), .TXD_OUT(XGMII_TXD),
  .DEBUG_OUT(DEBUG_TX_FCS));

endmodule
