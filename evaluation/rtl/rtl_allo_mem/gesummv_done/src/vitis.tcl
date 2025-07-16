
catch {::common::set_param -quiet hls.xocc.mode csynth};

open_project kernel_nlp
set_top kernel_nlp

add_files "output.cpp"  -cflags " -O3 -D XILINX "
add_files -tb "csim.cpp"
open_solution -flow_target vitis solution
set_part xcu200-fsgd2104-2-e

create_clock -period 220MHz -name default

config_dataflow -strict_mode warning

config_export -disable_deadlock_detection=true

config_rtl -m_axi_conservative_mode=1
config_interface -m_axi_addr64

config_interface -m_axi_auto_max_ports=0
config_export -format ip_catalog -ipname kernel_trmm
config_compile -unsafe_math_optimizations

csim_design
csynth_design
cosim_design
export_design -flow impl
get_clock_period -name ap_clk -ns
close_project
puts "HLS completed successfully"
exit
    