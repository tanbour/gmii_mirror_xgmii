namespace eval ns_write_confmem {
set proj_dir [get_property DIRECTORY [current_project]]
set proj_name [current_project]
set bit_filename [lindex [glob -dir ${proj_dir}/${proj_name}.runs/impl_1/ *.bit] 0]
write_cfgmem -force -format mcs -size 32 -interface SPIx4 -loadbit "up 0x00000000 $bit_filename" -file "${proj_dir}/${proj_name}.mcs"
current_hw_device [get_hw_devices xcku040_0]
create_hw_cfgmem -hw_device [lindex [get_hw_devices xcku040_0] 0] [lindex [get_cfgmem_parts {mt25qu256-spi-x1_x2_x4}] 0]
refresh_hw_device [lindex [get_hw_devices xcku040_0] 0]
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.FILES [list ${proj_dir}/${proj_name}.mcs ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.PRM_FILE {} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
if {![string equal [get_property PROGRAM.HW_CFGMEM_TYPE  [lindex [get_hw_devices xcku040_0] 0]] [get_property MEM_TYPE [get_property CFGMEM_PART [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]]]] }  { create_hw_bitstream -hw_device [lindex [get_hw_devices xcku040_0] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices xcku040_0] 0]]; program_hw_devices [lindex [get_hw_devices xcku040_0] 0]; }; 
program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku040_0] 0]]
}
