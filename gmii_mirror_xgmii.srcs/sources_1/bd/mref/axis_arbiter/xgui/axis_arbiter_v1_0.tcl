# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "WIDTH_CAP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_DATA" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WIDTH_USER" -parent ${Page_0}


}

proc update_PARAM_VALUE.WIDTH_CAP { PARAM_VALUE.WIDTH_CAP } {
	# Procedure called to update WIDTH_CAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_CAP { PARAM_VALUE.WIDTH_CAP } {
	# Procedure called to validate WIDTH_CAP
	return true
}

proc update_PARAM_VALUE.WIDTH_DATA { PARAM_VALUE.WIDTH_DATA } {
	# Procedure called to update WIDTH_DATA when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WIDTH_DATA { PARAM_VALUE.WIDTH_DATA } {
	# Procedure called to validate WIDTH_DATA
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

proc update_MODELPARAM_VALUE.WIDTH_USER { MODELPARAM_VALUE.WIDTH_USER PARAM_VALUE.WIDTH_USER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_USER}] ${MODELPARAM_VALUE.WIDTH_USER}
}

proc update_MODELPARAM_VALUE.WIDTH_CAP { MODELPARAM_VALUE.WIDTH_CAP PARAM_VALUE.WIDTH_CAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WIDTH_CAP}] ${MODELPARAM_VALUE.WIDTH_CAP}
}

