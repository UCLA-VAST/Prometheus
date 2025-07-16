import os



ll = os.listdir("nlp_cfile")
csv = open("nlp_info.csv", "w")
csv.write("file,objective,time,optimal\n")
for l in ll:
    if ".log" in l:
        f = open("nlp_cfile/"+l, "r")
        lines = f.readlines()
        f.close()
        objective = 0
        optimal = False
        time = 0
        for line in lines:
            if "Objective" in line:
                objective = line.replace("\n", "").replace("Objective", "").replace(" ", "")
            if "_total_solve_time" in line:
                time = line.replace("\n", "").replace("_total_solve_time =", "").replace(" ", "")
            if "optimal within tolerances" in line:
                optimal = True
        csv.write(l+","+str(objective)+","+str(time)+","+str(optimal)+"\n")
csv.close()
        