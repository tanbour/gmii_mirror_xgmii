//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
//Date        : Fri Mar 22 04:47:59 2019
//Host        : habuild running 64-bit Ubuntu 16.04.6 LTS
//Command     : generate_target bd_gmii_cross.bd
//Design      : bd_gmii_cross
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module RX1_TX2_imp_OO4UAT
   (GMII_CTRL,
    GMII_D,
    MDC,
    MDIO,
    RX_CLK,
    RX_CTRL,
    RX_D,
    TX_CTRL,
    TX_D,
    clk_125,
    dcm_locked,
    reset,
    reset_125);
  output GMII_CTRL;
  output [7:0]GMII_D;
  output MDC;
  inout MDIO;
  input RX_CLK;
  input RX_CTRL;
  input [3:0]RX_D;
  output TX_CTRL;
  output [3:0]TX_D;
  input clk_125;
  input dcm_locked;
  input reset;
  input reset_125;

  wire CLK_1;
  wire Net;
  wire PHY1_RX_CLK_1;
  wire PHY1_RX_CTRL_1;
  wire [3:0]PHY1_RX_D_1;
  wire clk_wiz_0_locked;
  wire eth_phy_ctrl_0_MDC;
  wire [7:0]fifo_generator_0_m_axis_tdata;
  wire fifo_generator_0_m_axis_tvalid;
  wire fifo_read_throttle_0_CTRL_OUT;
  wire [7:0]fifo_read_throttle_0_DATA_OUT;
  wire fifo_read_throttle_0_READ_EN_OUT;
  wire gmii_to_rgmii_0_TX_CTRL_OUT;
  wire [3:0]gmii_to_rgmii_0_TX_D_OUT;
  wire [0:0]proc_sys_reset_0_interconnect_aresetn;
  wire proc_sys_reset_1_peripheral_reset;
  wire reset_1;
  wire rgmii_to_gmii_0_GMII_CTRL_OUT;
  wire [7:0]rgmii_to_gmii_0_GMII_D_OUT;
  wire [0:0]xlconstant_0_dout;

  assign CLK_1 = clk_125;
  assign GMII_CTRL = fifo_read_throttle_0_CTRL_OUT;
  assign GMII_D[7:0] = fifo_read_throttle_0_DATA_OUT;
  assign MDC = eth_phy_ctrl_0_MDC;
  assign PHY1_RX_CLK_1 = RX_CLK;
  assign PHY1_RX_CTRL_1 = RX_CTRL;
  assign PHY1_RX_D_1 = RX_D[3:0];
  assign TX_CTRL = gmii_to_rgmii_0_TX_CTRL_OUT;
  assign TX_D[3:0] = gmii_to_rgmii_0_TX_D_OUT;
  assign clk_wiz_0_locked = dcm_locked;
  assign proc_sys_reset_1_peripheral_reset = reset_125;
  assign reset_1 = reset;
  bd_gmii_cross_eth_phy_ctrl_0_0 eth_phy_ctrl_0
       (.MDC(eth_phy_ctrl_0_MDC),
        .MDIO(MDIO));
  bd_gmii_cross_fifo_generator_0_1 fifo_generator_0
       (.m_aclk(CLK_1),
        .m_axis_tdata(fifo_generator_0_m_axis_tdata),
        .m_axis_tready(fifo_read_throttle_0_READ_EN_OUT),
        .m_axis_tvalid(fifo_generator_0_m_axis_tvalid),
        .s_aclk(PHY1_RX_CLK_1),
        .s_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axis_tdata(rgmii_to_gmii_0_GMII_D_OUT),
        .s_axis_tvalid(rgmii_to_gmii_0_GMII_CTRL_OUT));
  bd_gmii_cross_fifo_read_throttle_0_0 fifo_read_throttle_0
       (.CLK(CLK_1),
        .CTRL_OUT(fifo_read_throttle_0_CTRL_OUT),
        .DATA_IN(fifo_generator_0_m_axis_tdata),
        .DATA_OUT(fifo_read_throttle_0_DATA_OUT),
        .READ_EN_OUT(fifo_read_throttle_0_READ_EN_OUT),
        .RESET(proc_sys_reset_1_peripheral_reset),
        .VALID_IN(fifo_generator_0_m_axis_tvalid));
  bd_gmii_cross_gmii_to_rgmii_0_0 gmii_to_rgmii_0
       (.CLK(CLK_1),
        .RESET(proc_sys_reset_1_peripheral_reset),
        .TX_CTRL_IN(fifo_read_throttle_0_CTRL_OUT),
        .TX_CTRL_OUT(gmii_to_rgmii_0_TX_CTRL_OUT),
        .TX_D_IN(fifo_read_throttle_0_DATA_OUT),
        .TX_D_OUT(gmii_to_rgmii_0_TX_D_OUT),
        .TX_ERR_IN(xlconstant_0_dout));
  bd_gmii_cross_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .interconnect_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(PHY1_RX_CLK_1));
  bd_gmii_cross_rgmii_to_gmii_0_0 rgmii_to_gmii_0
       (.CLK(PHY1_RX_CLK_1),
        .GMII_CTRL_OUT(rgmii_to_gmii_0_GMII_CTRL_OUT),
        .GMII_D_OUT(rgmii_to_gmii_0_GMII_D_OUT),
        .RGMII_CTRL_IN(PHY1_RX_CTRL_1),
        .RGMII_D_IN(PHY1_RX_D_1));
  bd_gmii_cross_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
endmodule

module RX2_TX1_imp_1L684IK
   (GMII_CTRL,
    GMII_D,
    MDC,
    MDIO,
    RX_CLK,
    RX_CTRL,
    RX_D,
    TX_CTRL,
    TX_D,
    clk_125,
    dcm_locked,
    reset,
    reset_125);
  output GMII_CTRL;
  output [7:0]GMII_D;
  output MDC;
  inout MDIO;
  input RX_CLK;
  input RX_CTRL;
  input [3:0]RX_D;
  output TX_CTRL;
  output [3:0]TX_D;
  input clk_125;
  input dcm_locked;
  input reset;
  input reset_125;

  wire CLK_1;
  wire Net;
  wire PHY1_RX_CLK_1;
  wire PHY1_RX_CTRL_1;
  wire [3:0]PHY1_RX_D_1;
  wire clk_wiz_0_locked;
  wire eth_phy_ctrl_0_MDC;
  wire [7:0]fifo_generator_0_m_axis_tdata;
  wire fifo_generator_0_m_axis_tvalid;
  wire fifo_read_throttle_0_CTRL_OUT;
  wire [7:0]fifo_read_throttle_0_DATA_OUT;
  wire fifo_read_throttle_0_READ_EN_OUT;
  wire gmii_to_rgmii_0_TX_CTRL_OUT;
  wire [3:0]gmii_to_rgmii_0_TX_D_OUT;
  wire [0:0]proc_sys_reset_0_interconnect_aresetn;
  wire proc_sys_reset_1_peripheral_reset;
  wire reset_1;
  wire rgmii_to_gmii_0_GMII_CTRL_OUT;
  wire [7:0]rgmii_to_gmii_0_GMII_D_OUT;
  wire [0:0]xlconstant_0_dout;

  assign CLK_1 = clk_125;
  assign GMII_CTRL = fifo_read_throttle_0_CTRL_OUT;
  assign GMII_D[7:0] = fifo_read_throttle_0_DATA_OUT;
  assign MDC = eth_phy_ctrl_0_MDC;
  assign PHY1_RX_CLK_1 = RX_CLK;
  assign PHY1_RX_CTRL_1 = RX_CTRL;
  assign PHY1_RX_D_1 = RX_D[3:0];
  assign TX_CTRL = gmii_to_rgmii_0_TX_CTRL_OUT;
  assign TX_D[3:0] = gmii_to_rgmii_0_TX_D_OUT;
  assign clk_wiz_0_locked = dcm_locked;
  assign proc_sys_reset_1_peripheral_reset = reset_125;
  assign reset_1 = reset;
  bd_gmii_cross_eth_phy_ctrl_0_1 eth_phy_ctrl_0
       (.MDC(eth_phy_ctrl_0_MDC),
        .MDIO(MDIO));
  bd_gmii_cross_fifo_generator_0_2 fifo_generator_0
       (.m_aclk(CLK_1),
        .m_axis_tdata(fifo_generator_0_m_axis_tdata),
        .m_axis_tready(fifo_read_throttle_0_READ_EN_OUT),
        .m_axis_tvalid(fifo_generator_0_m_axis_tvalid),
        .s_aclk(PHY1_RX_CLK_1),
        .s_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axis_tdata(rgmii_to_gmii_0_GMII_D_OUT),
        .s_axis_tvalid(rgmii_to_gmii_0_GMII_CTRL_OUT));
  bd_gmii_cross_fifo_read_throttle_0_1 fifo_read_throttle_0
       (.CLK(CLK_1),
        .CTRL_OUT(fifo_read_throttle_0_CTRL_OUT),
        .DATA_IN(fifo_generator_0_m_axis_tdata),
        .DATA_OUT(fifo_read_throttle_0_DATA_OUT),
        .READ_EN_OUT(fifo_read_throttle_0_READ_EN_OUT),
        .RESET(proc_sys_reset_1_peripheral_reset),
        .VALID_IN(fifo_generator_0_m_axis_tvalid));
  bd_gmii_cross_gmii_to_rgmii_0_1 gmii_to_rgmii_0
       (.CLK(CLK_1),
        .RESET(proc_sys_reset_1_peripheral_reset),
        .TX_CTRL_IN(fifo_read_throttle_0_CTRL_OUT),
        .TX_CTRL_OUT(gmii_to_rgmii_0_TX_CTRL_OUT),
        .TX_D_IN(fifo_read_throttle_0_DATA_OUT),
        .TX_D_OUT(gmii_to_rgmii_0_TX_D_OUT),
        .TX_ERR_IN(xlconstant_0_dout));
  bd_gmii_cross_proc_sys_reset_0_1 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .interconnect_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(PHY1_RX_CLK_1));
  bd_gmii_cross_rgmii_to_gmii_0_1 rgmii_to_gmii_0
       (.CLK(PHY1_RX_CLK_1),
        .GMII_CTRL_OUT(rgmii_to_gmii_0_GMII_CTRL_OUT),
        .GMII_D_OUT(rgmii_to_gmii_0_GMII_D_OUT),
        .RGMII_CTRL_IN(PHY1_RX_CTRL_1),
        .RGMII_D_IN(PHY1_RX_D_1));
  bd_gmii_cross_xlconstant_0_1 xlconstant_0
       (.dout(xlconstant_0_dout));
endmodule

(* CORE_GENERATION_INFO = "bd_gmii_cross,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_gmii_cross,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=39,numReposBlks=35,numNonXlnxBlks=0,numHierBlks=4,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=16,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "bd_gmii_cross.hwdef" *) 
module bd_gmii_cross
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.DEBUG_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.DEBUG_CLK, CLK_DOMAIN bd_gmii_cross_PHY1_RX_CLK, FREQ_HZ 125000000, PHASE 0.000" *) output DEBUG_CLK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 MGTCLK0 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MGTCLK0, CAN_DEBUG false, FREQ_HZ 156250000" *) input MGTCLK0_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 MGTCLK0 CLK_P" *) input MGTCLK0_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY1_GTX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY1_GTX_CLK, CLK_DOMAIN bd_gmii_cross_clk_wiz_0_0_clk_125, FREQ_HZ 125000000, PHASE 0.0" *) output PHY1_GTX_CLK;
  output PHY1_MDC;
  inout PHY1_MDIO;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.PHY1_RESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.PHY1_RESETN, POLARITY ACTIVE_LOW" *) output [0:0]PHY1_RESETN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY1_RX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY1_RX_CLK, CLK_DOMAIN bd_gmii_cross_PHY1_RX_CLK, FREQ_HZ 125000000, PHASE 0.000" *) input PHY1_RX_CLK;
  input PHY1_RX_CTRL;
  input [3:0]PHY1_RX_D;
  output PHY1_TX_CTRL;
  output [3:0]PHY1_TX_D;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY2_GTX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY2_GTX_CLK, CLK_DOMAIN bd_gmii_cross_clk_wiz_0_0_clk_125, FREQ_HZ 125000000, PHASE 0.0" *) output PHY2_GTX_CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY2_MDC CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY2_MDC, FREQ_HZ 100000000, PHASE 0.000" *) output PHY2_MDC;
  inout PHY2_MDIO;
  output [0:0]PHY2_RESETN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PHY2_RX_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PHY2_RX_CLK, CLK_DOMAIN bd_gmii_cross_PHY2_RX_CLK, FREQ_HZ 125000000, PHASE 0.000" *) input PHY2_RX_CLK;
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_250 CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME default_sysclk_250, CAN_DEBUG false, FREQ_HZ 250000000" *) input default_sysclk_250_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 default_sysclk_250 CLK_P" *) input default_sysclk_250_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, POLARITY ACTIVE_HIGH" *) input reset;

  wire ETH10G_0_XGMII_CLK;
  wire ETH10G_0_XGMII_RESET;
  wire MGTCLK0_1_CLK_N;
  wire MGTCLK0_1_CLK_P;
  wire Net;
  wire Net1;
  wire PHY1_RX_CLK_1;
  wire PHY1_RX_CTRL_1;
  wire [3:0]PHY1_RX_D_1;
  wire RX1_TX2_GMII_CTRL;
  wire [7:0]RX1_TX2_GMII_D;
  wire RX1_TX2_MDC;
  wire RX1_TX2_TX_CTRL;
  wire [3:0]RX1_TX2_TX_D;
  wire RX2_TX1_GMII_CTRL;
  wire [7:0]RX2_TX1_GMII_D;
  wire RX2_TX1_MDC;
  wire RX2_TX1_TX_CTRL;
  wire [3:0]RX2_TX1_TX_D;
  wire RX_CLK_0_1;
  wire RX_CTRL_0_1;
  wire [3:0]RX_D_0_1;
  wire SFP1_RX_LOS_1;
  wire SFP1_RX_N_1;
  wire SFP1_RX_P_1;
  wire clk_wiz_0_clk_125;
  wire clk_wiz_0_locked;
  wire default_sysclk_250_1_CLK_N;
  wire default_sysclk_250_1_CLK_P;
  wire eth10g_0_SFP1_TX_DISABLE;
  wire eth10g_0_SFP1_TX_N;
  wire eth10g_0_SFP1_TX_P;
  wire [0:0]proc_sys_reset_1_peripheral_aresetn;
  wire [0:0]proc_sys_reset_1_peripheral_reset;
  wire reset_1;
  wire [7:0]xgmii_txc_1;
  wire [63:0]xgmii_txd_1;

  assign DEBUG_CLK = PHY1_RX_CLK_1;
  assign MGTCLK0_1_CLK_N = MGTCLK0_clk_n;
  assign MGTCLK0_1_CLK_P = MGTCLK0_clk_p;
  assign PHY1_GTX_CLK = clk_wiz_0_clk_125;
  assign PHY1_MDC = RX2_TX1_MDC;
  assign PHY1_RESETN[0] = proc_sys_reset_1_peripheral_aresetn;
  assign PHY1_RX_CLK_1 = PHY1_RX_CLK;
  assign PHY1_RX_CTRL_1 = PHY1_RX_CTRL;
  assign PHY1_RX_D_1 = PHY1_RX_D[3:0];
  assign PHY1_TX_CTRL = RX2_TX1_TX_CTRL;
  assign PHY1_TX_D[3:0] = RX2_TX1_TX_D;
  assign PHY2_GTX_CLK = clk_wiz_0_clk_125;
  assign PHY2_MDC = RX1_TX2_MDC;
  assign PHY2_RESETN[0] = proc_sys_reset_1_peripheral_aresetn;
  assign PHY2_TX_CTRL = RX1_TX2_TX_CTRL;
  assign PHY2_TX_D[3:0] = RX1_TX2_TX_D;
  assign RX_CLK_0_1 = PHY2_RX_CLK;
  assign RX_CTRL_0_1 = PHY2_RX_CTRL;
  assign RX_D_0_1 = PHY2_RX_D[3:0];
  assign SFP1_RX_LOS_1 = SFP1_RX_LOS;
  assign SFP1_RX_N_1 = SFP1_RX_N;
  assign SFP1_RX_P_1 = SFP1_RX_P;
  assign SFP1_TX_DISABLE = eth10g_0_SFP1_TX_DISABLE;
  assign SFP1_TX_N = eth10g_0_SFP1_TX_N;
  assign SFP1_TX_P = eth10g_0_SFP1_TX_P;
  assign default_sysclk_250_1_CLK_N = default_sysclk_250_clk_n;
  assign default_sysclk_250_1_CLK_P = default_sysclk_250_clk_p;
  assign reset_1 = reset;
  RX1_TX2_imp_OO4UAT RX1_TX2
       (.GMII_CTRL(RX1_TX2_GMII_CTRL),
        .GMII_D(RX1_TX2_GMII_D),
        .MDC(RX1_TX2_MDC),
        .MDIO(PHY2_MDIO),
        .RX_CLK(PHY1_RX_CLK_1),
        .RX_CTRL(PHY1_RX_CTRL_1),
        .RX_D(PHY1_RX_D_1),
        .TX_CTRL(RX1_TX2_TX_CTRL),
        .TX_D(RX1_TX2_TX_D),
        .clk_125(clk_wiz_0_clk_125),
        .dcm_locked(clk_wiz_0_locked),
        .reset(reset_1),
        .reset_125(proc_sys_reset_1_peripheral_reset));
  RX2_TX1_imp_1L684IK RX2_TX1
       (.GMII_CTRL(RX2_TX1_GMII_CTRL),
        .GMII_D(RX2_TX1_GMII_D),
        .MDC(RX2_TX1_MDC),
        .MDIO(PHY1_MDIO),
        .RX_CLK(RX_CLK_0_1),
        .RX_CTRL(RX_CTRL_0_1),
        .RX_D(RX_D_0_1),
        .TX_CTRL(RX2_TX1_TX_CTRL),
        .TX_D(RX2_TX1_TX_D),
        .clk_125(clk_wiz_0_clk_125),
        .dcm_locked(clk_wiz_0_locked),
        .reset(reset_1),
        .reset_125(proc_sys_reset_1_peripheral_reset));
  bd_gmii_cross_clk_wiz_0_0 clk_wiz_0
       (.clk_125(clk_wiz_0_clk_125),
        .clk_in1_n(default_sysclk_250_1_CLK_N),
        .clk_in1_p(default_sysclk_250_1_CLK_P),
        .locked(clk_wiz_0_locked),
        .reset(reset_1));
  eth10g_0_imp_U76XU2 eth10g_0
       (.MGTCLK0_clk_n(MGTCLK0_1_CLK_N),
        .MGTCLK0_clk_p(MGTCLK0_1_CLK_P),
        .SFP1_RX_LOS(SFP1_RX_LOS_1),
        .SFP1_RX_N(SFP1_RX_N_1),
        .SFP1_RX_P(SFP1_RX_P_1),
        .SFP1_TX_DISABLE(eth10g_0_SFP1_TX_DISABLE),
        .SFP1_TX_N(eth10g_0_SFP1_TX_N),
        .SFP1_TX_P(eth10g_0_SFP1_TX_P),
        .XGMII_CLK(ETH10G_0_XGMII_CLK),
        .XGMII_RESET(ETH10G_0_XGMII_RESET),
        .reset(reset_1),
        .sysclk_125(clk_wiz_0_clk_125),
        .xgmii_txc(xgmii_txc_1),
        .xgmii_txd(xgmii_txd_1));
  gmii_to_xgmii_imp_1AB0SOY gmii_to_xgmii
       (.GMII_CLK(clk_wiz_0_clk_125),
        .GMII_RESETN(proc_sys_reset_1_peripheral_aresetn),
        .RXC_IN_0(RX1_TX2_GMII_CTRL),
        .RXC_IN_1(RX2_TX1_GMII_CTRL),
        .RXD_IN_0(RX1_TX2_GMII_D),
        .RXD_IN_1(RX2_TX1_GMII_D),
        .TXC_OUT(xgmii_txc_1),
        .TXD_OUT(xgmii_txd_1),
        .XGMII_CLK(ETH10G_0_XGMII_CLK),
        .XGMII_RESET(ETH10G_0_XGMII_RESET));
  bd_gmii_cross_proc_sys_reset_125_0 proc_sys_reset_125
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(reset_1),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_1_peripheral_aresetn),
        .peripheral_reset(proc_sys_reset_1_peripheral_reset),
        .slowest_sync_clk(clk_wiz_0_clk_125));
  bd_gmii_cross_system_ila_0_0 system_ila_0
       (.clk(clk_wiz_0_clk_125),
        .probe0(RX2_TX1_GMII_D),
        .probe1(RX2_TX1_GMII_CTRL),
        .probe2(RX1_TX2_GMII_D),
        .probe3(RX1_TX2_GMII_CTRL));
  bd_gmii_cross_system_ila_1_0 system_ila_1
       (.clk(ETH10G_0_XGMII_CLK),
        .probe0(xgmii_txd_1),
        .probe1(xgmii_txc_1));
endmodule

module eth10g_0_imp_U76XU2
   (MGTCLK0_clk_n,
    MGTCLK0_clk_p,
    SFP1_RX_LOS,
    SFP1_RX_N,
    SFP1_RX_P,
    SFP1_TX_DISABLE,
    SFP1_TX_N,
    SFP1_TX_P,
    XGMII_CLK,
    XGMII_RESET,
    reset,
    sysclk_125,
    xgmii_rxc,
    xgmii_rxd,
    xgmii_txc,
    xgmii_txd);
  input MGTCLK0_clk_n;
  input MGTCLK0_clk_p;
  input SFP1_RX_LOS;
  input SFP1_RX_N;
  input SFP1_RX_P;
  output SFP1_TX_DISABLE;
  output SFP1_TX_N;
  output SFP1_TX_P;
  output XGMII_CLK;
  output XGMII_RESET;
  input reset;
  input sysclk_125;
  output [7:0]xgmii_rxc;
  output [63:0]xgmii_rxd;
  input [7:0]xgmii_txc;
  input [63:0]xgmii_txd;

  wire Conn1_CLK_N;
  wire Conn1_CLK_P;
  wire SFP1_RX_LOS_1;
  wire SFP1_RX_N_1;
  wire SFP1_RX_P_1;
  wire eth_ctrl_0_mdc;
  wire eth_ctrl_0_mdio_w;
  wire [2:0]eth_ctrl_0_pma_pmd_type;
  wire [4:0]eth_ctrl_0_prtad;
  wire eth_ctrl_0_signal_detect;
  wire eth_ctrl_0_sim_speedup_control;
  wire eth_ctrl_0_tx_fault;
  wire reset1_1;
  wire sysclk_125_1;
  wire ten_gig_eth_pcs_pma_0_areset_datapathclk_out;
  wire [15:0]ten_gig_eth_pcs_pma_0_core_to_gt_drp_DADDR;
  wire ten_gig_eth_pcs_pma_0_core_to_gt_drp_DEN;
  wire [15:0]ten_gig_eth_pcs_pma_0_core_to_gt_drp_DI;
  wire [15:0]ten_gig_eth_pcs_pma_0_core_to_gt_drp_DO;
  wire ten_gig_eth_pcs_pma_0_core_to_gt_drp_DRDY;
  wire ten_gig_eth_pcs_pma_0_core_to_gt_drp_DWE;
  wire ten_gig_eth_pcs_pma_0_drp_req;
  wire ten_gig_eth_pcs_pma_0_tx_disable;
  wire ten_gig_eth_pcs_pma_0_txn;
  wire ten_gig_eth_pcs_pma_0_txp;
  wire ten_gig_eth_pcs_pma_0_txusrclk2_out;
  wire [7:0]ten_gig_eth_pcs_pma_0_xgmii_rxc;
  wire [63:0]ten_gig_eth_pcs_pma_0_xgmii_rxd;
  wire [7:0]xgmii_txc_0_1;
  wire [63:0]xgmii_txd_0_1;

  assign Conn1_CLK_N = MGTCLK0_clk_n;
  assign Conn1_CLK_P = MGTCLK0_clk_p;
  assign SFP1_RX_LOS_1 = SFP1_RX_LOS;
  assign SFP1_RX_N_1 = SFP1_RX_N;
  assign SFP1_RX_P_1 = SFP1_RX_P;
  assign SFP1_TX_DISABLE = ten_gig_eth_pcs_pma_0_tx_disable;
  assign SFP1_TX_N = ten_gig_eth_pcs_pma_0_txn;
  assign SFP1_TX_P = ten_gig_eth_pcs_pma_0_txp;
  assign XGMII_CLK = ten_gig_eth_pcs_pma_0_txusrclk2_out;
  assign XGMII_RESET = ten_gig_eth_pcs_pma_0_areset_datapathclk_out;
  assign reset1_1 = reset;
  assign sysclk_125_1 = sysclk_125;
  assign xgmii_rxc[7:0] = ten_gig_eth_pcs_pma_0_xgmii_rxc;
  assign xgmii_rxd[63:0] = ten_gig_eth_pcs_pma_0_xgmii_rxd;
  assign xgmii_txc_0_1 = xgmii_txc[7:0];
  assign xgmii_txd_0_1 = xgmii_txd[63:0];
  bd_gmii_cross_eth_ctrl_0_0 eth_ctrl_0
       (.mdc(eth_ctrl_0_mdc),
        .mdio_w(eth_ctrl_0_mdio_w),
        .pma_pmd_type(eth_ctrl_0_pma_pmd_type),
        .prtad(eth_ctrl_0_prtad),
        .rx_loss(SFP1_RX_LOS_1),
        .signal_detect(eth_ctrl_0_signal_detect),
        .sim_speedup_control(eth_ctrl_0_sim_speedup_control),
        .tx_fault(eth_ctrl_0_tx_fault));
  bd_gmii_cross_ten_gig_eth_pcs_pma_0_0 ten_gig_eth_pcs_pma_0
       (.areset_datapathclk_out(ten_gig_eth_pcs_pma_0_areset_datapathclk_out),
        .core_to_gt_drpaddr(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DADDR),
        .core_to_gt_drpdi(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DI),
        .core_to_gt_drpdo(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DO),
        .core_to_gt_drpen(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DEN),
        .core_to_gt_drprdy(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DRDY),
        .core_to_gt_drpwe(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DWE),
        .dclk(sysclk_125_1),
        .drp_gnt(ten_gig_eth_pcs_pma_0_drp_req),
        .drp_req(ten_gig_eth_pcs_pma_0_drp_req),
        .gt_drpaddr(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DADDR),
        .gt_drpdi(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DI),
        .gt_drpdo(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DO),
        .gt_drpen(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DEN),
        .gt_drprdy(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DRDY),
        .gt_drpwe(ten_gig_eth_pcs_pma_0_core_to_gt_drp_DWE),
        .mdc(eth_ctrl_0_mdc),
        .mdio_in(eth_ctrl_0_mdio_w),
        .pma_pmd_type(eth_ctrl_0_pma_pmd_type),
        .prtad(eth_ctrl_0_prtad),
        .refclk_n(Conn1_CLK_N),
        .refclk_p(Conn1_CLK_P),
        .reset(reset1_1),
        .rxn(SFP1_RX_N_1),
        .rxp(SFP1_RX_P_1),
        .signal_detect(eth_ctrl_0_signal_detect),
        .sim_speedup_control(eth_ctrl_0_sim_speedup_control),
        .tx_disable(ten_gig_eth_pcs_pma_0_tx_disable),
        .tx_fault(eth_ctrl_0_tx_fault),
        .txn(ten_gig_eth_pcs_pma_0_txn),
        .txp(ten_gig_eth_pcs_pma_0_txp),
        .txusrclk2_out(ten_gig_eth_pcs_pma_0_txusrclk2_out),
        .xgmii_rxc(ten_gig_eth_pcs_pma_0_xgmii_rxc),
        .xgmii_rxd(ten_gig_eth_pcs_pma_0_xgmii_rxd),
        .xgmii_txc(xgmii_txc_0_1),
        .xgmii_txd(xgmii_txd_0_1));
endmodule

module gmii_to_xgmii_imp_1AB0SOY
   (GMII_CLK,
    GMII_RESETN,
    RXC_IN_0,
    RXC_IN_1,
    RXD_IN_0,
    RXD_IN_1,
    TXC_OUT,
    TXD_OUT,
    XGMII_CLK,
    XGMII_RESET);
  input GMII_CLK;
  input GMII_RESETN;
  input RXC_IN_0;
  input RXC_IN_1;
  input [7:0]RXD_IN_0;
  input [7:0]RXD_IN_1;
  output [7:0]TXC_OUT;
  output [63:0]TXD_OUT;
  input XGMII_CLK;
  input [0:0]XGMII_RESET;

  wire CLK_1;
  wire GMII_CTRL_0_1;
  wire [7:0]GMII_D_0_1;
  wire [0:0]Op1_1;
  wire RESETN1_1;
  wire [0:0]RESETN_1;
  wire \^RXC_IN_1 ;
  wire [7:0]\^RXD_IN_1 ;
  wire axis_arbiter_0_CUR_SOURCE;
  wire axis_arbiter_0_IV0_TREADY;
  wire axis_arbiter_0_IV1_TREADY;
  wire axis_arbiter_0_OV_TLAST;
  wire [63:0]axis_fifo_0_OV_TDATA;
  wire [0:0]axis_fifo_0_OV_TLAST;
  wire [3:0]axis_fifo_0_OV_TUSER;
  wire axis_fifo_0_OV_TVALID;
  wire [11:0]fifo_generator_0_axis_rd_data_count;
  wire [63:0]fifo_generator_0_m_axis_tdata;
  wire fifo_generator_0_m_axis_tlast;
  wire [3:0]fifo_generator_0_m_axis_tuser;
  wire fifo_generator_0_m_axis_tvalid;
  wire [11:0]fifo_generator_1_axis_rd_data_count;
  wire [63:0]fifo_generator_1_m_axis_tdata;
  wire fifo_generator_1_m_axis_tlast;
  wire [3:0]fifo_generator_1_m_axis_tuser;
  wire fifo_generator_1_m_axis_tvalid;
  wire [63:0]gmii_to_xgmii_axis_arbiter_0_OV_TDATA;
  wire [3:0]gmii_to_xgmii_axis_arbiter_0_OV_TUSER;
  wire gmii_to_xgmii_axis_arbiter_0_OV_TVALID;
  wire [0:0]gmii_to_xgmii_xlconstant_1_dout;
  wire gmii_to_xgmil_0_CE_OUT;
  wire [63:0]gmii_to_xgmil_0_RXD_OUT;
  wire [3:0]gmii_to_xgmil_0_RXLEN_OUT;
  wire gmii_to_xgmil_0_XGMII_LAST;
  wire [63:0]gmii_to_xgmil_1_XGMII_D;
  wire gmii_to_xgmil_1_XGMII_EN;
  wire gmii_to_xgmil_1_XGMII_LAST;
  wire [3:0]gmii_to_xgmil_1_XGMII_LEN;
  wire s_aclk_1;
  wire [63:0]xgmii_find_packet_end_0_OVAL_TDATA;
  wire xgmii_find_packet_end_0_OVAL_TLAST;
  wire [3:0]xgmii_find_packet_end_0_OVAL_TUSER;
  wire xgmii_find_packet_end_0_OVAL_TVALID;
  wire xgmii_find_packet_end_0_PACKET_END;
  wire [4:0]xgmii_make_contiguous_0_DBG_IFG;
  wire [15:0]xgmii_make_contiguous_0_DBG_PCNT;
  wire xgmii_make_contiguous_0_ERR_CONT;
  wire xgmii_make_contiguous_0_IVAL_TREADY;
  wire [63:0]xgmii_make_contiguous_0_OVAL_XGMII_D;
  wire xgmii_make_contiguous_0_OVAL_XGMII_HALFDELAY;
  wire [3:0]xgmii_make_contiguous_0_OVAL_XGMII_LEN;
  wire [7:0]xgmii_tx_nofcs_0_TXC_OUT;
  wire [63:0]xgmii_tx_nofcs_0_TXD_OUT;

  assign CLK_1 = XGMII_CLK;
  assign GMII_CTRL_0_1 = RXC_IN_1;
  assign GMII_D_0_1 = RXD_IN_1[7:0];
  assign Op1_1 = XGMII_RESET[0];
  assign RESETN1_1 = GMII_RESETN;
  assign TXC_OUT[7:0] = xgmii_tx_nofcs_0_TXC_OUT;
  assign TXD_OUT[63:0] = xgmii_tx_nofcs_0_TXD_OUT;
  assign \^RXC_IN_1  = RXC_IN_0;
  assign \^RXD_IN_1 [7:0] = RXD_IN_0[7:0];
  assign s_aclk_1 = GMII_CLK;
  bd_gmii_cross_axis_arbiter_0_0 axis_arbiter_0
       (.CAP_POP0(fifo_generator_0_axis_rd_data_count),
        .CAP_POP1(fifo_generator_1_axis_rd_data_count),
        .CLK(CLK_1),
        .CUR_SOURCE(axis_arbiter_0_CUR_SOURCE),
        .IV0_TDATA(fifo_generator_0_m_axis_tdata),
        .IV0_TLAST(fifo_generator_0_m_axis_tlast),
        .IV0_TREADY(axis_arbiter_0_IV0_TREADY),
        .IV0_TUSER(fifo_generator_0_m_axis_tuser),
        .IV0_TVALID(fifo_generator_0_m_axis_tvalid),
        .IV1_TDATA(fifo_generator_1_m_axis_tdata),
        .IV1_TLAST(fifo_generator_1_m_axis_tlast),
        .IV1_TREADY(axis_arbiter_0_IV1_TREADY),
        .IV1_TUSER(fifo_generator_1_m_axis_tuser),
        .IV1_TVALID(fifo_generator_1_m_axis_tvalid),
        .OV_TDATA(gmii_to_xgmii_axis_arbiter_0_OV_TDATA),
        .OV_TLAST(axis_arbiter_0_OV_TLAST),
        .OV_TREADY(gmii_to_xgmii_xlconstant_1_dout),
        .OV_TUSER(gmii_to_xgmii_axis_arbiter_0_OV_TUSER),
        .OV_TVALID(gmii_to_xgmii_axis_arbiter_0_OV_TVALID),
        .RESETN(RESETN_1));
  bd_gmii_cross_axis_fifo_0_0 axis_fifo_0
       (.CLK(CLK_1),
        .IV_TDATA(xgmii_find_packet_end_0_OVAL_TDATA),
        .IV_TID(1'b0),
        .IV_TKEEP(1'b1),
        .IV_TLAST(xgmii_find_packet_end_0_OVAL_TLAST),
        .IV_TUSER(xgmii_find_packet_end_0_OVAL_TUSER),
        .IV_TVALID(xgmii_find_packet_end_0_OVAL_TVALID),
        .OV_TDATA(axis_fifo_0_OV_TDATA),
        .OV_TLAST(axis_fifo_0_OV_TLAST),
        .OV_TREADY(xgmii_make_contiguous_0_IVAL_TREADY),
        .OV_TUSER(axis_fifo_0_OV_TUSER),
        .OV_TVALID(axis_fifo_0_OV_TVALID),
        .RESETN(RESETN_1));
  bd_gmii_cross_fifo_generator_0_0 fifo_generator_0
       (.axis_rd_data_count(fifo_generator_0_axis_rd_data_count),
        .m_aclk(CLK_1),
        .m_axis_tdata(fifo_generator_0_m_axis_tdata),
        .m_axis_tlast(fifo_generator_0_m_axis_tlast),
        .m_axis_tready(axis_arbiter_0_IV0_TREADY),
        .m_axis_tuser(fifo_generator_0_m_axis_tuser),
        .m_axis_tvalid(fifo_generator_0_m_axis_tvalid),
        .s_aclk(s_aclk_1),
        .s_aresetn(RESETN1_1),
        .s_axis_tdata(gmii_to_xgmil_0_RXD_OUT),
        .s_axis_tlast(gmii_to_xgmil_0_XGMII_LAST),
        .s_axis_tuser(gmii_to_xgmil_0_RXLEN_OUT),
        .s_axis_tvalid(gmii_to_xgmil_0_CE_OUT));
  bd_gmii_cross_fifo_generator_1_0 fifo_generator_1
       (.axis_rd_data_count(fifo_generator_1_axis_rd_data_count),
        .m_aclk(CLK_1),
        .m_axis_tdata(fifo_generator_1_m_axis_tdata),
        .m_axis_tlast(fifo_generator_1_m_axis_tlast),
        .m_axis_tready(axis_arbiter_0_IV1_TREADY),
        .m_axis_tuser(fifo_generator_1_m_axis_tuser),
        .m_axis_tvalid(fifo_generator_1_m_axis_tvalid),
        .s_aclk(s_aclk_1),
        .s_aresetn(RESETN1_1),
        .s_axis_tdata(gmii_to_xgmil_1_XGMII_D),
        .s_axis_tlast(gmii_to_xgmil_1_XGMII_LAST),
        .s_axis_tuser(gmii_to_xgmil_1_XGMII_LEN),
        .s_axis_tvalid(gmii_to_xgmil_1_XGMII_EN));
  bd_gmii_cross_gmii_to_xgmil_0_0 gmii_to_xgmil_0
       (.CLK(s_aclk_1),
        .GMII_CTRL(\^RXC_IN_1 ),
        .GMII_D(\^RXD_IN_1 ),
        .RESETN(RESETN1_1),
        .XGMII_D(gmii_to_xgmil_0_RXD_OUT),
        .XGMII_EN(gmii_to_xgmil_0_CE_OUT),
        .XGMII_LAST(gmii_to_xgmil_0_XGMII_LAST),
        .XGMII_LEN(gmii_to_xgmil_0_RXLEN_OUT));
  bd_gmii_cross_gmii_to_xgmil_1_0 gmii_to_xgmil_1
       (.CLK(s_aclk_1),
        .GMII_CTRL(GMII_CTRL_0_1),
        .GMII_D(GMII_D_0_1),
        .RESETN(RESETN1_1),
        .XGMII_D(gmii_to_xgmil_1_XGMII_D),
        .XGMII_EN(gmii_to_xgmil_1_XGMII_EN),
        .XGMII_LAST(gmii_to_xgmil_1_XGMII_LAST),
        .XGMII_LEN(gmii_to_xgmil_1_XGMII_LEN));
  bd_gmii_cross_system_ila_0_1 system_ila_0
       (.clk(s_aclk_1),
        .probe0(\^RXC_IN_1 ),
        .probe1(\^RXD_IN_1 ),
        .probe2(gmii_to_xgmil_0_RXLEN_OUT),
        .probe3(gmii_to_xgmil_0_RXD_OUT),
        .probe4(gmii_to_xgmil_0_CE_OUT));
  bd_gmii_cross_system_ila_1_1 system_ila_1
       (.clk(CLK_1),
        .probe0(fifo_generator_1_m_axis_tdata),
        .probe1(fifo_generator_1_m_axis_tlast),
        .probe10(gmii_to_xgmii_axis_arbiter_0_OV_TDATA),
        .probe11(gmii_to_xgmii_axis_arbiter_0_OV_TUSER),
        .probe12(gmii_to_xgmii_axis_arbiter_0_OV_TVALID),
        .probe13(gmii_to_xgmii_xlconstant_1_dout),
        .probe14(axis_arbiter_0_CUR_SOURCE),
        .probe2(axis_arbiter_0_IV1_TREADY),
        .probe3(fifo_generator_1_m_axis_tuser),
        .probe4(fifo_generator_1_m_axis_tvalid),
        .probe5(fifo_generator_0_m_axis_tdata),
        .probe6(fifo_generator_0_m_axis_tlast),
        .probe7(axis_arbiter_0_IV0_TREADY),
        .probe8(fifo_generator_0_m_axis_tuser),
        .probe9(fifo_generator_0_m_axis_tvalid));
  bd_gmii_cross_system_ila_2_0 system_ila_2
       (.clk(s_aclk_1),
        .probe0(GMII_CTRL_0_1),
        .probe1(GMII_D_0_1),
        .probe2(gmii_to_xgmil_1_XGMII_LEN),
        .probe3(gmii_to_xgmil_1_XGMII_D),
        .probe4(gmii_to_xgmil_1_XGMII_EN));
  bd_gmii_cross_system_ila_3_0 system_ila_3
       (.clk(CLK_1),
        .probe0(gmii_to_xgmii_axis_arbiter_0_OV_TUSER),
        .probe1(gmii_to_xgmii_axis_arbiter_0_OV_TDATA),
        .probe10(axis_fifo_0_OV_TUSER),
        .probe11(axis_fifo_0_OV_TVALID),
        .probe12(xgmii_make_contiguous_0_IVAL_TREADY),
        .probe13(xgmii_make_contiguous_0_OVAL_XGMII_D),
        .probe14(xgmii_make_contiguous_0_OVAL_XGMII_LEN),
        .probe15(xgmii_make_contiguous_0_ERR_CONT),
        .probe16(xgmii_make_contiguous_0_DBG_PCNT),
        .probe17(xgmii_make_contiguous_0_DBG_IFG),
        .probe2(gmii_to_xgmii_axis_arbiter_0_OV_TVALID),
        .probe3(xgmii_find_packet_end_0_OVAL_TDATA),
        .probe4(xgmii_find_packet_end_0_OVAL_TVALID),
        .probe5(xgmii_find_packet_end_0_OVAL_TUSER),
        .probe6(xgmii_find_packet_end_0_OVAL_TLAST),
        .probe7(xgmii_find_packet_end_0_PACKET_END),
        .probe8(axis_fifo_0_OV_TDATA),
        .probe9(axis_fifo_0_OV_TLAST));
  bd_gmii_cross_util_vector_logic_0_0 util_vector_logic_0
       (.Op1(Op1_1),
        .Res(RESETN_1));
  bd_gmii_cross_xgmii_find_packet_end_0_0 xgmii_find_packet_end_0
       (.CLK(CLK_1),
        .OVAL_TDATA(xgmii_find_packet_end_0_OVAL_TDATA),
        .OVAL_TLAST(xgmii_find_packet_end_0_OVAL_TLAST),
        .OVAL_TUSER(xgmii_find_packet_end_0_OVAL_TUSER),
        .OVAL_TVALID(xgmii_find_packet_end_0_OVAL_TVALID),
        .PACKET_END(xgmii_find_packet_end_0_PACKET_END),
        .RESETN(RESETN_1),
        .XGMII_D(gmii_to_xgmii_axis_arbiter_0_OV_TDATA),
        .XGMII_EN(gmii_to_xgmii_axis_arbiter_0_OV_TVALID),
        .XGMII_LAST(axis_arbiter_0_OV_TLAST),
        .XGMII_LEN(gmii_to_xgmii_axis_arbiter_0_OV_TUSER));
  bd_gmii_cross_xgmii_make_contiguous_0_0 xgmii_make_contiguous_0
       (.CLK(CLK_1),
        .DBG_IFG(xgmii_make_contiguous_0_DBG_IFG),
        .DBG_PCNT(xgmii_make_contiguous_0_DBG_PCNT),
        .ERR_CONT(xgmii_make_contiguous_0_ERR_CONT),
        .IVAL_TDATA(axis_fifo_0_OV_TDATA),
        .IVAL_TLAST(axis_fifo_0_OV_TLAST),
        .IVAL_TREADY(xgmii_make_contiguous_0_IVAL_TREADY),
        .IVAL_TUSER(axis_fifo_0_OV_TUSER),
        .IVAL_TVALID(axis_fifo_0_OV_TVALID),
        .OVAL_XGMII_D(xgmii_make_contiguous_0_OVAL_XGMII_D),
        .OVAL_XGMII_HALFDELAY(xgmii_make_contiguous_0_OVAL_XGMII_HALFDELAY),
        .OVAL_XGMII_LEN(xgmii_make_contiguous_0_OVAL_XGMII_LEN),
        .PACKET_END(xgmii_find_packet_end_0_PACKET_END),
        .RESETN(RESETN_1));
  bd_gmii_cross_xgmii_tx_nofcs_0_0 xgmii_tx_nofcs_0
       (.CLK(CLK_1),
        .CLOCK_EN(gmii_to_xgmii_xlconstant_1_dout),
        .RESET(Op1_1),
        .TXC_OUT(xgmii_tx_nofcs_0_TXC_OUT),
        .TXD_IN(xgmii_make_contiguous_0_OVAL_XGMII_D),
        .TXD_OUT(xgmii_tx_nofcs_0_TXD_OUT),
        .TXHD_IN(xgmii_make_contiguous_0_OVAL_XGMII_HALFDELAY),
        .TXLEN_IN(xgmii_make_contiguous_0_OVAL_XGMII_LEN));
  bd_gmii_cross_xlconstant_1_0 xlconstant_1
       (.dout(gmii_to_xgmii_xlconstant_1_dout));
endmodule
