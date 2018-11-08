
################################################################
# This is a generated script based on design: bd_gmii_cross
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
# source bd_gmii_cross_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# eth_phy_ctrl, fifo_read_throttle, gmii_to_rgmii, rgmii_to_gmii, eth_phy_ctrl, fifo_read_throttle, gmii_to_rgmii, rgmii_to_gmii, eth_ctrl, axis_arbiter, axis_fifo, gmii_to_xgmil, gmii_to_xgmil, xgmii_find_packet_end, xgmii_make_contiguous, xgmii_tx_nofcs

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
set design_name bd_gmii_cross

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


# Hierarchical cell: gmii_to_xgmii
proc create_hier_cell_gmii_to_xgmii { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_gmii_to_xgmii() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir I -type clk GMII_CLK
  create_bd_pin -dir I -type rst GMII_RESETN
  create_bd_pin -dir I RXC_IN_0
  create_bd_pin -dir I RXC_IN_1
  create_bd_pin -dir I -from 7 -to 0 RXD_IN_0
  create_bd_pin -dir I -from 7 -to 0 RXD_IN_1
  create_bd_pin -dir O -from 7 -to 0 TXC_OUT
  create_bd_pin -dir O -from 63 -to 0 TXD_OUT
  create_bd_pin -dir I -type clk XGMII_CLK
  create_bd_pin -dir I -from 0 -to 0 XGMII_RESET

  # Create instance: axis_arbiter_0, and set properties
  set block_name axis_arbiter
  set block_cell_name axis_arbiter_0
  if { [catch {set axis_arbiter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_arbiter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_fifo_0, and set properties
  set block_name axis_fifo
  set block_cell_name axis_fifo_0
  if { [catch {set axis_fifo_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_fifo_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.FIFO_SIZE_L2 {11} \
   CONFIG.WIDTH_USER {4} \
 ] $axis_fifo_0

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Enable_Data_Counts_axis {true} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {2048} \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.TUSER_WIDTH {4} \
 ] $fifo_generator_0

  # Create instance: fifo_generator_1, and set properties
  set fifo_generator_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_1 ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Enable_Data_Counts_axis {true} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {2048} \
   CONFIG.TDATA_NUM_BYTES {8} \
   CONFIG.TUSER_WIDTH {4} \
 ] $fifo_generator_1

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
  
  # Create instance: gmii_to_xgmil_1, and set properties
  set block_name gmii_to_xgmil
  set block_cell_name gmii_to_xgmil_1
  if { [catch {set gmii_to_xgmil_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gmii_to_xgmil_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {5} \
 ] $system_ila_0

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_MONITOR_SLOTS {15} \
   CONFIG.C_NUM_OF_PROBES {15} \
 ] $system_ila_1

  # Create instance: system_ila_2, and set properties
  set system_ila_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_2 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_MONITOR_SLOTS {5} \
   CONFIG.C_NUM_OF_PROBES {5} \
 ] $system_ila_2

  # Create instance: system_ila_3, and set properties
  set system_ila_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_3 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {18} \
 ] $system_ila_3

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xgmii_find_packet_end_0, and set properties
  set block_name xgmii_find_packet_end
  set block_cell_name xgmii_find_packet_end_0
  if { [catch {set xgmii_find_packet_end_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $xgmii_find_packet_end_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xgmii_make_contiguous_0, and set properties
  set block_name xgmii_make_contiguous
  set block_cell_name xgmii_make_contiguous_0
  if { [catch {set xgmii_make_contiguous_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $xgmii_make_contiguous_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xgmii_tx_nofcs_0, and set properties
  set block_name xgmii_tx_nofcs
  set block_cell_name xgmii_tx_nofcs_0
  if { [catch {set xgmii_tx_nofcs_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $xgmii_tx_nofcs_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins XGMII_CLK] [get_bd_pins axis_arbiter_0/CLK] [get_bd_pins axis_fifo_0/CLK] [get_bd_pins fifo_generator_0/m_aclk] [get_bd_pins fifo_generator_1/m_aclk] [get_bd_pins system_ila_1/clk] [get_bd_pins system_ila_3/clk] [get_bd_pins xgmii_find_packet_end_0/CLK] [get_bd_pins xgmii_make_contiguous_0/CLK] [get_bd_pins xgmii_tx_nofcs_0/CLK]
  connect_bd_net -net GMII_CTRL_0_1 [get_bd_pins RXC_IN_1] [get_bd_pins gmii_to_xgmil_1/GMII_CTRL] [get_bd_pins system_ila_2/probe0]
  connect_bd_net -net GMII_D_0_1 [get_bd_pins RXD_IN_1] [get_bd_pins gmii_to_xgmil_1/GMII_D] [get_bd_pins system_ila_2/probe1]
  connect_bd_net -net Op1_1 [get_bd_pins XGMII_RESET] [get_bd_pins util_vector_logic_0/Op1] [get_bd_pins xgmii_tx_nofcs_0/RESET]
  connect_bd_net -net RESETN1_1 [get_bd_pins GMII_RESETN] [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins fifo_generator_1/s_aresetn] [get_bd_pins gmii_to_xgmil_0/RESETN] [get_bd_pins gmii_to_xgmil_1/RESETN]
  connect_bd_net -net RESETN_1 [get_bd_pins axis_arbiter_0/RESETN] [get_bd_pins axis_fifo_0/RESETN] [get_bd_pins util_vector_logic_0/Res] [get_bd_pins xgmii_find_packet_end_0/RESETN] [get_bd_pins xgmii_make_contiguous_0/RESETN]
  connect_bd_net -net RXC_IN_1 [get_bd_pins RXC_IN_0] [get_bd_pins gmii_to_xgmil_0/GMII_CTRL] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net RXD_IN_1 [get_bd_pins RXD_IN_0] [get_bd_pins gmii_to_xgmil_0/GMII_D] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net axis_arbiter_0_CUR_SOURCE [get_bd_pins axis_arbiter_0/CUR_SOURCE] [get_bd_pins system_ila_1/probe14]
  connect_bd_net -net axis_arbiter_0_IV0_TREADY [get_bd_pins axis_arbiter_0/IV0_TREADY] [get_bd_pins fifo_generator_0/m_axis_tready] [get_bd_pins system_ila_1/probe7]
  connect_bd_net -net axis_arbiter_0_IV1_TREADY [get_bd_pins axis_arbiter_0/IV1_TREADY] [get_bd_pins fifo_generator_1/m_axis_tready] [get_bd_pins system_ila_1/probe2]
  connect_bd_net -net axis_arbiter_0_OV_TLAST [get_bd_pins axis_arbiter_0/OV_TLAST] [get_bd_pins xgmii_find_packet_end_0/XGMII_LAST]
  connect_bd_net -net axis_fifo_0_OV_TDATA [get_bd_pins axis_fifo_0/OV_TDATA] [get_bd_pins system_ila_3/probe8] [get_bd_pins xgmii_make_contiguous_0/IVAL_TDATA]
  connect_bd_net -net axis_fifo_0_OV_TLAST [get_bd_pins axis_fifo_0/OV_TLAST] [get_bd_pins system_ila_3/probe9] [get_bd_pins xgmii_make_contiguous_0/IVAL_TLAST]
  connect_bd_net -net axis_fifo_0_OV_TUSER [get_bd_pins axis_fifo_0/OV_TUSER] [get_bd_pins system_ila_3/probe10] [get_bd_pins xgmii_make_contiguous_0/IVAL_TUSER]
  connect_bd_net -net axis_fifo_0_OV_TVALID [get_bd_pins axis_fifo_0/OV_TVALID] [get_bd_pins system_ila_3/probe11] [get_bd_pins xgmii_make_contiguous_0/IVAL_TVALID]
  connect_bd_net -net fifo_generator_0_axis_rd_data_count [get_bd_pins axis_arbiter_0/CAP_POP0] [get_bd_pins fifo_generator_0/axis_rd_data_count]
  connect_bd_net -net fifo_generator_0_m_axis_tdata [get_bd_pins axis_arbiter_0/IV0_TDATA] [get_bd_pins fifo_generator_0/m_axis_tdata] [get_bd_pins system_ila_1/probe5]
  connect_bd_net -net fifo_generator_0_m_axis_tlast [get_bd_pins axis_arbiter_0/IV0_TLAST] [get_bd_pins fifo_generator_0/m_axis_tlast] [get_bd_pins system_ila_1/probe6]
  connect_bd_net -net fifo_generator_0_m_axis_tuser [get_bd_pins axis_arbiter_0/IV0_TUSER] [get_bd_pins fifo_generator_0/m_axis_tuser] [get_bd_pins system_ila_1/probe8]
  connect_bd_net -net fifo_generator_0_m_axis_tvalid [get_bd_pins axis_arbiter_0/IV0_TVALID] [get_bd_pins fifo_generator_0/m_axis_tvalid] [get_bd_pins system_ila_1/probe9]
  connect_bd_net -net fifo_generator_1_axis_rd_data_count [get_bd_pins axis_arbiter_0/CAP_POP1] [get_bd_pins fifo_generator_1/axis_rd_data_count]
  connect_bd_net -net fifo_generator_1_m_axis_tdata [get_bd_pins axis_arbiter_0/IV1_TDATA] [get_bd_pins fifo_generator_1/m_axis_tdata] [get_bd_pins system_ila_1/probe0]
  connect_bd_net -net fifo_generator_1_m_axis_tlast [get_bd_pins axis_arbiter_0/IV1_TLAST] [get_bd_pins fifo_generator_1/m_axis_tlast] [get_bd_pins system_ila_1/probe1]
  connect_bd_net -net fifo_generator_1_m_axis_tuser [get_bd_pins axis_arbiter_0/IV1_TUSER] [get_bd_pins fifo_generator_1/m_axis_tuser] [get_bd_pins system_ila_1/probe3]
  connect_bd_net -net fifo_generator_1_m_axis_tvalid [get_bd_pins axis_arbiter_0/IV1_TVALID] [get_bd_pins fifo_generator_1/m_axis_tvalid] [get_bd_pins system_ila_1/probe4]
  connect_bd_net -net gmii_to_xgmii_axis_arbiter_0_OV_TDATA [get_bd_pins axis_arbiter_0/OV_TDATA] [get_bd_pins system_ila_1/probe10] [get_bd_pins system_ila_3/probe1] [get_bd_pins xgmii_find_packet_end_0/XGMII_D]
  connect_bd_net -net gmii_to_xgmii_axis_arbiter_0_OV_TUSER [get_bd_pins axis_arbiter_0/OV_TUSER] [get_bd_pins system_ila_1/probe11] [get_bd_pins system_ila_3/probe0] [get_bd_pins xgmii_find_packet_end_0/XGMII_LEN]
  connect_bd_net -net gmii_to_xgmii_axis_arbiter_0_OV_TVALID [get_bd_pins axis_arbiter_0/OV_TVALID] [get_bd_pins system_ila_1/probe12] [get_bd_pins system_ila_3/probe2] [get_bd_pins xgmii_find_packet_end_0/XGMII_EN]
  connect_bd_net -net gmii_to_xgmii_xlconstant_1_dout [get_bd_pins axis_arbiter_0/OV_TREADY] [get_bd_pins system_ila_1/probe13] [get_bd_pins xgmii_tx_nofcs_0/CLOCK_EN] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net gmii_to_xgmil_0_CE_OUT [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins gmii_to_xgmil_0/XGMII_EN] [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net gmii_to_xgmil_0_RXD_OUT [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins gmii_to_xgmil_0/XGMII_D] [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net gmii_to_xgmil_0_RXLEN_OUT [get_bd_pins fifo_generator_0/s_axis_tuser] [get_bd_pins gmii_to_xgmil_0/XGMII_LEN] [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net gmii_to_xgmil_0_XGMII_LAST [get_bd_pins fifo_generator_0/s_axis_tlast] [get_bd_pins gmii_to_xgmil_0/XGMII_LAST]
  connect_bd_net -net gmii_to_xgmil_1_XGMII_D [get_bd_pins fifo_generator_1/s_axis_tdata] [get_bd_pins gmii_to_xgmil_1/XGMII_D] [get_bd_pins system_ila_2/probe3]
  connect_bd_net -net gmii_to_xgmil_1_XGMII_EN [get_bd_pins fifo_generator_1/s_axis_tvalid] [get_bd_pins gmii_to_xgmil_1/XGMII_EN] [get_bd_pins system_ila_2/probe4]
  connect_bd_net -net gmii_to_xgmil_1_XGMII_LAST [get_bd_pins fifo_generator_1/s_axis_tlast] [get_bd_pins gmii_to_xgmil_1/XGMII_LAST]
  connect_bd_net -net gmii_to_xgmil_1_XGMII_LEN [get_bd_pins fifo_generator_1/s_axis_tuser] [get_bd_pins gmii_to_xgmil_1/XGMII_LEN] [get_bd_pins system_ila_2/probe2]
  connect_bd_net -net s_aclk_1 [get_bd_pins GMII_CLK] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins fifo_generator_1/s_aclk] [get_bd_pins gmii_to_xgmil_0/CLK] [get_bd_pins gmii_to_xgmil_1/CLK] [get_bd_pins system_ila_0/clk] [get_bd_pins system_ila_2/clk]
  connect_bd_net -net xgmii_find_packet_end_0_OVAL_TDATA [get_bd_pins axis_fifo_0/IV_TDATA] [get_bd_pins system_ila_3/probe3] [get_bd_pins xgmii_find_packet_end_0/OVAL_TDATA]
  connect_bd_net -net xgmii_find_packet_end_0_OVAL_TLAST [get_bd_pins axis_fifo_0/IV_TLAST] [get_bd_pins system_ila_3/probe6] [get_bd_pins xgmii_find_packet_end_0/OVAL_TLAST]
  connect_bd_net -net xgmii_find_packet_end_0_OVAL_TUSER [get_bd_pins axis_fifo_0/IV_TUSER] [get_bd_pins system_ila_3/probe5] [get_bd_pins xgmii_find_packet_end_0/OVAL_TUSER]
  connect_bd_net -net xgmii_find_packet_end_0_OVAL_TVALID [get_bd_pins axis_fifo_0/IV_TVALID] [get_bd_pins system_ila_3/probe4] [get_bd_pins xgmii_find_packet_end_0/OVAL_TVALID]
  connect_bd_net -net xgmii_find_packet_end_0_PACKET_END [get_bd_pins system_ila_3/probe7] [get_bd_pins xgmii_find_packet_end_0/PACKET_END] [get_bd_pins xgmii_make_contiguous_0/PACKET_END]
  connect_bd_net -net xgmii_make_contiguous_0_DBG_IFG [get_bd_pins system_ila_3/probe17] [get_bd_pins xgmii_make_contiguous_0/DBG_IFG]
  connect_bd_net -net xgmii_make_contiguous_0_DBG_PCNT [get_bd_pins system_ila_3/probe16] [get_bd_pins xgmii_make_contiguous_0/DBG_PCNT]
  connect_bd_net -net xgmii_make_contiguous_0_ERR_CONT [get_bd_pins system_ila_3/probe15] [get_bd_pins xgmii_make_contiguous_0/ERR_CONT]
  connect_bd_net -net xgmii_make_contiguous_0_IVAL_TREADY [get_bd_pins axis_fifo_0/OV_TREADY] [get_bd_pins system_ila_3/probe12] [get_bd_pins xgmii_make_contiguous_0/IVAL_TREADY]
  connect_bd_net -net xgmii_make_contiguous_0_OVAL_XGMII_D [get_bd_pins system_ila_3/probe13] [get_bd_pins xgmii_make_contiguous_0/OVAL_XGMII_D] [get_bd_pins xgmii_tx_nofcs_0/TXD_IN]
  connect_bd_net -net xgmii_make_contiguous_0_OVAL_XGMII_HALFDELAY [get_bd_pins xgmii_make_contiguous_0/OVAL_XGMII_HALFDELAY] [get_bd_pins xgmii_tx_nofcs_0/TXHD_IN]
  connect_bd_net -net xgmii_make_contiguous_0_OVAL_XGMII_LEN [get_bd_pins system_ila_3/probe14] [get_bd_pins xgmii_make_contiguous_0/OVAL_XGMII_LEN] [get_bd_pins xgmii_tx_nofcs_0/TXLEN_IN]
  connect_bd_net -net xgmii_tx_nofcs_0_TXC_OUT [get_bd_pins TXC_OUT] [get_bd_pins xgmii_tx_nofcs_0/TXC_OUT]
  connect_bd_net -net xgmii_tx_nofcs_0_TXD_OUT [get_bd_pins TXD_OUT] [get_bd_pins xgmii_tx_nofcs_0/TXD_OUT]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: eth10g_0
proc create_hier_cell_eth10g_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eth10g_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 MGTCLK0

  # Create pins
  create_bd_pin -dir I SFP1_RX_LOS
  create_bd_pin -dir I SFP1_RX_N
  create_bd_pin -dir I SFP1_RX_P
  create_bd_pin -dir O SFP1_TX_DISABLE
  create_bd_pin -dir O SFP1_TX_N
  create_bd_pin -dir O SFP1_TX_P
  create_bd_pin -dir O -type clk XGMII_CLK
  create_bd_pin -dir O -type rst XGMII_RESET
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir I -type clk sysclk_125
  create_bd_pin -dir O -from 7 -to 0 xgmii_rxc
  create_bd_pin -dir O -from 63 -to 0 xgmii_rxd
  create_bd_pin -dir I -from 7 -to 0 xgmii_txc
  create_bd_pin -dir I -from 63 -to 0 xgmii_txd

  # Create instance: eth_ctrl_0, and set properties
  set block_name eth_ctrl
  set block_cell_name eth_ctrl_0
  if { [catch {set eth_ctrl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $eth_ctrl_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ten_gig_eth_pcs_pma_0, and set properties
  set ten_gig_eth_pcs_pma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ten_gig_eth_pcs_pma:6.0 ten_gig_eth_pcs_pma_0 ]
  set_property -dict [ list \
   CONFIG.Locations {X0Y8} \
   CONFIG.RefClk {clk0} \
   CONFIG.SupportLevel {1} \
   CONFIG.base_kr {BASE-R} \
   CONFIG.no_ebuff {false} \
 ] $ten_gig_eth_pcs_pma_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins MGTCLK0] [get_bd_intf_pins ten_gig_eth_pcs_pma_0/refclk_diff_port]
  connect_bd_intf_net -intf_net ten_gig_eth_pcs_pma_0_core_to_gt_drp [get_bd_intf_pins ten_gig_eth_pcs_pma_0/core_to_gt_drp] [get_bd_intf_pins ten_gig_eth_pcs_pma_0/gt_drp]

  # Create port connections
  connect_bd_net -net SFP1_RX_LOS_1 [get_bd_pins SFP1_RX_LOS] [get_bd_pins eth_ctrl_0/rx_loss]
  connect_bd_net -net SFP1_RX_N_1 [get_bd_pins SFP1_RX_N] [get_bd_pins ten_gig_eth_pcs_pma_0/rxn]
  connect_bd_net -net SFP1_RX_P_1 [get_bd_pins SFP1_RX_P] [get_bd_pins ten_gig_eth_pcs_pma_0/rxp]
  connect_bd_net -net eth_ctrl_0_mdc [get_bd_pins eth_ctrl_0/mdc] [get_bd_pins ten_gig_eth_pcs_pma_0/mdc]
  connect_bd_net -net eth_ctrl_0_mdio_w [get_bd_pins eth_ctrl_0/mdio_w] [get_bd_pins ten_gig_eth_pcs_pma_0/mdio_in]
  connect_bd_net -net eth_ctrl_0_pma_pmd_type [get_bd_pins eth_ctrl_0/pma_pmd_type] [get_bd_pins ten_gig_eth_pcs_pma_0/pma_pmd_type]
  connect_bd_net -net eth_ctrl_0_prtad [get_bd_pins eth_ctrl_0/prtad] [get_bd_pins ten_gig_eth_pcs_pma_0/prtad]
  connect_bd_net -net eth_ctrl_0_signal_detect [get_bd_pins eth_ctrl_0/signal_detect] [get_bd_pins ten_gig_eth_pcs_pma_0/signal_detect]
  connect_bd_net -net eth_ctrl_0_sim_speedup_control [get_bd_pins eth_ctrl_0/sim_speedup_control] [get_bd_pins ten_gig_eth_pcs_pma_0/sim_speedup_control]
  connect_bd_net -net eth_ctrl_0_tx_fault [get_bd_pins eth_ctrl_0/tx_fault] [get_bd_pins ten_gig_eth_pcs_pma_0/tx_fault]
  connect_bd_net -net reset1_1 [get_bd_pins reset] [get_bd_pins ten_gig_eth_pcs_pma_0/reset]
  connect_bd_net -net sysclk_125_1 [get_bd_pins sysclk_125] [get_bd_pins ten_gig_eth_pcs_pma_0/dclk]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_areset_datapathclk_out [get_bd_pins XGMII_RESET] [get_bd_pins ten_gig_eth_pcs_pma_0/areset_datapathclk_out]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_drp_req [get_bd_pins ten_gig_eth_pcs_pma_0/drp_gnt] [get_bd_pins ten_gig_eth_pcs_pma_0/drp_req]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_tx_disable [get_bd_pins SFP1_TX_DISABLE] [get_bd_pins ten_gig_eth_pcs_pma_0/tx_disable]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_txn [get_bd_pins SFP1_TX_N] [get_bd_pins ten_gig_eth_pcs_pma_0/txn]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_txp [get_bd_pins SFP1_TX_P] [get_bd_pins ten_gig_eth_pcs_pma_0/txp]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_txusrclk2_out [get_bd_pins XGMII_CLK] [get_bd_pins ten_gig_eth_pcs_pma_0/txusrclk2_out]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_xgmii_rxc [get_bd_pins xgmii_rxc] [get_bd_pins ten_gig_eth_pcs_pma_0/xgmii_rxc]
  connect_bd_net -net ten_gig_eth_pcs_pma_0_xgmii_rxd [get_bd_pins xgmii_rxd] [get_bd_pins ten_gig_eth_pcs_pma_0/xgmii_rxd]
  connect_bd_net -net xgmii_txc_0_1 [get_bd_pins xgmii_txc] [get_bd_pins ten_gig_eth_pcs_pma_0/xgmii_txc]
  connect_bd_net -net xgmii_txd_0_1 [get_bd_pins xgmii_txd] [get_bd_pins ten_gig_eth_pcs_pma_0/xgmii_txd]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RX2_TX1
proc create_hier_cell_RX2_TX1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_RX2_TX1() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir O GMII_CTRL
  create_bd_pin -dir O -from 7 -to 0 GMII_D
  create_bd_pin -dir O MDC
  create_bd_pin -dir IO MDIO
  create_bd_pin -dir I -type clk RX_CLK
  create_bd_pin -dir I RX_CTRL
  create_bd_pin -dir I -from 3 -to 0 RX_D
  create_bd_pin -dir O TX_CTRL
  create_bd_pin -dir O -from 3 -to 0 TX_D
  create_bd_pin -dir I -type clk clk_125
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir I -type rst reset_125

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
  
  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

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
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins clk_125] [get_bd_pins fifo_generator_0/m_aclk] [get_bd_pins fifo_read_throttle_0/CLK] [get_bd_pins gmii_to_rgmii_0/CLK]
  connect_bd_net -net Net [get_bd_pins MDIO] [get_bd_pins eth_phy_ctrl_0/MDIO]
  connect_bd_net -net PHY1_RX_CLK_1 [get_bd_pins RX_CLK] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins rgmii_to_gmii_0/CLK]
  connect_bd_net -net PHY1_RX_CTRL_1 [get_bd_pins RX_CTRL] [get_bd_pins rgmii_to_gmii_0/RGMII_CTRL_IN]
  connect_bd_net -net PHY1_RX_D_1 [get_bd_pins RX_D] [get_bd_pins rgmii_to_gmii_0/RGMII_D_IN]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net eth_phy_ctrl_0_MDC [get_bd_pins MDC] [get_bd_pins eth_phy_ctrl_0/MDC]
  connect_bd_net -net fifo_generator_0_m_axis_tdata [get_bd_pins fifo_generator_0/m_axis_tdata] [get_bd_pins fifo_read_throttle_0/DATA_IN]
  connect_bd_net -net fifo_generator_0_m_axis_tvalid [get_bd_pins fifo_generator_0/m_axis_tvalid] [get_bd_pins fifo_read_throttle_0/VALID_IN]
  connect_bd_net -net fifo_read_throttle_0_CTRL_OUT [get_bd_pins GMII_CTRL] [get_bd_pins fifo_read_throttle_0/CTRL_OUT] [get_bd_pins gmii_to_rgmii_0/TX_CTRL_IN]
  connect_bd_net -net fifo_read_throttle_0_DATA_OUT [get_bd_pins GMII_D] [get_bd_pins fifo_read_throttle_0/DATA_OUT] [get_bd_pins gmii_to_rgmii_0/TX_D_IN]
  connect_bd_net -net fifo_read_throttle_0_READ_EN_OUT [get_bd_pins fifo_generator_0/m_axis_tready] [get_bd_pins fifo_read_throttle_0/READ_EN_OUT]
  connect_bd_net -net gmii_to_rgmii_0_TX_CTRL_OUT [get_bd_pins TX_CTRL] [get_bd_pins gmii_to_rgmii_0/TX_CTRL_OUT]
  connect_bd_net -net gmii_to_rgmii_0_TX_D_OUT [get_bd_pins TX_D] [get_bd_pins gmii_to_rgmii_0/TX_D_OUT]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins reset_125] [get_bd_pins fifo_read_throttle_0/RESET] [get_bd_pins gmii_to_rgmii_0/RESET]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net rgmii_to_gmii_0_GMII_CTRL_OUT [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins rgmii_to_gmii_0/GMII_CTRL_OUT]
  connect_bd_net -net rgmii_to_gmii_0_GMII_D_OUT [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins rgmii_to_gmii_0/GMII_D_OUT]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gmii_to_rgmii_0/TX_ERR_IN] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RX1_TX2
proc create_hier_cell_RX1_TX2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_RX1_TX2() - Empty argument(s)!"}
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

  # Create pins
  create_bd_pin -dir O GMII_CTRL
  create_bd_pin -dir O -from 7 -to 0 GMII_D
  create_bd_pin -dir O MDC
  create_bd_pin -dir IO MDIO
  create_bd_pin -dir I -type clk RX_CLK
  create_bd_pin -dir I RX_CTRL
  create_bd_pin -dir I -from 3 -to 0 RX_D
  create_bd_pin -dir O TX_CTRL
  create_bd_pin -dir O -from 3 -to 0 TX_D
  create_bd_pin -dir I -type clk clk_125
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir I -type rst reset_125

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
  
  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

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
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create port connections
  connect_bd_net -net CLK_1 [get_bd_pins clk_125] [get_bd_pins fifo_generator_0/m_aclk] [get_bd_pins fifo_read_throttle_0/CLK] [get_bd_pins gmii_to_rgmii_0/CLK]
  connect_bd_net -net Net [get_bd_pins MDIO] [get_bd_pins eth_phy_ctrl_0/MDIO]
  connect_bd_net -net PHY1_RX_CLK_1 [get_bd_pins RX_CLK] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins rgmii_to_gmii_0/CLK]
  connect_bd_net -net PHY1_RX_CTRL_1 [get_bd_pins RX_CTRL] [get_bd_pins rgmii_to_gmii_0/RGMII_CTRL_IN]
  connect_bd_net -net PHY1_RX_D_1 [get_bd_pins RX_D] [get_bd_pins rgmii_to_gmii_0/RGMII_D_IN]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net eth_phy_ctrl_0_MDC [get_bd_pins MDC] [get_bd_pins eth_phy_ctrl_0/MDC]
  connect_bd_net -net fifo_generator_0_m_axis_tdata [get_bd_pins fifo_generator_0/m_axis_tdata] [get_bd_pins fifo_read_throttle_0/DATA_IN]
  connect_bd_net -net fifo_generator_0_m_axis_tvalid [get_bd_pins fifo_generator_0/m_axis_tvalid] [get_bd_pins fifo_read_throttle_0/VALID_IN]
  connect_bd_net -net fifo_read_throttle_0_CTRL_OUT [get_bd_pins GMII_CTRL] [get_bd_pins fifo_read_throttle_0/CTRL_OUT] [get_bd_pins gmii_to_rgmii_0/TX_CTRL_IN]
  connect_bd_net -net fifo_read_throttle_0_DATA_OUT [get_bd_pins GMII_D] [get_bd_pins fifo_read_throttle_0/DATA_OUT] [get_bd_pins gmii_to_rgmii_0/TX_D_IN]
  connect_bd_net -net fifo_read_throttle_0_READ_EN_OUT [get_bd_pins fifo_generator_0/m_axis_tready] [get_bd_pins fifo_read_throttle_0/READ_EN_OUT]
  connect_bd_net -net gmii_to_rgmii_0_TX_CTRL_OUT [get_bd_pins TX_CTRL] [get_bd_pins gmii_to_rgmii_0/TX_CTRL_OUT]
  connect_bd_net -net gmii_to_rgmii_0_TX_D_OUT [get_bd_pins TX_D] [get_bd_pins gmii_to_rgmii_0/TX_D_OUT]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins reset_125] [get_bd_pins fifo_read_throttle_0/RESET] [get_bd_pins gmii_to_rgmii_0/RESET]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net rgmii_to_gmii_0_GMII_CTRL_OUT [get_bd_pins fifo_generator_0/s_axis_tvalid] [get_bd_pins rgmii_to_gmii_0/GMII_CTRL_OUT]
  connect_bd_net -net rgmii_to_gmii_0_GMII_D_OUT [get_bd_pins fifo_generator_0/s_axis_tdata] [get_bd_pins rgmii_to_gmii_0/GMII_D_OUT]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins gmii_to_rgmii_0/TX_ERR_IN] [get_bd_pins xlconstant_0/dout]

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
  set MGTCLK0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 MGTCLK0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $MGTCLK0
  set default_sysclk_250 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk_250 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {250000000} \
   ] $default_sysclk_250

  # Create ports
  set DEBUG_CLK [ create_bd_port -dir O -type clk DEBUG_CLK ]
  set PHY1_GTX_CLK [ create_bd_port -dir O -type clk PHY1_GTX_CLK ]
  set PHY1_MDC [ create_bd_port -dir O PHY1_MDC ]
  set PHY1_MDIO [ create_bd_port -dir IO PHY1_MDIO ]
  set PHY1_RESETN [ create_bd_port -dir O -from 0 -to 0 -type rst PHY1_RESETN ]
  set PHY1_RX_CLK [ create_bd_port -dir I -type clk PHY1_RX_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $PHY1_RX_CLK
  set PHY1_RX_CTRL [ create_bd_port -dir I PHY1_RX_CTRL ]
  set PHY1_RX_D [ create_bd_port -dir I -from 3 -to 0 PHY1_RX_D ]
  set PHY1_TX_CTRL [ create_bd_port -dir O PHY1_TX_CTRL ]
  set PHY1_TX_D [ create_bd_port -dir O -from 3 -to 0 PHY1_TX_D ]
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
  set SFP1_RX_LOS [ create_bd_port -dir I SFP1_RX_LOS ]
  set SFP1_RX_N [ create_bd_port -dir I SFP1_RX_N ]
  set SFP1_RX_P [ create_bd_port -dir I SFP1_RX_P ]
  set SFP1_TX_DISABLE [ create_bd_port -dir O SFP1_TX_DISABLE ]
  set SFP1_TX_N [ create_bd_port -dir O SFP1_TX_N ]
  set SFP1_TX_P [ create_bd_port -dir O SFP1_TX_P ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset

  # Create instance: RX1_TX2
  create_hier_cell_RX1_TX2 [current_bd_instance .] RX1_TX2

  # Create instance: RX2_TX1
  create_hier_cell_RX2_TX1 [current_bd_instance .] RX2_TX1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {40.0} \
   CONFIG.CLKOUT1_JITTER {102.531} \
   CONFIG.CLKOUT1_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} \
   CONFIG.CLKOUT1_USED {true} \
   CONFIG.CLKOUT2_JITTER {107.111} \
   CONFIG.CLKOUT2_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_USED {false} \
   CONFIG.CLKOUT3_JITTER {89.528} \
   CONFIG.CLKOUT3_PHASE_ERROR {85.928} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk_250} \
   CONFIG.CLK_OUT1_PORT {clk_125} \
   CONFIG.CLK_OUT2_PORT {clk_out2} \
   CONFIG.CLK_OUT3_PORT {clk_out3} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {4.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {4.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {1} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
 ] $clk_wiz_0

  # Create instance: eth10g_0
  create_hier_cell_eth10g_0 [current_bd_instance .] eth10g_0

  # Create instance: gmii_to_xgmii
  create_hier_cell_gmii_to_xgmii [current_bd_instance .] gmii_to_xgmii

  # Create instance: proc_sys_reset_125, and set properties
  set proc_sys_reset_125 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_125 ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {4} \
 ] $system_ila_0

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {2} \
 ] $system_ila_1

  # Create interface connections
  connect_bd_intf_net -intf_net MGTCLK0_1 [get_bd_intf_ports MGTCLK0] [get_bd_intf_pins eth10g_0/MGTCLK0]
  connect_bd_intf_net -intf_net default_sysclk_250_1 [get_bd_intf_ports default_sysclk_250] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net ETH10G_0_XGMII_CLK [get_bd_pins eth10g_0/XGMII_CLK] [get_bd_pins gmii_to_xgmii/XGMII_CLK] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net ETH10G_0_XGMII_RESET [get_bd_pins eth10g_0/XGMII_RESET] [get_bd_pins gmii_to_xgmii/XGMII_RESET]
  connect_bd_net -net Net [get_bd_ports PHY2_MDIO] [get_bd_pins RX1_TX2/MDIO]
  connect_bd_net -net Net1 [get_bd_ports PHY1_MDIO] [get_bd_pins RX2_TX1/MDIO]
  connect_bd_net -net PHY1_RX_CLK_1 [get_bd_ports DEBUG_CLK] [get_bd_ports PHY1_RX_CLK] [get_bd_pins RX1_TX2/RX_CLK]
  connect_bd_net -net PHY1_RX_CTRL_1 [get_bd_ports PHY1_RX_CTRL] [get_bd_pins RX1_TX2/RX_CTRL]
  connect_bd_net -net PHY1_RX_D_1 [get_bd_ports PHY1_RX_D] [get_bd_pins RX1_TX2/RX_D]
  connect_bd_net -net RX1_TX2_GMII_CTRL [get_bd_pins RX1_TX2/GMII_CTRL] [get_bd_pins gmii_to_xgmii/RXC_IN_0] [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net RX1_TX2_GMII_D [get_bd_pins RX1_TX2/GMII_D] [get_bd_pins gmii_to_xgmii/RXD_IN_0] [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net RX1_TX2_MDC [get_bd_ports PHY2_MDC] [get_bd_pins RX1_TX2/MDC]
  connect_bd_net -net RX1_TX2_TX_CTRL [get_bd_ports PHY2_TX_CTRL] [get_bd_pins RX1_TX2/TX_CTRL]
  connect_bd_net -net RX1_TX2_TX_D [get_bd_ports PHY2_TX_D] [get_bd_pins RX1_TX2/TX_D]
  connect_bd_net -net RX2_TX1_GMII_CTRL [get_bd_pins RX2_TX1/GMII_CTRL] [get_bd_pins gmii_to_xgmii/RXC_IN_1] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net RX2_TX1_GMII_D [get_bd_pins RX2_TX1/GMII_D] [get_bd_pins gmii_to_xgmii/RXD_IN_1] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net RX2_TX1_MDC [get_bd_ports PHY1_MDC] [get_bd_pins RX2_TX1/MDC]
  connect_bd_net -net RX2_TX1_TX_CTRL [get_bd_ports PHY1_TX_CTRL] [get_bd_pins RX2_TX1/TX_CTRL]
  connect_bd_net -net RX2_TX1_TX_D [get_bd_ports PHY1_TX_D] [get_bd_pins RX2_TX1/TX_D]
  connect_bd_net -net RX_CLK_0_1 [get_bd_ports PHY2_RX_CLK] [get_bd_pins RX2_TX1/RX_CLK]
  connect_bd_net -net RX_CTRL_0_1 [get_bd_ports PHY2_RX_CTRL] [get_bd_pins RX2_TX1/RX_CTRL]
  connect_bd_net -net RX_D_0_1 [get_bd_ports PHY2_RX_D] [get_bd_pins RX2_TX1/RX_D]
  connect_bd_net -net SFP1_RX_LOS_1 [get_bd_ports SFP1_RX_LOS] [get_bd_pins eth10g_0/SFP1_RX_LOS]
  connect_bd_net -net SFP1_RX_N_1 [get_bd_ports SFP1_RX_N] [get_bd_pins eth10g_0/SFP1_RX_N]
  connect_bd_net -net SFP1_RX_P_1 [get_bd_ports SFP1_RX_P] [get_bd_pins eth10g_0/SFP1_RX_P]
  connect_bd_net -net clk_wiz_0_clk_125 [get_bd_ports PHY1_GTX_CLK] [get_bd_ports PHY2_GTX_CLK] [get_bd_pins RX1_TX2/clk_125] [get_bd_pins RX2_TX1/clk_125] [get_bd_pins clk_wiz_0/clk_125] [get_bd_pins eth10g_0/sysclk_125] [get_bd_pins gmii_to_xgmii/GMII_CLK] [get_bd_pins proc_sys_reset_125/slowest_sync_clk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins RX1_TX2/dcm_locked] [get_bd_pins RX2_TX1/dcm_locked] [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_125/dcm_locked]
  connect_bd_net -net eth10g_0_SFP1_TX_DISABLE [get_bd_ports SFP1_TX_DISABLE] [get_bd_pins eth10g_0/SFP1_TX_DISABLE]
  connect_bd_net -net eth10g_0_SFP1_TX_N [get_bd_ports SFP1_TX_N] [get_bd_pins eth10g_0/SFP1_TX_N]
  connect_bd_net -net eth10g_0_SFP1_TX_P [get_bd_ports SFP1_TX_P] [get_bd_pins eth10g_0/SFP1_TX_P]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_ports PHY1_RESETN] [get_bd_ports PHY2_RESETN] [get_bd_pins gmii_to_xgmii/GMII_RESETN] [get_bd_pins proc_sys_reset_125/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins RX1_TX2/reset_125] [get_bd_pins RX2_TX1/reset_125] [get_bd_pins proc_sys_reset_125/peripheral_reset]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins RX1_TX2/reset] [get_bd_pins RX2_TX1/reset] [get_bd_pins clk_wiz_0/reset] [get_bd_pins eth10g_0/reset] [get_bd_pins proc_sys_reset_125/ext_reset_in]
  connect_bd_net -net xgmii_txc_1 [get_bd_pins eth10g_0/xgmii_txc] [get_bd_pins gmii_to_xgmii/TXC_OUT] [get_bd_pins system_ila_1/probe1]
  connect_bd_net -net xgmii_txd_1 [get_bd_pins eth10g_0/xgmii_txd] [get_bd_pins gmii_to_xgmii/TXD_OUT] [get_bd_pins system_ila_1/probe0]

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


