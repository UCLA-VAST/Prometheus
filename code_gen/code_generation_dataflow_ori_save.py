import os
import numpy as np
import re

class Node:
    def __init__(self, value, string, l, kind, depth, it=None, lb=None, ub=None, is_innermost=None, is_reduction=None):

        self.value = value
        self.string = string
        self.l = l
        self.kind = kind
        self.depth = depth
        self.l += [self]
        self.children = []
        self.aready_seen = False
        self.it = it
        self.lb = lb
        self.ub = ub
        self.is_innermost = is_innermost
        self.is_reduction = is_reduction

    def add_child(self, child):
        self.children.append(child)

    def __str__(self):
        str_ = f"Node: {self.value}"
        str_ += "-> Child ["
        if self.children:
            # str_ += " -> "
            for child in self.children:
                str_ += f"{child} "
        str_ += "]"
        return str_

class AST:
    def __init__(self, schedule, reuse_buffer, UB, LB, TC, statements, iterators, output, headers, arguments, name_function, pragmas_top):
        self.schedule = schedule
        self.UB = UB
        self.LB = LB
        self.TC = TC
        self.reuse_buffer = reuse_buffer
        self.statements = statements
        self.iterators = iterators
        self.output = output
        self.headers = headers
        self.arguments = arguments
        self.name_function = name_function
        # self.pragmas = pragmas
        self.pragmas_top = pragmas_top
        self.tab = "    "
        self.list_nodes = []
        self.tree = Node("Root",  "", self.list_nodes, "Root", 0)
        self.compute()
        # self.print_ast()
        
        self.order_per_task = []
        self.order = []
        self.write_order(self.tree)

    def apply_tiling(self, stat, id_, indent):
        
        new_str = ""
        loops = self.schedule[id_][1::2]
        loops = loops[:len(loops)//2]
        for i, loop in enumerate(loops):
            it = self.iterators[loop]
            new_str += indent
            new_str += f"{it} = {it}0 * {self.TC[loop][1]} + {it}1;\n"


        new_str += indent + stat 
        return new_str

    def compute(self):
        for i, stat in enumerate(self.schedule):
            str_statement = self.statements[i]
            for j in range(1, len(stat), 2):
                loop = int(self.schedule[i][j])
                it = f"{self.iterators[loop]}"
                #FIXME: we suppose lb = 0
                # lb = self.LB[loop]
                # ub = self.UB[loop]
                lb = 0
                depth_tile = 0
                if stat[1::2].index(loop) != (j-1)//2:
                    depth_tile = 1
                    it = f"{it}1"
                else:
                    it = f"{it}0"
                ub = self.TC[loop][depth_tile]
                # if loop not in [x.value for x in self.list_nodes]:
                loop_str = self.create_tab((j-1)//2+1) + self.create_loop(it, lb, ub, self.schedule[i][j]) 
                if it[-1] == "1":
                    loop_str += "\n#pragma HLS unroll"
                if it[-1] == "0" and j == len(stat)//2-1:
                    loop_str += "\n#pragma HLS pipeline II=2" # trick to have II=3
                if j == 1:
                    if loop not in [x.value for x in self.list_nodes]:
                        node = Node(f"{loop}_{depth_tile}", loop_str, self.list_nodes, "Loop", (j-1)//2+1)
                        self.tree.add_child(node)
                else:
                    node = Node(f"{loop}_{depth_tile}", loop_str, self.list_nodes, "Loop", (j-1)//2+1)
                    bdepth_parent = self.schedule[i][1::2].index(int(self.schedule[i][j-2])) != (j-3)//2
                    if bdepth_parent:
                        depth_parent = 1
                    else:
                        depth_parent = 0
                    parent = f"{int(self.schedule[i][j-2])}_{depth_parent}"

                    parent_node = [x for x in self.list_nodes if x.value == parent][0]
                    parent_node.add_child(node)
            if ";" not in str_statement:
                str_statement += ";"
            str_statement = self.apply_tiling(str_statement, i, self.create_tab((len(stat)-1)//2+1))
            str_statement =  str_statement
            node_statement = Node(f"S{i}", str_statement, self.list_nodes, "Statement", len(stat))
            if len(stat) > 1:

                parent = f"{int(self.schedule[i][-2])}_1"
                parent_node = [x for x in self.list_nodes if x.value == parent][0]
                parent_node.add_child(node_statement)
            else:
                self.tree.add_child(node_statement)
    
    def create_loop(self, it, lb, ub, id_):
        str_ = ""
        # if self.pragmas_top:
        #     for p in self.pragmas[id_].split(";"):
        #         if p != "":
        #             str_ += f"#pragma ACCEL {p}\n"
        str_ += f"for (int {it} = {lb}; {it} < {ub}; {it}++) {{\n"
        # if not self.pragmas_top:
        #     for p in self.pragmas[id_].split(";"):
        #         if p != "":
        #             str_ += f"#pragma HLS {p}\n"
        # remove the last \n
        str_ = str_[:-1]
        return str_

    def create_tab(self, nb):
        return self.tab * nb

    def print_ast(self):
        print(self.tree)

    def write_order(self, tree):
        
        
        for k,subtree in enumerate(tree.children):
            self.order = []
            if subtree.kind == "Statement":
                self.order.append(subtree.string)
            elif subtree.kind == "Loop":
                self.order.append(subtree.string)
                for child in subtree.children:
                    # if not child.aready_seen:
                    self.write_order2(child)
                tab = self.create_tab(subtree.depth)
                self.order.append(f"{tab}}}")
            else: # Root
                for child in subtree.children:
                    self.write_order2(child)
            self.order_per_task.append(self.order)

    def write_order2(self, tree):
        if tree.kind == "Statement":
            self.order.append(tree.string)
        elif tree.kind == "Loop":
            self.order.append(tree.string)
            for child in tree.children:
                # if not child.aready_seen:
                self.write_order2(child)
            tab = self.create_tab(tree.depth)
            self.order.append(f"{tab}}}")
        else: # Root
            for child in tree.children:
                self.write_order2(child)
        
        

                


class CodeGeneration:
    def __init__(self, nlp_file, log_file, output, analysis):
        self.nlp_file = nlp_file
        self.log_file = log_file
        self.analysis = analysis

        
        
        self.what_array_has_shit = []
        self.schedule = self.compute_schedule()
        
        self.number_of_loops = 0
        
        for i in range(len(self.schedule)):
            self.schedule[i] = list(map(int, self.schedule[i]))
        
        
        self.fuse_task = {}
        self.task_to_FT = {}
        self.compute_nb_fuse_task()


        self.info_log = {}
        self.compute_info_log()

        # self.nb_fuse_task = 0
        # self.fuse_task = {}
        # self.task_to_FT = {}
        # self.compute_nb_fuse_task()
        self.info_padding = {}
        self.info_size_transferred = {}
        self.info_on_chip_size = {}
        self.info_loop_to_array = {}
        self.compute_padding()
        self.UB = []
        self.LB = []
        self.TC = {}
        self.burst = {}
        self.compute_TC()
        self.compute_burst()
        self.statements = []
        self.iterators = []
        self.compute_statements()
        self.compute_iterators()
        self.reuse_buffer = {}
        self.compute_reuse_buffer()
        self.flow_read_array = {}
        self.flow_write_array = {}
        self.compute_flow()
        self.output = output
        self.headers = ['ap_int.h', 'hls_stream.h', 'hls_vector.h', 'cstring', 'algorithm', 'iostream', 'ap_axi_sdata.h'] 
        self.typedef = ['hls::vector<float,16> float16', 'hls::vector<float,8> float8', 'hls::vector<float,4> float4', 'hls::vector<float,2> float2', 'hls::vector<float,1> float1']
        self.arguments = []
        self.compute_arguments()
        self.name_function = "kernel_nlp"
        # self.pragmas = pragmas
        self.pragmas_top = False
        self.optimize_burst = False

        self.array_information = {}
        self.pre_treatement_statements()
        self.compute_arrays_information()
        self.type = ""
        self.size_arrays = {}
        self.perm = {}
        self.compute_perm()
        self.order_read_per_array = {}

        self.compute_order_read_per_array()




        self.tab = "    "
        self.warnings = "\n/****************************************************\n This file was automatically generated by Prometheus\n****************************************************/\n"
        
        self.ast = AST(self.schedule, self.reuse_buffer, self.UB, self.LB, self.TC, self.statements, self.iterators, self.output, self.headers, self.arguments, self.name_function, self.pragmas_top)
        # self.compute_order()
        self.generate_code()
    
    def compute_padding(self):
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
                    if id_FT not in list(self.info_size_transferred.keys()):
                        self.info_size_transferred[id_FT] = {}
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
                            res -= 1 # FIXME
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
                            res -= 1 # FIXME
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
                    self.info_size_transferred[id_FT][name_array] = tmp4

    def update_log_file(self, lines):
        
        new_lines = []
        lev_res = {}
        llev_res = []
        perm = []
        for k, line in enumerate(lines):
            if "level_reuse" in line or "level_transfer" in line:
                if "level_transfer" in line:
                    new_lines.append(line)
                key, value = line.split("=")
                key = key.replace(" ", "")
                value = value.replace(" ", "").replace("\n", "")
                if value == "1":
                    lev_res[key] = True
                else:
                    lev_res[key] = False
                llev_res.append(line)
            else:
                new_lines.append(line)


        info = {}
        for k in range(len(self.schedule)):
            info[k] = {}
        f = open(self.nlp_file, "r")
        lines_ = f.readlines()
        f.close()
        for line in lines_:
            if "#comment:" in line and "Array" in line and "for tc in dim" in line:
                l = line.split(" ")
                arr = l[2]
                dim = int(l[8])
                loop = l[9].replace("TC", "")
                id_schedule = -1
                for id_sched in range(len(self.schedule)):
                    loops = list(map(int, self.schedule[id_sched][1::2]))
                    if int(loop) in loops:
                        id_schedule = id_sched
                        break
                if arr not in list(info[id_schedule].keys()):
                    info[id_schedule][arr] = {}
                info[id_schedule][arr][dim] = loop
        #now we try to reduce the level of reuse
        for id_ft in list(self.fuse_task.keys()):
            inf = {}
            already_done = []
            for id_stat in self.fuse_task[id_ft]:
                for arr in list(info[id_stat].keys()):
                    # if arr not in already_done:
                    #     already_done.append(arr)
                    loops = self.schedule[id_stat][1::2]
                    level_reuse = -1
                    level_transfer = -1
                    max_level = -1
                    for key in list(lev_res.keys()):
                        if f"level_transfer_{arr}_FT{id_ft}" in key:
                            max_level = max(max_level, int(key.split("_")[-1].replace("under", "")))
                        if f"level_transfer_{arr}_FT{id_ft}" in key and lev_res[key]:
                            level_transfer = int(key.split("_")[-1].replace("under", ""))
                        if f"level_reuse_{arr}_FT{id_ft}" in key and lev_res[key]:
                            level_reuse = int(key.split("_")[-1].replace("under", ""))

                    
                    if level_reuse == level_transfer:
                        # nothing to do
                        pass
                    else:
                        # if loop iterate the array we put level at lower level
                        for id_level in range(level_reuse, level_transfer+1):
                            cur_loop = str(loops[id_level])
                            if cur_loop in list(info[id_stat][arr].values()):
                                level_reuse += 1
                            else:
                                break
                        for id_level in range(max_level+1):
                            for key in list(lev_res.keys()):
                                if f"level_reuse_{arr}_FT{id_ft}_under{id_level}" in key:
                                    lev_res[key] = False
                        lev_res[f"level_reuse_{arr}_FT{id_ft}_under{level_reuse}"] = True
                        for id_level in range(max_level+1):
                            for key in list(lev_res.keys()):
                                if f"level_reuse_{arr}_FT{id_ft}_under{id_level}" in key:
                                    if lev_res[key]:
                                        for dd, line in enumerate(lines):
                                            if f"level_reuse_{arr}_FT{id_ft}_under{id_level}" in line:
                                                lines[dd] = f"level_reuse_{arr}_FT{id_ft}_under{id_level} = 1\n"
                                    else:
                                        for dd, line in enumerate(lines):
                                            if f"level_reuse_{arr}_FT{id_ft}_under{id_level}" in line:
                                                lines[dd] = f"level_reuse_{arr}_FT{id_ft}_under{id_level} = 0\n"

        return lines

    def compute_info_log(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()

        lines = self.update_log_file(lines.copy())


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

    def compute_perm(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "perm" in line:
                p, b = line.replace("\n", "").split("=")
                p = p.replace(" ", "")
                b = b.replace(" ", "")
                if b == "1":
                    self.perm[p] = True
                else:
                    self.perm[p] = False

    def compute_order_read_per_array(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()

        for line in lines:
            if "#comment:" in line and "Schedule" in line and "permutation" in line:
                id_sched = int(line.split("Schedule ")[1].split(" for")[0])
                array = line.split("Array ")[1].split(" with")[0]
                perm = line.split("permutation ")[1].split(" have")[0]
                order = line.split("order ")[-1].split(" with")[0].replace("\n", "").replace(" ", "").replace("(", "").replace(")", "").replace("[", "").replace("]", "").split(",")
                TC = line.split("TC ")[-1].replace("\n", "").replace("'", "").replace(" ", "").replace("(", "").replace(")", "").replace("[", "").replace("]", "").split(",")

                for d, tc in enumerate(TC):
                    id_loop, id_dim = tc.replace("TC", "").split("_")
                    id_loop = int(id_loop)
                    id_dim = int(id_dim)
                    TC[d] = self.TC[id_loop][id_dim]

                if self.perm[perm]:
                    if array not in list(self.order_read_per_array.keys()):
                        self.order_read_per_array[array] = {}
                        self.order_read_per_array[array][tuple(order)] = {"sched": [], "TC": []}
                        self.order_read_per_array[array][tuple(order)]["sched"] = [id_sched]
                        self.order_read_per_array[array][tuple(order)]["TC"] = [TC]
                    elif tuple(order) not in list(self.order_read_per_array[array].keys()):
                        self.order_read_per_array[array][tuple(order)] = {"sched": [], "TC": []}
                        self.order_read_per_array[array][tuple(order)]["sched"] = [id_sched]
                        self.order_read_per_array[array][tuple(order)]["TC"] = [TC]
                    else:
                        self.order_read_per_array[array][tuple(order)]["sched"] += [id_sched]
                        self.order_read_per_array[array][tuple(order)]["TC"] += [TC]

        


    def compute_flow(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()

        for line in lines:
            if "#comment:" in line and "Task" in line:
                if "read" in line:
                    id_task = int(line.split("Task ")[1].split(" reads")[0])
                    array = line.split("reads ")[1].split(" from")[0]
                    if id_task not in list(self.flow_read_array.keys()):
                        self.flow_read_array[id_task] = []
                    self.flow_read_array[id_task] += [(array, "off-chip")]
                elif "received" in line:
                    id_task1 = int(line.split("Task ")[1].split(" received")[0])
                    id_task2 = int(line.split("Task ")[2].replace("\n", "").replace(" ", ""))
                    array = line.split("received ")[1].split(" from")[0]
                    if id_task1 not in list(self.flow_read_array.keys()):
                        self.flow_read_array[id_task1] = []
                    if (array, id_task2) not in self.flow_read_array[id_task1]:
                        self.flow_read_array[id_task1] += [(array, id_task2)]
                elif "gives" in line:
                    id_task1 = int(line.split("Task ")[1].split(" gives")[0])
                    id_task2 = int(line.split("Task ")[2].replace("\n", "").replace(" ", ""))
                    array = line.split("gives ")[1].split(" to")[0]
                    if id_task1 not in list(self.flow_write_array.keys()):
                        self.flow_write_array[id_task1] = []
                    if (array, id_task2) not in self.flow_write_array[id_task1]:
                        self.flow_write_array[id_task1] += [(array, id_task2)]
                elif "writes" in line:
                    id_task = int(line.split("Task ")[1].split(" writes")[0])
                    array = line.split("writes ")[1].split(" to")[0]
                    if id_task not in list(self.flow_write_array.keys()):
                        self.flow_write_array[id_task] = []
                    self.flow_write_array[id_task] += [(array, "off-chip")]

    def compute_reuse_buffer(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for k in range(len(self.schedule)):
            self.reuse_buffer[k] = []
        for line in lines:
            if "#comment:" in line and "reuse buffer" in line:
                id_sched = int(line.split("Sched ")[1].split(" has")[0])
                buf = line.split("reuse buffer ")[1].replace("\n", "").replace(" ", "")
                for loop in list(self.TC.keys()):
                    for dim in list(self.TC[loop].keys()):
                        buf = buf.replace(f"TC{loop}_{dim}", str(self.TC[loop][dim]))
                self.reuse_buffer[id_sched] += [buf]

    def compute_arguments(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "#comment:" in line and "Argument" in line:
                self.arguments += [line.split(": ")[2].replace("\n", "")]

    def update_size(self, size, burst):
        if size[-1] % burst != 0:
            size[-1] = size[-1] + burst - size[-1] % burst
        return size

    def compute_statements(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "#comment:" in line and "Statement" in line:
                self.statements.append(line.split(": ")[2].replace("\n", ""))

    def compute_iterators(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:

            if "#comment:" in line and "Loop_" in line:
                self.iterators.append(line.split(":")[2].replace("\n", "").replace(" ", ""))


    def compute_TC(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()
        
        for line in lines:
            if "TC" in line and "_" in line and "cte" not in line:
                id_loop = int(line.split("_")[0].replace("TC", ""))
                if id_loop not in list(self.TC.keys()):
                    self.TC[id_loop] = {0: 0, 1: 0}
                depth = int(line.split("_")[1].split("=")[0].replace(" ", ""))
                value = int(line.split("=")[1].replace(" ", "").replace("\n", ""))
                self.TC[id_loop][depth] = value
    
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

    def compute_schedule(self):
        f = open(self.nlp_file, "r")
        lines_nlp = f.readlines()
        f.close()

        f = open(self.log_file, "r")
        lines_log = f.readlines()
        f.close()

        N = 0

        dic_perm = {}
        dic_schedule = {}
        schedule = []
        for line in lines_log:
            if "perm" in line:
                p, b = line.replace("\n", "").split("=")
                p = p.replace(" ", "")
                b = b.replace(" ", "")
                if b == "1":
                    dic_perm[p] = True
                else:
                    dic_perm[p] = False
        for line in lines_nlp:
            if "var" in line and "perm" in line:

                p = line.split("var")[1].split("binary")[0].replace(" ", "")
                id_statement = int(p.split("_")[1].replace("S", ""))
                if dic_perm[p]:
                    tuple_perm = line.split("#")[-1].replace("\n", "").replace(" ", "").replace("[", "").replace("]", "").split(",")
                    dic_schedule[id_statement] = tuple_perm
                    N = max(N, id_statement)
        for k in range(N+1):
            schedule.append(dic_schedule[k])

        return schedule



    def create_tab(self, nb):
        return self.tab * nb

    def compute_arrays_information(self):
        all_arrays = []
        for stat in self.statements:
            if "=" in stat:
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
                all_arrays += [out] 
                for inpp in inp:
                    if "[" not in inpp and "]" not in inpp:
                        all_arrays += [inpp]
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
        for arr in all_arrays:
            for arg in self.arguments:
                if arr in arg:
                    self.array_information[arr]["type"] = arg.split(" ")[0].strip()
                    self.array_information[arr]["size"] = self.extract_size_array(arg)
                    self.array_information[arr]["dim"] = arg.count("[")
                    self.array_information[arr]["part_per_dim"] = [1 for k in range(self.array_information[arr]["dim"])]
                    break
        for arr in all_arrays:
            for stat in self.array_information[arr]["statements"]:
                it_per_dim = []
                ss = self.multi_split_2(self.statements[stat].replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])
                ss = list(set(ss))
                for s in ss:
                    tmp = ["" for k in range(self.array_information[arr]["dim"])]
                    if f"{arr}[" in s:
                        index = s.index(f"[")
                        s = s[index:]
                        s = s.replace("][", "*")
                        s = s.replace("[", "")
                        s = s.replace("]", "")
                        tmp = s.split("*")
                        it_per_dim.append(tmp)
                loop_to_it = {}
                for i in range(1, len(self.schedule[stat]), 2):
                    loop = int(self.schedule[stat][i])
                    it = self.iterators[loop]
                    loop_to_it[loop] = it
                it_to_loop = {v: k for k, v in loop_to_it.items()}
                for i, it in enumerate(it_per_dim):
                    for j, it_ in enumerate(it):
                        it_per_dim[i][j] = []
                        if "+" in it_ or "-" in it_ or "*" in it_ or "/" in it_:
                            it_ = it_.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                        else:
                            it_ = [it_]
                        
                        for it__ in it_:
                            it__ = it__.replace("(", "").replace(")", "")
                            it_per_dim[i][j] += [it_to_loop[it__]]

                
                for pos in range(len(it_per_dim)):
                    for dim in range(len(it_per_dim[pos])):
                        for loop in it_per_dim[pos][dim]:
                            self.array_information[arr]["loop_to_dim"][loop] = dim
                for pos in range(len(it_per_dim)):
                    for dim in range(len(it_per_dim[pos])):
                        loop = it_per_dim[pos][dim]
                        # pragma_loop = self.pragmas[loop]
                        # if pragma_loop != [""]:
                        #     pragma_loop = pragma_loop.split(";")
                        #     for p in pragma_loop:
                        #         if "unroll" in p.lower():
                        #             factor = p.split("=")[-1].strip().replace(" ", "")
                        #             self.array_information[arr]["part_per_dim"][dim] = max(self.array_information[arr]["part_per_dim"][dim], int(factor))

    def find_size_last_dim(self, val, burst):
        if val % burst != 0:
            return val + burst - val % burst
        return val

    def extract_size_array(self, arg):
        if "[" in arg:
            index = arg.index("[")
            arg = arg[index:]
            arg = arg.replace("][", "*")
            arg = arg.replace("[", "")
            arg = arg.replace("]", "")
            return eval(arg)
        return 1

    def change_type_arguments_to_vector(self):
        old_arguments = self.arguments
        self.arguments = []

        info = {}
        ori = {}
        shift_last_dim = {}

        bits = 32

        for i, arg in enumerate(old_arguments):
            if "float" in arg:
                bits = 32
                self.type = "float"
            elif "int" in arg:
                bits = 32
                self.type = "int"
            elif "double" in arg:
                bits = 32
                self.type = "double"
            else:
                self.arguments = old_arguments
                continue
            if "[" not in arg: # not an array
                self.arguments += [old_arguments[i]]
                continue
            
            


            name_array = arg.split(" ")[-1].split("[")[0]
            info[name_array] = {}
            ori[name_array] = {}

            if name_array not in list(self.burst.keys()):
                continue

            size_burst = self.burst[name_array]

            # check new size with padding
            f = open(self.nlp_file, "r")
            lines = f.readlines()
            f.close()
            for line in lines:
                if "#comment:" in line and "Array" in line and f" {name_array} " in line and "tc" in line:
                    size = line.split(" (")[0].split("dim ")[1]
                    dim, size = size.split(" ")
                    ori_size = line.split("(")[-1].split(")")[0].split("=")[-1]
                    if dim not in list(info[name_array].keys()):
                        info[name_array][dim] = {}
                    if dim not in list(ori[name_array].keys()):
                        ori[name_array][dim] = []
                    # info[name_array][dim] += [int(self.info_log[size])]
                    # ori[name_array][dim] += [int(self.info_log[ori_size])]
            nb_dim = len(list(info[name_array].keys()))
            # size_array = 1
            # for i in range(nb_dim-1):
            #     size_array *= max(ori[name_array][str(i)])
            # size_array *= max(info[name_array][str(nb_dim-1)])

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
            size_array = 1
            for i in range(nb_dim-1):
                ttt = []
                for j in range(len(info[name_array][str(i)])):
                    ttt.append(max(info[name_array][str(i)][j]))
                if len(ttt) == 1:
                    size_array *= (ttt[0])
                else:
                    size_array *= (sum(ttt)-1)
            i = nb_dim-1
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

                    
                    size_array *= self.find_size_last_dim(vv, self.burst[name_array])
                    self.what_array_has_shit.append(name_array)
                else:
                    ttt = []
                    for j in range(len(info[name_array][str(i)])):
                        ttt.append(max(info[name_array][str(i)][j]))
                    if len(ttt) == 1:
                        vv = ttt[0] 
                    else:
                        self.what_array_has_shit.append(name_array)
                        vv = sum(ttt)-1 
                    size_array *= self.find_size_last_dim(vv, self.burst[name_array])
            else:
                ttt = []
                for j in range(len(info[name_array][str(i)])):
                    ttt.append(max(info[name_array][str(i)][j]))
                if len(ttt) == 1:
                    vv = ttt[0] 
                else:
                    vv = sum(ttt)-1 
                size_array *= self.find_size_last_dim(vv, self.burst[name_array])

            self.size_arrays[name_array] = size_array
            size_vector = size_array // size_burst

            self.arguments += [f"float{size_burst} v{name_array}[{size_vector}]"]




    def extract_iterators(self, out):
        iterators = []
        if "[" in out:
            it = out[out.index("[")+1:]
            iterators = it.replace("][", "@").replace("]", "").split("@")

        return iterators

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

    def multi_split_2(self, str_, delimiters, delete_array=False):
        #we need to replace element of delimiters inside brackets by a special character
        inside_brackets = False
        dico = {}
        rev_dico = {}
        for k, deli in enumerate(delimiters):
            dico[deli] = f"#{k}#"
            rev_dico[f"#{k}#"] = deli
        new_str = ""
        for k, elmt in enumerate(str_):
            if elmt == "[":
                inside_brackets = True
            if elmt == "]":
                inside_brackets = False
            if inside_brackets and elmt in delimiters:
                new_str +=  dico[elmt]
            else:
                new_str += elmt
        
        str_ = new_str

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
        for k, r in enumerate(res):
            for key in list(rev_dico.keys()):
                res[k] = res[k].replace(key, rev_dico[key])

        return res

    def load(self, arg):

        # str_ = f"memcpy(v{arg}, {arg}, {self.size_arrays[arg]}*sizeof({self.type}));\n"
        str_ = ""
        return str_

    def write(self, arg):
        # str_ = f"memcpy({arg}, v{arg}, {self.size_arrays[arg]}*sizeof({self.type}));\n"
        str_ = ""
        return str_

    def array_partition(self, arg):
        name_array = arg.split(" ")[-1].split("[")[0]
        str_ = ""
        # str_ += "\n"
        for i in range(self.array_information[name_array]["dim"]):
            if self.array_information[name_array]["part_per_dim"][i] != 1:
                str_ += f"#pragma HLS ARRAY_PARTITION variable={name_array} cyclic factor={self.array_information[name_array]['part_per_dim'][i]} dim={i+1}\n"

        # str_ += "\n"
        return str_

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

    def get_name_fifo(self, arg, name_array, tasks):
        fifo = ""
        for elemt in arg:
            if f"fifo_{name_array}_from" in elemt:
                is_to_read = True

                for task in tasks:
                    if f"fifo_{name_array}_from_task{task}" in elemt:
                        is_to_read = False
                        break
                if is_to_read:
                    fifo = elemt.split(" ")[-1]
                    break
        return fifo
    
    def get_declatation_fifo(self, arg, name_array, tasks):
        fifo = ""
        for elemt in arg:
            if f"fifo_{name_array}_from" in elemt:
                is_to_read = True

                for task in tasks:
                    if f"fifo_{name_array}_from_task{task}" in elemt:
                        is_to_read = False
                        break
                if is_to_read:
                    fifo = elemt
                    break
        
        return fifo

    def get_name_fifo_write(self, arg, name_array, tasks):
        fifos = []
        for elemt in arg:
            if f"fifo_{name_array}_to" in elemt:
                str_ = elemt.split(" ")[-1]
                if str_ not in fifos:
                    fifos.append(str_)
            else:
                for task in tasks:
                    if f"fifo_{name_array}_from_task{task}" in elemt:
                        str_ = elemt.split(" ")[-1]
                        if str_ not in fifos:
                            fifos.append(str_)
                    
        return fifos

    def get_declaration_fifo_write(self, arg, name_array, tasks):
        fifos = []
        for elemt in arg:
            if f"fifo_{name_array}_to" in elemt:
                str_ = elemt
                if str_ not in fifos:
                    fifos.append(str_)
            else:
                for task in tasks:
                    if f"fifo_{name_array}_from_task{task}" in elemt:
                        str_ = elemt
                        if str_ not in fifos:
                            fifos.append(str_)
                    
        return fifos

    def add_definition_array_on_chip(self, dic, name, size_, id_fuse_task):
        if id_fuse_task not in list(dic.keys()):
            dic[id_fuse_task] = {}
        dic[id_fuse_task][f"{name}"] = size_
        return dic

    def get_task(self, code, id_):
        begin = 0
        end = 0
        nb = 0
        for i, line in enumerate(code.split("\n")):
            if f"task{id_}_intra" in line and "void" in line:
                begin = i
            if begin > 0 and "{" in line:
                nb += 1
            if begin > 0 and "}" in line:
                nb -= 1
                if nb == 0:
                    end = i
                    break
        return code.split("\n")[begin:end+1], begin, end



    def generate_code(self):
        # code = f"Schedule: {self.schedule}, UB: {self.UB}, LB: {self.LB}, Statements: {self.statements}, Iterators: {self.iterators}"
        code = ""
        h_definition = []
        h_name_for_cfile = self.output.split(".")[0].split("/")[-1] + ".h"
        h_name = self.output.split(".")[0] + ".h"

        definition_array_on_chip = {}

        for header in self.headers:
            h_definition += [f"#include <{header}>"]
        h_definition += ["\n"]
        code += f"#include \"{h_name_for_cfile}\"\n"

        code += "\n"
        code += "#define READ_RANGE(Arr, data_size, l) (Arr.data.range((data_size)*(l) + (data_size)-1, (data_size)*(l)))\n"
        code += "\n"
        
        for typedef in self.typedef:
            h_definition += [f"typedef {typedef};"]
        h_definition += ["\n"]
        

        code += self.warnings
        old_arguments = self.arguments.copy()

        self.change_type_arguments_to_vector()

        definition_fifo = ""

        arg_per_task = {}
        definition_per_task = {}
        arg_per_FT = {}
        definition_per_FT = {}

        for key in list(self.fuse_task):
            arg_per_FT[key] = []
            definition_per_FT[key] = []
            for arg in self.arguments:
                if "]" not in arg:
                    arg_per_FT[key].append(arg.split(" ")[-1])
                    definition_per_FT[key].append(arg)


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
        array_read_from_different_bank = []
        # FIXME
        for key in list(info_arr.keys()):
            nb_read = 0
            nb_write = 0
            for elemt in info_arr[key]:
                if elemt[0] == "r":
                    nb_read += 1
                else:
                    nb_write += 1
            if nb_read > 1 and nb_write == 0:
                array_read_from_different_bank.append(key)


        fct_load = []
        fct_write = []
        for task in list(self.flow_read_array.keys()):
            arg_per_task[task] = []
            definition_per_task[task] = []

        for task in list(self.flow_read_array.keys()):
            for element in self.flow_read_array[task]:
                array, source = element
                if source == "off-chip":
                    name_fifo = f"fifo_{array}_from_off_chip_to_S{task}"
                    burst = self.burst[array]

                    defi = f"hls::stream<{self.type}{burst}> {name_fifo}"
                    definition_fifo += f"    {defi};\n"
                    # FIXME depth
                    definition_fifo += f"    #pragma HLS stream variable={name_fifo} depth=512\n"
                    arg_per_task[task].append(f"{name_fifo}")
                    definition_per_task[task].append(f"{defi}")
                    arg_per_FT[self.task_to_FT[task]].append(f"{name_fifo}")
                    definition_per_FT[self.task_to_FT[task]].append(f"{defi.replace('>', '>&')}")
                    original_def = ""
                    original_name = ""
                    for arg in self.arguments:
                        if array in arg:
                            original_def = arg
                            original_name = arg.split(" ")[-1].split("[")[0] + "_for_task" + str(task)
                            break
                    fct_load += [(array, defi, name_fifo, original_def, original_name)]
                else:
                    task2 = int(source)
                    name_fifo = f"fifo_{array}_from_task{task2}_to_task{task}"
                    burst = self.burst[array]
                    defi = f"hls::stream<{self.type}{burst}> {name_fifo}"
                    definition_fifo += f"    {defi};\n"
                    # FIXME depth
                    definition_fifo += f"    #pragma HLS stream variable={name_fifo} depth=512\n"
                    arg_per_task[task].append(f"{name_fifo}")
                    arg_per_FT[self.task_to_FT[task]].append(f"{name_fifo}")
                    if task2 in list(arg_per_task.keys()):
                        arg_per_task[task2].append(f"{name_fifo}")
                        arg_per_FT[self.task_to_FT[task2]].append(f"{name_fifo}")
                    definition_per_task[task].append(f"{defi}")
                    definition_per_FT[self.task_to_FT[task]].append(f"{defi.replace('>', '>&')}")
                    if task2 in list(definition_per_task.keys()):
                        definition_per_task[task2].append(f"{defi}")
                        definition_per_FT[self.task_to_FT[task2]].append(f"{defi.replace('>', '>&')}")
        for task in list(self.flow_write_array.keys()):
            for element in self.flow_write_array[task]:


                array, source = element
                if source == "off-chip":
                    name_fifo = f"fifo_{array}_to_off_chip"
                    burst = self.burst[array]
                    defi = f"hls::stream<{self.type}{burst}> {name_fifo}"
                    definition_fifo += f"    {defi};\n"
                    # FIXME depth
                    definition_fifo += f"    #pragma HLS stream variable={name_fifo} depth=512\n"
                    if task not in list(arg_per_task.keys()):
                        arg_per_task[task] = []
                    arg_per_task[task].append(f"{name_fifo}")
                    arg_per_FT[self.task_to_FT[task]].append(f"{name_fifo}")
                    if task not in list(definition_per_task.keys()):
                        definition_per_task[task] = []
                    definition_per_task[task].append(f"{defi}")
                    definition_per_FT[self.task_to_FT[task]].append(f"{defi.replace('>', '>&')}")
                    original_def = ""
                    original_name = ""
                    for arg in self.arguments:
                        if array in arg:
                            original_def = arg
                            nname = arg.split(" ")[-1].split("[")[0].replace("v", "")
                            original_name = f"v{nname}_for_task{first_read[nname]}"
                            break
                    task_id = self.task_to_FT[task]
                    # for arg in self.arguments:
                    #     if array in arg:
                    #         original_def = arg
                    #         original_name = arg.split(" ")[-1].split("[")[0]
                    #         break
                    str_ = (array, defi, name_fifo, original_def, original_name, task_id)
                    if str_ not in fct_write:
                        fct_write += [str_]
                else:
                    pass
                    # already done in read


                    # name_fifo = f"fifo_{array}_to_off_chip"
                    # burst = self.burst[array]
                    # defi = f"hls::stream<{self.type}{burst}> {name_fifo}"
                    # definition_fifo += f"    {defi};\n"
                    # # FIXME depth
                    # definition_fifo += f"    #pragma HLS stream variable={name_fifo} depth=512\n"
                    # arg_per_task[task].append(f"{name_fifo}")
                    # arg_per_FT[self.task_to_FT[task]].append(f"{name_fifo}")
                    # definition_per_task[task].append(f"{defi}")
                    # definition_per_FT[self.task_to_FT[task]].append(f"{defi.replace('>', '>&')}")
                    # original_def = ""
                    # original_name = ""
                    # task_id = self.task_to_FT[task]
                    # for arg in self.arguments:
                    #     if array in arg:
                    #         original_def = arg
                    #         original_name = arg.split(" ")[-1].split("[")[0]
                    #         break
                    # str_ = (array, defi, name_fifo, original_def, original_name, task_id)
                    # if str_ not in fct_write:
                    #     fct_write += [str_]
        # exit(0)
        ######
        # Compute array size and array size transfer
        ######
        info_transfer = {}
        info_reuse = {}

        size_reuse = {}
        size_transfer = {}
        it_per_transfer = {}

        # init
        for id_fuse_task in range(self.nb_fuse_task):
            info_transfer[id_fuse_task] = {}
            info_reuse[id_fuse_task] = {}
            size_reuse[id_fuse_task] = {}
            size_transfer[id_fuse_task] = {}
            it_per_transfer[id_fuse_task] = {}
            tasks = self.fuse_task[id_fuse_task]
            out_arr = self.statements[tasks[0]].split("=")[0].split("[")[0]
            dim_output = self.array_information[out_arr]["dim"]
            for k in range(dim_output+1):
                info_transfer[id_fuse_task][k] = []
                info_reuse[id_fuse_task][k] = []

        

        for id_fuse_task in range(self.nb_fuse_task):
            all_loops = []

            tasks = self.fuse_task[id_fuse_task]

            for task in tasks:
                all_loops += self.schedule[task][1::2]

            out_arr = self.statements[tasks[0]].split("=")[0].split("[")[0]
            dim_output = self.array_information[out_arr]["dim"]
            for dd in range(dim_output, -1, -1):
                for key in list(self.info_log.keys()):
                    if "level_transfer" in key and f"FT{id_fuse_task}" in key and f"under{dd}" in key:
                        res = str(self.info_log[key]).split("=")[-1].replace(" ", "").replace("\n", "")
                        if res == "1":
                            name_array = key.split("_")[2]

                            f = open(self.nlp_file, "r")
                            lines = f.readlines()
                            f.close()
                            size_arr = {}
                            size_level = {}
                            ori_size = {}
                            loops_before_level = []

                            for task in tasks:
                                for loop in self.schedule[task][1::2][:dd]:
                                    loops_before_level.append(int(loop))

                            for line in lines:
                                if "#comment:" in line and "Array" in line and f" {name_array} " in line:
                                    size = line.split(" (")[0].split("dim ")[1]
                                    dim, size = size.split(" ")
                                    ori_size_ = line.split("(")[-1].split(")")[0].split("=")[-1]
                                    if int(size.replace("TC", "")) in all_loops:
                                        ori_size[dim] = int(self.info_log[ori_size_])
                                        if dim not in list(size_arr.keys()):
                                            size_arr[dim] = {}
                                        size_arr[dim]["all"] = int(self.info_log[size])
                                        size_arr[dim]["0"] = int(self.info_log[f"{size}_0"])
                                        size_arr[dim]["1"] = int(self.info_log[f"{size}_1"])
                                        if int(size.replace("TC", "")) in loops_before_level:
                                            size_level[dim] = int(self.info_log[size])//int(self.info_log[f"{size}_0"])
                                        else:
                                            size_level[dim] = int(self.info_log[size])


                            res = (name_array, size_level, size_arr, ori_size)
                            info_transfer[id_fuse_task][dd] += [res]

        for id_fuse_task in range(self.nb_fuse_task):
            all_loops = []

            tasks = self.fuse_task[id_fuse_task]

            for task in tasks:
                all_loops += self.schedule[task][1::2]

            out_arr = self.statements[tasks[0]].split("=")[0].split("[")[0]
            dim_output = self.array_information[out_arr]["dim"]
            for dd in range(dim_output, -1, -1):
                for key in list(self.info_log.keys()):
                    if "level_reuse" in key and f"FT{id_fuse_task}" in key and f"under{dd}" in key:
                        res = str(self.info_log[key]).split("=")[-1].replace(" ", "").replace("\n", "")
                        if res == "1":
                            name_array = key.split("_")[2]

                            f = open(self.nlp_file, "r")
                            lines = f.readlines()
                            f.close()
                            size_arr = {}
                            size_level = {}
                            ori_size = {}
                            loops_before_level = []

                            for task in tasks:
                                for loop in self.schedule[task][1::2][:dd]:
                                    loops_before_level.append(int(loop))

                            size_level_ = {}
                            for line in lines:
                                if "#comment:" in line and "Array" in line and f" {name_array} " in line:
                                    size = line.split(" (")[0].split("dim ")[1]
                                    dim, size = size.split(" ")
                                    ori_size_ = line.split("(")[-1].split(")")[0].split("=")[-1]
                                    id_arg = int(line.split(")")[-1].replace(" ", "").replace("arg", "").replace("\n", ""))
                                    if int(size.replace("TC", "")) in all_loops:
                                        ori_size[dim] = int(self.info_log[ori_size_])
                                        if dim not in list(size_arr.keys()):
                                            size_arr[dim] = {}
                                        if dim not in list(size_level_.keys()):
                                            size_level_[dim] = {}
                                        size_arr[dim]["all"] = int(self.info_log[size])
                                        size_arr[dim]["0"] = int(self.info_log[f"{size}_0"])
                                        size_arr[dim]["1"] = int(self.info_log[f"{size}_1"])
                                        # NTM TODO
                                        if int(size.replace("TC", "")) in loops_before_level:
                                            size_level_[dim][id_arg] = int(self.info_log[size])//int(self.info_log[f"{size}_0"])
                                        else:
                                            size_level_[dim][id_arg] = int(self.info_log[size])
                            for dim in list(size_level_.keys()):
                                res = 0
                                if len(list(size_level_[dim].keys())) == 1:
                                    res = size_level_[dim][0]
                                else:
                                    tt = []
                                    for key in list(size_level_[dim].keys()):
                                        tt.append(size_level_[dim][key])
                                    res = sum(tt)-1
                                size_level[dim] = res
                            dims = list(size_level_.keys())

                            res = (name_array, size_level, size_arr, ori_size)
                            info_reuse[id_fuse_task][dd] += [res]


        for array, defi, name_fifo, original_def, original_name in fct_load:

            if array in list(self.order_read_per_array.keys()) and len(self.order_read_per_array[array]) > 1:
                # we need to create a function for each order
                # FIXME
                pass
            else:
                # if array not in list(self.order_read_per_array.keys()):
                    # implies one dimension
                dim = self.array_information[array]["dim"]

                if "&" not in defi:
                    defi = defi.replace(">", ">&")

                code += f"void load_{original_name}({defi}, {original_def}){{\n"
                h_definition += [f"void load_{original_name}({defi}, {original_def});"]
                code += f"#pragma HLS inline off\n"
                shift = "    "
                id_task = int(original_name.split("for_task")[-1])
                id_ft = self.task_to_FT[id_task]
                name_array = original_name.split("_")[0].replace("v", "")

                size_ = 1
                for k in range(len(self.info_padding[id_ft][name_array])-1):
                    size_ *= self.info_padding[id_ft][name_array][k]
                size_ *= int(np.ceil(self.info_padding[id_ft][name_array][-1]/self.burst[name_array]))
                loops_of_stat = self.schedule[id_task][1::2]
                nb_dim = len(self.info_padding[id_ft][name_array])
                loop_last_dim = -1
                info_arr2 = self.array_information[name_array]['loop_to_dim']

                for ll in loops_of_stat:
                    if int(ll) in list(info_arr2.keys()):
                        if info_arr2[int(ll)] == nb_dim-1:
                            if f"cte_burst_without_tiling_TC{ll}_for_{name_array}" in list(self.info_log.keys()):
                                loop_last_dim = int(ll)
                                break


                if int(self.info_log[f"cte_burst_without_tiling_TC{loop_last_dim}_for_{name_array}"]) > 1:
                    if int(self.info_log[f"{name_array}_is_fully_transfered_on_last_dim_FT{id_ft}"]) == 1:
                        size_2 = 1
                        for k in range(len(self.info_padding[id_ft][name_array])-1):
                            size_2 *= self.info_padding[id_ft][name_array][k]
                        size_2 *= (int(self.info_log[f"TC{loop_last_dim}"]) + int(self.info_log[f"cte_burst_without_tiling_TC{loop_last_dim}_for_{name_array}"]))
                        size_2 /= self.burst[name_array]
                        if size_2 > size_:
                            size_ = int(size_2)

                # size_ = self.size_arrays[array] // self.burst[array]
                code += f"{shift}for (int i = 0; i < {size_}; i++){{\n"
                code += f"{shift}#pragma HLS pipeline II=1\n"
                
                name_array = original_def.split(" ")[-1].split("[")[0]
                code += f"        {name_fifo}.write({name_array}[i]);\n"
                code += f"{shift}}}\n"
                code += f"}}\n\n"

                # code += f"void read_{original_name}({defi}, {original_def}){{\n"
                # h_definition += [f"void read_{original_name}({defi}, {original_def});"]
                # code += f"#pragma HLS inline off\n"
                # shift = "    "
                # code += f"{shift}for (int i = 0; i < {self.size_arrays[array] // self.burst[array]}; i++){{\n"
                # code += f"{shift}#pragma HLS pipeline II=1\n"
                
                # name_array = original_def.split(" ")[-1].split("[")[0]
                # code += f"        {name_fifo}.write({name_array}[i]);\n"
                # code += f"{shift}}}\n"
                # code += f"}}\n\n"

        
        for array, defi, name_fifo, original_def, original_name, _ in fct_write:
            if "off_chip" not in name_fifo:
                continue
            dim = self.array_information[array]["dim"]
            if "&" not in defi:
                defi = defi.replace(">", ">&")
            code += f"void store_{original_name}({defi}, {original_def}){{\n"
            h_definition += [f"void store_{original_name}({defi}, {original_def});"]
            code += f"#pragma HLS inline off\n"
            shift = "    "
            # here if we have differend padding we need to check for each FT
            name_arr = original_def.split(" ")[-1].split("[")[0].replace("v", "")
            id_task = original_name.split("for_task")[-1]
            id_ft = self.task_to_FT[int(id_task)]
            tc_arr = list(map(int, self.info_padding[id_ft][name_arr]))
            size_arr = np.prod(tc_arr)
            code += f"{shift}for (int i = 0; i < {min(self.size_arrays[array],size_arr) // self.burst[array]}; i++){{\n"
            code += f"{shift}#pragma HLS pipeline II=1\n"
            
            name_array = original_def.split(" ")[-1].split("[")[0]
            code += f"        {name_array}[i] = {name_fifo}.read();\n"
            code += f"{shift}}}\n"
            code += f"}}\n\n"
        arg_per_intra = {}
        definition_per_intra = {}
        # computa intra tile

        
        for k, task in enumerate(self.ast.order_per_task):
            out_arr = self.statements[k].split("=")[0].split("[")[0]
            dim_output = self.array_information[out_arr]["dim"]

            arg_per_intra[k] = {}
            definition_per_intra[k] = {}
            

            for d in range(dim_output+1):
                arg_per_intra[k][d] = []
                definition_per_intra[k][d] = []

            for d in range(dim_output+1):
                if k in list(arg_per_FT.keys()):
                    for j in range(len(arg_per_FT[k])):
                        if d == dim_output:
                            if "stream" not in definition_per_FT[k][j]:
                                arg_per_intra[k][d] += [arg_per_FT[k][j]]
                                definition_per_intra[k][d] += [definition_per_FT[k][j]]
                        else:
                            arg_per_intra[k][d] += [arg_per_FT[k][j]]
                            definition_per_intra[k][d] += [definition_per_FT[k][j]]
            lll = self.schedule[k][1::2]
            # for i, loop in enumerate(lll[:dim_output]):
            #     # code += f"    int {self.iterators[loop]};\n"
            #     if f"int {self.iterators[loop]}0" not in arg_per_intra[k][dim_output]:
            #         arg_per_intra[k][dim_output] += [f"int {self.iterators[loop]}0"]
            
        
        read_write_arg = {}
        read_write_def = {}
        definition_array = {}
        # per level
        for id_fuse_task in range(self.nb_fuse_task):
            definition_array[id_fuse_task] = {}
            iterator_per_level = []
            tasks = self.fuse_task[id_fuse_task]
            out_arr = self.statements[tasks[0]].split("=")[0].split("[")[0]
            dim_output = self.array_information[out_arr]["dim"]

            full_array = []

            for dd in range(dim_output):
                # arg = []
                read_inside_loop = []
                read_outside_loop = []
                write_inside_loop = []
                write_outside_loop = []
                
                decl = definition_per_intra[id_fuse_task][dd]
                arg = arg_per_intra[id_fuse_task][dd]

                code += f"void FT{id_fuse_task}_level{dd}({', '.join(decl)}){{\n"
                h_definition += [f"void FT{id_fuse_task}_level{dd}({', '.join(decl)});"]
                code += f"#pragma HLS inline off\n"
                
                for key in list(self.info_log.keys()):
                    if "level_transfer" in key and f"FT{id_fuse_task}" in key and f"under{dd+1}" in key:
                        res = str(self.info_log[key]).split("=")[-1].replace(" ", "").replace("\n", "")
                        if res == "1":
                            name_array = key.split("_")[2]
                            read_inside_loop += [name_array]
                            is_array_write = False
                            for task in tasks:
                                if name_array in self.statements[task].split("=")[0]:
                                    is_array_write = True
                                    break
                            if is_array_write:
                                write_inside_loop += [name_array]

                if dd == 0:
                    for key in list(self.info_log.keys()):
                        if "level_transfer" in key and f"FT{id_fuse_task}" in key and f"under0" in key:
                            res = str(self.info_log[key]).split("=")[-1].replace(" ", "").replace("\n", "")
                            if res == "1":
                                name_array = key.split("_")[2]
                                read_outside_loop += [name_array]
                                is_array_write = False
                                for task in tasks:
                                    if name_array in self.statements[task].split("=")[0]:
                                        is_array_write = True
                                        break
                                if is_array_write:
                                    write_outside_loop += [name_array]

                loop = self.ast.order_per_task[tasks[0]][dd]
                # loop = loop.replace("pipeline", "pipeline off")
                loop = loop.replace("#pragma HLS pipeline II=2", "").replace("#pragma HLS pipeline II=1", "").replace("#pragma HLS pipeline II = 2", "").replace("#pragma HLS pipeline II = 1", "").replace("#pragma HLS pipeline", "")

                kind_of_ping_pong = "only_read"
                # TODO only write
                for name_array in read_inside_loop:
                    
                    for task in tasks:
                        if name_array in self.statements[task].split("=")[0]:
                            kind_of_ping_pong = "read_write"
                            is_init = False
                            # FIXME todo 
                            try:
                                val = self.statements[task].split("=")[-1].replace(" ", "").replace("\n", "").replace(";", "")
                                val = float(eval(val))
                                is_init = True
                            except:
                                pass
                            if is_init:
                                kind_of_ping_pong = "only_write"
                            break

                if id_fuse_task in list(info_reuse.keys()) and dd+1 in list(info_reuse[id_fuse_task].keys()):
                    for id_arr in range(len(info_reuse[id_fuse_task][dd+1])):
                        for key in list(info_reuse[id_fuse_task][dd+1][id_arr][1].keys()):

                            name = info_reuse[id_fuse_task][dd+1][id_arr][0].replace(" ", "")
                            size = info_reuse[id_fuse_task][dd+1][id_arr][1]
                            size_ = []
                            keys = list(size.keys())
                            keys.sort()
                            for k in keys:
                                size_ += [str(size[k])]
                            if kind_of_ping_pong == "only_read" or kind_of_ping_pong == "only_write":
                                nb = 2
                            elif kind_of_ping_pong == "read_write" :
                                nb = 3
                            for r in range(nb):
                                # size_[-1] = str(self.find_size_last_dim(int(size_[-1]), self.burst[name])) # FIXME 
                                str_ = f"    float {name}_{r}[{']['.join(size_)}];\n"
                                str_ += f"// {info_reuse[id_fuse_task][dd+1][id_arr][1]}\n"
                                
                                # str_ += f"// {size}\n"
                                
                                definition_array_on_chip = self.add_definition_array_on_chip(definition_array_on_chip, name, size_, id_fuse_task)

                                size_transfer[id_fuse_task][f"read_{name}_FT{id_fuse_task}"] = size_

                                size_reuse[id_fuse_task][f"read_{name}_FT{id_fuse_task}"] = size_


                                # TODO find the factor
                                cyclic_factor = []
                                already_done = False
                                for id_task in range(len(tasks)):
                                    w_ = self.analysis.dic[tasks[id_task]]["write"]
                                    r_ = self.analysis.dic[tasks[id_task]]["read"]
                                    loops = self.schedule[tasks[id_task]][1::2]
                                    loops = loops[:len(loops)//2]
                                    for r2 in w_+r_:
                                        if not already_done:
                                            if name in r2:
                                                c_it = self.extract_iterators(r2)
                                                for id_it, it_ in enumerate(c_it):
                                                    for l in loops:
                                                        if it_ == self.iterators[l]:
                                                            # cyclic_factor.append(id_it)
                                                            cyclic_factor.append(self.info_log[f"TC{l}_1"])
                                                            already_done = True

                                                            # TODO when add

                                for d_ in range(len(cyclic_factor)):
                                    str_ += f"#pragma HLS array_partition variable={name}_{r} cyclic factor={cyclic_factor[d_]} dim={d_+1}\n"
                                if str_ not in code:
                                    code += str_
                            definition_array[id_fuse_task][name] = f"float {name}[{']['.join(size_)}]"
                            for d_ in range(dd+1, dim_output+1):
                                str_ = f"{name}"
                                if str_ not in arg_per_intra[id_fuse_task][d_]:
                                    arg_per_intra[id_fuse_task][d_] += [str_]
                                # size_[-1] = str(self.find_size_last_dim(int(size_[-1]), self.burst[name]))
                                str_ = f"float {name}[{']['.join(size_)}]"
                                # str_ += f"// {size}\n"
                                definition_array_on_chip = self.add_definition_array_on_chip(definition_array_on_chip, name, size_, id_fuse_task)
                                if str_ not in definition_per_intra[id_fuse_task][d_]:
                                    definition_per_intra[id_fuse_task][d_] += [str_]
                            
                if dd == 0:
                    if id_fuse_task in list(info_reuse.keys()) and dd in list(info_reuse[id_fuse_task].keys()):
                        for id_arr in range(len(info_reuse[id_fuse_task][dd])):
                            for key in list(info_reuse[id_fuse_task][dd][id_arr][1].keys()):

                                name = info_reuse[id_fuse_task][dd][id_arr][0]
                                size = info_reuse[id_fuse_task][dd][id_arr][1]
                                size_ = []
                                keys = list(size.keys())
                                keys.sort()
                                for k in keys:
                                    size_ += [str(size[k])]
                                # if kind_of_ping_pong == "only_read":
                                #     nb = 2
                                # elif kind_of_ping_pong == "read_write":
                                #     nb = 3
                                # for r in range(nb):
                                # size_[-1] = str(self.find_size_last_dim(int(size_[-1]), self.burst[name]))
                                str_ = f"    float {name}[{']['.join(size_)}];\n"
                                # str_ += f"// {size}\n"
                                # str_ += f"// {info_reuse[id_fuse_task]}\n"
                                definition_array_on_chip = self.add_definition_array_on_chip(definition_array_on_chip, name, size_, id_fuse_task)
                                # size_reuse[id_fuse_task] = {}
                                size_reuse[id_fuse_task][f"read_{name}_FT{id_fuse_task}"] = size_
                                definition_array[id_fuse_task][name] = f"float {name}[{']['.join(size_)}]"
                                for d_ in range(len(size_)):
                                    fac=1
                                    ir = info_reuse[id_fuse_task]
                                    for a, arr_ in enumerate(ir[dd]):
                                        if arr_[0] == name:
                                            fac = ir[dd][a][2][str(d_)]["1"]
                                    str_ += f"#pragma HLS array_partition variable={name} cyclic factor={fac} dim={d_+1}\n"
                                if str_ not in code:
                                    full_array += [name]
                                    code += str_
                                for d_ in range(dd+1, dim_output+1):
                                    str_ = f"{name}"
                                    if str_ not in arg_per_intra[id_fuse_task][d_]:
                                        arg_per_intra[id_fuse_task][d_] += [str_]
                                    str_ = f"float {name}[{']['.join(size_)}]"
                                    definition_array_on_chip = self.add_definition_array_on_chip(definition_array_on_chip, name, size_, id_fuse_task)
                                    # size_reuse[id_fuse_task] = {}
                                    size_reuse[id_fuse_task][f"read_{name}_FT{id_fuse_task}"] = size_
                                    if str_ not in definition_per_intra[id_fuse_task][d_]:  
                                        definition_per_intra[id_fuse_task][d_] += [str_]

                for name_array in read_outside_loop:
                    fifo = self.get_name_fifo(arg, name_array, tasks)
                    fido_def = self.get_declatation_fifo(decl, name_array, tasks)
                    if fifo != "":
                        code += f"    read_{name_array}_FT{id_fuse_task}({name_array}, {fifo});\n"
                        read_write_arg[f"read_{name_array}_FT{id_fuse_task}"] = [name_array, fifo]
                        read_write_def[f"read_{name_array}_FT{id_fuse_task}"] = [definition_array[id_fuse_task][name_array],fido_def]
                        size_transfer[id_fuse_task][f"read_{name_array}_FT{id_fuse_task}"] = size_reuse[id_fuse_task][f"read_{name_array}_FT{id_fuse_task}"]



                it_loop = loop.split("int")[1].split("=")[0].replace(" ", "")
                iterator_per_level += [it_loop]

                for d_ in range(dd+1, dim_output+1):
                    str_1 = f"int {it_loop}"
                    str_2 = f"{it_loop}"
                    if str_2 not in arg_per_intra[id_fuse_task][d_]:
                        arg_per_intra[id_fuse_task][d_] += [str_2]
                    if str_1 not in definition_per_intra[id_fuse_task][d_]:
                        definition_per_intra[id_fuse_task][d_] += [str_1]

                tc_loop = int(loop.split(";")[1].split("<")[-1].replace(" ", ""))
                for name_array in read_inside_loop:
                    fifo = self.get_name_fifo(arg, name_array, tasks)
                    fifo_def = self.get_declatation_fifo(decl, name_array, tasks)
                    if fifo != "":
                        # iterator_per_level
                        if name_array not in full_array:
                            c_arg = [f"{name_array}_0", f"{fifo}", f"0"]
                            size_tmp = size_reuse[id_fuse_task][f"read_{name_array}_FT{id_fuse_task}"].copy()
                            for id_dim, it_ in enumerate(iterator_per_level):
                                if it_ != it_loop:
                                    c_arg += [f"{it_}"]

                            c_arg = ", ".join(c_arg)
                            code += f"    read_{name_array}_FT{id_fuse_task}({c_arg});\n"
                            size_transfer[id_fuse_task][f"read_{name_array}_FT{id_fuse_task}"] = size_tmp

                            
                               
                        else:
                            c_arg = [f"{name_array}", f"{fifo}", f"0"]
                            size_tmp = size_reuse[id_fuse_task][f"read_{name_array}_FT{id_fuse_task}"].copy()
                            for id_dim, it_ in enumerate(iterator_per_level):
                                if it_ != it_loop:
                                    c_arg += [f"{it_}"]
                            for id_dim, it_ in enumerate(iterator_per_level):
                                cur_info = info_transfer[id_fuse_task][dd+1]
                                for elemt in cur_info:
                                    if elemt[0] == name_array:
                                        for dim_array in list(elemt[1].keys()):
                                            tc_loop_it = elemt[1][dim_array]

                                            size_tmp[int(dim_array)] = tc_loop_it
                                        
                            c_arg = ", ".join(c_arg)
                            code += f"    read_{name_array}_FT{id_fuse_task}({c_arg});\n"
                            size_transfer[id_fuse_task][f"read_{name_array}_FT{id_fuse_task}"] = size_tmp

                            
                        read_write_arg[f"read_{name_array}_FT{id_fuse_task}"] = [name_array, fifo, f"{it_loop}"]
                        read_write_def[f"read_{name_array}_FT{id_fuse_task}"] = [definition_array[id_fuse_task][name_array],fifo_def, f"int {it_loop}"]

                        for it_ in iterator_per_level:
                            if f"int {it_}" not in read_write_def[f"read_{name_array}_FT{id_fuse_task}"]:
                                read_write_def[f"read_{name_array}_FT{id_fuse_task}"] += [f"int {it_}"]
                        
                code += f"{loop}\n"
                
                modul = 3
                if kind_of_ping_pong == "read_write":
                    modul = 3
                elif kind_of_ping_pong == "only_read" or kind_of_ping_pong == "only_write":
                    modul = 2

                # code += f"    read_{name_array}({name_array}, {name_array});\n"
                for l in range(modul):
                    if l == 0:
                        code += f"if ({it_loop} % {modul} == {l}){{\n"
                    else:
                        code += f"else if ({it_loop} % {modul} == {l}){{\n"
                    for name_array in read_inside_loop:
                        fifo = self.get_name_fifo(arg, name_array, tasks)
                        fifo_def = self.get_name_fifo_write(arg, name_array, tasks)
                        if fifo != "":
                            
                            if name_array not in full_array:
                                c_arg = [f"{name_array}_{(l+1)%modul}", f"{fifo}", f"{it_loop}+1"]
                                for it_ in iterator_per_level:
                                    if it_ != it_loop:
                                        c_arg += [f"{it_}"]
                                c_arg = ", ".join(c_arg)
                                code += f"    read_{name_array}_FT{id_fuse_task}({c_arg});\n"
                            else:
                                c_arg = [f"{name_array}", f"{fifo}", f"{it_loop}+1"]
                                for it_ in iterator_per_level:
                                    if it_ != it_loop:
                                        c_arg += [f"{it_}"]
                                c_arg = ", ".join(c_arg)
                                code += f"    read_{name_array}_FT{id_fuse_task}({c_arg});\n"
                    if dd == dim_output-1:
                        for id_task in tasks:
                            curr_arg = arg_per_intra[id_fuse_task][dd+1].copy()
                            for name_array in read_inside_loop:
                                if name_array not in full_array:
                                    for id_, arg_ in enumerate(curr_arg):
                                        if arg_ == f"{name_array}":
                                            curr_arg[id_] = f"{name_array}_{(l)%modul}"
                            curr_arg = ", ".join(curr_arg)
                            code += f"    task{id_task}_intra({curr_arg});\n"
                    else:
                        
                        curr_arg = arg_per_intra[id_fuse_task][dd+1].copy()
                        for name_array in read_inside_loop:
                            if name_array not in full_array:
                                for id_, arg_ in enumerate(curr_arg):
                                    
                                    if arg_ == f"{name_array}":
                                        curr_arg[id_] = f"{name_array}_{(l)%modul}"
                            
                        curr_arg = ", ".join(curr_arg)
                        code += f"        FT{id_fuse_task}_level{dd+1}({curr_arg});\n"
                        
                    
                    for name_array in write_inside_loop:
                        fifos = self.get_name_fifo_write(arg, name_array, tasks)
                        fido_def = self.get_declaration_fifo_write(decl, name_array, tasks)[0]
                        for fifo in fifos:
                            if modul == 3:
                                c_arg = [f"{name_array}_{(l+2)%modul}", f"{fifo}", f"{it_loop}-1"]

                            else:
                                c_arg = [f"{name_array}_{(l+1)%modul}", f"{fifo}", f"{it_loop}-1"]
                            for it_ in iterator_per_level:
                                if it_ != it_loop:
                                    c_arg += [f"{it_}"]
                            c_arg = ", ".join(c_arg)
                            code += f"    write_{name_array}_FT{id_fuse_task}({c_arg});\n"
                            read_write_arg[f"write_{name_array}_FT{id_fuse_task}"] = [name_array, fifo, f"{it_loop}"]
                            read_write_def[f"write_{name_array}_FT{id_fuse_task}"] = [definition_array[id_fuse_task][name_array],fido_def, f"int {it_loop}"]
                            for it_ in iterator_per_level:
                                if f"int {it_}" not in read_write_def[f"write_{name_array}_FT{id_fuse_task}"]:
                                    read_write_def[f"write_{name_array}_FT{id_fuse_task}"] += [f"int {it_}"]
                    
                    
                    code += f"    }}\n"

                    # for name_array in write_inside_loop:
                    #     fifo = ""
                    #     for elemt in arg:
                    #         if f"fifo_{name_array}_to" in elemt:
                    #             fifo = elemt.split(" ")[-1]
                    #             break
                    #     code += f"    write_{name_array}({name_array}_0, {fifo}, {tc_loop-1});\n"
                    


                
                

                shift = "    "
                for _ in range(dd):
                    shift += "    "
                code += f"{shift}}}\n"

                for name_array in write_inside_loop:
                    # fifo = self.get_name_fifo(arg, name_array, tasks)
                    fifos = self.get_name_fifo_write(arg, name_array, tasks)
                    fifo_def = self.get_declatation_fifo(decl, name_array, tasks)
                    for fifo in fifos:
                        c_arg = [f"{(tc_loop-1)%modul}", f"{fifo}", f"{int(tc_loop)-1}"]
                        for it_ in iterator_per_level:
                            if it_ != it_loop:
                                c_arg += [f"{it_}"]
                        c_arg = ", ".join(c_arg)
                        code += f"    write_{name_array}_FT{id_fuse_task}({name_array}_{c_arg});\n"
                        read_write_arg[f"write_{name_array}_FT{id_fuse_task}"] = [name_array, fifo, f"{it_loop}"]
                        read_write_def[f"write_{name_array}_FT{id_fuse_task}"] = [definition_array[id_fuse_task][name_array],fido_def, f"int {it_loop}"]
                        for it_ in iterator_per_level:
                            if f"int {it_}" not in read_write_def[f"write_{name_array}_FT{id_fuse_task}"]:
                                read_write_def[f"write_{name_array}_FT{id_fuse_task}"] += [f"int {it_}"]

                

                code += f"}}\n"


        ### for intra

         # for id_fuse_task in range(self.nb_fuse_task):
        #     for k, task in enumerate(self.fuse_task[id_fuse_task]):
        for k, task_str in enumerate(self.ast.order_per_task):
       
            out_arr = self.statements[k].split("=")[0].split("[")[0]
            dim_output = self.array_information[out_arr]["dim"]

            id_fuse_task = self.task_to_FT[k]
            defi_ = definition_per_intra[id_fuse_task][dim_output]
            arg_ = definition_per_intra[id_fuse_task][dim_output]
            code += f"void task{k}_intra({', '.join(defi_)}){{\n"
            h_definition += [f"void task{k}_intra({', '.join(arg_)});"]
            code += f"#pragma HLS inline off\n"
            # code += f"{self.iterators}"
            
            cur_it = []
            cur_loops = self.schedule[k][1::2]
            for i, loop in enumerate(cur_loops):
                if self.iterators[loop] not in cur_it:
                    cur_it += [self.iterators[loop]]

            for cit in cur_it:
                code += f"    int {cit};\n"

            lll = lll[:len(lll)//2]
            for line in task_str[dim_output:-dim_output]:
                code += line + "\n"
            code += f"}}\n"


        # void read
        for fct_read in list(read_write_def.keys()):
            if "read" in fct_read:
                name = fct_read
                name_array = name.split("_")[1]
                defi = read_write_def[name]
                defi = ", ".join(defi)
                code += f"void {name}({defi}){{\n"
                h_definition += [f"void {name}({defi});"]
                code += f"#pragma HLS inline off\n"
                shift = "    "
                id_fuse_task = int(name.split("_")[2].replace("FT", ""))
                
                cond = []
                its = []
                it_ori_array = []
                stat = ""
                for stat_ in self.fuse_task[id_fuse_task]:
                    stat = stat_

                    loops = self.schedule[stat][1::2]

                    its = []
                    for arg in defi.split(","):
                        if "int" in arg:
                            its += [arg.split(" ")[-1]]

                    w = self.analysis.dic[stat]["write"]
                    r = self.analysis.dic[stat]["read"]
                    it_ori_array = []
                    for r_ in r+w:
                        if name_array == r_.split("[")[0]:
                            it_ori_array = self.extract_iterators(r_)
                            break
                    if len(it_ori_array) > 0:
                        break
                for loop in loops:
                    it_l = self.iterators[loop]
                    for it_ in its:
                        if it_ == f"{it_l}0":
                            if it_l in it_ori_array:
                                cc = f"{it_} >= {self.info_log[f'TC{loop}_0']}"
                            else:
                                cc = f"{it_} > 0"
                            if cc not in cond:
                                cond += [cc]
                                break
                    
                if len(cond) > 0:
                    cond = "||".join(cond)
                    code += f"if ({cond}) {{\nreturn;\n}}\n"

                extra_arg = []
                extra_arg_ = defi.split(",")[2:]
                for arg in extra_arg_:
                    extra_arg += [arg.split(" ")[-1]]
                
                it_ori_array = []
                id_stat = ""
                real_size = []
                for task in self.fuse_task[id_fuse_task]:
                    stat = self.statements[task]
                    r = self.analysis.dic[task]["read"]
                    w = self.analysis.dic[task]["write"]
                    for r_ in r+w:
                        if name_array == r_.split("[")[0]:
                            it_ori_array = self.extract_iterators(r_)
                            id_stat = task
                            break
                
                loop_task = self.schedule[id_stat][1::2]
                for it_ in it_ori_array:
                    for loop in loop_task:
                        if it_ == self.iterators[loop]:
                            real_size += [self.info_log[f'TC{loop}']]
                            break


                transfer_size = size_transfer[id_fuse_task][name]


                full_size = size_reuse[id_fuse_task][name]
                nb_dim = len(transfer_size)

                size_array_def = ""
                
                for elemt in defi.split(","):
                    if "float" in elemt and name_array in elemt:
                        size_array_def = elemt[elemt.index("[")+1:].replace("][", "@").split("]")[0].split("@")
                        break


                shift_per_dim = {}
                fifo_name = defi.split(",")[1].split(" ")[-1]
                name_array = defi.split(",")[0].split(" ")[-1].split("[")[0] 

                for d in range(nb_dim):
                    if f"{it_ori_array[d]}0" in extra_arg and (int(size_array_def[d]) >= int(real_size[d]) and int(transfer_size[d]) < int(real_size[d])):
                        shift_per_dim[d] = f"{it_ori_array[d]}0 * {transfer_size[d]}"
                    else:
                        shift_per_dim[d] = "0"

                burst = 1
                if "float16" in defi:
                    burst = 16
                elif "float8" in defi:
                    burst = 8
                elif "float4" in defi:
                    burst = 4
                elif "float2" in defi:
                    burst = 2

                
                

                # id_fuse_task

                prev_size = []

                for prev_id_fuse_task in range(id_fuse_task-1, -1, -1):
                    if name_array in list(self.info_padding[prev_id_fuse_task].keys()):
                        is_write = False
                        for id_task in self.fuse_task[prev_id_fuse_task]:
                            if id_task in self.array_information[name_array]["W"]:
                                is_write = True
                        if is_write:
                            prev_size = self.info_padding[prev_id_fuse_task][name_array]
                            break

                nb_loop_for_inter_task_transfer = 0
                if fifo_name.count("task") > 1:
                    # Inter-task transfer


                    #find what task transfer to us
                    id_previous_ft = -1
                    for id_previous_ft_ in range(id_fuse_task-1, -1, -1):
                        if name_array in list(self.info_padding[id_previous_ft_].keys()):
                            is_write = False
                            for id_task in self.fuse_task[id_previous_ft_]:
                                if id_task in self.array_information[name_array]["W"]:
                                    is_write = True
                            if is_write:
                                previous_size = self.info_padding[id_previous_ft_][name_array]
                                id_previous_ft = id_previous_ft_
                                break
                    on_chip_size_prev = self.info_on_chip_size[id_previous_ft][name_array]
                    loops = []
                    for dim in range(nb_dim-1):
                        curr_loop = self.info_loop_to_array[id_previous_ft][name_array][dim][0]
                        ub = self.info_log[f"TC{curr_loop}_1"]
                        for r in range(1, len(self.info_loop_to_array[id_previous_ft][name_array][dim])):
                            curr_loop = self.info_loop_to_array[id_previous_ft][name_array][dim][r]
                            # FIXME it may not be add
                            ub += self.info_log[f"TC{curr_loop}_1"]
                        loops += [f"{shift}for (int d{dim}_1 = 0; d{dim}_1 < {ub}; d{dim}_1++){{\n"]
                    for dim in range(nb_dim-1, nb_dim):
                        curr_loop = self.info_loop_to_array[id_previous_ft][name_array][dim]
                        curr_loop = self.info_loop_to_array[id_previous_ft][name_array][dim][0]
                        ub = self.info_log[f"TC{curr_loop}_1"]
                        for r in range(1, len(self.info_loop_to_array[id_previous_ft][name_array][dim])):
                            curr_loop = self.info_loop_to_array[id_previous_ft][name_array][dim][r]
                            # FIXME it may not be add
                            ub += self.info_log[f"TC{curr_loop}_1"]
                        loops += [f"{shift}for (int d{dim}_1 = 0; d{dim}_1 <  {ub}; d{dim}_1+={burst}){{\n"]
                    
                    what_dim_need_loops = []
                    dim_to_loops = {}
                    for dim in range(nb_dim):
                        if int(transfer_size[dim]) > int(on_chip_size_prev[dim]):
                            what_dim_need_loops += [dim]
                            dim_to_loops[dim] = self.info_loop_to_array[id_previous_ft][name_array][dim]
                        

                    

                    id_sched = max(self.fuse_task[id_previous_ft])
                    sched = self.schedule[id_sched]
                    sched_loops = sched[1::2][:len(sched[1::2])//2] # only the first half for the inter-tile

                    #reverse order sched_loops
                    sched_loops = sched_loops[::-1]

                    for ll in sched_loops:
                        for dim_need in what_dim_need_loops:
                            if int(ll) in list(map(int, dim_to_loops[dim_need])):
                                curr_loop = self.info_loop_to_array[id_previous_ft][name_array][dim_need][0]
                                ub = self.info_log[f"TC{curr_loop}_0"]
                                for r in range(1, len(self.info_loop_to_array[id_previous_ft][name_array][dim_need])):
                                    # FIXME may no be add
                                    ub += self.info_log[f"TC{self.info_loop_to_array[id_previous_ft][name_array][dim_need][r]}_0"]
                                str_loop = f"{shift}for (int d{dim_need}_0 = 0; d{dim_need}_0 < {ub}; d{dim_need}_0++){{\n"
                                loops = [str_loop] + loops
                    nb_loop_for_inter_task_transfer = len(loops)
                    for loop in loops:
                        code += f"{loop}\n"

                    for dim in range(nb_dim):
                        if dim not in what_dim_need_loops:
                            code += f"int d{dim} = d{dim}_1;\n"
                        else:
                            code += f"int d{dim} = d{dim}_0 * {on_chip_size_prev[dim]} + d{dim}_1;\n"
                else:
                    
                    for d in range(nb_dim):
                        add = 0
                        for ll in loop_task:
                            if d == nb_dim -1 :
                                if f"cte_burst_without_tiling_TC{ll}_for_{name_array}" in list(self.info_log.keys()):
                                    if f"{name_array}_is_fully_transfered_on_last_dim_FT{id_ft}" in list(self.info_log.keys()):
                                        if int(self.info_log[f"{name_array}_is_fully_transfered_on_last_dim_FT{id_ft}"]) == 1:
                                            add = int(self.info_log[f"cte_burst_without_tiling_TC{ll}_for_{name_array}"])
                        if len(prev_size) == 0:
                            # FIXME IS IT CORRECT ?
                            ub = str(int(transfer_size[d]) + int(add))
                        else:
                            ub = min(int(transfer_size[d]), int(prev_size[d]))
                        #ub = min(transfer_size[d], previous_size[d])
                        if d == nb_dim -1 :
                            code += f"{shift}for (int d{d} = 0; d{d} < {ub}; d{d}+={burst}){{\n"
                            code += f"{shift}#pragma HLS pipeline II=1\n"
                        else:
                            code += f"{shift}for (int d{d} = 0; d{d} < {ub}; d{d}++){{\n"
                        shift += "    "

                code += f"float{burst} tmp_fifo = {fifo_name}.read();\n"
                for b in range(burst):
                    if name_array in self.what_array_has_shit or fifo_name.count("task") > 1:
                        # FIXME
                        code += f"if (d{nb_dim-1} + {b} < {transfer_size[-1]})\n"
                    code += f"{shift}{name_array}["
                    for d in range(nb_dim):
                        code += f"d{d}"
                        code += f" + {shift_per_dim[d]}"
                        if d == nb_dim -1:
                            code += f" + {b}"
                        if d != nb_dim -1:
                            code += "]["
                    code += f"] = tmp_fifo[{b}];\n"

                nb_loop = nb_dim
                if fifo_name.count("task") > 1:
                    nb_loop = nb_loop_for_inter_task_transfer

                for d in range(nb_loop):
                    shift = shift[:-4]
                    code += f"{shift}}}\n"



                code += f"}}\n\n"
                


        # for fct_write_ in list(read_write_def.keys()):
        #     if "write" in fct_write_:
        #         name = fct_write_
        #         defi = read_write_def[name]
        #         defi = ", ".join(defi)
        #         code += f"void {name}({defi}){{\n"
        #         h_definition += [f"void {name}({defi});"]
        #         code += f"#pragma HLS inline off\n"
        #         shift = "    "
        #         code += f"}}\n\n"

        for fct_write_ in list(read_write_def.keys()):
            if "write" in fct_write_:
                name = fct_write_
                name_array = name.split("_")[1]
                defi = read_write_def[name]
                defi = ", ".join(defi)
                code += f"void {name}({defi}){{\n"
                h_definition += [f"void {name}({defi});"]
                code += f"#pragma HLS inline off\n"
                shift = "    "
                id_fuse_task = int(name.split("_")[2].replace("FT", ""))

                cond = []

                size_array_def = ""
                
                for elemt in defi.split(","):
                    if "float" in elemt and name_array in elemt:
                        size_array_def = elemt[elemt.index("[")+1:].replace("][", "@").split("]")[0].split("@")
                        break

                its = []
                for arg in defi.split(","):
                    if "int" in arg:
                        its += [arg.split(" ")[-1]]
                

                for it_ in its:
                    cc = f"{it_} < 0"
                    if cc not in cond:
                        cond += [cc]    
                if len(cond) > 0:
                    cond = "||".join(cond)
                    code += f"if ({cond}) {{\nreturn;\n}}\n"

                extra_arg = []
                extra_arg_ = defi.split(",")[2:]
                for arg in extra_arg_:
                    extra_arg += [arg.split(" ")[-1]]
                
                it_ori_array = []
                id_stat = ""
                real_size = []
                for task in self.fuse_task[id_fuse_task]:
                    stat = self.statements[task]
                    r = self.analysis.dic[task]["read"]
                    w = self.analysis.dic[task]["write"]
                    for r_ in r+w:
                        if name_array == r_.split("[")[0]:
                            it_ori_array = self.extract_iterators(r_)
                            id_stat = task
                            break

                loop_task = self.schedule[id_stat][1::2]
                for it_ in it_ori_array:
                    for loop in loop_task:
                        if it_ == self.iterators[loop]:
                            real_size += [self.info_log[f'TC{loop}']]
                            break
                
                transfer_size = size_transfer[id_fuse_task][name.replace("write", "read")]
                full_size = size_reuse[id_fuse_task][name.replace("write", "read")]
                nb_dim = len(transfer_size)

                shift_per_dim = {}
                for d in range(nb_dim):
                    if f"{it_ori_array[d]}0" in extra_arg and (int(size_array_def[d]) >= int(real_size[d]) and int(transfer_size[d]) < int(real_size[d])):
                        shift_per_dim[d] = f"{it_ori_array[d]}0 * {transfer_size[d]}"
                    else:
                        shift_per_dim[d] = "0"

                burst = 1
                if "float16" in defi:
                    burst = 16
                elif "float8" in defi:
                    burst = 8
                elif "float4" in defi:
                    burst = 4
                elif "float2" in defi:
                    burst = 2

                fifo_name = defi.split(",")[1].split(" ")[-1]
                name_array = defi.split(",")[0].split(" ")[-1].split("[")[0] 
                

                for d in range(nb_dim):
                    if d == nb_dim -1 :
                        code += f"{shift}for (int d{d} = 0; d{d} < {transfer_size[d]}; d{d}+={burst}){{\n"
                        code += f"{shift}#pragma HLS pipeline II=1\n"
                    else:
                        code += f"{shift}for (int d{d} = 0; d{d} < {transfer_size[d]}; d{d}++){{\n"
                    shift += "    "

                code += f"float{burst} tmp_fifo;\n"
                for b in range(burst):
                    code += f"tmp_fifo[{b}] = {shift}{name_array}["
                    for d in range(nb_dim):
                        code += f"d{d}"
                        code += f" + {shift_per_dim[d]}"
                        if d == nb_dim -1:
                            code += f" + {b}"
                        if d != nb_dim -1:
                            code += "]["
                    code += f"];\n"

                code += f"{fifo_name}.write(tmp_fifo);\n"

                for d in range(nb_dim):
                    shift = shift[:-4]
                    code += f"{shift}}}\n"



                # if name == "read_A_FT0":
                #     exit(0)

                code += f"}}\n\n"

        code += "\n"
        # code += "#ifdef EXTERN_C\n"
        code += "//extern \"C\"{\n"
        # code += "#endif\n"

        # modify self.arguments to match name and number of arguments
        old_arguments = self.arguments.copy()
        self.arguments = []
        for arg in old_arguments:
            if "]" not in arg:
                self.arguments += [arg]
        cur_array = []
        for arg in old_arguments:
            if "]" in arg:
                name = arg.split("[")[0].split(" ")[-1]
                if name not in cur_array:
                    cur_array += [name.replace("v", "")]
        
        # info_arr = {}
        # first_read = {}
        # first_write = {}
        # for k in range(len(self.schedule)):
        #     w = self.analysis.dic[k]["write"]
        #     r = self.analysis.dic[k]["read"]
        #     for r_ in r:
        #         if "[" in r_ and "[0]" not in r_:
        #             name = r_.split("[")[0]
        #             if name not in list(info_arr.keys()):
        #                 info_arr[name] = []
        #             if name not in list(first_read.keys()):
        #                 first_read[name] = k
        #             info_arr[name] += [("r", k)]
        #             first_read[name] = min(first_read[name], k)

        #     for w_ in w:
        #         if "[" in w_ and "[0]" not in w_:
        #             name = w_.split("[")[0]
        #             if name not in list(info_arr.keys()):
        #                 info_arr[name] = []
        #             info_arr[name] += [("w", k)]
        #             if name not in list(first_write.keys()):
        #                 first_write[name] = k
        #             first_write[name] = min(first_write[name], k)
        # array_read_from_different_bank = []
        # # FIXME
        # for key in list(info_arr.keys()):
        #     nb_read = 0
        #     nb_write = 0
        #     for elemt in info_arr[key]:
        #         if elemt[0] == "r":
        #             nb_read += 1
        #         else:
        #             nb_write += 1
        #     if nb_read > 1 and nb_write == 0:
        #         array_read_from_different_bank.append(key)


        for key in list(info_arr.keys()):
            if key not in array_read_from_different_bank:
                for old_arg in old_arguments:
                    if key in old_arg:
                        type = old_arg.split(" ")[0]
                        size = old_arg[old_arg.index("[")+1:]
                        new_name = f"{type} v{key}_for_task{first_read[key]}[{size}"
                        self.arguments += [new_name]
            else:
                for old_arg in old_arguments:
                    if key in old_arg:
                        type = old_arg.split(" ")[0]
                        size = old_arg[old_arg.index("[")+1:]
                        for k in range(len(info_arr[key])):
                            if info_arr[key][k][0] == "r":
                                new_name = f"{type} v{key}_for_task{info_arr[key][k][1]}[{size}"
                                self.arguments += [new_name]
                                





        code += f"void {self.name_function}({', '.join(self.arguments)}) {{\n\n"
        k2k = []
        id_ = 0
        h_definition += [f"void {self.name_function}({', '.join(self.arguments)});"]
        for arg in self.arguments:
            name = arg.split("[")[0].split(" ")[-1]
            code += f"#pragma HLS INTERFACE m_axi port={name} offset=slave bundle=kernel_{name}\n"
            k2k += [f"sp=kernel_nlp_1.{name}:HBM[{id_}]\n"]
            id_ += 3
        
        k2k_file = "/".join(self.output.split("/")[:-1]) + "/k2k.cfg"

        f = open(k2k_file, "w")
        f.write("[connectivity]\n")
        f.write("".join(k2k))
        f.close()
        for arg in self.arguments:
            name = arg.split("[")[0].split(" ")[-1]
            code += f"#pragma HLS INTERFACE s_axilite port={name} bundle=control\n"
        for arg in self.arguments:
            name = arg.split("[")[0].split(" ")[-1]
            code += f"#pragma HLS DATA_PACK VARIABLE={name}\n"
        
        code += "#pragma HLS INTERFACE s_axilite port=return bundle=control\n\n"
        code += "#pragma HLS dataflow\n\n"


        
        code += definition_fifo

        if self.optimize_burst:
            for arg in old_arguments:
                code += f"{arg};\n"

            
            for arg in old_arguments:
                code += self.array_partition(arg)

        loads = []
        writes = []
        for i, stat in enumerate(self.statements):
            out, inp = stat.split("=")
            out = out.strip().split("[")[0]
            inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
            
            writes += [out]
            loads += inp

        


        writes = list(set(writes))
        loads = list(set(loads))

        #remove loads if not array
        new_loads = []
        for i, l in enumerate(loads):
            try:
                float(l)
            except:
                new_loads.append(l)

        loads = new_loads



        # for l in loads:
        #     code += self.load(l)
        code += "\n"

        # FIXME is order of load important ????
        # call load
        for array, defi, name_fifo, original_def, original_name in fct_load:
            code += f"    load_{original_name}({name_fifo}, {original_name});\n"

        code += "\n"

        # for k in range(len(list(self.flow_read_array.keys()))):
        #     if k not in list(arg_per_task.keys()):
        #         continue
        #     code += f"    task{k}({', '.join(arg_per_task[k])});\n"

        for id_fuse_task in range(self.nb_fuse_task):
            code += f"    FT{id_fuse_task}_level0({', '.join(arg_per_FT[id_fuse_task])});\n"
        
        code += "\n"
        for array, defi, name_fifo, original_def, original_name, task_id in fct_write:
            code += f"    store_{original_name}({name_fifo}, {original_name});\n"
        # for w in writes:
        #     code += self.write(w)

        code += "}\n"
        # code += "#ifdef EXTERN_C\n"
        code += "//}\n"
        # code += "#endif\n"

        TC_ori = {}

        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()

        it_ori = {}

        for line in lines:
            if "param" in line and "TC" in line and "ori" in line:
                name = int(line.split("TC")[-1].split("_")[0])
                value = int(line.split("=")[-1].replace(" ", "").replace("\n", "").replace(";", ""))
                TC_ori[name] = value
            #comment: Loop_0: i
            if "comment" in line and "Loop" in line:
                name = line.split("_")[-1].split(":")[0]
                value = line.split(":")[-1].replace(" ", "").replace("\n", "")
                it_ori[int(name)] = value


        # update the indice for each array
        for k, task_str in enumerate(self.ast.order_per_task):
            task, begin, end = self.get_task(code, k)
            loops = []
            tc = []
            its = []
            it_loop = {}
            for line in task:
                if "for" in line:
                    loops.append(line)
                    tc.append(int(line.split("<")[-1].split(";")[0].replace(" ", "")))
                    its.append(line.split("int")[1].split("=")[0].replace(" ", ""))
                    it_loop[line.split("int")[1].split("=")[0].replace(" ", "")] = int(line.split("<")[-1].split(";")[0].replace(" ", ""))
            
            for id_line, line in enumerate(task):
                if "=" in line and "for" not in line and "if" not in line and "#" not in line:
                    l = line.split("=")[0].strip()
                    if f"{l}1" not in its:
                        statement = line.replace("\n", "").replace(" ", "")


                        # format 
                        if "+=" in statement.replace(" ", ""):
                            out = statement.split("=")[0]
                            statement = statement.replace("+=", f"={out}+(").replace(";", ");")
                        if "-=" in statement.replace(" ", ""):
                            out = statement.split("=")[0]
                            statement = statement.replace("-=", f"={out}-(").replace(";", ");")
                        if "*=" in statement.replace(" ", ""):
                            out = statement.split("=")[0]
                            statement = statement.replace("*=", f"={out}*(").replace(";", ");")
                        if "/=" in statement.replace(" ", ""):
                            out = statement.split("=")[0]
                            statement = statement.replace("/=", f"={out}/(").replace(";", ");")

                        statement = statement.replace(";", "")
                        # change all operation outside brackets
                        arrays = []
                        op = []
                        
                        cur_str = ""
                        inside_bracket = False
                        for elemt in statement:
                            if elemt == "[":
                                inside_bracket = True
                            if elemt == "]":
                                inside_bracket = False
                                
                            if not inside_bracket and (elemt == "+" or elemt == "-" or elemt == "*" or elemt == "/" or elemt == "="):
                                arrays.append(cur_str)
                                op.append(elemt)
                                cur_str = ""
                            else:
                                cur_str += elemt
                        arrays.append(cur_str)
                        new_statement = ""
                        id_FT = self.task_to_FT[k]
                        for id_, a in enumerate(arrays):
                            if "[" in a:
                                new_array = a
                                name = a.split("[")[0]
                                size_on_chip = definition_array_on_chip[id_FT][name]
                                it_array = self.extract_iterators(a)
                                for id_dim, it_ in enumerate(it_array):
                                    if "+" in it_ or "-" in it_ or "*" in it_ or "/" in it_:
                                        it_ = it_.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                                    else:
                                        it_ = [it_]
                                    for it__ in it_:
                                        if int(it_loop[f"{it__}1"]) == int(size_on_chip[id_dim]):
                                            # new_array = new_array.replace(f"{it__}", f"{it__}1")
                                            new_array = re.sub(rf'\b{it__}\b', f"{it__}1", new_array)

                                new_statement += new_array
                                if id_ < len(op):
                                    new_statement += op[id_]
                            else:
                                new_statement += a
                                if id_ < len(op):
                                    new_statement += op[id_]
                        statement = new_statement + ";"
                        task[id_line] = statement
                            
            code_ = code.split("\n")
            code_ = code_[:begin] + task + ["\n"] + code_[end+1:]
            code = "\n".join(code_)


        # update the padding

        reduction_loop = []
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "reduction" in line and "#comment:" in line:
                reduction_loop.append(int(line.split(":")[-1].split("is")[0].replace(" ", "")))

        id_loop_original = 0

        for k, task_str in enumerate(self.ast.order_per_task):
            task, begin, end = self.get_task(code, k)
            loops = []
            tc = []
            its = []
            it_loop = {}
            id_loop_task = 0
            reduction = []
            reduction_of_the_original = []
            begin_2 = -1
            end_2 = -1
            nb = 0
            for id_line, line in enumerate(task):
                if "for" in line:
                    loops.append(line)
                    tc.append(int(line.split("<")[-1].split(";")[0].replace(" ", "")))
                    its.append(line.split("int")[1].split("=")[0].replace(" ", ""))
                    it_loop[line.split("int")[1].split("=")[0].replace(" ", "")] = int(line.split("<")[-1].split(";")[0].replace(" ", ""))
                    if begin_2 == -1:
                        begin_2 = id_line
                    if id_loop_original in reduction_loop:
                        reduction.append(id_loop_task)
                        reduction_of_the_original.append(id_loop_original)
                    id_loop_task += 1
                    id_loop_original += 1
                if begin_2 != -1:
                    if "{" in line:
                        nb += 1
                    if "}" in line:
                        nb -= 1
                        if nb == 0:
                            end_2 = id_line
                            break
            if begin_2 == -1 and end_2 == -1:
                continue
            if len(reduction) == 0:
                continue
            at_least_one = False

            loop_which_need_change = []

            for k_, ll in enumerate(reduction_of_the_original):
                new_tc = self.info_log[f"TC{ll}"]
                ori_tc = TC_ori[ll]
                if int(new_tc) != int(ori_tc):
                    at_least_one = True
                    loop_which_need_change += [(reduction[k_], int(new_tc), int(ori_tc))]

            if not at_least_one:
                continue

            interior = task[begin_2:end_2+1]
            new_interior = ""

            reduction_it = [self.iterators[int(l)] for l in reduction_of_the_original]


            # let suppose one loop to change for now
            tc_0 = 0
            tc_1 = 0
            for line in interior:
                
                if "for" in line:
                    it = line.split("int")[1].split("=")[0].replace(" ", "")
                    if it.replace("0", "") in reduction_it:
                        tc = int(line.split("<")[-1].split(";")[0].replace(" ", ""))
                        tc_0 = tc
                    if it.replace("1", "") in reduction_it:
                        tc = int(line.split("<")[-1].split(";")[0].replace(" ", ""))
                        tc_1 = tc
            tc_tot = int(tc_0) * int(tc_1)
            diff = tc_tot - TC_ori[reduction_of_the_original[0]] 
            
            if diff <= tc_1:
                first_interior = interior.copy()
                second_interior = interior.copy()
                for id_line, line in enumerate(first_interior):
                    if "for" in line:
                        it = line.split("int")[1].split("=")[0].replace(" ", "")
                        if it.replace("0", "") in reduction_it:
                            tc = line.split("<")[-1].split(";")[0].replace(" ", "")
                            first_interior[id_line] = first_interior[id_line].replace(f"{tc}", f"{int(tc)-1}")
                for id_line, line in enumerate(second_interior):
                    if "for" in line:
                        it = line.split("int")[1].split("=")[0].replace(" ", "")
                        if it.replace("0", "") in reduction_it:
                            tc = line.split("<")[-1].split(";")[0].replace(" ", "")
                            second_interior[id_line] = second_interior[id_line].replace(f"= 0", f"= {int(tc)-1}")
                        if it.replace("1", "") in reduction_it:
                            tc = line.split("<")[-1].split(";")[0].replace(" ", "")
                            second_interior[id_line] = second_interior[id_line].replace(f"{tc}", f"{int(tc)-diff}")
                if first_interior != second_interior:
                    new_interior = first_interior + ["\n"] + second_interior
                else:
                    new_interior = first_interior
            else:

                new_interior = interior.copy()
                pass
                        



            # FIXME For now we remove that because we suppose we put 0 in padding

            # begin_fct = task[:begin_2]
            # end_fct = task[end_2+1:]
            
            # new_task = begin_fct + new_interior + end_fct

                            
            # code_ = code.split("\n")
            # code_ = code_[:begin] + new_task + code_[end+1:]
            # code = "\n".join(code_)

    
            

        # exit(0)


        with open(self.output, "w") as f:
            f.write(code)

        
        with open(h_name, "w") as f:
            f.write("#ifndef PROMETHEUS_H\n")
            f.write("#define PROMETHEUS_H\n\n")
            for h in h_definition:
                f.write(h + "\n")
            f.write("\n")
            f.write("#endif // PROMETHEUS_H\n")


        
        print(f"Code written to {self.output}")