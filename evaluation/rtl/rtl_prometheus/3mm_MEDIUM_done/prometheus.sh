#!/bin/bash

#kill -9 $(pgrep -u milo168 -x xsim)
#kill -9 $(pgrep -u milo168 -x xsimk)
rm -rf v++*.log xcd.log xrc.log src/bin/.run

RD='\033[0;31m'
GN='\033[0;32m'
CY='\033[0;36m'
NC='\033[0m'

COMMAND="$1"
FREQ_SC=220
FREQ=()
FREQ[0]=220000000
FREQ[1]=220000000
FREQ[2]=220000000
EMU_TYPE=sw_emu
LIB_EMU_TYPE=-lxrt_swemu
VER=2023.2
EN_PROF=""
PLATFORM=xilinx_u55c_gen3x16_xdma_3_202210_1

OPENCL_FILES_CPP="host.cpp xcl2.cpp"
OPENCL_FILES_OBJ="host.o xcl2.o"

VITIS_HLS_CPP=()
VITIS_HLS_CPP[0]="slr0.cpp"
VITIS_HLS_KERNEL=()
VITIS_HLS_KERNEL[0]="kernel_nlp_slr0"

VITIS_INCLUDE="/opt/xilinx/tools/Vitis_HLS/$VER/include"
XRT_INCLUDE="/opt/xilinx/xrt/include"

CONNECTIVITY="k2k.cfg"

source /opt/xilinx/xrt/setup.sh
source /opt/xilinx/tools/Vitis_HLS/$VER/settings64.sh
mkdir -p src/bin
mkdir -p src/obj

compile_opencl(){
	IS_HW_SIM="-DHW_SIM"

	cd src
	echo -e "${CY}Running Vitis make for $EMU_TYPE... ${NC}"

	if [[ $EMU_TYPE == hw_emu ]]
	then
		LIB_EMU_TYPE=-lxrt_hwemu
	fi

	if [[ $EMU_TYPE == real ]]
	then
		LIB_EMU_TYPE=-lxrt_core
		IS_HW_SIM=""
	fi

	(set -x; g++ -std=c++17 \
	-Wall -Wno-unknown-pragmas \
	-O3 \
	-DFPGA_DEVICE -DC_KERNEL $IS_HW_SIM \
	-Irapid_json \
	-I$XRT_INCLUDE \
	-I$VITIS_INCLUDE \
	-Isrc \
	-c $OPENCL_FILES_CPP; mv $OPENCL_FILES_OBJ obj) 

	if [ $? -ne 0 ]
	then
    		echo -e "${RD}OpenCL section failed to compile ${NC}"
       		exit 1
	fi

	cd obj

	g++ -o ../bin/test.$EMU_TYPE.out $OPENCL_FILES_OBJ -L/opt/xilinx/xrt/lib -lxilinxopencl -lpthread -lrt -lstdc++ -luuid $LIB_EMU_TYPE

	if [ $? -ne 0 ]
	then
		echo -e "${RD}OpenCL section failed to link ${NC}"
		exit 1
	fi

	cd ../../
}

compile_kernel(){
	## emconfig.json needs to be in same folder as the sw-emu/hw-emu xclbin file
	cd src
	emconfigutil --platform $PLATFORM --od emconfig_out
	cp emconfig_out/emconfig.json bin

	PIDS=""
	FAIL=0
	extraCommands=""
	(set -x; rm bin/*-$EMU_TYPE.xo bin/workload-$EMU_TYPE.xclbin)

	if [[ $EMU_TYPE == hw_emu || $EMU_TYPE == hw ]]
	then
		extraCommands="-DFPGA_HW"
		#extraCommands="${extraCommands} --advanced.param compiler.fsanitize=address,memory"
		#extraCommands="${extraCommands} --advanced.param compiler.deadlockDetection=true"
	fi

	########## BUILDS KERNEL ##########
	echo -e "${CY}Running Vitis $EMU_TYPE make for the Vitis kernels... ${NC}"

	for VITIS_HLS_CPP_VAL in "${VITIS_HLS_CPP[@]}"
	do

		(set -x; g++ -std=c++17 -w -O3 \
		-I$XRT_INCLUDE \
		-I$VITIS_INCLUDE \
		-c $VITIS_HLS_CPP_VAL; rm *.o)

		if [ $? -ne 0 ]
		then
			echo -e "${RD}g++ compile check failed ${NC}"
			exit 1
		fi

	done

	for i in "${!VITIS_HLS_CPP[@]}"
	do
		echo -e "${CY} ${VITIS_HLS_KERNEL[i]} kernel running at ${FREQ[i]} ${NC}"

		(set -x; v++ -c -t $EMU_TYPE \
		--temp_dir ../_x \
		--log_dir ../_x \
		--report_dir ../_x \
		--include ./ \
		--hls.pre_tcl ../tcl_scripts/hls_pre.tcl \
		$extraCommands \
		--platform $PLATFORM \
		-s --kernel ${VITIS_HLS_KERNEL[i]} \
		--hls.clock ${FREQ[i]}:${VITIS_HLS_KERNEL[i]} \
		-R2 \
		${VITIS_HLS_CPP[i]} \
		-o bin/workload-${VITIS_HLS_KERNEL[i]}-$EMU_TYPE.xo) &

		PIDS="$PIDS $!"

	done

	for job in $PIDS
	do
		wait $job || let "FAIL+=1"
	done

	if [ "$FAIL" -ne "0" ];
	then
		echo -e "${RD}Build process failed${NC}"
		exit 1
	fi

	########## Return early, we do not want to generate bitstream for ./runCompile hls ##########
	if [[ $EMU_TYPE == hw ]]
	then
		cd ../
		return
	fi

	########## LINK THE KERNELS TOGETHER ##########
	echo -e "${CY}Running Vitis $EMU_TYPE link... ${NC}"

	v++ -l $EN_PROF -t $EMU_TYPE \
	--temp_dir ../_x \
	--log_dir ../_x \
	--report_dir ../_x \
	--config $CONNECTIVITY \
	--include ./ \
	--platform $PLATFORM \
	--kernel_frequency $FREQ_SC \
	-R2 \
	bin/workload-${VITIS_HLS_KERNEL[0]}-$EMU_TYPE.xo \
	-o bin/workload-$EMU_TYPE.xclbin

	if [ $? -ne 0 ]
	then
		echo -e "${RD}Failed to link kernel object ${NC}"
		exit 1
	fi
	cd ../
}

run_program(){
	cd src/bin

	time XCL_EMULATION_MODE=$EMU_TYPE ./test.$EMU_TYPE.out workload-$EMU_TYPE.xclbin
	if [ $? -ne 0 ]
    then
        exit 1
    fi

	cd ../../
}

if [[ $COMMAND == compilecl ]]
then

	EMU_TYPE=sw_emu
	compile_opencl

	EMU_TYPE=hw_emu
	compile_opencl

	EMU_TYPE=real
	compile_opencl
fi

if [[ $COMMAND == compilekernel ]]
then
	rm -rf _x
	EMU_TYPE=hw_emu
	#EN_PROF="--profile.data all:all:all --profile.exec all:all"

	compile_kernel
fi

if [[ $COMMAND == run ]]
then
	#EMU_TYPE=sw_emu
	#run_program

	EMU_TYPE=hw_emu
	run_program
fi

if [[ $COMMAND == doall ]]
then
	rm -rf _x
	#EN_PROF="--profile.data all:all:all --profile.exec all:all"

	VER=2022.2
        VITIS_INCLUDE="/opt/xilinx/tools/Vitis_HLS/$VER/include"
        source /opt/xilinx/tools/Vitis_HLS/$VER/settings64.sh

        EMU_TYPE=sw_emu
        compile_opencl
        compile_kernel
        run_program

        VER=2023.2
        VITIS_INCLUDE="/opt/xilinx/tools/Vitis_HLS/$VER/include"
        source /opt/xilinx/tools/Vitis_HLS/$VER/settings64.sh

        EMU_TYPE=hw_emu
        compile_opencl
        compile_kernel
        run_program

fi

if [[ $COMMAND == hw ]]
then
	var=$PWD
	concat="set dirname \"${var}\""
	sed -i "1s@.*@$concat@" tcl_scripts/phys_opt_loop.tcl
	sed -i "1s@.*@$concat@" tcl_scripts/post_place_qor.tcl

	v++ -l -t hw \
	--config src/$CONNECTIVITY \
	--include src \
	--platform $PLATFORM \
	--vivado.prop "run.my_rm_synth_1.{STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS}={-directive AlternateRoutability}" \
	--vivado.prop run.impl_1.STEPS.OPT_DESIGN.TCL.PRE=tcl_scripts/constrain_blocks.tcl \
	--vivado.prop "run.impl_1.{STEPS.PLACE_DESIGN.ARGS.MORE OPTIONS}={-directive AltSpreadLogic_medium}" \
	--vivado.prop "run.impl_1.{STEPS.PHYS_OPT_DESIGN.ARGS.MORE OPTIONS}={-directive Explore}" \
	--vivado.prop run.impl_1.STEPS.PHYS_OPT_DESIGN.TCL.POST=tcl_scripts/phys_opt_loop.tcl \
	--vivado.prop "run.impl_1.{STEPS.ROUTE_DESIGN.ARGS.MORE OPTIONS}={-directive AlternateCLBRouting}" \
	-s --kernel_frequency $FREQ_SC \
	-R1 src/bin/workload-${VITIS_HLS_KERNEL[0]}-hw.xo \
	-o src/bin/workload-hw.xclbin

	#--vivado.prop run.impl_1.STEPS.OPT_DESIGN.TCL.PRE=tcl_scripts/constrain_blocks.tcl \

	#--vivado.prop run.impl_1.STEPS.OPT_DESIGN.TCL.PRE=tcl_scripts/post_place_rerun.tcl \
	#--vivado.prop run.impl_1.STEPS.PLACE_DESIGN.TCL.POST=tcl_scripts/post_place_qor.tcl \
	#--vivado.prop "run.impl_1.{STEPS.OPT_DESIGN.ARGS.MORE OPTIONS}={-directive ExploreWithRemap}" \
	#--vivado.prop "run.impl_1.{STEPS.PLACE_DESIGN.ARGS.MORE OPTIONS}={-directive EarlyBlockPlacement -timing_summary}" \
	#--vivado.prop "run.impl_1.{STEPS.PHYS_OPT_DESIGN.ARGS.MORE OPTIONS}={-directive Explore}" \
	#--vivado.prop "run.impl_1.{STEPS.PLACE_DESIGN.ARGS.MORE OPTIONS}={-directive SSI_SpreadLogic_high}" \
	#--vivado.prop "run.impl_1.{STEPS.ROUTE_DESIGN.ARGS.MORE OPTIONS}={-directive AlternateCLBRouting}" \

	exit 0
fi

if [[ $COMMAND == hls ]]
then

	rm -rf FPGArpt/ _x
	mkdir FPGArpt
	EMU_TYPE=hw
	compile_kernel

	for i in "${!VITIS_HLS_KERNEL[@]}"
        do
		echo -e "${CY}Copying Vitis HLS reports for ${VITIS_HLS_KERNEL[i]} kernel... ${NC}"
		cp _x/workload-${VITIS_HLS_KERNEL[i]}-hw/${VITIS_HLS_KERNEL[i]}/${VITIS_HLS_KERNEL[i]}/solution/syn/report/*.rpt FPGArpt/
	done

	exit 0
fi
