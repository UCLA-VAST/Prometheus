import os
import sys
import argparse
import argcomplete
import ast
import code_generation
import extract
import analysis as analysis_
import pickle
import memoryBound
import memoryBoundSplit
import iscc
import subprocess
import parse_vitis_report
import pocc
import code_gen.main as code_gen
import utilities
import splitKernel
import ressources 

AMPL_CMD = "/home/spouget/ampl.linux-intel64/ampl"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Code Generation")
    parser.add_argument("--file", type=str, help="kernel.c")
    parser.add_argument("--schedule", type=str, nargs='+', help="Schedule e.g., \"[[0,0,0], [1,1,0]]\"")
    parser.add_argument("--UB", type=str, nargs='+', help="UB e.g., [12, 12]")
    parser.add_argument("--LB", type=str, nargs='+', help="LB e.g., [12, 12]")
    parser.add_argument("--statements", type=str, nargs='+', help="Statements e.g. '[\"a+=b\", \"a+=c\"]'")
    parser.add_argument("--iterators", type=str, nargs='+', help="iterators e.g. '[\"i\", \"j\"]'")
    parser.add_argument("--headers", type=str, nargs='+', help="headers e.g. '[\"i\", \"j\"]'")
    parser.add_argument("--arguments", type=str, nargs='+', help="arguments e.g. '[\"i\", \"j\"]'")
    parser.add_argument("--pragmas", type=str, nargs='+', help="pragmas e.g. '[\"\", \"pipeline;unroll factor=8\", \"pipeline\"]'")
    parser.add_argument("--name_function", type=str, help="Name function")
    parser.add_argument("--pragmas_top", action="store_true", help="Is the pragma above the loop (True), by default is False")
    parser.add_argument("--csim", action="store_true", help="Launch CSIM")
    parser.add_argument("--update_shape", action="store_true", help="Update Shape")
    parser.add_argument("--ap_multiple_burst", action="store_true", help="Is array partitioning have to be multiple of burst")
    parser.add_argument("--allow_multiple_transfer", action="store_true", help="allow_multiple_transfer")
    parser.add_argument("--graph_partitioning", action="store_true", help="Launch CSIM")
    parser.add_argument("--vitis", action="store_true", help="Launch Vitis-HLS")
    parser.add_argument("--no_distribution", action="store_true", help="Launch Vitis-HLS")
    parser.add_argument("--print_summary", action="store_true", help="Print Summary of the Report")
    parser.add_argument("--not_optimize_burst", action="store_true", help="Remove the optimization for the burst. Default=False")
    parser.add_argument("--reuse_nlp", action="store_true", help="Remove the optimization for the burst. Default=False")
    parser.add_argument("--not_cyclic_buffer", action="store_true", help="Remove the cyclic buffer optimization. Default=False")
    parser.add_argument("--code_generation", action="store_true", help="Remove the cyclic buffer optimization. Default=False")
    parser.add_argument("--output", type=str, help="Name of the output file")
    parser.add_argument("--SLR", type=int, default=0, help="Number of SLR. Default is 3")
    parser.add_argument("--factor", type=float, default=0, help="factor. Default is 1")
    parser.add_argument("--partitioning_max", type=int, default=0, help="Number of SLR. Default is 3")
    parser.add_argument("--MAX_BUFFER_SIZE", type=int, default=0, help="Number of SLR. Default is 3")
    parser.add_argument("--MAX_UF", type=int, default=0, help="Number of SLR. Default is 3")
    parser.add_argument("--ON_CHIP_MEM_SIZE", type=int, default=0, help="Number of SLR. Default is 3")
    parser.add_argument("--DSP", type=int, default=0, help="Number of SLR. Default is 3")


    parser.add_argument("--folder", type=str, default="prometheus", help="Name of the folder to store the files. Default is 'prometheus'")
    argcomplete.autocomplete(parser)
    args = parser.parse_args()

    output = f"{args.folder}/src/output.cpp"
    host_name = f"{args.folder}/src/host.cpp"
    # os.system(f"rm -rf prometheus")
    os.makedirs(args.folder, exist_ok=True)
    os.makedirs(f"{args.folder}/tmp", exist_ok=True)
    os.makedirs(f"{args.folder}/src", exist_ok=True)
    os.makedirs(f"{args.folder}/tcl_scripts", exist_ok=True)

    os.system(f"cp script/constrain_blocks.tcl {args.folder}/tcl_scripts")
    os.system(f"cp script/phys_opt_loop.tcl {args.folder}/tcl_scripts")
    os.system(f"cp script/print_CR.tcl {args.folder}/tcl_scripts")
    os.system(f"cp script/hls_pre.tcl {args.folder}/tcl_scripts")
    os.system(f"cp script/post_place_qor.tcl {args.folder}/tcl_scripts")
    os.system(f"cp script/print_CR_utilization.tcl {args.folder}/tcl_scripts")

    os.system(f"cp script/vitis.tcl {args.folder}/src")
    os.system(f"cp script/csim.tcl {args.folder}/src")

    os.system(f"cp script/prometheus.sh {args.folder}/")
    os.system(f"cp script/xcl2* {args.folder}/src")

    nlp_file = f"{args.folder}/nlp.mod"
    nlp_log = f"{args.folder}/nlp.log"

    # schedule, dic, operations, arrays_size, dep, operation_list = extract.compute_statement(args.file)
    # iscc_ = iscc.ISCC(args.no_distribution, args.folder, schedule, dic, operations, arrays_size, dep, operation_list)

        
    if not args.no_distribution:
        schedule, dic, operations, arrays_size, dep, operation_list = extract.compute_statement(args.folder, args.file)
        iscc_ = iscc.ISCC(args.no_distribution, args.folder, schedule, dic, operations, arrays_size, dep, operation_list)
    else:
        os.system(f"cp {args.file} {args.folder}/new.cpp")
        f = open(f"{args.folder}/new.cpp", "r")
        lines = f.readlines()
        f.close()
        for i in range(len(lines)):
            if "void" in lines[i] and "(" in lines[i] and ")" in lines[i]:
                lines[i] = f"void kernel_nlp(" + lines[i].split("(")[1]
                break
        f = open(f"{args.folder}/new.cpp", "w")
        f.writelines(lines)
        f.close()


    schedule, dic, operations, arrays_size, dep, operation_list = extract.compute_statement(args.folder, f"{args.folder}/new.cpp")


    analysis = analysis_.Analysis(schedule, dic, operations, arrays_size, dep, operation_list)
    UB = analysis.UB
    LB = analysis.LB
    statements = analysis.statements
    iterators = analysis.iterators
    schedule = analysis.only_schedule
    
    headers = ['ap_int.h', 'hls_stream.h', 'hls_vector.h', 'cstring'] 
    arguments = []
    # compute cte

    f = open(args.file, "r")
    lines = f.readlines()
    f.close()


    for line in lines:
        if "void" in line and "(" in line and ")" in line:
            cte = line.split("(")[1].split(")")[0].split(",")
            for cc in cte:
                if "[" not in cc:
                    arguments.append(cc)
            break

    arguments += analysis.arguments
    name_function = "kernel_nlp"
    pragmas = [[] for k in range(len(UB))]
    pragmas_top = False

    res = ressources.Ressources()
    if args.SLR != 0:
        res.SLR = args.SLR
    if args.factor != 0:
        res.factor = args.factor
    if args.partitioning_max != 0:
        res.partitioning_max = args.partitioning_max
    if args.MAX_BUFFER_SIZE != 0:
        res.MAX_BUFFER_SIZE = args.MAX_BUFFER_SIZE
    if args.MAX_UF != 0:
        res.MAX_UF = args.MAX_UF
    if args.ON_CHIP_MEM_SIZE != 0:
        res.ON_CHIP_MEM_SIZE = args.ON_CHIP_MEM_SIZE
    if args.DSP != 0:
        res.DSP = args.DSP

    res.DSP_per_SLR = int(res.DSP/res.SLR)
    res.BRAM_per_SLR = int(res.BRAM/res.SLR)
    res.MEM_PER_SLR = int(res.ON_CHIP_MEM_SIZE/res.SLR)

    if not args.reuse_nlp:
        if args.graph_partitioning:
            split = splitKernel.Identify("new.cpp", nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top)
            memoryBoundSplit.memoryBound(res, args.folder, split, "new.cpp", nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top)
            os.system(f"cd {args.folder} && {AMPL_CMD} nlp.mod > nlp.log 2>&1")
            splitKernel.splitKernel("new.cpp", nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top)
        else:
            memoryBound.memoryBound(res, args.folder, args.allow_multiple_transfer, args.ap_multiple_burst, "new.cpp", nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top)
            os.system(f"cd {args.folder} && {AMPL_CMD} nlp.mod > nlp.log 2>&1")



    code_gen.code_gen(args.update_shape, res.SLR, nlp_file, nlp_log, args.file, output, host_name, schedule, analysis)

    try:
        os.system(f"clang-format -i {output}")
    except:
        pass

    for id_slr in range(res.SLR):
        try:
            os.system(f"clang-format -i {output.replace('output.cpp', f'slr{id_slr}.cpp')}")
        except:
            pass

    h_file = output.split(".")[0] + ".h"
    try:
        os.system(f"clang-format -i {h_file}")
    except:
        pass
    try:
        os.system(f"clang-format -i {host_name}")
    except:
        pass

    try:
        os.system(f"clang-format -i {host_name.replace('host.cpp', 'csim.cpp')}")
    except:
        pass
    

    print("Files generated in", args.folder + "/")
    # Run Vitis-HLS if specified
    if args.csim:
        utilities.run_vitis_hls("csim.tcl",f"{args.folder}/src")

    if args.vitis:
        utilities.run_vitis_hls("vitis.tcl", f"{args.folder}/src")
        cycles, gf, DSP_utilization, BRAM_utilization, LUT_utilization, FF_utilization, URAM_utilization = utilities.print_summary(args.folder, args.file)
        # need_to_be_relaunch = False
        # if BRAM_utilization > 100 and DSP_utilization <= 100 and FF_utilization <= 100 and LUT_utilization <= 100:
        #     ressource.ON_CHIP_MEM_SIZE = 0.70 * ressource.ON_CHIP_MEM_SIZE
        #     need_to_be_relaunch = True
        # elif DSP_utilization > 100 or BRAM_utilization > 100 or FF_utilization > 100 or LUT_utilization > 100:
        #     if args.no_optimistic_reuse == True:
        #         ressource.DSP = 0.50 * ressource.DSP
        #     args.no_optimistic_reuse = True
        #     need_to_be_relaunch = True

        # if need_to_be_relaunch:
        #     os.system(f"cp -r {args.folder} {args.folder}_overuse")
        #     # Perform computation bound analysis
        #     computationBound.computationBound(ressource, solver, nlp_file, args.no_tree_reduction, args.no_optimistic_reuse, args.timeout_nlp, analysis, schedule, UB, LB, statements, iterators, output_file, headers, arguments, function_name, pragmas, pragmas_top, optimize_burst)
        #     # Run NLP optimization using AMPL
        #     utilities.run_ampl(AMPL, args.folder)

        #     # Process NLP log and model files
        #     results, order_array = utilities.process_nlp_results(schedule, nlp_file, nlp_log)

        #     # Generate final code and run CSIM
        #     generate_code_computation.GenerateCodeComputation(args.folder, args.file, nlp_file, nlp_log)
        #     generate_csim.CSIM(args.folder, args.file, f"{args.folder}/code_generated.cpp", args.no_tree_reduction, args.frequency, args.board)

        #     post_pass.PostPass(fully_distributed_file, args.folder, f"{args.folder}/code_generated.cpp", nlp_file, nlp_log)
        #     print("Files generated in", args.folder + "/")
        #     utilities.run_vitis_hls("csim.tcl", args.folder)
        #     utilities.run_vitis_hls("vitis.tcl", args.folder)
        #     cycles, gf, DSP_utilization, BRAM_utilization, LUT_utilization, FF_utilization, URAM_utilization = utilities.print_summary(args.folder, args.file)

    