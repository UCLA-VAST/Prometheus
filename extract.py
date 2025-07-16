
import os
import pocc
import utilities
import parser
import re



def multiple_split(string, delimiters=["+", "-", "*", "/", "(", ")", "<", ">", "=", " "]):
    splits = string
    for deli in delimiters:
        splits = splits.replace(deli, "#")
    return splits.split("#")

def find_variable(string):

    delimiters = ["+", "-", "*", "/", "(", ")", "<", ">", "=", " "]
    splits = multiple_split(string, delimiters)
    pos = []
    for s in splits:
        #if we can convert in float or int, it is a number
        try:
            float(s)
            pass
        except:
            if s != "":
                pos.append(s)
    return pos[-1]

def extract_variable_bounds(constraints):
    lower_bounds = {}
    upper_bounds = {}
    trip_counts = {}
    lower_bounds_ = {}
    upper_bounds_ = {}


    for constraint in constraints:
        var_name = constraint
        var_name = var_name.split(">=")[0].split("+")[0]

        var_name = find_variable(constraint)
        if var_name not in lower_bounds:
            lower_bounds[var_name] = +float('inf')
            lower_bounds_[var_name] = +float('inf')
        if var_name not in upper_bounds:
            upper_bounds[var_name] = -float('inf')
            upper_bounds_[var_name] = -float('inf')
        

        cc = constraint.split(">=")[0]
        if f"-{var_name}" in cc:
            nb = cc.split(f"-{var_name}")[-1]
            nb = cc.split(f"{var_name}")[-1]

            cc = cc.replace(f"{var_name}", "0")
            upper_bounds_[var_name] = cc.replace("-0", "").replace("+0", "")
            if upper_bounds_[var_name][0] == "-":
                upper_bounds_[var_name] = upper_bounds_[var_name][1:]
            if upper_bounds_[var_name][0] == "+":
                upper_bounds_[var_name] = upper_bounds_[var_name][1:]
            split_ = multiple_split(cc)
            for k in list(upper_bounds.keys()):
                for s in split_:
                    if k in s:
                        cc = cc.replace(s, str(upper_bounds[k]))

            nb = eval(cc)
            upper_bounds[var_name] = max(upper_bounds[var_name], int(nb))
        else:
            nb = cc.split(f"{var_name}")[-1]


            cc = cc.replace(f"{var_name}", "0")
            lower_bounds_[var_name] = cc.replace("-0", "").replace("+0", "")
            if lower_bounds_[var_name][0] == "-":
                lower_bounds_[var_name] = lower_bounds_[var_name][1:]
            if lower_bounds_[var_name][0] == "+":
                lower_bounds_[var_name] = lower_bounds_[var_name][1:]
            split_ = multiple_split(cc)
            for k in list(lower_bounds.keys()):
                for s in split_:
                    if k in s:
                        cc = cc.replace(s, str(lower_bounds[k]))

            
            nb = eval(cc)
            if nb == "":
                nb = 0
            lower_bounds[var_name] = min(lower_bounds[var_name], -int(nb))

    for var_name in lower_bounds:
        if var_name != "fakeiter":
            trip_counts[var_name] = int(upper_bounds[var_name]) - int(lower_bounds[var_name]) + 1

    return lower_bounds, upper_bounds, lower_bounds_, upper_bounds_, trip_counts

def compute_size_arrays(fil):
    # FIXME
    f = open(fil, "r")
    lines = f.readlines()
    f.close()

    size_arrays = {}
    for line in lines:
        if "void" in line:
            line = line.split("(")[-1].split(")")[0].replace("float", "").replace("int", "").replace("double", "").replace(" ", "").split(",")
            for elmt in line:
                if "[" in elmt:
                    name = elmt.split("[")[0]
                    size = elmt[elmt.index("[")+1:-1].split("][")
                    size_arrays[name] = list(map(int, size))
            break
    return size_arrays

def extract_cte(scop, k):
    for i in range(k+2, len(scop)):
        if "# Statement body" in scop[i]:
            stat = scop[i+1]
    new_stat = ""
    inside_bracket = False
    for c in stat:
        if c == "[":
            inside_bracket = True
        if not inside_bracket:
            new_stat += c
        if c == "]":
            inside_bracket = False
    new_stat = new_stat.replace("+", "@").replace("-", "@").replace("*", "@").replace("/", "@").replace("=", "@")
    new_stat = new_stat.split("@")
    cte = []
    for elmt in new_stat:
        try:
            float(elmt)
            cte.append(elmt)
        except:
            pass
    return cte

def extract_statement(scop, k):
    for i in range(k+2, len(scop)):
        if "# Statement body" in scop[i] and "is provided" not in scop[i]:
            stat = scop[i+1]
            break
    return stat

def compute_statement(folder, fil):
    
    size_arrays = compute_size_arrays(fil)

    

    name = fil.split("/")[-1]
    os.system(f"cp {fil} {folder}/tmp/{name}")
    file_ = f"{folder}/tmp/{name}"
    utilities.add_pragma_scop(file_)
    sdep = pocc.candl(folder, file_)

    operations_list = []
    operations = []
    op = {
        "+": 0,
        "-": 0,
        "*": 0,
        "/": 0,
    }
    
    utilities.replace_define(file_)
    # utilities.delete_pragma_scop(file_)
    # utilities.change_name_variable_one_file(file_)
    # utilities.add_pragma_scop(file_)
    scop = pocc.scop(folder, file_)
    sched = pocc.compute_schedule(folder, file_)
    id_statement = -1
    dic = {}
    for k, line in enumerate(scop):
        if "==== Statement" in line:
            id_statement += 1
            dic[id_statement] = {"read": [], "statement_body": "", "read_with_cte": [], "write": [], "TC": 0, "LB": 0, "UB": 0, "LB_": 0, "UB_":0, "constraint": []}
        if "# Read access informations" in line:
            cte = extract_cte(scop, k)
            id_cte = 0
            nb_arrays_read = int(scop[k+1].split()[0])
            nb_arrays_write = int(scop[k+1+nb_arrays_read+2].split()[0])
            for i in range(k+2, k+2+nb_arrays_read):
                dd = scop[i].split("##")[-1]

                if list(dd) != ['\n']:
                    arr = dd.replace(" ", "").replace("\n", "")
                    dic[id_statement]["read"].append(arr)

            #FIXME:
            # if len(cte) > 0:
            dic[id_statement]["statement_body"] = extract_statement(scop, k)
            #     dic[id_statement]["read"].append(cte)
            for i in range(k+nb_arrays_read+4, k+nb_arrays_read+4+nb_arrays_write):
                dd = scop[i].split("##")[-1]
                if list(dd) != ['\n']:
                    arr = dd.replace(" ", "").replace("\n", "")
                    dic[id_statement]["write"].append(arr)
        
        di = []
        if "# Iteration domain" in line:
            nb_line = scop[k+2].split(" ")[0]
            for i in range(k+3, k+3+int(nb_line)):
                dd = scop[i].split("##")[-1].replace(" ", "").replace("\n", "")
                if list(dd) != ['\n']:
                    di.append(dd)
                    dic[id_statement]["constraint"].append(dd)
        if "# Statement body" in line and "is provided" not in line:
            string = scop[k+1].replace("\n", "")
            tmp_string = ""
            tmp_op = op.copy()
            tmp_operations_list = []

            inside_bracket = False
            for c in string:
                if c == "[":
                    inside_bracket = True
                if not inside_bracket:
                    tmp_string += c
                if c == "]":
                    inside_bracket = False
                
            tmp_op["+"] += tmp_string.count("+")
            tmp_op["-"] += tmp_string.count("-")
            tmp_op["*"] += tmp_string.count("*")
            tmp_op["/"] += tmp_string.count("/")

            for elmt in tmp_string:
                if elmt in list(op.keys()):
                    tmp_operations_list.append(elmt)


            operations.append(tmp_op)
            operations_list.append(tmp_operations_list)

        if len(di) > 0:


            lower_bounds, upper_bounds, lower_bounds_, upper_bounds_, trip_counts = extract_variable_bounds(di)

            dic[id_statement]["TC"] = trip_counts
            dic[id_statement]["LB"] = lower_bounds
            dic[id_statement]["UB"] = upper_bounds
            dic[id_statement]["LB_"] = lower_bounds_
            dic[id_statement]["UB_"] = upper_bounds_

        dep = []
        
        for d in sdep:
            if "label" in d:
                arrays = d.split("[")[0].replace(" ", "").replace("S", "").split("->")
                arrays = list(map(int, arrays))
                type = d.split("label=")[1].split("depth")[0].replace(" ", "").replace("\"", "")
                dep.append([arrays, type])
    return sched, dic, operations, size_arrays, dep, operations_list




