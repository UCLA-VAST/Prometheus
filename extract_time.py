import os


fold = ["/home/spouget/prometheus/evaluation_mm_slr", "/home/spouget/prometheus/evaluation_mm"]

for fol in fold:
    is_3_slr = False
    size = ""
    depth = ""
    if "slr" in fol:
        is_3_slr = True
    l = os.listdir(fol)
    for f in l:
        if "generated_tree" in f:
            size = f.split("_")[-1]
            depth = f.split("_")[-2]
            time=-1
            finised = False
            if "gurobi.log" in os.listdir(fol + "/" + f):
                fil = open(fol + "/" + f + "/gurobi.log", "r")
                lines = fil.readlines()
                fil.close()
                optimal = False
                for line in lines:
                    if "Optimal solution found" in line:
                        optimal = True
                    if "Explored" in line:
                        time = line.split("in ")[-1].split(" s")[0]
                        finised = True
                
                print(f"{fol} {size} {depth} {finised} {time} {optimal} {is_3_slr}")

                        
