# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "IP0" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IP1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IP2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IP3" -parent ${Page_0}


}

proc update_PARAM_VALUE.IP0 { PARAM_VALUE.IP0 } {
	# Procedure called to update IP0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IP0 { PARAM_VALUE.IP0 } {
	# Procedure called to validate IP0
	return true
}

proc update_PARAM_VALUE.IP1 { PARAM_VALUE.IP1 } {
	# Procedure called to update IP1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IP1 { PARAM_VALUE.IP1 } {
	# Procedure called to validate IP1
	return true
}

proc update_PARAM_VALUE.IP2 { PARAM_VALUE.IP2 } {
	# Procedure called to update IP2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IP2 { PARAM_VALUE.IP2 } {
	# Procedure called to validate IP2
	return true
}

proc update_PARAM_VALUE.IP3 { PARAM_VALUE.IP3 } {
	# Procedure called to update IP3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IP3 { PARAM_VALUE.IP3 } {
	# Procedure called to validate IP3
	return true
}


proc update_MODELPARAM_VALUE.IP0 { MODELPARAM_VALUE.IP0 PARAM_VALUE.IP0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IP0}] ${MODELPARAM_VALUE.IP0}
}

proc update_MODELPARAM_VALUE.IP1 { MODELPARAM_VALUE.IP1 PARAM_VALUE.IP1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IP1}] ${MODELPARAM_VALUE.IP1}
}

proc update_MODELPARAM_VALUE.IP2 { MODELPARAM_VALUE.IP2 PARAM_VALUE.IP2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IP2}] ${MODELPARAM_VALUE.IP2}
}

proc update_MODELPARAM_VALUE.IP3 { MODELPARAM_VALUE.IP3 PARAM_VALUE.IP3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IP3}] ${MODELPARAM_VALUE.IP3}
}

