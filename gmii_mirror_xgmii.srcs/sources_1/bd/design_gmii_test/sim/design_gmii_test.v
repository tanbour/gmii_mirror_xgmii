//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Sat Oct 13 09:10:57 2018
//Host        : habuild running 64-bit Ubuntu 16.04.5 LTS
//Command     : generate_target design_gmii_test.bd
//Design      : design_gmii_test
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ETH1_imp_1E3TQBT
   (PHY1_GTX_CLK,
    PHY1_MDC,
    PHY1_MDIO,
    PHY1_RESETN,
    PHY1_RX_CLK,
    PHY1_RX_CTRL,
    PHY1_RX_D,
    PHY1_TX_CTRL,
    PHY1_TX_D,
    default_sysclk_250_clk_n,
    default_sysclk_250_clk_p,
    reset);
  output PHY1_GTX_CLK;
  output PHY1_MDC;
  inout PHY1_MDIO;
  output [0:0]PHY1_RESETN;
  input PHY1_RX_CLK;
  input PHY1_RX_CTRL;
  input [3:0]PHY1_RX_D;
  output PHY1_TX_CTRL;
  output [3:0]PHY1_TX_D;
  input default_sysclk_250_clk_n;
  input default_sysclk_250_clk_p;
  input reset;

  wire CE_1;
  wire CLK_1;
  wire Conn1_CLK_N;
  wire Conn1_CLK_P;
  wire Net;
  wire PHY1_RX_CLK_1;
  wire PHY1_RX_CTRL_1;
  wire [3:0]PHY1_RX_D_1;
  wire [31:0]address_mac_ip_0_IP_ADDR;
  wire [47:0]address_mac_ip_0_MAC_ADDR;
  wire clk_wiz_0_locked;
  wire eth_phy_ctrl_0_MDC;
  wire [7:0]fifo_generator_0_m_axis_tdata;
  wire fifo_generator_0_m_axis_tvalid;
  wire fifo_read_throttle_0_CTRL_OUT;
  wire [7:0]fifo_read_throttle_0_DATA_OUT;
  wire fifo_read_throttle_0_READ_EN_OUT;
  wire gmii_rx_fcs_0_RXC_OUT;
  wire [7:0]gmii_rx_fcs_0_RXD_OUT;
  wire gmii_to_rgmii_0_TX_CTRL_OUT;
  wire [3:0]gmii_to_rgmii_0_TX_D_OUT;
  wire [63:0]gmii_to_xgmil_0_RXD_OUT;
  wire [3:0]gmii_to_xgmil_0_RXLEN_OUT;
  wire gmii_tx_fcs_0_GMII_TX_CTRL;
  wire [7:0]gmii_tx_fcs_0_GMII_TX_D;
  wire gmii_tx_fcs_0_GMII_TX_ERR;
  wire [0:0]proc_sys_reset_0_interconnect_aresetn;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;
  wire [0:0]proc_sys_reset_0_peripheral_reset;
  wire [0:0]proc_sys_reset_1_peripheral_aresetn;
  wire [0:0]proc_sys_reset_1_peripheral_reset;
  wire reset_1;
  wire rgmii_to_gmii_0_GMII_CTRL_OUT;
  wire [7:0]rgmii_to_gmii_0_GMII_D_OUT;
  wire [63:0]xgmii_test_server_0_TXD_OUT;
  wire [3:0]xgmii_test_server_0_TXLEN_OUT;
  wire xgmii_to_gmii_0_TX_CTRL_OUT;
  wire [7:0]xgmii_to_gmii_0_TX_D_OUT;

  assign Conn1_CLK_N = default_sysclk_250_clk_n;
  assign Conn1_CLK_P = default_sysclk_250_clk_p;
  assign PHY1_GTX_CLK = CLK_1;
  assign PHY1_MDC = eth_phy_ctrl_0_MDC;
  assign PHY1_RESETN[0] = proc_sys_reset_1_peripheral_aresetn;
  assign PHY1_RX_CLK_1 = PHY1_RX_CLK;
  assign PHY1_RX_CTRL_1 = PHY1_RX_CTRL;
  assign PHY1_RX_D_1 = PHY1_RX_D[3:0];
  assign PHY1_TX_CTRL = gmii_to_rgmii_0_TX_CTRL_OUT;
  assign PHY1_TX_D[3:0] = gmii_to_rgmii_0_TX_D_OUT;
  assign reset_1 = reset;
  design_gmii_test_address_mac_ip_0_0 address_mac_ip_0
       (.IP_ADDR(address_mac_ip_0_IP_ADDR),
        .MAC_ADDR(address_mac_ip_0_MAC_ADDR));
  design_gmii_test_clk_wiz_0_0 clk_wiz_0
       (.clk_125(CLK_1),
        .clk_in1_n(Conn1_CLK_N),
        .clk_in1_p(Conn1_CLK_P),
        .locked(clk_wiz_0_locked),
        .reset(reset_1));
  design_gmii_test_eth_phy_ctrl_0_0 eth_phy_ctrl_0
       (.MDC(eth_phy_ctrl_0_MDC),
        .MDIO(PHY1_MDIO),
        .RX_CLK(PHY1_RX_CLK_1),
        .RX_CTRL(PHY1_RX_CTRL_1),
        .RX_D(PHY1_RX_D_1));
  design_gmii_test_fifo_generator_0_0 fifo_generator_0
       (.m_aclk(CLK_1),
        .m_axis_tdata(fifo_generator_0_m_axis_tdata),
        .m_axis_tready(fifo_read_throttle_0_READ_EN_OUT),
        .m_axis_tvalid(fifo_generator_0_m_axis_tvalid),
        .s_aclk(PHY1_RX_CLK_1),
        .s_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axis_tdata(xgmii_to_gmii_0_TX_D_OUT),
        .s_axis_tvalid(xgmii_to_gmii_0_TX_CTRL_OUT));
  design_gmii_test_fifo_read_throttle_0_0 fifo_read_throttle_0
       (.CLK(CLK_1),
        .CTRL_OUT(fifo_read_throttle_0_CTRL_OUT),
        .DATA_IN(fifo_generator_0_m_axis_tdata),
        .DATA_OUT(fifo_read_throttle_0_DATA_OUT),
        .READ_EN_OUT(fifo_read_throttle_0_READ_EN_OUT),
        .RESET(proc_sys_reset_1_peripheral_reset),
        .VALID_IN(fifo_generator_0_m_axis_tvalid));
  design_gmii_test_gmii_rx_fcs_0_0 gmii_rx_fcs_0
       (.CLK(PHY1_RX_CLK_1),
        .RESETN(proc_sys_reset_0_peripheral_aresetn),
        .RXC_IN(rgmii_to_gmii_0_GMII_CTRL_OUT),
        .RXC_OUT(gmii_rx_fcs_0_RXC_OUT),
        .RXD_IN(rgmii_to_gmii_0_GMII_D_OUT),
        .RXD_OUT(gmii_rx_fcs_0_RXD_OUT));
  design_gmii_test_gmii_to_rgmii_0_0 gmii_to_rgmii_0
       (.CLK(CLK_1),
        .RESET(proc_sys_reset_1_peripheral_reset),
        .TX_CTRL_IN(gmii_tx_fcs_0_GMII_TX_CTRL),
        .TX_CTRL_OUT(gmii_to_rgmii_0_TX_CTRL_OUT),
        .TX_D_IN(gmii_tx_fcs_0_GMII_TX_D),
        .TX_D_OUT(gmii_to_rgmii_0_TX_D_OUT),
        .TX_ERR_IN(gmii_tx_fcs_0_GMII_TX_ERR));
  design_gmii_test_gmii_to_xgmil_0_0 gmii_to_xgmil_0
       (.CE_OUT(CE_1),
        .CLK(PHY1_RX_CLK_1),
        .RESETN(proc_sys_reset_0_peripheral_aresetn),
        .RXC_IN(gmii_rx_fcs_0_RXC_OUT),
        .RXD_IN(gmii_rx_fcs_0_RXD_OUT),
        .RXD_OUT(gmii_to_xgmil_0_RXD_OUT),
        .RXLEN_OUT(gmii_to_xgmil_0_RXLEN_OUT));
  design_gmii_test_gmii_tx_fcs_0_0 gmii_tx_fcs_0
       (.CLK(CLK_1),
        .GMII_TX_CTRL(gmii_tx_fcs_0_GMII_TX_CTRL),
        .GMII_TX_D(gmii_tx_fcs_0_GMII_TX_D),
        .GMII_TX_ERR(gmii_tx_fcs_0_GMII_TX_ERR),
        .RESETN(proc_sys_reset_1_peripheral_aresetn),
        .TXCTRL_IN(fifo_read_throttle_0_CTRL_OUT),
        .TXD_IN(fifo_read_throttle_0_DATA_OUT));
  design_gmii_test_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .interconnect_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .peripheral_reset(proc_sys_reset_0_peripheral_reset),
        .slowest_sync_clk(PHY1_RX_CLK_1));
  design_gmii_test_proc_sys_reset_1_0 proc_sys_reset_1
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_1_peripheral_aresetn),
        .peripheral_reset(proc_sys_reset_1_peripheral_reset),
        .slowest_sync_clk(CLK_1));
  design_gmii_test_rgmii_to_gmii_0_0 rgmii_to_gmii_0
       (.CLK(PHY1_RX_CLK_1),
        .GMII_CTRL_OUT(rgmii_to_gmii_0_GMII_CTRL_OUT),
        .GMII_D_OUT(rgmii_to_gmii_0_GMII_D_OUT),
        .RGMII_CTRL_IN(PHY1_RX_CTRL_1),
        .RGMII_D_IN(PHY1_RX_D_1));
  design_gmii_test_xgmii_test_server_0_0 xgmii_test_server_0
       (.CLK(PHY1_RX_CLK_1),
        .CLOCK_EN(CE_1),
        .LOCAL_IP(address_mac_ip_0_IP_ADDR),
        .LOCAL_MAC(address_mac_ip_0_MAC_ADDR),
        .RESET(proc_sys_reset_0_peripheral_reset),
        .RXD_IN(gmii_to_xgmil_0_RXD_OUT),
        .RXLEN_IN(gmii_to_xgmil_0_RXLEN_OUT),
        .TXD_OUT(xgmii_test_server_0_TXD_OUT),
        .TXLEN_OUT(xgmii_test_server_0_TXLEN_OUT));
  design_gmii_test_xgmii_to_gmii_0_0 xgmii_to_gmii_0
       (.CLK(PHY1_RX_CLK_1),
        .CLOCK_EN(CE_1),
        .RESETN(proc_sys_reset_0_peripheral_aresetn),
        .TXD_IN(xgmii_test_server_0_TXD_OUT),
        .TXLEN_IN(xgmii_test_server_0_TXLEN_OUT),
        .TX_CTRL_OUT(xgmii_to_gmii_0_TX_CTRL_OUT),
        .TX_D_OUT(xgmii_to_gmii_0_TX_D_OUT));
endmodule

(* CORE_GENERATION_INFO = "design_gmii_test,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_gmii_test,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=15,numReposBlks=14,numNonXlnxBlks=0,numHierBlks=1,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=10,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_gmii_test.hwdef" *) 
module design_gmii_test
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.DEBUG_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.DEBUG_CLK, CLK_DOMAIN design_gmii_test_PHY2_RX_CLK, FREQ_HZ 125000000, PHASE 0.000" *) output DEBUG_CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY2_GTX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY2_GTX_CLK, CLK_DOMAIN design_gmii_test_clk_wiz_0_0_clk_125, FREQ_HZ 125000000, PHASE 0.0" *) output PHY2_GTX_CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY2_MDC CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY2_MDC, FREQ_HZ 100000000, PHASE 0.000" *) output PHY2_MDC;
  inout PHY2_MDIO;
  output [0:0]PHY2_RESETN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY2_RX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY2_RX_CLK, CLK_DOMAIN design_gmii_test_PHY2_RX_CLK, FREQ_HZ 125000000, PHASE 0.000" *) input PHY2_RX_CLK;
  input PHY2_RX_CTRL;
  input [3:0]PHY2_RX_D;
  output PHY2_TX_CTRL;
  output [3:0]PHY2_TX_D;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_250 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk_250, CAN_DEBUG false, FREQ_HZ 250000000" *) input default_sysclk_250_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_250 CLK_P" *) input default_sysclk_250_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, POLARITY ACTIVE_HIGH" *) input reset;

  wire ETH1_PHY1_MDC;
  wire ETH1_PHY1_TX_CTRL;
  wire [3:0]ETH1_PHY1_TX_D;
  wire Net;
  wire PHY1_RX_CLK_1;
  wire RGMII_CTRL_IN_1;
  wire [3:0]RGMII_D_IN_1;
  wire clk_wiz_0_clk_125;
  wire default_sysclk_250_1_CLK_N;
  wire default_sysclk_250_1_CLK_P;
  wire [0:0]proc_sys_reset_1_peripheral_aresetn;
  wire reset_1;

  assign DEBUG_CLK = PHY1_RX_CLK_1;
  assign PHY1_RX_CLK_1 = PHY2_RX_CLK;
  assign PHY2_GTX_CLK = clk_wiz_0_clk_125;
  assign PHY2_MDC = ETH1_PHY1_MDC;
  assign PHY2_RESETN[0] = proc_sys_reset_1_peripheral_aresetn;
  assign PHY2_TX_CTRL = ETH1_PHY1_TX_CTRL;
  assign PHY2_TX_D[3:0] = ETH1_PHY1_TX_D;
  assign RGMII_CTRL_IN_1 = PHY2_RX_CTRL;
  assign RGMII_D_IN_1 = PHY2_RX_D[3:0];
  assign default_sysclk_250_1_CLK_N = default_sysclk_250_clk_n;
  assign default_sysclk_250_1_CLK_P = default_sysclk_250_clk_p;
  assign reset_1 = reset;
  ETH1_imp_1E3TQBT ETH1
       (.PHY1_GTX_CLK(clk_wiz_0_clk_125),
        .PHY1_MDC(ETH1_PHY1_MDC),
        .PHY1_MDIO(PHY2_MDIO),
        .PHY1_RESETN(proc_sys_reset_1_peripheral_aresetn),
        .PHY1_RX_CLK(PHY1_RX_CLK_1),
        .PHY1_RX_CTRL(RGMII_CTRL_IN_1),
        .PHY1_RX_D(RGMII_D_IN_1),
        .PHY1_TX_CTRL(ETH1_PHY1_TX_CTRL),
        .PHY1_TX_D(ETH1_PHY1_TX_D),
        .default_sysclk_250_clk_n(default_sysclk_250_1_CLK_N),
        .default_sysclk_250_clk_p(default_sysclk_250_1_CLK_P),
        .reset(reset_1));
endmodule
