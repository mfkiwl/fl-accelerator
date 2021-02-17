# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "I_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "I_DIM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "K_DIM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_CNT" -parent ${Page_0}


}

proc update_PARAM_VALUE.I_BITS { PARAM_VALUE.I_BITS } {
	# Procedure called to update I_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I_BITS { PARAM_VALUE.I_BITS } {
	# Procedure called to validate I_BITS
	return true
}

proc update_PARAM_VALUE.I_DIM { PARAM_VALUE.I_DIM } {
	# Procedure called to update I_DIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I_DIM { PARAM_VALUE.I_DIM } {
	# Procedure called to validate I_DIM
	return true
}

proc update_PARAM_VALUE.K_DIM { PARAM_VALUE.K_DIM } {
	# Procedure called to update K_DIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.K_DIM { PARAM_VALUE.K_DIM } {
	# Procedure called to validate K_DIM
	return true
}

proc update_PARAM_VALUE.M_BITS { PARAM_VALUE.M_BITS } {
	# Procedure called to update M_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_BITS { PARAM_VALUE.M_BITS } {
	# Procedure called to validate M_BITS
	return true
}

proc update_PARAM_VALUE.M_CNT { PARAM_VALUE.M_CNT } {
	# Procedure called to update M_CNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_CNT { PARAM_VALUE.M_CNT } {
	# Procedure called to validate M_CNT
	return true
}


proc update_MODELPARAM_VALUE.K_DIM { MODELPARAM_VALUE.K_DIM PARAM_VALUE.K_DIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.K_DIM}] ${MODELPARAM_VALUE.K_DIM}
}

proc update_MODELPARAM_VALUE.I_DIM { MODELPARAM_VALUE.I_DIM PARAM_VALUE.I_DIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I_DIM}] ${MODELPARAM_VALUE.I_DIM}
}

proc update_MODELPARAM_VALUE.M_BITS { MODELPARAM_VALUE.M_BITS PARAM_VALUE.M_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_BITS}] ${MODELPARAM_VALUE.M_BITS}
}

proc update_MODELPARAM_VALUE.M_CNT { MODELPARAM_VALUE.M_CNT PARAM_VALUE.M_CNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_CNT}] ${MODELPARAM_VALUE.M_CNT}
}

proc update_MODELPARAM_VALUE.I_BITS { MODELPARAM_VALUE.I_BITS PARAM_VALUE.I_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I_BITS}] ${MODELPARAM_VALUE.I_BITS}
}

