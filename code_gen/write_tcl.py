


def generate_tcl(output_file, platform="xcu55c-fsvh2892-2L-e", freq="220"):
    str_ = f"""
catch {{::common::set_param -quiet hls.xocc.mode csynth}};

open_project kernel_nlp
set_top kernel_nlp

add_files "output.cpp"  
open_solution -flow_target vitis solution
set_part {platform}

create_clock -period {freq}MHz -name default

config_dataflow -strict_mode warning

config_export -disable_deadlock_detection=true

config_rtl -m_axi_conservative_mode=1
config_interface -m_axi_addr64

config_interface -m_axi_auto_max_ports=0
config_export -format ip_catalog -ipname kernel_trmm
config_compile -unsafe_math_optimizations

csynth_design
export_design
close_project
puts "HLS completed successfully"
exit
    """
    f = open(output_file, "w")
    f.write(str_)
    f.close()

def generate_csim(output_file, platform="xcu55c-fsvh2892-2L-e", freq="220"):
    str_ = f"""
catch {{::common::set_param -quiet hls.xocc.mode csynth}};

open_project CnnKernel
set_top CnnKernel
add_files "output.cpp" -cflags " -O3 -D XILINX "
add_files -tb "csim.cpp" -cflags " -O3 -D XILINX "
open_solution -flow_target vitis solution
set_part {platform}
create_clock -period 250MHz -name default
csim_design
close_project
puts "HLS completed successfully"
exit
    """
    f = open(output_file, "w")
    f.write(str_)
    f.close()

def generate_makefile(output_file):
    str_ = """

hls:
    vitis_hls vitis.tcl

csim:
    vitis_hls csim.tcl
    """
    f = open(output_file, "w")
    f.write(str_)
    f.close()