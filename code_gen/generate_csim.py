import numpy as np


class CSIM:
    def __init__(self, original_file, new_file, output, analysis, schedule, nlp_file, log_file):
        self.original_file = original_file
        self.new_file = new_file
        self.analysis = analysis
        self.schedule = schedule
        self.nlp_file = nlp_file
        self.log_file = log_file
        self.burst = {}
        self.compute_burst()
        
        self.statements = []
        self.compute_statements()
        self.array_information = {}
        self.pre_treatement_statements()
        self.compute_arrays_information()
        self.change_order = {}
        self.task_to_FT = {}
        self.info_log = {}
        self.compute_info_log()
        self.compute_nb_fuse_task()
        self.info_padding = {}
        self.info_on_chip_size = {}
        self.info_loop_to_array = {}
        self.compute_size_array_per_ft()
        self.size_arrays = {}
        self.info_log = {}
        self.compute_info_log()
        self.diff = 0.0001
        self.output = output
        self.original_code = self.read_file(original_file)
        self.new_code = self.read_file(new_file)
        self.generate()

    def extract_name_fct(self,lines):
        l = []
        for k, line in enumerate(lines):
            if "void" in line:
                l.append(line.split("void")[-1].split("(")[0])
        return l

    def extract_fct(self, name,lines):
        begin = -1
        end = -1
        inside = False
        seen_one = False
        nb_bracket = 0
        for k, line in enumerate(lines):
            if f"void" in line and f"{name}" in line:
                begin = k
                inside = True
                nb_bracket = 0
            if inside:
                if "{" in line:
                    nb_bracket += 1
                    seen_one = True
                if "}" in line:
                    nb_bracket -= 1
                if nb_bracket == 0 and seen_one:
                    end = k
                    break
        return lines[begin:end+1]

    def compute_burst(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "burst" in line and "is" not in line:
                array = line.split("=")[0].replace("burst_", "").replace(" ", "")
                try:
                    value = int(line.split("=")[1].replace(" ", "").replace("\n", ""))
                except:
                    value = float(line.split("=")[1].replace(" ", "").replace("\n", ""))
                    value = int(value)
                self.burst[array] = value

    def compute_statements(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "#comment:" in line and "Statement" in line:
                self.statements.append(line.split(": ")[2].replace("\n", ""))
    
    def multi_split(self, str_, delimiters, delete_array=False):
        for delim in delimiters:
            str_ = str_.replace(delim, "@")
        res = str_.split("@")
        new_res = []
        if delete_array:
            for r in res:
                if "[" in r:
                    r = r.split("[")[0]
                new_res.append(r)
                while "" in res:
                    res.remove("")
            return new_res
        while "" in res:
            res.remove("")
        return res

    def pre_treatement_statements(self):
        for i, stat in enumerate(self.statements):
            out, inp = stat.split("=")
            if "+" in out:
                out = out.split("+")[0].strip()
                self.statements[i] = f"{out} = {out} + {inp}"
            if "-" in out:
                out = out.split("-")[0].strip()
                self.statements[i] = f"{out} = {out} - {inp}"
            if "*" in out:
                out = out.split("*")[0].strip()
                self.statements[i] = f"{out} = {out} * {inp}"
            if "/" in out:
                out = out.split("/")[0].strip()
                self.statements[i] = f"{out} = {out} / {inp}"

    def compute_arrays_information(self):
        all_arrays = []
        for stat in self.statements:
            if "=" in stat:
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
                all_arrays += [out] 
                all_arrays += inp
        all_arrays = list(set(all_arrays))
        for arr in all_arrays:
            self.array_information[arr] = {"size": 0, "type": "", "W": [], "size_burst": 0, "size_vector": 0, "statements": [], "dim": 0, "loop_to_dim": {}, "part_per_dim": []}
            for i, stat in enumerate(self.statements):
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                if f"{arr}[" in stat:
                    self.array_information[arr]["statements"].append(i)
                if f"{arr}" in out:
                    self.array_information[arr]["W"].append(i)
        # for arr in all_arrays:
        #     for arg in self.arguments:
        #         if arr in arg:
        #             self.array_information[arr]["type"] = arg.split(" ")[0].strip()
        #             self.array_information[arr]["size"] = self.extract_size_array(arg)
        #             self.array_information[arr]["dim"] = arg.count("[")
        #             self.array_information[arr]["part_per_dim"] = [1 for k in range(self.array_information[arr]["dim"])]
        #             break
        # for arr in all_arrays:
        #     for stat in self.array_information[arr]["statements"]:
        #         it_per_dim = []
        #         ss = self.multi_split(self.statements[stat].replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])
        #         ss = list(set(ss))
        #         for s in ss:
        #             tmp = ["" for k in range(self.array_information[arr]["dim"])]
        #             if f"{arr}[" in s:
        #                 index = s.index(f"[")
        #                 s = s[index:]
        #                 s = s.replace("][", "*")
        #                 s = s.replace("[", "")
        #                 s = s.replace("]", "")
        #                 tmp = s.split("*")
        #                 it_per_dim.append(tmp)
        #         loop_to_it = {}
        #         for i in range(1, len(self.schedule[stat]), 2):
        #             loop = int(self.schedule[stat][i])
        #             it = self.iterators[loop]
        #             loop_to_it[loop] = it
        #         it_to_loop = {v: k for k, v in loop_to_it.items()}
        #         for i, it in enumerate(it_per_dim):
        #             for j, it_ in enumerate(it):
        #                 it_per_dim[i][j] = it_to_loop[it_]

        #         for pos in range(len(it_per_dim)):
        #             for dim in range(len(it_per_dim[pos])):
        #                 self.array_information[arr]["loop_to_dim"][it_per_dim[pos][dim]] = dim
        #         for pos in range(len(it_per_dim)):
        #             for dim in range(len(it_per_dim[pos])):
        #                 loop = it_per_dim[pos][dim]
        #                 # pragma_loop = self.pragmas[loop]
        #                 # if pragma_loop != [""]:
        #                 #     pragma_loop = pragma_loop.split(";")
        #                 #     for p in pragma_loop:
        #                 #         if "unroll" in p.lower():
        #                 #             factor = p.split("=")[-1].strip().replace(" ", "")
        #                 #             self.array_information[arr]["part_per_dim"][dim] = max(self.array_information[arr]["part_per_dim"][dim], int(factor))

    
    def compute_info_log(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "=" in line:
                key = line.split("=")[0].replace(" ", "")
                value = line.split("=")[1].replace(" ", "").replace("\n", "")
                try: 
                    self.info_log[key] = int(value)
                except:
                    try:
                        self.info_log[key] = float(value)
                        if self.info_log[key] < 0.5:
                            self.info_log[key] = 0
                        else:
                            self.info_log[key] = int(float(value))
                    except:
                        self.info_log[key] = value
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "param" in line and "=" in line:
                key = line.split("=")[0].replace("param ", "").replace(" ", "")
                value = line.split("=")[1].replace(" ", "").replace("\n", "").replace(";", "")
                try: 
                    self.info_log[key] = int(value)
                except:
                    try:
                        self.info_log[key] = float(value)
                        if self.info_log[key] < 0.5:
                            self.info_log[key] = 0
                        else:
                            self.info_log[key] = int(float(value))
                    except:
                        self.info_log[key] = value

    def compute_nb_fuse_task(self):
        self.nb_fuse_task = 0
        self.fuse_task = {}
        self.task_to_FT = {}

        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "#comment:" in line and "Fuse" in line:
                self.fuse_task[self.nb_fuse_task] = list(map(int, line.split("[")[-1].split("]")[0].replace("\n", "").replace(" ", "").split(",")))
                for task in self.fuse_task[self.nb_fuse_task]:
                    self.task_to_FT[task] = self.nb_fuse_task
                self.nb_fuse_task += 1
        
    def compute_size_array_per_ft(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "#comment:" in line:
                if "Sched" in line and "has reuse buffer" in line:
                    id_task = int(line.split("Sched ")[1].split(" has")[0])
                    id_FT = self.task_to_FT[id_task]
                    if id_FT not in list(self.info_padding.keys()):
                        self.info_padding[id_FT] = {}
                    if id_FT not in list(self.info_on_chip_size.keys()):
                        self.info_on_chip_size[id_FT] = {}
                    if id_FT not in list(self.info_loop_to_array.keys()):
                        self.info_loop_to_array[id_FT] = {}
                    # if id_FT not in list(self.info_size_transferred.keys()):
                    #     self.info_size_transferred[id_FT] = {}
                    name_array = line.split("reuse buffer ")[1].split("[")[0]
                    index = line.index("[")
                    tmp_ = line[index+1:].replace("\n", "")[:-1].split("][")
                    tmp = []
                    tmp2 = []
                    tmp3 = []
                    tmp4 = []
                    # TODO info_size_transferred
                    for t in tmp_:
                        op = []
                        for elmt in t:
                            if elmt == "+" or elmt == "-" or elmt == "*" or elmt == "/":
                                op.append(elmt) 
                        if "+" in t or "-" in t or "*" in t or "/" in t:
                            t = t.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                        else:
                            t = [t]
                        ltc = []
                        for tt in t:
                            tc = self.info_log[tt.split("_")[0]]
                            ltc.append(tc)
                        res = ltc[0]
                        for i, o in enumerate(op):
                            if o == "+":
                                res += ltc[i+1]
                            elif o == "-":
                                res -= ltc[i+1]
                            elif o == "*":
                                res *= ltc[i+1]
                            elif o == "/":
                                res /= ltc[i+1]
                        if len(op) >= 1:
                            res = int(res)- 1 # FIXME
                        tmp.append(res) 
                    for t in tmp_:
                        op = []
                        for elmt in t:
                            if elmt == "+" or elmt == "-" or elmt == "*" or elmt == "/":
                                op.append(elmt) 
                        if "+" in t or "-" in t or "*" in t or "/" in t:
                            t = t.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                        else:
                            t = [t]
                        ltc = []
                        for tt in t:
                            tc = self.info_log[tt]
                            ltc.append(tc)
                        
                        res = ltc[0]
                        for i, o in enumerate(op):
                            if o == "+":
                                res += ltc[i+1]
                            elif o == "-":
                                res -= ltc[i+1]
                            elif o == "*":
                                res *= ltc[i+1]
                            elif o == "/":
                                res /= ltc[i+1]
                        if len(op) >= 1:
                            res = int(res)- 1 # FIXME
                        tmp2.append(res)
                    for t in tmp_:
                        if "+" in t or "-" in t or "*" in t or "/" in t:
                            t = t.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                        else:
                            t = [t]
                        ltc = []
                        for tt in t:
                            tc = tt.split("_")[0].replace("TC", "")
                            ltc.append(tc)
                        tmp3.append(ltc)
                    self.info_padding[id_FT][name_array] = tmp
                    self.info_on_chip_size[id_FT][name_array] = tmp2
                    self.info_loop_to_array[id_FT][name_array] = tmp3

    def compute_info_log(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "=" in line:
                key = line.split("=")[0].replace(" ", "")
                value = line.split("=")[1].replace(" ", "").replace("\n", "")
                self.info_log[key] = value
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "param" in line and "=" in line:
                key = line.split("=")[0].replace("param ", "").replace(" ", "")
                value = line.split("=")[1].replace(" ", "").replace("\n", "").replace(";", "")
                self.info_log[key] = value

    def read_file(self, file):
        f = open(file, "r")
        code = f.readlines()
        f.close()
        return code
    
    def extract_iterator(self, string):
        if "[" not in string:
            return []
        index = string.find("[")
        string = string[index:]
        string = string.replace("][", "!")
        string = string.replace("[", "")
        string = string.replace("]", "")
        string = string.split("!")
        return string

    def extract_name(self, string):
        string = string.replace("float16", "").replace("float8", "").replace("float4", "").replace("float2", "").replace("float1", "").replace("float", "").replace("int", "").replace("void", "").replace(" ", "")
        return string.split("[")[0]
    
    def extract_data_type(self, string):
        #FIXME 
        if "float2" in string:
            return "float2"
        elif "float4" in string:
            return "float4"
        elif "float8" in string:
            return "float8"
        elif "float16" in string:
            return "float16"
        elif "float" in string:
            return "float"
        if "int" in string:
            return "int"
        return "void"

    def extract_arguments(self, code):
        arguments = []
        last_void = 0
        for line in code:
            if "void" in line:
                last_void = code.index(line)
        l = code[last_void]
        index_open = l.index("(")
        index_close = l.index(")")
        arguments = l[index_open+1:index_close].split(",")
        if "n" in arguments:
            arguments.remove("n")
        if "m" in arguments:
            arguments.remove("m")
        return arguments

    def extract_call(self, code):
        arguments = []
        last_void = 0
        for line in code:
            if "void" in line:
                last_void = code.index(line)
        l = code[last_void].replace("{", "").replace("\n", "")
        return l

    def extract_name_function(self, code):
        arguments = []
        last_void = 0
        for line in code:
            if "void" in line:
                last_void = code.index(line)
        l = code[last_void].split("(")[0].split(" ")[-1].replace("\n", "")
        return l

    def extract_headers(self, code):
        headers = []
        for line in code:
            if "#include" in line:
                headers.append(line)
        return headers

    def create_tab(self, nb):
        nb = max(0,nb)
        return "    " * nb

    def find_size_last_dim(self, val, burst):
        if val % burst != 0:
            return val + burst - val % burst
        return val

    def generate(self):
        code = []
        code_csim = []
        original_headers = self.extract_headers(self.original_code)
        new_headers = self.extract_headers(self.new_code)
        headers = list(set(original_headers + new_headers))
        code += headers
        name = self.new_file.split("/")[-1].split(".")[0]
        for k, h in enumerate(headers):
            if f"{name}.h" in h:
                headers[k] = headers[k].replace(f"{name}.h", f"{name}_2.h")
        code_csim += headers
        code += '#include "xcl2.hpp"\n\n'


        # code += "typedef hls::vector<float,16> float16;\n"
        # code += "typedef hls::vector<float,8> float8;\n"
        # code += "typedef hls::vector<float,4> float4;\n"
        # code += "typedef hls::vector<float,2> float2;\n"

        code += self.original_code
        code_csim += self.original_code

        # code += """extern "C" { \n"""
        code += "\n"
        code_csim += "\n"
        # code +=  self.extract_call(self.new_code) + ";\n"
        code_csim +=  self.extract_call(self.new_code) + ";\n"
        code += "\n"
        code_csim += "\n"
        # code += "}\n"
        # f = open("output.h", "w")
        # f.write("typedef hls::vector<float,16> float16;\n")
        # f.write("typedef hls::vector<float,8> float8;\n")
        # f.write("typedef hls::vector<float,4> float4;\n")
        # f.write("typedef hls::vector<float,2> float2;\n")
        # f.write(self.create_tab(1) + self.extract_call(self.new_code) + ";\n")
        # f.close()

        

        original_arg = self.extract_arguments(self.original_code)
        new_arg = self.extract_arguments(self.new_code)
        
        info = {}
        ori = {}
        shift_last_dim = {}

        for arg in original_arg:
            name_array = self.extract_name(arg)
            info[name_array] = {}
            ori[name_array] = {}
            f = open(self.nlp_file, "r")
            lines = f.readlines()
            f.close()
            shift_last_dim[name_array] = {}
            for line in lines:
                if "#comment:" in line and "Array" in line and f" {name_array} " in line and "tc" in line:
                    size = line.split(" (")[0].split("dim ")[1]
                    dim, size = size.split(" ")
                    ori_size = line.split("(")[-1].split(")")[0].split("=")[-1]
                    id_arg = int(line.split(")")[-1].replace(" ", "").replace("arg", "").replace("\n", ""))
                    if dim not in list(info[name_array].keys()):
                        info[name_array][dim] = {}
                    if dim not in list(ori[name_array].keys()):
                        ori[name_array][dim] = []
                    if id_arg not in list(info[name_array][dim].keys()):
                        info[name_array][dim][id_arg] = []
                    info[name_array][dim][id_arg] += [int(self.info_log[size])]
                    ori[name_array][dim] += [int(self.info_log[ori_size])]
                    if f"cte_burst_without_tiling_{size}_for_{name_array}" in list(self.info_log.keys()):
                        if dim not in list(shift_last_dim[name_array].keys()):
                            shift_last_dim[name_array][dim] = []
                        shift_last_dim[name_array][dim] += [int(self.info_log[f"cte_burst_without_tiling_{size}_for_{name_array}"])]
            
            
            nb_dim = len(list(info[name_array].keys()))
            size_array = []
            for i in range(nb_dim):
                
                if i == nb_dim - 1:
                    if str(i) in list(shift_last_dim[name_array].keys()):
                        val = max(shift_last_dim[name_array][str(i)])
                        if val > 1:
                            ttt = []
                            for j in range(len(info[name_array][str(i)])):
                                ttt.append(max(info[name_array][str(i)][j]))
                            if len(ttt) == 1:
                                vv = ttt[0] + val
                            else:
                                vv = sum(ttt)-1 + val

                            
                            
                            size_array.append(vv)
                        else:
                            ttt = []
                            for j in range(len(info[name_array][str(i)])):
                                ttt.append(max(info[name_array][str(i)][j]))
                            if len(ttt) == 1:
                                vv = ttt[0] 
                            else:
                                vv = sum(ttt)-1 
                            size_array.append(vv)
                    else:
                        ttt = []
                        for j in range(len(info[name_array][str(i)])):
                            ttt.append(max(info[name_array][str(i)][j]))
                        if len(ttt) == 1:
                            vv = ttt[0] 
                        else:
                            vv = sum(ttt)-1 
                        
                        size_array.append(vv)
                else:
                    ttt = []
                    for j in range(len(info[name_array][str(i)])):
                        ttt.append(max(info[name_array][str(i)][j]))
                    if len(ttt) == 1:
                        size_array.append(ttt[0])
                    else:
                        size_array.append(sum(ttt)-1)
            if len(size_array) >= 1:
                size_array[-1] = self.find_size_last_dim(size_array[-1], self.burst[name_array])
            self.size_arrays[name_array] = size_array



        need_many_def = {}
        for arg in new_arg:
            if "[" in arg:
                name = self.extract_name(arg).replace("v", "").split("_for")[0]
                if name in need_many_def:
                    need_many_def[name] += 1
                else:
                    need_many_def[name] = 1

        perms = {}
        iteration_per_dim = {}
        f = open(self.nlp_file, "r")
        lines_nlp = f.readlines()
        f.close()
        for line in lines_nlp:
            if "var" in line and "perm" in line:
                name = line.split("var")[-1].split("binary")[0].replace(" ", "")
                sched = line.split("[")[-1].split("]")[0].replace(" ", "").split(",")
                loops = sched[1::2]
                loops = loops[:len(loops)//2]
                perms[name] = loops
            if "#comment: Array" in line:
                name_array = line.split("Array ")[1].split(" has")[0]
                dim = line.split("dim ")[1].split(" TC")[0]
                loop = line.split("TC")[1].split(" (")[0]
                if name_array not in list(iteration_per_dim.keys()):
                    iteration_per_dim[name_array] = {}
                if dim not in list(iteration_per_dim[name_array].keys()):
                    iteration_per_dim[name_array][dim] = []
                iteration_per_dim[name_array][dim] += [loop]


        code += "int main(int argc, char* argv[]){\n"
        code_csim += "int main(){\n"
        code += self.create_tab(1) + 'printf("Starting C-simulation...\\n");\n'
        code_csim += self.create_tab(1) + 'printf("Starting C-simulation...\\n");\n'
        for arg in original_arg:
            data_type = self.extract_data_type(arg).replace(" ", "") 
            name = self.extract_name(arg).replace(" ", "") 
            array_size = self.extract_iterator(arg)
            array_size_for_fpga = list(map(str, self.size_arrays[name]))
            if data_type == "int":
                continue
            if len(array_size) == 0:
                code += f"{self.create_tab(1)}{data_type} {name}_ori = {{0}};\n"
                code_csim += f"{self.create_tab(1)}{data_type} {name}_ori = {{0}};\n"
                code += f"{self.create_tab(1)}{data_type} {name}_new = {{0}};\n"
                code_csim += f"{self.create_tab(1)}{data_type} {name}_new = {{0}};\n"
                # code += f"{self.create_tab(1)}{data_type} {name}_new_before_trans;\n"
            else:
                code += f"{self.create_tab(1)}{data_type} {name}_ori[{']['.join(array_size)}] = {{0}};\n"
                code_csim += f"{self.create_tab(1)}{data_type} {name}_ori[{']['.join(array_size)}] = {{0}};\n"


                for nb_copy in range(need_many_def[name]):
                    code += f"{self.create_tab(1)}{data_type} {name}_new_before_trans_{nb_copy}[{'*'.join(array_size_for_fpga)}] = {{0}};\n"
                    code_csim += f"{self.create_tab(1)}{data_type} {name}_new_before_trans_{nb_copy}[{'*'.join(array_size_for_fpga)}] = {{0}};\n"
                    code += f"{self.create_tab(1)}{data_type} {name}_new_{nb_copy}[{'*'.join(array_size_for_fpga)}] = {{0}};\n"
                    code_csim += f"{self.create_tab(1)}{data_type} {name}_new_{nb_copy}[{'*'.join(array_size_for_fpga)}] = {{0}};\n"

        code += "int memIndex = 0;\n"
        code_csim += "int memIndex = 0;\n"
        code += "float val;\n"
        code_csim += "float val;\n"

        array_to_check = {}

        for arg in original_arg:
            data_type = self.extract_data_type(arg).replace(" ", "") 
            if data_type == "int":
                continue
            name = self.extract_name(arg).replace(" ", "") 
            array_size = self.extract_iterator(arg)

            if len(array_size) == 0:
                code += f"val = (({data_type})rand() / RAND_MAX);\n"
                code += f"{name}_ori = val;\n"
                code += f"{name}_new = val;\n"
                code_csim += f"val = (({data_type})rand() / RAND_MAX);\n"
                code_csim += f"{name}_ori = val;\n"
                code_csim += f"{name}_new = val;\n"
            else:
                it = [] 
                dims = []
                for k, dim in enumerate(array_size):
                    tab = self.create_tab(1+k)
                    code += f"{tab}for(int i{k} = 0; i{k} < {dim}; i{k}++){{\n"
                    code_csim += f"{tab}for(int i{k} = 0; i{k} < {dim}; i{k}++){{\n"
                    it += [f"i{k}"]
                    dims += [dim]
                tab = self.create_tab(1+len(array_size))
                code += f"{tab} val = (({data_type})rand() / RAND_MAX);\n"
                code += f"{tab}{name}_ori[{']['.join(it)}] = val;\n"
                code_csim += f"{tab} val = (({data_type})rand() / RAND_MAX);\n"
                code_csim += f"{tab}{name}_ori[{']['.join(it)}] = val;\n"
                access = []
                for id_, it in enumerate(it):
                    dim = 1
                    
                    for d in self.size_arrays[name][id_+1:]:
                        dim *= d
                    access += [f"{it} * {dim}"]
                access = ' + '.join(access)
                for nb_copy in range(need_many_def[name]):
                    code += f"{tab}{name}_new_before_trans_{nb_copy}[{access}] = val;\n"
                    code_csim += f"{tab}{name}_new_before_trans_{nb_copy}[{access}] = val;\n"

                    code += f"{tab}{name}_new_{nb_copy}[{access}] = val;\n"
                    code_csim += f"{tab}{name}_new_{nb_copy}[{access}] = val;\n"
                    # code += f"{tab}{name}_new_{nb_copy}[{access}] = val;\n"
                for k in range(len(array_size)):
                    tab = self.create_tab(len(array_size) - k)
                    code += f"{tab}}}\n"
                    code_csim += f"{tab}}}\n"



                full_transferred = {}
                for key in list(self.info_log.keys()):
                    if f"level_transfer_{name}" in key and "under0" in key:
                        if self.info_log[key] == "1":
                            id_ft = key.split("_")[-2].replace("FT", "")
                            full_transferred[id_ft] = True
                        else:
                            id_ft = key.split("_")[-2].replace("FT", "")
                            full_transferred[id_ft] = False
                nb_copy = -1
                for id_ft in list(full_transferred.keys()):

                    if id_ft not in list(self.change_order.keys()):
                        self.change_order[id_ft] = {}
                    if name not in list(self.change_order[id_ft].keys()):
                        self.change_order[id_ft][name] = ""


                    nb_copy += 1
                    if nb_copy >= need_many_def[name]:
                        continue
                    if not full_transferred[id_ft]:
                        array_to_check[name] = f"{name}_new_before_trans_{nb_copy}"
                        code += "// if padding we need to change data order\n"
                        code += "   memIndex = 0;\n"
                        code_csim += "// if padding we need to change data order\n"
                        code_csim += "   memIndex = 0;\n"

                        self.change_order[id_ft][name] += "   memIndex = 0;\n"

                        loop_order = []
                        tc_order = []
                        size_per_dim = []
                        it_order = []
                        tc_dim = {}
                        
                        id_sched = 0
                        all_id_sched = []
                        for id_stat in self.fuse_task[int(id_ft)]:
                            f = open(self.nlp_file, "r")
                            lines = f.readlines()
                            f.close()
                            for line in lines:
                                if "#comment: Sched" in line:
                                    id_sched = int(line.split("Sched ")[1].split(" has")[0])
                                    name_array = line.split("reuse buffer ")[1].split("[")[0]
                                    if name_array == name and int(id_sched) in list(map(int, self.fuse_task[int(id_ft)])):
                                        break
                            for line in lines:
                                if "#comment: Sched" in line:
                                    id_sched_ = int(line.split("Sched ")[1].split(" has")[0])
                                    all_id_sched.append(id_sched_)
                        for key in list(self.info_log.keys()):
                            if "perm" in key and f"S{id_sched}" in key and self.info_log[key] == "1":
                                loop_order = perms[key]
                                break
                        all_loop_order = []
                        for idddd in all_id_sched:
                            for key in list(self.info_log.keys()):
                                if "perm" in key and f"S{idddd}" in key and self.info_log[key] == "1":
                                    loop_order_ = perms[key]
                                    if loop_order_ not in all_loop_order:
                                        all_loop_order.append(loop_order_)
                        # TODO Fix bug for weight eg 
                        for u in range(2):
                            for ll in loop_order:
                                if str(u) in iteration_per_dim[name]:
                                    if ll in iteration_per_dim[name][str(u)]:
                                        tc = self.info_log[f"TC{ll}"]
                                        
                                        # tc_order += [tc]
                                        # tc_dim[str(u)] = tc
                                        # break
                                        size_per_dim += [tc]
                        loop_order_array = self.info_loop_to_array[int(id_ft)][name]

                        for u in range(1):
                            for ll in loop_order:
                                is_present = False
                                for dd in range(4):
                                    if str(dd) in list(iteration_per_dim[name].keys()):
                                        if ll in iteration_per_dim[name][str(dd)]:
                                            is_present = True
                                            it_order += [f"d{dd}_{u}"]
                                            tc = self.info_log[f"TC{ll}_0"]
                                            tc_dim[str(dd)] = tc
                                            break
                                if is_present:
                                    tc = self.info_log[f"TC{ll}_{u}"]
                                    tc_order += [tc]

                        # for the intra-tile we iterate from out dimension to inner of the array
                        for u in range(1,2):
                            for ll in loop_order_array:
                                is_present = False
                                for dd in range(4):
                                    if str(dd) in list(iteration_per_dim[name].keys()):
                                        for lll in ll:
                                            if lll in iteration_per_dim[name][str(dd)]:
                                                is_present = True
                                                it_order += [f"d{dd}_{u}"]
                                                tc = self.info_log[f"TC{lll}_1"]
                                                tc_dim[str(dd)] = tc
                                                break
                                if is_present:
                                    tc = self.info_log[f"TC{ll[0]}_{u}"]
                                    for lll in ll[1:]:
                                        tc += self.info_log[f"TC{lll}_1"] #FIXME
                                    tc_order += [tc]
                        

                        # compute it_order
                        # compute tc_order
                        # name
                        # id_ft
                        f = open(self.new_file, "r")
                        lines_c = f.readlines()
                        f.close()

                        all_fct = self.extract_name_fct(lines_c)
                        maxi_level = 0
                        
                        full_transfered = False
                        for fct in all_fct:
                            if f"FT{id_ft}" in fct and "level" in fct:
                                level = fct.split("level")[-1].split("(")[-1]
                                maxi_level = max(maxi_level, int(level))
                        level_trans = maxi_level # because if init on chip the next loops will not find it
                        for level in range(maxi_level+1):
                            name_fct = f"FT{id_ft}_level{level}"
                            ll = self.extract_fct(name_fct, lines_c)
                            for l in ll:
                                if f"read_{name}_FT{id_ft}" in l:
                                    level_trans = level
                                    if f"{name}_0" in l or f"{name}_1" in l or f"{name}_2" in l:
                                        pass
                                    else:
                                        full_transfered = True
                                    break

                        if full_transfered:
                            pass

                        else:
                            dim_fully_transfered = [True for k in range(len(it_order)//2)]
                            #need to reorder
                            dic = {}
                            for alll in all_loop_order:
                                for ll in alll:
                                    for id_dim, dd in enumerate(loop_order_array):
                                        if ll in dd:
                                            dic[ll] = id_dim
                            for level in range(level_trans+1):
                                for alll in all_loop_order:
                                    try:
                                        loopp = alll[level]
                                        if loopp in list(dic.keys()):
                                            dim = dic[loopp]
                                            dim_fully_transfered[dim] = False
                                    except:
                                        pass


                        new_tc_order = tc_order.copy()
                        new_it_order = it_order.copy()
                        new_tc_order = new_tc_order[len(new_tc_order)//2:]
                        new_it_order = new_it_order[len(new_it_order)//2:]


                        for a in range(len(dim_fully_transfered)-1, -1, -1):
                            if dim_fully_transfered[a]:
                                if f"d{a}_0" in new_it_order:
                                    new_it_order.insert(a, f"d{a}_0")
                                    ind = it_order.index(f"d{a}_0")
                                    tcc = tc_order[ind]
                                    new_tc_order.insert(a, tcc)
                        

                        for a in range(len(it_order)-1, -1, -1):
                            if it_order[a] not in new_it_order:
                                new_it_order.insert(0, it_order[a])
                                new_tc_order.insert(0, tc_order[a])

                        it_order = new_it_order
                        tc_order = new_tc_order

                        under_what_loop = 0
                        for key in list(self.info_log.keys()):
                            if "level_transfer" in key and name in key and self.info_log[key] == "1":
                                level = key.split("under")[-1].split("=")[0].replace(" ", "")
                                under_what_loop = level
                                break
                        # TODO finish this method
                        dic = {}
                        for key in list(self.info_log.keys()):
                            if f"{name}_is_fully_transfered_on_last_dim_FT{id_ft}" in key:
                                level = int(key.split("FT")[-1].split("=")[0].replace(" ", ""))
                                try:
                                    dic[level] = int(self.info_log[key])
                                except:
                                    dic[level] = 0
                        min_FT = min(list(dic.keys()))
                        is_last_dim_fully_transfered = dic[min_FT] == 1

                        nb_dim = len(tc_dim)
                        code += f"//{it_order}\n"
                        code_csim += f"//{it_order}\n"
                        if is_last_dim_fully_transfered:
                            
                            for k in range(len(it_order)):
                                if int(it_order[k].split("_")[0].replace("d", "")) != nb_dim-1:
                                    code += f"for(int {it_order[k]} = 0; {it_order[k]} < {tc_order[k]}; {it_order[k]}++){{\n"
                                    code_csim += f"for(int {it_order[k]} = 0; {it_order[k]} < {tc_order[k]}; {it_order[k]}++){{\n"
                                    self.change_order[id_ft][name] += f"for(int {it_order[k]} = 0; {it_order[k]} < {tc_order[k]}; {it_order[k]}++){{\n"
                            cte_burst = 0

                            loop_last_dim = int(iteration_per_dim[name][str(nb_dim-1)][0])

                            for key in list(self.info_log.keys()):
                                if f"cte_burst_without_tiling" in key and f"_for_{name}" in key:
                                    cte_burst = int(self.info_log[key])
                                    break

                            tcc = int(self.info_log[f"TC{loop_last_dim}"]) + cte_burst
                            code += f"for(int d{nb_dim-1} = 0; d{nb_dim-1} < {tcc}; d{nb_dim-1}++){{\n"
                            code_csim += f"for(int d{nb_dim-1} = 0; d{nb_dim-1} < {tcc}; d{nb_dim-1}++){{\n"
                            self.change_order[id_ft][name] += f"for(int d{nb_dim-1} = 0; d{nb_dim-1} < {tcc}; d{nb_dim-1}++){{\n"

                            for k in range(len(tc_dim)-1):
                                code += f"int d{k} = d{k}_0 * {tc_dim[str(k)]} + d{k}_1;\n"
                                code_csim += f"int d{k} = d{k}_0 * {tc_dim[str(k)]} + d{k}_1;\n"
                                self.change_order[id_ft][name] += f"int d{k} = d{k}_0 * {tc_dim[str(k)]} + d{k}_1;\n"

                            access = []
                            its = [f"d{k}" for k in range(len(tc_dim))]
                            for id_, it in enumerate(its):
                                dim = 1
                                
                                for d in self.size_arrays[name][id_+1:]:
                                    dim *= d
                                access += [f"{it} * {dim}"]
                            access = ' + '.join(access)
                            code += f"{name}_new_{nb_copy}[memIndex] = {name}_new_before_trans_{nb_copy}[{access}];\n"
                            code += f"memIndex++;\n"
                            code_csim += f"{name}_new_{nb_copy}[memIndex] = {name}_new_before_trans_{nb_copy}[{access}];\n"
                            code_csim += f"memIndex++;\n"
                            self.change_order[id_ft][name] += f"{name}_new_before_trans_{nb_copy}[{access}] = {name}_new_{nb_copy}[memIndex];\n" # reverse
                            self.change_order[id_ft][name] += f"memIndex++;\n"

                            for k in range(len(it_order)):
                                if int(it_order[k].split("_")[0].replace("d", "")) != nb_dim-1:
                                    code += "}\n"
                                    code_csim += "}\n"
                                    self.change_order[id_ft][name] += "}\n"
                            code += "}\n"
                            code_csim += "}\n"
                            self.change_order[id_ft][name] += "}\n"

                        else:
                        
                        
                        
                            for k in range(len(it_order)):
                                try:
                                    code += f"for(int {it_order[k]} = 0; {it_order[k]} < {tc_order[k]}; {it_order[k]}++){{\n"
                                    code_csim += f"for(int {it_order[k]} = 0; {it_order[k]} < {tc_order[k]}; {it_order[k]}++){{\n"
                                    self.change_order[id_ft][name] += f"for(int {it_order[k]} = 0; {it_order[k]} < {tc_order[k]}; {it_order[k]}++){{\n"
                                except:
                                    pass
                            
                            for k in range(len(tc_dim)):
                                code += f"int d{k} = d{k}_0 * {tc_dim[str(k)]} + d{k}_1;\n"
                                code_csim += f"int d{k} = d{k}_0 * {tc_dim[str(k)]} + d{k}_1;\n"
                                self.change_order[id_ft][name] += f"int d{k} = d{k}_0 * {tc_dim[str(k)]} + d{k}_1;\n"

                            access = []
                            its = [f"d{k}" for k in range(len(tc_dim))]
                            for id_, it in enumerate(its):
                                dim = 1
                                
                                for d in self.size_arrays[name][id_+1:]:
                                    dim *= d
                                access += [f"{it} * {dim}"]
                            access = ' + '.join(access)
                            code += f"{name}_new_{nb_copy}[memIndex] = {name}_new_before_trans_{nb_copy}[{access}];\n"
                            code += f"memIndex++;\n"
                            code_csim += f"{name}_new_{nb_copy}[memIndex] = {name}_new_before_trans_{nb_copy}[{access}];\n"
                            code_csim += f"memIndex++;\n"
                            self.change_order[id_ft][name] += f"{name}_new_before_trans_{nb_copy}[{access}] = {name}_new_{nb_copy}[memIndex];\n" #reverse
                            self.change_order[id_ft][name] += f"memIndex++;\n"

                            for k in range(len(it_order)):
                                code += "}\n"
                                code_csim += "}\n"
                                self.change_order[id_ft][name] += "}\n"
                    else:
                        array_to_check[name] = f"{name}_new_{nb_copy}"

        original_name = self.extract_name_function(self.original_code)
        new_name = self.extract_name_function(self.new_code)

        # code += f"{self.create_tab(1)}{original_name}("
        # for k, arg in enumerate(original_arg):
        #     data_type = self.extract_data_type(arg).replace(" ", "") 
        #     name = self.extract_name(arg).replace(" ", "") 
        #     code += f"{name}_ori"
        #     if k < len(original_arg) - 1:
        #         code += ", "
        # code += ");\n"

        # code += f"{self.create_tab(1)}{new_name}("
        # for k, arg in enumerate(new_arg):
        #     data_type = self.extract_data_type(arg).replace(" ", "") 
        #     if data_type != "float":
        #         name = f"({data_type} *) "
        #     else:
        #         name = ""
        #     name += self.extract_name(original_arg[k]).replace(" ", "") 
        #     code += f"{name}_new"
        #     if k < len(new_arg) - 1:
        #         code += ", "
        # code += ");\n"

        code += f"cl_int err;\n"
        code += f"std::vector<cl::Device> devices = xcl::get_xil_devices();\n"
        code += f"cl::Device device;\n"

        code += 'for(unsigned int i = 0; i < devices.size(); i++){\n'
        code += 'device = devices[i];\n'
        code += 'std::cout << "Trying to program device[" << i << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;\n'
        code += '    #ifndef HW_SIM\n'
        code += '    if (device.getInfo<CL_DEVICE_NAME>() == "xilinx_u55c_gen3x16_xdma_base_3") {\n'
        code += '    #else\n'
        code += '    if (device.getInfo<CL_DEVICE_NAME>() == "xilinx_u55c_gen3x16_xdma_3_202210_1") {\n'
        code += '    #endif\n'
        code += '        break;\n'
        code += '    }\n'
        code += '}\n'

        code += f"OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));\n"
        code += f"OCL_CHECK(err, cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err));\n"
        code += f"OCL_CHECK(err, std::string device_name = device.getInfo<CL_DEVICE_NAME>(&err));\n"

        code += f"std::string binary(argv[1]);\n"
        code += f"auto fileBuf = xcl::read_binary_file(binary);\n"
        code += f"cl::Program::Binaries bins{{{{fileBuf.data(), fileBuf.size()}}}};\n"

        code += f"OCL_CHECK(err, cl::Program program(context, {{device}}, bins, NULL, &err));\n"
        code += f"OCL_CHECK(err, cl::Kernel kernel(program, \"kernel_nlp\", &err));\n"


        info_arr = {}
        first_read = {}
        first_write = {}
        for k in range(len(self.schedule)):
            w = self.analysis.dic[k]["write"]
            r = self.analysis.dic[k]["read"]
            for r_ in r:
                if "[" in r_ and "[0]" not in r_:
                    name = r_.split("[")[0]
                    if name not in list(info_arr.keys()):
                        info_arr[name] = []
                    if name not in list(first_read.keys()):
                        first_read[name] = k
                    info_arr[name] += [("r", k)]
                    first_read[name] = min(first_read[name], k)

            for w_ in w:
                if "[" in w_ and "[0]" not in w_:
                    name = w_.split("[")[0]
                    if name not in list(info_arr.keys()):
                        info_arr[name] = []
                    info_arr[name] += [("w", k)]
                    if name not in list(first_write.keys()):
                        first_write[name] = k
                    first_write[name] = min(first_write[name], k)

        # TODO we need to get padding size, + array duplication

        read = []
        write = []
        dont_need_to_check = []

        constant = []

        for arg in original_arg:
            data_type = self.extract_data_type(arg).replace(" ", "") 
            name = self.extract_name(arg).replace(" ", "") 
            array_size = self.extract_iterator(arg)
            only_read = False
            only_write = False
            read_write = False

            nb_read = 0
            nb_write = 0
            if name in list(info_arr.keys()):
                for arr in info_arr[name]:
                    if arr[0] == "r":
                        nb_read += 1
                    else:
                        nb_write += 1

                if nb_read >= 1 and nb_write == 0:
                    only_read = True
                elif nb_write >= 1 and nb_read == 0:
                    only_write = True
                else:
                    read_write = True
            else:
                only_read = True


            kind = ""
            if only_read:
                kind = "CL_MEM_READ_ONLY"
            elif only_write:
                kind = "CL_MEM_WRITE_ONLY"
            elif read_write:
                kind = "CL_MEM_READ_WRITE"
            if f"a" in array_size or len(array_size) == 0:
                constant += [f"{name}_new"]
            else:
                
                array_size = "*".join(list(map(str, self.size_arrays[name])))
                if name in list(need_many_def.keys()):
                    for nb_copy in range(need_many_def[name]):
                        code += f"cl::Buffer {name}_{nb_copy}NewOCL = cl::Buffer(context, CL_MEM_USE_HOST_PTR | {kind}, sizeof({data_type}) * {array_size}, {name}_new_{nb_copy}, &err);\n"
                        code += f"if(err != CL_SUCCESS){{"
                        code += f"std::cerr << \"Could not allocate buffer {name}NewOCL, error number: \" << err << \"\\n\";"
                        code += f"return EXIT_FAILURE;\n"
                        code += f"}}\n"
                        if kind == "CL_MEM_READ_ONLY":
                            read += [f"{name}_{nb_copy}NewOCL"]
                            dont_need_to_check += [name]
                        else:
                            write += [f"{name}_{nb_copy}NewOCL"]
                else:
                    code += f"cl::Buffer {name}NewOCL = cl::Buffer(context, CL_MEM_USE_HOST_PTR | {kind}, sizeof({data_type}) * {array_size}, {name}_new, &err);\n"
                    code += f"if(err != CL_SUCCESS){{"
                    code += f"std::cerr << \"Could not allocate buffer {name}NewOCL, error number: \" << err << \"\\n\";"
                    code += f"return EXIT_FAILURE;\n"
                    code += f"}}\n"
                    if kind == "CL_MEM_READ_ONLY":
                        read += [f"{name}NewOCL"]
                        dont_need_to_check += [name]
                    else:
                        write += [f"{name}NewOCL"]

        code += f"int argN = 0;"
        # for arg in constant:
        #     # data_type = self.extract_data_type(arg).replace(" ", "") 
        #     # name = self.extract_name(arg).replace(" ", "") 
        #     # array_size = self.extract_iterator(arg)
        #     code += f"kernel.setArg(argN++, {arg});\n"

        # for arg in new_arg:
            # name = self.extract_name(arg).replace(" ", "") 

            # if f"{name}_new" in constant:
            #     continue
            # if name in list(need_many_def.keys()):
            #     for nb_copy in range(need_many_def[name]):
            #         data_type = self.extract_data_type(arg).replace(" ", "") 
                    
            #         code += f"kernel.setArg(argN++, {name}_{nb_copy}NewOCL);\n" # TODO FIXME
            # else:
            #     data_type = self.extract_data_type(arg).replace(" ", "") 
            #     code += f"kernel.setArg(argN++, {name}NewOCL);\n"
        already_seen = {}
        for k, arg in enumerate(new_arg):
            
            data_type = self.extract_data_type(arg).replace(" ", "") 
            if data_type != "float":
                # name = f"({data_type} *) "
                name = ""
            else:
                name = ""

            name_ = arg.split(" ")[-1].split("_")[0].replace("v", "").replace(" ", "")
            name += name_
            name_array = name.split(" ")[-1].replace(" ", "")

            if name_array in list(need_many_def.keys()):

                if name not in list(already_seen.keys()):
                    already_seen[name] = 0
                code += f"kernel.setArg(argN++, {name}_{already_seen[name]}NewOCL);\n"
                code += f""
                # if already_seen[name] < need_many_def[name_array] - 1:
                #     code_csim += ", "
                already_seen[name] += 1
            else:
                # code += f"{name}_new"
                code += f"kernel.setArg(argN++, {name}_new);\n"
            # if k < len(new_arg) - 1:
            #     code += ", "
        
        

        # TODO
        read = ", ".join(read)

        code += f'OCL_CHECK(err, err = q.enqueueMigrateMemObjects({{ {read} }}, 0, nullptr, nullptr));'
        code += f'q.finish();'

        code += f'cl::Event kernelCompute;'
        code += f'OCL_CHECK(err, err = q.enqueueTask(kernel, nullptr, &kernelCompute));'
        code += f'q.finish();'
        code += f'kernelCompute.wait();'

        
        #TODO
        write = ", ".join(write)

        code += f'OCL_CHECK(err, err = q.enqueueMigrateMemObjects({{ {write} }}, CL_MIGRATE_MEM_OBJECT_HOST, nullptr, nullptr));'
        code += f'q.finish();'

        code += f"{self.create_tab(1)}{original_name}("
        code_csim += f"{self.create_tab(1)}{original_name}("
        for k, arg in enumerate(original_arg):
            data_type = self.extract_data_type(arg).replace(" ", "") 
            name = self.extract_name(arg).replace(" ", "") 
            code += f"{name}_ori"
            code_csim += f"{name}_ori"
            if k < len(original_arg) - 1:
                code += ", "
                code_csim += ", "
        code += ");\n"
        code_csim += ");\n"

        code_csim += f"{self.create_tab(1)}{new_name}("
        already_seen = {}
        for k, arg in enumerate(new_arg):
            
            data_type = self.extract_data_type(arg).replace(" ", "") 
            
            if data_type != "float":
                name = f"({data_type} *) "
            else:
                name = ""

            if data_type == "float" and "[" in arg:
                name = f"({data_type}1 *) "

            name_ = arg.split(" ")[-1].split("_")[0].replace("v", "").replace(" ", "")
            name += name_
            name_array = name.split(" ")[-1].replace(" ", "")

            if name_array in list(need_many_def.keys()):

                if name not in list(already_seen.keys()):
                    already_seen[name] = 0
                code_csim += f"{name}_new_{already_seen[name]}"
                # if already_seen[name] < need_many_def[name_array] - 1:
                #     code_csim += ", "
                already_seen[name] += 1
            else:
                code_csim += f"{name}_new"
            if k < len(new_arg) - 1:
                code_csim += ", "
        code_csim += ");\n"


        for arg in original_arg:
            data_type = self.extract_data_type(arg).replace(" ", "") 
            if data_type == "int":
                continue
            name = self.extract_name(arg).replace(" ", "") 
            array_size = self.extract_iterator(arg)

            if len(array_size) > 0:
                id_ft = -1
                if len(self.array_information[name]["W"]) > 0:
                    id_stat = max(self.array_information[name]["W"])
                    
                    for id_ft_ in list(self.fuse_task.keys()):
                        if id_stat in self.fuse_task[int(id_ft_)]:
                            id_ft = id_ft_
                            break
                full_transferred = False
                for key in list(self.info_log.keys()):
                    if id_ft != -1 and f"level_transfer_{name}_FT{id_ft}" in key and "under0" in key:
                        if self.info_log[key] == "1":
                            full_transferred = True
                    elif id_ft == -1 and f"level_transfer_{name}" in key and "under0" in key: # just for write
                        if self.info_log[key] == "1":
                            full_transferred = True

                if not full_transferred:
                    array_to_check[name] = f"{name}_new_before_trans_{nb_copy}"
                    # code += "// if padding we need to change data order\n"
                    # code += "   memIndex = 0;\n"
                    # code_csim += "// if padding we need to change data order\n"
                    # code_csim += "   memIndex = 0;\n"

                    ####### 
                    



                    data_type = self.extract_data_type(arg).replace(" ", "") 
                    name = self.extract_name(arg).replace(" ", "") 
                    if name in dont_need_to_check:
                        continue

                    # find the last id_ft where name is written
                    id_stat = max(self.array_information[name]["W"])
                    id_ft = 0
                    for id_ft_ in list(self.fuse_task.keys()):
                        if id_stat in self.fuse_task[int(id_ft_)]:
                            id_ft = id_ft_
                            break
                    if name in list(self.change_order[str(id_ft)].keys()):
                        code += self.change_order[str(id_ft)][name]
                        code_csim += self.change_order[str(id_ft)][name]

                    array_size = self.extract_iterator(arg)

                    if len(array_size) == 0:
                        code += f"{self.create_tab(1)}if(abs({name}_ori - {name}_new_before_trans_0) > {self.diff}){{\n"
                        code += f"{self.create_tab(2)}printf(\"Error in {name}...\\n\");\n"
                        code += f"{self.create_tab(2)}return 1;\n"
                        code += f"{self.create_tab(1)}}}\n"

                        code_csim += f"{self.create_tab(1)}if(abs({name}_ori - {name}_new_before_trans_0) > {self.diff}){{\n"
                        code_csim += f"{self.create_tab(2)}printf(\"Error in {name}...\\n\");\n"
                        code_csim += f"{self.create_tab(2)}return 1;\n"
                        code_csim += f"{self.create_tab(1)}}}\n"
                    else:
                        it = [] 
                        dims = []
                        for k, dim in enumerate(array_size):
                            tab = self.create_tab(1+k)
                            code += f"{tab}for(int i{k} = 0; i{k} < {dim}; i{k}++){{\n"
                            code_csim += f"{tab}for(int i{k} = 0; i{k} < {dim}; i{k}++){{\n"
                            it += [f"i{k}"]
                            dims += [dim]
                        tab = self.create_tab(1+len(array_size))
                        tabp1 = self.create_tab(2+len(array_size))
                        access = []
                        for id_, it_ in enumerate(it):
                            dim = 1
                            # list(map(str, self.size_arrays[name]))
                            for d in self.size_arrays[name][id_+1:]:
                                dim *= d
                            access += [f"{it_} * {dim}"]
                        access = ' + '.join(access)
                        for nb in range(need_many_def[name]):
                            code += f"{tab}if(abs({name}_ori[{']['.join(it)}] - {name}_new_before_trans_{nb}[{access}]) > {self.diff}){{\n"
                            # code += f"{tabp1}printf(\"Error in {name}...\\n\");\n"
                            code += f"{tabp1}printf(\"Error in {name}..."
                            for k, dim in enumerate(array_size):
                                code += f" %d "
                            code += "%f %f\\n\","
                            for k, dim in enumerate(array_size):
                                code += f"i{k}, "
                            code += f"{name}_ori[{']['.join(it)}], {name}_new_before_trans_{nb}[{access}]);\n"
                            
                            # code += ");\n"
                            code += f"{tabp1}return 1;\n"
                            code += f"{tab}}}\n"

                            code_csim += f"{tab}if(abs({name}_ori[{']['.join(it)}] - {name}_new_before_trans_{nb}[{access}]) > {self.diff}){{\n"
                            code_csim += f"{tabp1}printf(\"Error in {name}..."
                            for k, dim in enumerate(array_size):
                                code_csim += f" %d "
                            code_csim += "%f %f\\n\","
                            for k, dim in enumerate(array_size):
                                code_csim += f"i{k}, "
                            code_csim += f"{name}_ori[{']['.join(it)}], {name}_new_before_trans_{nb}[{access}]);\n"
                            
                            # code_csim += ");\n"
                            code_csim += f"{tabp1}return 1;\n"
                            code_csim += f"{tab}}}\n"
                        for k in range(len(array_size)):
                            tab = self.create_tab(len(array_size) - k)
                            code += f"{tab}}}\n"
                            code_csim += f"{tab}}}\n"
                else:
                    data_type = self.extract_data_type(arg).replace(" ", "") 
                    name = self.extract_name(arg).replace(" ", "") 
                    if name in dont_need_to_check:
                        continue
                    array_size = self.extract_iterator(arg)

                    if len(array_size) == 0:
                        code += f"{self.create_tab(1)}if(abs({name}_ori - {name}_new_0) > {self.diff}){{\n"
                        code += f"{self.create_tab(2)}printf(\"Error in {name}...\\n\");\n"
                        code += f"{self.create_tab(2)}return 1;\n"
                        code += f"{self.create_tab(1)}}}\n"

                        code_csim += f"{self.create_tab(1)}if(abs({name}_ori - {name}_new_0) > {self.diff}){{\n"
                        code_csim += f"{self.create_tab(2)}printf(\"Error in {name}...\\n\");\n"
                        code_csim += f"{self.create_tab(2)}return 1;\n"
                        code_csim += f"{self.create_tab(1)}}}\n"
                    else:
                        it = [] 
                        dims = []
                        for k, dim in enumerate(array_size):
                            tab = self.create_tab(1+k)
                            code += f"{tab}for(int i{k} = 0; i{k} < {dim}; i{k}++){{\n"
                            code_csim += f"{tab}for(int i{k} = 0; i{k} < {dim}; i{k}++){{\n"
                            it += [f"i{k}"]
                            dims += [dim]
                        tab = self.create_tab(1+len(array_size))
                        tabp1 = self.create_tab(2+len(array_size))
                        access = []
                        for id_, it_ in enumerate(it):
                            dim = 1
                            # list(map(str, self.size_arrays[name]))
                            for d in self.size_arrays[name][id_+1:]:
                                dim *= d
                            access += [f"{it_} * {dim}"]
                        access = ' + '.join(access)
                        for nb in range(need_many_def[name]):
                            code += f"{tab}if(abs({name}_ori[{']['.join(it)}] - {name}_new_{nb}[{access}]) > {self.diff}){{\n"
                            code += f"{tabp1}printf(\"Error in {name}...\\n\");\n"
                            code += f"{tabp1}return 1;\n"
                            code += f"{tab}}}\n"
                            code_csim += f"{tab}if(abs({name}_ori[{']['.join(it)}] - {name}_new_{nb}[{access}]) > {self.diff}){{\n"
                            code_csim += f"{tabp1}printf(\"Error in {name}...\\n\");\n"
                            code_csim += f"{tabp1}return 1;\n"
                            code_csim += f"{tab}}}\n"
                        for k in range(len(array_size)):
                            tab = self.create_tab(len(array_size) - k)
                            code += f"{tab}}}\n"
                            code_csim += f"{tab}}}\n"
        
        
        code += f"""{self.create_tab(1)}printf(\"C-simulation passed!\\n\");\n"""
        code_csim += f"""{self.create_tab(1)}printf(\"C-simulation passed!\\n\");\n"""
        code += f'uint64_t executionTime = kernelCompute.getProfilingInfo<CL_PROFILING_COMMAND_END>() - kernelCompute.getProfilingInfo<CL_PROFILING_COMMAND_START>();\n'
        code += f'std::cout << "Time in seconds: " << (double)executionTime/pow(1000,3) << "\\n";\n'
        code += f"{self.create_tab(1)}return 0;\n"
        code_csim += f"{self.create_tab(1)}return 0;\n"
        code += "}\n"
        code_csim += "}\n"

        f = open(self.output, "w")
        code = "".join(code)
        f.write(code)
        f.close()

        f = open(self.output.replace("host.cpp", "csim.cpp"), "w")
        code_csim = "".join(code_csim)
        f.write(code_csim)
        f.close()