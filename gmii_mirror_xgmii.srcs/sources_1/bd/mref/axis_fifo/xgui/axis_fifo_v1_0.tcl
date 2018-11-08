# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "FIFO_DELAY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIFO_REG" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FIFO_SIZE_L2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_DATA" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_KEEP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_LAST" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_USER" -parent ${Page_0}


}

proc update_PARAM_VALUE.FIFO_DELAY { PARAM_VALUE.FIFO_DELAY } {
	# Procedure called to update FIFO_DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_DELAY { PARAM_VALUE.FIFO_DELAY } {
	# Procedure called to validate FIFO_DELAY
	return true
}

proc update_PARAM_VALUE.FIFO_REG { PARAM_VALUE.FIFO_REG } {
	# Procedure called to update FIFO_REG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_REG { PARAM_VALUE.FIFO_REG } {
	# Procedure called to validate FIFO_REG
	return true
}

proc update_PARAM_VALUE.FIFO_SIZE_L2 { PARAM_VALUE.FIFO_SIZE_L2 } {
	# Procedure called to update FIFO_SIZE_L2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FIFO_SIZE_L2 { PARAM_VALUE.FIFO_SIZE_L2 } {
	# Procedure called to validate FIFO_SIZE_L2
	return true
}

proc update_PARAM_VALUE.WIDTH_DATA { PARAM_VALUE.WIDTH_DATA } {
	# Procedure called to update WIDTH_DATA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_DATA { PARAM_VALUE.WIDTH_DATA } {
	# Procedure called to validate WIDTH_DATA
	return true
}

proc update_PARAM_VALUE.WIDTH_ID { PARAM_VALUE.WIDTH_ID } {
	# Procedure called to update WIDTH_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_ID { PARAM_VALUE.WIDTH_ID } {
	# Procedure called to validate WIDTH_ID
	return true
}

proc update_PARAM_VALUE.WIDTH_KEEP { PARAM_VALUE.WIDTH_KEEP } {
	# Procedure called to update WIDTH_KEEP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_KEEP { PARAM_VALUE.WIDTH_KEEP } {
	# Procedure called to validate WIDTH_KEEP
	return true
}

proc update_PARAM_VALUE.WIDTH_LAST { PARAM_VALUE.WIDTH_LAST } {
	# Procedure called to update WIDTH_LAST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_LAST { PARAM_VALUE.WIDTH_LAST } {
	# Procedure called to validate WIDTH_LAST
	return true
}

proc update_PARAM_VALUE.WIDTH_USER { PARAM_VALUE.WIDTH_USER } {
	# Procedure called to update WIDTH_USER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_USER { PARAM_VALUE.WIDTH_USER } {
	# Procedure called to validate WIDTH_USER
	return true
}


proc update_MODELPARAM_VALUE.WIDTH_DATA { MODELPARAM_VALUE.WIDTH_DATA PARAM_VALUE.WIDTH_DATA } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_DATA}] ${MODELPARAM_VALUE.WIDTH_DATA}
}

proc update_MODELPARAM_VALUE.WIDTH_LAST { MODELPARAM_VALUE.WIDTH_LAST PARAM_VALUE.WIDTH_LAST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_LAST}] ${MODELPARAM_VALUE.WIDTH_LAST}
}

proc update_MODELPARAM_VALUE.WIDTH_KEEP { MODELPARAM_VALUE.WIDTH_KEEP PARAM_VALUE.WIDTH_KEEP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_KEEP}] ${MODELPARAM_VALUE.WIDTH_KEEP}
}

proc update_MODELPARAM_VALUE.WIDTH_USER { MODELPARAM_VALUE.WIDTH_USER PARAM_VALUE.WIDTH_USER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_USER}] ${MODELPARAM_VALUE.WIDTH_USER}
}

proc update_MODELPARAM_VALUE.WIDTH_ID { MODELPARAM_VALUE.WIDTH_ID PARAM_VALUE.WIDTH_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_ID}] ${MODELPARAM_VALUE.WIDTH_ID}
}

proc update_MODELPARAM_VALUE.FIFO_SIZE_L2 { MODELPARAM_VALUE.FIFO_SIZE_L2 PARAM_VALUE.FIFO_SIZE_L2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_SIZE_L2}] ${MODELPARAM_VALUE.FIFO_SIZE_L2}
}

proc update_MODELPARAM_VALUE.FIFO_REG { MODELPARAM_VALUE.FIFO_REG PARAM_VALUE.FIFO_REG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_REG}] ${MODELPARAM_VALUE.FIFO_REG}
}

proc update_MODELPARAM_VALUE.FIFO_DELAY { MODELPARAM_VALUE.FIFO_DELAY PARAM_VALUE.FIFO_DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_DELAY}] ${MODELPARAM_VALUE.FIFO_DELAY}
}

