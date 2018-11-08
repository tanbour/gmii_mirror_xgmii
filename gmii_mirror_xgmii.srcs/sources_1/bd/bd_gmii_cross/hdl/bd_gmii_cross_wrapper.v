//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Fri Oct 26 04:18:19 2018
//Host        : habuild running 64-bit Ubuntu 16.04.5 LTS
//Command     : generate_target bd_gmii_cross_wrapper.bd
//Design      : bd_gmii_cross_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_gmii_cross_wrapper
   (DEBUG_CLK,
    MGTCLK0_clk_n,
    MGTCLK0_clk_p,
    PHY1_GTX_CLK,
    PHY1_MDC,
    PHY1_MDIO,
    PHY1_RESETN,
    PHY1_RX_CLK,
    PHY1_RX_CTRL,
    PHY1_RX_D,
    PHY1_TX_CTRL,
    PHY1_TX_D,
    PHY2_GTX_CLK,
    PHY2_MDC,
    PHY2_MDIO,
    PHY2_RESETN,
    PHY2_RX_CLK,
    PHY2_RX_CTRL,
    PHY2_RX_D,
    PHY2_TX_CTRL,
    PHY2_TX_D,
    SFP1_RX_LOS,
    SFP1_RX_N,
    SFP1_RX_P,
    SFP1_TX_DISABLE,
    SFP1_TX_N,
    SFP1_TX_P,
    default_sysclk_250_clk_n,
    default_sysclk_250_clk_p,
    reset);
  output DEBUG_CLK;
  input MGTCLK0_clk_n;
  input MGTCLK0_clk_p;
  output PHY1_GTX_CLK;
  output PHY1_MDC;
  inout PHY1_MDIO;
  output [0:0]PHY1_RESETN;
  input PHY1_RX_CLK;
  input PHY1_RX_CTRL;
  input [3:0]PHY1_RX_D;
  output PHY1_TX_CTRL;
  output [3:0]PHY1_TX_D;
  output PHY2_GTX_CLK;
  output PHY2_MDC;
  inout PHY2_MDIO;
  output [0:0]PHY2_RESETN;
  input PHY2_RX_CLK;
  input PHY2_RX_CTRL;
  input [3:0]PHY2_RX_D;
  output PHY2_TX_CTRL;
  output [3:0]PHY2_TX_D;
  input SFP1_RX_LOS;
  input SFP1_RX_N;
  input SFP1_RX_P;
  output SFP1_TX_DISABLE;
  output SFP1_TX_N;
  output SFP1_TX_P;
  input default_sysclk_250_clk_n;
  input default_sysclk_250_clk_p;
  input reset;

  wire DEBUG_CLK;
  wire MGTCLK0_clk_n;
  wire MGTCLK0_clk_p;
  wire PHY1_GTX_CLK;
  wire PHY1_MDC;
  wire PHY1_MDIO;
  wire [0:0]PHY1_RESETN;
  wire PHY1_RX_CLK;
  wire PHY1_RX_CTRL;
  wire [3:0]PHY1_RX_D;
  wire PHY1_TX_CTRL;
  wire [3:0]PHY1_TX_D;
  wire PHY2_GTX_CLK;
  wire PHY2_MDC;
  wire PHY2_MDIO;
  wire [0:0]PHY2_RESETN;
  wire PHY2_RX_CLK;
  wire PHY2_RX_CTRL;
  wire [3:0]PHY2_RX_D;
  wire PHY2_TX_CTRL;
  wire [3:0]PHY2_TX_D;
  wire SFP1_RX_LOS;
  wire SFP1_RX_N;
  wire SFP1_RX_P;
  wire SFP1_TX_DISABLE;
  wire SFP1_TX_N;
  wire SFP1_TX_P;
  wire default_sysclk_250_clk_n;
  wire default_sysclk_250_clk_p;
  wire reset;

  bd_gmii_cross bd_gmii_cross_i
       (.DEBUG_CLK(DEBUG_CLK),
        .MGTCLK0_clk_n(MGTCLK0_clk_n),
        .MGTCLK0_clk_p(MGTCLK0_clk_p),
        .PHY1_GTX_CLK(PHY1_GTX_CLK),
        .PHY1_MDC(PHY1_MDC),
        .PHY1_MDIO(PHY1_MDIO),
        .PHY1_RESETN(PHY1_RESETN),
        .PHY1_RX_CLK(PHY1_RX_CLK),
        .PHY1_RX_CTRL(PHY1_RX_CTRL),
        .PHY1_RX_D(PHY1_RX_D),
        .PHY1_TX_CTRL(PHY1_TX_CTRL),
        .PHY1_TX_D(PHY1_TX_D),
        .PHY2_GTX_CLK(PHY2_GTX_CLK),
        .PHY2_MDC(PHY2_MDC),
        .PHY2_MDIO(PHY2_MDIO),
        .PHY2_RESETN(PHY2_RESETN),
        .PHY2_RX_CLK(PHY2_RX_CLK),
        .PHY2_RX_CTRL(PHY2_RX_CTRL),
        .PHY2_RX_D(PHY2_RX_D),
        .PHY2_TX_CTRL(PHY2_TX_CTRL),
        .PHY2_TX_D(PHY2_TX_D),
        .SFP1_RX_LOS(SFP1_RX_LOS),
        .SFP1_RX_N(SFP1_RX_N),
        .SFP1_RX_P(SFP1_RX_P),
        .SFP1_TX_DISABLE(SFP1_TX_DISABLE),
        .SFP1_TX_N(SFP1_TX_N),
        .SFP1_TX_P(SFP1_TX_P),
        .default_sysclk_250_clk_n(default_sysclk_250_clk_n),
        .default_sysclk_250_clk_p(default_sysclk_250_clk_p),
        .reset(reset));
endmodule
