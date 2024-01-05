
# Set the project name
variable proj_name
set proj_name "proj"

# Set main design name
variable design_name
set design_name "system"

variable script_folder
set script_folder [file dirname [file normalize [info script]]]

set_param board.repoPaths [list [file normalize "$::env(HOME)/ecen220/board_files"]]

create_project $proj_name $script_folder/$proj_name -part xc7a35tcpg236-1
set_property board_part digilentinc.com:basys3:part0:1.1.1 [current_project]

puts "########## create $design_name begin ##########"
create_bd_design $design_name

set mcs_ps_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze_mcs:3.0 microblaze_mcs_0]
set_property -dict [list \
  CONFIG.DEBUG_ENABLED {1} \
  CONFIG.MEMSIZE {16384} \
] $mcs_ps_0

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {sys_clock ( System Clock ) } Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins microblaze_mcs_0/Clk]
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins microblaze_mcs_0/Reset]

apply_board_connection -board_interface "usb_uart" -ip_intf "/microblaze_mcs_0/UART" -diagram "system" 
apply_board_connection -board_interface "push_buttons_5bits" -ip_intf "/microblaze_mcs_0/GPIO1" -diagram "system" 
apply_board_connection -board_interface "seven_seg_led" -ip_intf "/microblaze_mcs_0/GPIO2" -diagram "system" 
apply_board_connection -board_interface "led_16bits" -ip_intf "/microblaze_mcs_0/GPIO3" -diagram "system" 
apply_board_connection -board_interface "dip_switches_16bits" -ip_intf "/microblaze_mcs_0/GPIO4" -diagram "system" 
puts "########## create $design_name end ##########"

validate_bd_design
# Save after validate to keep any propagated parameters
save_bd_design
close_bd_design $design_name

puts "########## create $design_name wrapper begin ##########"
set wrapper [make_wrapper -files [get_files -of_objects [get_filesets [current_fileset]] $design_name.bd] -top]
add_files -norecurse $wrapper
puts "########## create $design_name wrapper end ##########"

puts "INFO: Project created: $proj_name"
close_project
