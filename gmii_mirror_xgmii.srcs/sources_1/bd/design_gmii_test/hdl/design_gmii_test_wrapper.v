//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Sat Oct 13 09:10:57 2018
//Host        : habuild running 64-bit Ubuntu 16.04.5 LTS
//Command     : generate_target design_gmii_test_wrapper.bd
//Design      : design_gmii_test_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_gmii_test_wrapper
   (DEBUG_CLK,
    PHY2_GTX_CLK,
    PHY2_MDC,
    PHY2_MDIO,
    PHY2_RESETN,
    PHY2_RX_CLK,
    PHY2_RX_CTRL,
    PHY2_RX_D,
    PHY2_TX_CTRL,
    PHY2_TX_D,
    default_sysclk_250_clk_n,
    default_sysclk_250_clk_p,
    reset);
  output DEBUG_CLK;
  output PHY2_GTX_CLK;
  output PHY2_MDC;
  inout PHY2_MDIO;
  output [0:0]PHY2_RESETN;
  input PHY2_RX_CLK;
  input PHY2_RX_CTRL;
  input [3:0]PHY2_RX_D;
  output PHY2_TX_CTRL;
  output [3:0]PHY2_TX_D;
  input default_sysclk_250_clk_n;
  input default_sysclk_250_clk_p;
  input reset;

  wire DEBUG_CLK;
  wire PHY2_GTX_CLK;
  wire PHY2_MDC;
  wire PHY2_MDIO;
  wire [0:0]PHY2_RESETN;
  wire PHY2_RX_CLK;
  wire PHY2_RX_CTRL;
  wire [3:0]PHY2_RX_D;
  wire PHY2_TX_CTRL;
  wire [3:0]PHY2_TX_D;
  wire default_sysclk_250_clk_n;
  wire default_sysclk_250_clk_p;
  wire reset;

  design_gmii_test design_gmii_test_i
       (.DEBUG_CLK(DEBUG_CLK),
        .PHY2_GTX_CLK(PHY2_GTX_CLK),
        .PHY2_MDC(PHY2_MDC),
        .PHY2_MDIO(PHY2_MDIO),
        .PHY2_RESETN(PHY2_RESETN),
        .PHY2_RX_CLK(PHY2_RX_CLK),
        .PHY2_RX_CTRL(PHY2_RX_CTRL),
        .PHY2_RX_D(PHY2_RX_D),
        .PHY2_TX_CTRL(PHY2_TX_CTRL),
        .PHY2_TX_D(PHY2_TX_D),
        .default_sysclk_250_clk_n(default_sysclk_250_clk_n),
        .default_sysclk_250_clk_p(default_sysclk_250_clk_p),
        .reset(reset));
endmodule
