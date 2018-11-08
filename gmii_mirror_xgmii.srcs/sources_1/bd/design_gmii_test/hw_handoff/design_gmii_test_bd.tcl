
################################################################
# This is a generated script based on design: design_gmii_test
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_gmii_test_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# address_mac_ip, eth_phy_ctrl, fifo_read_throttle, gmii_rx_fcs, gmii_to_rgmii, gmii_to_xgmil, gmii_tx_fcs, rgmii_to_gmii, xgmii_test_server, xgmii_to_gmii

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku040-fbva676-1-c
   set_property BOARD_PART em.avnet.com:ku040:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_gmii_test

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: ETH1
proc create_hier_cell_ETH1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ETH1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk_250

  # Create pins
  create_bd_pin -dir O -type clk PHY1_GTX_CLK
  create_bd_pin -dir O PHY1_MDC
  create_bd_pin -dir IO PHY1_MDIO
  create_bd_pin -dir O -from 0 -to 0 -type rst PHY1_RESETN
  create_bd_pin -dir I -type clk PHY1_RX_CLK
  create_bd_pin -dir I PHY1_RX_CTRL
  create_bd_pin -dir I -from 3 -to 0 PHY1_RX_D
  create_bd_pin -dir O PHY1_TX_CTRL
  create_bd_pin -dir O -from 3 -to 0 PHY1_TX_D
  create_bd_pin -dir I -type rst reset

  # Create instance: address_mac_ip_0, and set properties
  set block_name address_mac_ip
  set block_cell_name address_mac_ip_0
  if { [catch {set address_mac_ip_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $address_mac_ip_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.IP2 {100} \
   CONFIG.IP3 {251} \
 ] $address_mac_ip_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {40.0} \
   CONFIG.CLKOUT1_JITTER {99.067} \
   CONFIG.CLKOUT1_PHASE_ERROR {80.553} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_JITTER {79.919} \
   CONFIG.CLKOUT2_PHASE_ERROR {80.553} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {375.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {89.528} \
   CONFIG.CLKOUT3_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk_250} \
   CONFIG.CLK_OUT1_PORT {clk_125} \
   CONFIG.CLK_OUT2_PORT {clk_ila} \
   CONFIG.CLK_OUT3_PORT {clk_out3} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {4.500} \
   CONFIG.MMCM_CLKIN1_PERIOD {4.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
 ] $clk_wiz_0

  # Create instance: eth_phy_ctrl_0, and set properties
  set block_name eth_phy_ctrl
  set block_cell_name eth_phy_ctrl_0
  if { [catch {set eth_phy_ctrl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_phy_ctrl_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Fifo_Implementation {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Flags_Reset_Value {1} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Data_Width {8} \
   CONFIG.Input_Depth {32} \
   CONFIG.Input_Depth_axis {32} \
   CONFIG.Performance_Options {Standard_FIFO} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.Valid_Flag {true} \
 ] $fifo_generator_0

  # Create instance: fifo_read_throttle_0, and set properties
  set block_name fifo_read_throttle
  set block_cell_name fifo_read_throttle_0
  if { [catch {set fifo_read_throttle_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fifo_read_throttle_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gmii_rx_fcs_0, and set properties
  set block_name gmii_rx_fcs
  set block_cell_name gmii_rx_fcs_0
  if { [catch {set gmii_rx_fcs_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gmii_rx_fcs_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gmii_to_rgmii_0, and set properties
  set block_name gmii_to_rgmii
  set block_cell_name gmii_to_rgmii_0
  if { [catch {set gmii_to_rgmii_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gmii_to_rgmii_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gmii_to_xgmil_0, and set properties
  set block_name gmii_to_xgmil
  set block_cell_name gmii_to_xgmil_0
  if { [catch {set gmii_to_xgmil_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gmii_to_xgmil_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gmii_tx_fcs_0, and set properties
  set block_name gmii_tx_fcs
  set block_cell_name gmii_tx_fcs_0
  if { [catch {set gmii_tx_fcs_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gmii_tx_fcs_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: rgmii_to_gmii_0, and set properties
  set block_name rgmii_to_gmii
  set block_cell_name rgmii_to_gmii_0
  if { [catch {set rgmii_to_gmii_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $rgmii_to_gmii_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xgmii_test_server_0, and set properties
  set block_name xgmii_test_server
  set block_cell_name xgmii_test_server_0
  if { [catch {set xgmii_test_server_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $xgmii_test_server_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xgmii_to_gmii_0, and set properties
  set block_name xgmii_to_gmii
  set block_cell_name xgmii_to_gmii_0
  if { [catch {set xgmii_to_gmii_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $xgmii_to_gmii_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins default_sysclk_250] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net CE_1 [get_bd_pins gmii_to_xgmil_0/CE_OUT] [get_bd_pins xgmii_test_server_0/CLOCK_EN] [get_bd_pins xgmii_to_gmii_0/CLOCK_EN]
  connect_bd_net -net CLK_1 [get_bd_pins PHY1_GTX_CLK] [get_bd_pins clk_wiz_0/clk_125] [get_bd_pins fifo_generator_0/m_aclk] [get_bd_pins fifo_read_throttle_0/CLK] [get_bd_pins gmii_to_rgmii_0/CLK] [get_bd_pins gmii_tx_fcs_0/CLK] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net Net [get_bd_pins PHY1_MDIO] [get_bd_pins eth_phy_ctrl_0/MDIO]
  connect_bd_net -net PHY1_RX_CLK_1 [get_bd_pins PHY1_RX_CLK] [get_bd_pins eth_phy_ctrl_0/RX_CLK] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins gmii_rx_fcs_0/CLK] [get_bd_pins gmii_to_xgmil_0/CLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins rgmii_to_gmii_0/CLK] [get_bd_pins xgmii_test_server_0/CLK] [get_bd_pins xgmii_to_gmii_0/CLK]
  connect_bd_net -net PHY1_RX_CTRL_1 [get_bd_pins PHY1_RX_CTRL] [get_bd_pins eth_phy_ctrl_0/RX_CTRL] [get_bd_pins rgmii_to_gmii_0/RGMII_CTRL_IN]
  connect_bd_net -net PHY1_RX_D_1 [get_bd_pins PHY1_RX_D] [get_bd_pins eth_phy_ctrl_0/RX_D] [get_bd_pins rgmii_to_gmii_0/RGMII_D_IN]
  connect_bd_net -net address_mac_ip_0_IP_ADDR [get_bd_pins address_mac_ip_0/IP_ADDR] [get_bd_pins xgmii_test_server_0/LOCAL_IP]
  connect_bd_net -net address_mac_ip_0_MAC_ADDR [get_bd_pins address_mac_ip_0/MAC_ADDR] [get_bd_pins xgmii_test_server_0/LOCAL_MAC]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net eth_phy_ctrl_0_MDC [get_bd_pins PHY1_MDC] [get_bd_pins eth_phy_ctrl_0/MDC]
  connect_bd_net -net fifo_generator_0_m_axis_tdata [get_bd_pins fifo_generator_0/m_axis_tdata] [get_bd_pins fifo_read_throttle_0/DATA_IN]
  connect_bd_net -net fifo_generator_0_m_axis_tvalid [get_bd_pins fifo_generator_0/m_axis_tvalid] [get_bd_pins fifo_read_throttle_0/VALID_IN]
  connect_bd_net -net fifo_read_throttle_0_CTRL_OUT [get_bd_pins fifo_read_throttle_0/CTRL_OUT] [get_bd_pins gmii_tx_fcs_0/TXCTRL_IN]
  connect_bd_net -net fifo_read_throttle_0_DATA_OUT [get_bd_pins fifo_read_throttle_0/DATA_OUT] [get_bd_pins gmii_tx_fcs_0/TXD_IN]
  connect_bd_net -net fifo_read_throttle_0_READ_EN_OUT [get_bd_pins fifo_generator_0/m_axis_tready] [get_bd_pins fifo_read_throttle_0/READ_EN_OUT]
  connect_bd_net -net gmii_rx_fcs_0_RXC_OUT [get_bd_pins gmii_rx_fcs_0/RXC_OUT] [get_bd_pins gmii_to_xgmil_0/RXC_IN]
  connect_bd_net -net gmii_rx_fcs_0_RXD_OUT [get_bd_pins gmii_rx_fcs_0/RXD_OUT] [get_bd_pins gmii_to_xgmil_0/RXD_IN]
  connect_bd_net -net gmii_to_rgmii_0_TX_CTRL_OUT [get_bd_pins PHY1_TX_CTRL] [get_bd_pins gmii_to_rgmii_0/TX_CTRL_OUT]
  connect_bd_net -net gmii_to_rgmii_0_TX_D_OUT [get_bd_pins PHY1_TX_D] [get_bd_pins gmii_to_rgmii_0/TX_D_OUT]
  connect_bd_net -net gmii_to_xgmil_0_RXD_OUT [get_bd_pins gmii_to_xgmil_0/RXD_OUT] [get_bd_pins xgmii_test_server_0/RXD_IN]
  connect_bd_net -net gmii_to_xgmil_0_RXLEN_OUT [get_bd_pins gmii_to_xgmil_0/RXLEN_OUT] [get_bd_pins xgmii_test_server_0/RXLEN_IN]
  connect_bd_net -net gmii_tx_fcs_0_GMII_TX_CTRL [get_bd_pins gmii_to_rgmii_0/TX_CTRL_IN] [get_bd_pins gmii_tx_fcs_0/GMII_TX_CTRL]
  connect_bd_net -net gmii_tx_fcs_0_GMII_TX_D [get_bd_pins gmii_to_rgmii_0/TX_D_IN] [get_bd_pins gmii_tx_fcs_0/GMII_TX_D]
  connect_bd_net -net gmii_tx_fcs_0_GMII_TX_ERR [get_bd_pins gmii_to_rgmii_0/TX_ERR_IN] [get_bd_pins gmii_tx_fcs_0/GMII_TX_ERR]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins gmii_rx_fcs_0/RESETN] [get_bd_pins gmii_to_xgmil_0/RESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins xgmii_to_gmii_0/RESETN]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins xgmii_test_server_0/RESET]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins PHY1_RESETN] [get_bd_pins gmii_tx_fcs_0/RESETN] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins fifo_read_throttle_0/RESET] [get_bd_pins gmii_to_rgmii_0/RESET] [get_bd_pins proc_sys_reset_1/peripheral_reset]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins clk_wiz_0/reset] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net rgmii_to_gmii_0_GMII_CTRL_OUT [get_bd_pins gmii_rx_fcs_0/RXC_IN] [get_bd_pins rgmii_to_gmii_0/GMII_CTRL_OUT]
  connect_bd_net -net rgmii_to_gmii_0_GMII_D_OUT [get_bd_pins gmii_rx_fcs_0/RXD_IN] [get_bd_pins rgmii_to_gmii_0/GMII_D_OUT]
  connect_bd_net -net xgmii_test_server_0_TXD_OUT [get_bd_pins xgmii_test_server_0/TXD_OUT] [get_bd_pins xgmii_to_gmii_0/TXD_IN]
  connect_bd_net -net xgmii_test_server_0_TXLEN_OUT [get_bd_pins xgmii_test_server_0/TXLEN_OUT] [get_bd_pins xgmii_to_gmii_0/TXLEN_IN]
  connect_bd_net -net xgmii_to_gmii_0_TX_CTRL_OUT [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins xgmii_to_gmii_0/TX_CTRL_OUT]
  connect_bd_net -net xgmii_to_gmii_0_TX_D_OUT [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins xgmii_to_gmii_0/TX_D_OUT]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set default_sysclk_250 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk_250 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   ] $default_sysclk_250

  # Create ports
  set DEBUG_CLK [ create_bd_port -dir O -type clk DEBUG_CLK ]
  set PHY2_GTX_CLK [ create_bd_port -dir O -type clk PHY2_GTX_CLK ]
  set PHY2_MDC [ create_bd_port -dir O -type clk PHY2_MDC ]
  set PHY2_MDIO [ create_bd_port -dir IO PHY2_MDIO ]
  set PHY2_RESETN [ create_bd_port -dir O -from 0 -to 0 PHY2_RESETN ]
  set PHY2_RX_CLK [ create_bd_port -dir I -type clk PHY2_RX_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $PHY2_RX_CLK
  set PHY2_RX_CTRL [ create_bd_port -dir I PHY2_RX_CTRL ]
  set PHY2_RX_D [ create_bd_port -dir I -from 3 -to 0 PHY2_RX_D ]
  set PHY2_TX_CTRL [ create_bd_port -dir O PHY2_TX_CTRL ]
  set PHY2_TX_D [ create_bd_port -dir O -from 3 -to 0 PHY2_TX_D ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset

  # Create instance: ETH1
  create_hier_cell_ETH1 [current_bd_instance .] ETH1

  # Create interface connections
  connect_bd_intf_net -intf_net default_sysclk_250_1 [get_bd_intf_ports default_sysclk_250] [get_bd_intf_pins ETH1/default_sysclk_250]

  # Create port connections
  connect_bd_net -net ETH1_PHY1_MDC [get_bd_ports PHY2_MDC] [get_bd_pins ETH1/PHY1_MDC]
  connect_bd_net -net ETH1_PHY1_TX_CTRL [get_bd_ports PHY2_TX_CTRL] [get_bd_pins ETH1/PHY1_TX_CTRL]
  connect_bd_net -net ETH1_PHY1_TX_D [get_bd_ports PHY2_TX_D] [get_bd_pins ETH1/PHY1_TX_D]
  connect_bd_net -net Net [get_bd_ports PHY2_MDIO] [get_bd_pins ETH1/PHY1_MDIO]
  connect_bd_net -net PHY1_RX_CLK_1 [get_bd_ports DEBUG_CLK] [get_bd_ports PHY2_RX_CLK] [get_bd_pins ETH1/PHY1_RX_CLK]
  connect_bd_net -net RGMII_CTRL_IN_1 [get_bd_ports PHY2_RX_CTRL] [get_bd_pins ETH1/PHY1_RX_CTRL]
  connect_bd_net -net RGMII_D_IN_1 [get_bd_ports PHY2_RX_D] [get_bd_pins ETH1/PHY1_RX_D]
  connect_bd_net -net clk_wiz_0_clk_125 [get_bd_ports PHY2_GTX_CLK] [get_bd_pins ETH1/PHY1_GTX_CLK]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_ports PHY2_RESETN] [get_bd_pins ETH1/PHY1_RESETN]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins ETH1/reset]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


