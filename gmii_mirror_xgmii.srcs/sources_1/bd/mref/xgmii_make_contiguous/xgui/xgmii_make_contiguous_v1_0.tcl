# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "INTERFRAME_GAP" -parent ${Page_0}


}

proc update_PARAM_VALUE.INTERFRAME_GAP { PARAM_VALUE.INTERFRAME_GAP } {
	# Procedure called to update INTERFRAME_GAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INTERFRAME_GAP { PARAM_VALUE.INTERFRAME_GAP } {
	# Procedure called to validate INTERFRAME_GAP
	return true
}


proc update_MODELPARAM_VALUE.INTERFRAME_GAP { MODELPARAM_VALUE.INTERFRAME_GAP PARAM_VALUE.INTERFRAME_GAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INTERFRAME_GAP}] ${MODELPARAM_VALUE.INTERFRAME_GAP}
}

