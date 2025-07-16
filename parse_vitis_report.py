

def parse_vitis(path_report):
    result = {
        "version": "",
        "target": "",
        "cycles": 0,
        "cycles_min": 0,
        "cycles_max": 0,
        "DSP_used": 0,
        "BRAM_used": 0,
        "LUT_used": 0,
        "FF_used": 0,
        "URAM_used": 0,
        "DSP_available": 0,
        "BRAM_available": 0,
        "LUT_available": 0,
        "FF_available": 0,
        "URAM_available": 0,
        "DSP_utilization": 0,
        "BRAM_utilization": 0,
        "LUT_utilization": 0,
        "FF_utilization": 0,
        "URAM_utilization": 0,
        "cycle_instance": 0,
        "cycle_loop": 0,

    }

    f = open(path_report, "r")
    lines = f.readlines()
    f.close()

    line_utilization_estimates = 0

    for k,line in enumerate(lines):
        if "== Utilization Estimates" in line:
            line_utilization_estimates = k


    for k,line in enumerate(lines):
        if "* Version:" in line:
            result["version"] = line.split(":")[1].split("(")[0].replace(" ", "").replace("\n", "")
        if "* Target device:" in line:
            result["target"] = line.split(":")[-1].split("(")[0].replace(" ", "").replace("\n", "")
        if "+ Latency:" in line:
            l = lines[k+6].split("|")
            cycles_min = l[1].replace(" ", "")
            cycles_max = l[2].replace(" ", "")
            result["cycles_min"] = cycles_min
            result["cycles_max"] = cycles_max
            result["cycles"] =  int(cycles_max)
        if "+ Detail:" in line and k < line_utilization_estimates:
            id_ = k+6
            loop_line = 0
            for j in range(id_, len(lines)):
                if "* Loop:" in lines[j]:
                    loop_line = j
                    break
            for j in range(loop_line, len(lines)):
                if "== Utilization Estimates" in lines[j]:
                    break
        if "== Utilization Estimates" in line:
            for j in range(k, len(lines)):
                if "+ Detail:" in lines[j]:
                    break
                if "Available" in lines[j] and "SLR" not in lines[j]:
                    l = lines[j].split("|")
                    result["DSP_available"] = int(l[3].replace(" ", ""))
                    result["BRAM_available"] = int(l[2].replace(" ", ""))
                    result["LUT_available"] = int(l[5].replace(" ", ""))
                    result["FF_available"] = int(l[4].replace(" ", ""))
                    result["URAM_available"] = int(l[6].replace(" ", ""))
                if "Total" in lines[j]:
                    l = lines[j].split("|")
                    result["DSP_used"] = int(l[3].replace(" ", ""))
                    result["BRAM_used"] = int(l[2].replace(" ", ""))
                    result["LUT_used"] = int(l[5].replace(" ", ""))
                    result["FF_used"] = int(l[4].replace(" ", ""))
                    result["URAM_used"] = int(l[6].replace(" ", ""))

    result["DSP_utilization"] = int(result["DSP_used"] / result["DSP_available"] * 100 )
    result["BRAM_utilization"] = int(result["BRAM_used"] / result["BRAM_available"] * 100)
    result["LUT_utilization"] = int(result["LUT_used"] / result["LUT_available"] * 100)
    result["FF_utilization"] = int(result["FF_used"] / result["FF_available"] * 100)
    result["URAM_utilization"] = int(result["URAM_used"] / result["URAM_available"] * 100)

    # cycles, DSP_utilization, BRAM_utilization, LUT_utilization, FF_utilization, URAM_utilization
    return result["cycles"], result["DSP_utilization"], result["BRAM_utilization"], result["LUT_utilization"], result["FF_utilization"], result["URAM_utilization"]

            
            