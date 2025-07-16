import os
import numpy as np
import islpy as isl
from sympy import simplify
from sympy.abc import i

def unique_list_in_order(l1):
    l2 = []
    for l in l1:
        if l not in l2:
            l2.append(l)
    return l2


#### TODO
# remove module initialization
# do cyclic buffer

CYCLIC_BUFFER = False

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

        # return f"{self.value} -> {self.children}"
        str_ = f"Node: {self.value}"
        str_ += "-> Child ["
        if self.children:
            # str_ += " -> "
            for child in self.children:
                str_ += f"{child} "
        str_ += "]"
        return str_


class AST:
    def __init__(self, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top, analysis, array_need_more_than_one_copy, sched_need_different_copy_par_array, condition_copy_array_between_statement, array_need_complete_copy_inside_task,  array_need_partial_copy_inside_task,  array_dont_need_copy_per_schedule):
        self.schedule = schedule
        self.iterator_cyclic = {}
        self.output_array = {}
        self.should_reduce = {}
        self.UB = UB
        self.LB = LB

        self.array_need_more_than_one_copy = array_need_more_than_one_copy
        self.sched_need_different_copy_par_array = sched_need_different_copy_par_array
        self.condition_copy_array_between_statement = condition_copy_array_between_statement
        self.array_need_complete_copy_inside_task = array_need_complete_copy_inside_task
        self.array_need_partial_copy_inside_task = array_need_partial_copy_inside_task
        self.array_dont_need_copy_per_schedule = array_dont_need_copy_per_schedule
        
        self.statements = statements
        self.iterators = iterators
        self.output = output
        self.headers = headers
        self.limit_IL = 4
        self.transfer_totally = {}
        self.condition_fifo = {}
        self.arguments = arguments
        self.analysis = analysis
        self.UB_ = self.analysis.UB_
        self.LB_ = self.analysis.LB_
        for k in range(len(self.schedule)):
            self.transfer_totally[k] = {}
            self.condition_fifo[k] = {}
            stat = self.statements[k]
            out, inp = self.extract_array_and_constant(stat)
            for in_ in inp + [out]:
                self.condition_fifo[k][in_] = ""

        try:
            self.compute_condition_fifo()
        except:
            pass
        

        
        for i, it in enumerate(self.schedule):
            self.iterator_cyclic[i] = {}
            self.output_array[i] = ""
            self.should_reduce[i] = False

        self.name_function = name_function
        self.pragmas = pragmas
        self.pragmas_top = pragmas_top
        self.tab = "    "
        self.data_type = "float" # FIXME
        self.list_nodes = []
        self.array_need_reuse = {}
        self.level_read = {}

        self.array_information = {}
        self.compute_arrays_information()

        self.compute_not_copy()

        self.tree = Node("Root",  "", self.list_nodes, "Root", 0)
        self.compute()
        # self.print_ast()
        
        self.order = []
        self.write_order(self.tree)

        self.order_per_loop_body = []


        self.write_order_per_loop_body(self.tree)


    def extract_size_array(self, arg):
        if "[" in arg:
            index = arg.index("[")
            arg = arg[index:]
            arg = arg.replace("][", "*")
            arg = arg.replace("[", "")
            arg = arg.replace("]", "")
            return eval(arg)
        return 1
    
    def extract_size_array_dim(self, arg):
        if "[" in arg:
            index = arg.index("[")
            arg = arg[index:]
            arg = arg.replace("][", "*")
            arg = arg.replace("[", "")
            arg = arg.replace("]", "")
        return arg.split("*")

    def compute_arrays_information(self):
        all_arrays = []
        for stat in self.statements:
            if "=" in stat:
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
                all_arrays += [out] 
                all_arrays += inp
        all_arrays = unique_list_in_order(all_arrays)

        for arr in all_arrays:
            self.array_information[arr] = {"size": 0, "type": "", "W": [], "size_burst": 0, "size_vector": 0, "statements": [], "dim": 0, "loop_to_dim": {}, "part_per_dim": [], "size_per_dim": [], "iterators":{}, "polyhedron":{}, "intersection":{}, "polyhedron_size": {}, "access":{}}
            for i, stat in enumerate(self.statements):
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                if f"{arr}[" in stat:
                    self.array_information[arr]["statements"].append(i)
                if f"{arr}" in out:
                    self.array_information[arr]["W"].append(i)
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                self.array_information[arr]["iterators"][id_stat] = []
                self.array_information[arr]["polyhedron"][id_stat] = []
                self.array_information[arr]["polyhedron_size"][id_stat] = []
                self.array_information[arr]["access"][id_stat] = []
                self.array_information[arr]["intersection"][id_stat] = []
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                stat = self.statements[id_stat]
                out, inp = self.extract_array_and_constant(stat, False)
                all_ = [out] + inp
                for id_, al_ in enumerate(all_):

                    if al_.split("[")[0] == arr:

                        for k in range(0, 10):
                            al_ = al_.replace(f"{k}", "")
                        # al_ = al_.replace("[]", "").
                        if "[" in al_:
                            it = al_[al_.index("[") + 1:-1].split("][")
                            self.array_information[arr]["iterators"][id_stat].append(it)
                            if ("+=" in stat or "-=" in stat or "*=" in stat or "/=" in stat) and id_ == 0: # output
                                self.array_information[arr]["iterators"][id_stat].append(it)

        for arr in all_arrays:
            for arg in self.arguments:
                if arr in arg:
                    self.array_information[arr]["type"] = arg.split(" ")[0].strip()
                    self.array_information[arr]["size"] = self.extract_size_array(arg)
                    self.array_information[arr]["size_per_dim"] = self.extract_size_array_dim(arg)
                    self.array_information[arr]["dim"] = arg.count("[")
                    self.array_information[arr]["part_per_dim"] = [1 for k in range(self.array_information[arr]["dim"])]
                    break
        for arr in all_arrays:
            for stat in self.array_information[arr]["statements"]:
                it_per_dim = []
                ss = self.multi_split(self.statements[stat].replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])
                ss = unique_list_in_order(ss)
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
                        if it_ in loop_to_it:
                            it_per_dim[i][j] = it_to_loop[it_]
                        

                for pos in range(len(it_per_dim)):
                    for dim in range(len(it_per_dim[pos])):
                        self.array_information[arr]["loop_to_dim"][it_per_dim[pos][dim]] = dim
                for pos in range(len(it_per_dim)):
                    for dim in range(len(it_per_dim[pos])):
                        loop = it_per_dim[pos][dim]
                        if type(loop) == str:
                            continue
                        pragma_loop = self.pragmas[loop]
                        if pragma_loop != [""]:
                            if ";" in pragma_loop:
                                pragma_loop = pragma_loop.split(";")
                                for p in pragma_loop:
                                    if "unroll" in p.lower():
                                        factor = p.split("=")[-1].strip().replace(" ", "")
                                        self.array_information[arr]["part_per_dim"][dim] = max(self.array_information[arr]["part_per_dim"][dim], int(factor))
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                for i, it in enumerate(self.array_information[arr]["iterators"][id_stat]):
                    try:
                        var1 = []
                        var2 = []

                        cond_arr1 = []
                        cond_arr2 = []
                        for j, it_ in enumerate(it):
                            if it_ != "":
                                cond_arr1.append(f"0 <= {it_} < {self.array_information[arr]['size_per_dim'][j]}")
                                var1.append(f"{it_}")
                        cond_arr2 += self.analysis.dic[id_stat]["constraint"]
                        for conf in self.analysis.dic[id_stat]["constraint"]:
                            conf = conf.replace(" ", "").replace("+", "@").replace("-", "@").replace("0", "@").replace("1", "@").replace("2", "@").replace("3", "@").replace("4", "@").replace("5", "@").replace("6", "@").replace("7", "@").replace("8", "@").replace("9", "@").replace("=", "@").replace("<", "@").replace(">", "@")
                            conf = conf.split("@")
                            while "" in conf:
                                conf.remove("")
                            

                            var2 += conf
                        var1 = unique_list_in_order(var1)
                        var2 = unique_list_in_order(var2)
                        var = var1 + var2
                        while "" in var:
                            var.remove("")
                        var = unique_list_in_order(var)
                        cond1 = " and ".join(cond_arr1)
                        cond2 = " and ".join(cond_arr2)
                        # sort var
                        var1 = sorted(var1)
                        var2 = sorted(var2)
                        var = sorted(var)
                        str_1 = f"[{', '.join(var)}] -> {{ [{', '.join(var)}] :{cond1} }}"
                        str_2 = f"[{', '.join(var)}] -> {{ [{', '.join(var)}] :{cond2} }}"
                        poly1 = isl.Set(str_1)
                        poly2 = isl.Set(str_2) #domain

                        poly = {} #poly1.intersect(poly2) 

                        self.array_information[arr]["polyhedron"][id_stat].append(poly)
                        self.array_information[arr]["access"][id_stat].append(f"{arr}[{']['.join(it)}]")
                        # self.array_information[arr]["polyhedron_size"][id_stat].append(int(poly.count_val().to_str()))
                        self.array_information[arr]["polyhedron_size"][id_stat].append(0)
                    except:
                        pass
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                self.array_information[arr]["intersection"][id_stat] = {}
                for k1, elmt1 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                    self.array_information[arr]["intersection"][id_stat][k1] = {}
                    for k2, elmt2 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                        if k2!=k1:
                            self.array_information[arr]["intersection"][id_stat][k1][k2] = 0
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                for k1, elmt1 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                    for k2, elmt2 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                        if k2!=k1:
                            intersection = {} #int(elmt1.intersect(elmt2).count_val().to_str())
                            self.array_information[arr]["intersection"][id_stat][k1][k2] = intersection




    def write_order_per_loop_body(self, tree):

        self.analyze_reuse()
        for k,subtree in enumerate(tree.children):

            out = []
            # add in comment the schedule
            out.append(f"    // Schedule: {self.schedule[k]}")
            for reuse in self.array_need_reuse[k]:
                # out.append(f"    {self.data_type} {reuse};")
                # FIXME do it clearly
                for arg in self.arguments:
                    if f"{reuse}[" in arg:
                        out.append(f"    {arg};")
                if self.from_off_chip[k][reuse] and k >= 1:
                    # out.append(f"    // weshhhh")
                    loops = list(self.array_information[reuse]["loop_to_dim"].keys())
                    for j in range(1, len(self.schedule[k]), 2):
                        loop = int(self.schedule[k][j])
                        if loop in loops:
                            it = self.iterators[loop]
                            lb = self.LB_[loop]
                            
                            ub = self.UB_[loop]
                            tab = self.create_tab((j-1)//2)
                            out.append(tab + self.create_loop(it, f"{lb}", f"{ub}+1", self.schedule[k][j]))
                    tab = self.create_tab(len(self.schedule[k])//2 )

                    # exit(0)
                    if reuse not in self.transfer_totally[k]:
                        out.append("// read 9\n")
                        out.append(f"{tab}{reuse}{self.reuse_it[k][reuse]} = {self.nameR[k][reuse]}.read();")
                    for j in range(1, len(self.schedule[k]), 2):
                        loop = int(self.schedule[k][j])
                        if loop in loops:
                            tab = self.create_tab((j-1)//2)
                            out.append(f"{tab}}}")

            ####
            self.transfer_totally[k] = self.compute_transfer_totally(k)
            for arr in list(self.transfer_totally[k].keys()):
                out.append(f"// beginnn {arr}")
                dim = []
                for tmp in self.analysis.dic[k]["read"] + self.analysis.dic[k]["write"]:
                    if arr in tmp:

                        its = self.extract_iterator(tmp)
                        for kk, it in enumerate(its):

                            # exit(0)
                            try:
                                a = self.analysis.dic[k]["TC"][it]
                            except:
                                it = it.replace("+", "")
                                it = it.replace("-", "")
                                it = it.replace("*", "")
                                it = it.replace("/", "")
                                it = it.replace("0", "")
                                it = it.replace("1", "")
                                it = it.replace("2", "")
                                it = it.replace("3", "")
                                it = it.replace("4", "")
                                it = it.replace("5", "")
                                it = it.replace("6", "")
                                it = it.replace("7", "")
                                it = it.replace("8", "")
                                it = it.replace("9", "")
                            dim += [self.analysis.dic[k]["TC"][it]]
                        break
                dim = list(map(str, dim))
                out.append(f"    {self.data_type} {arr}[{']['.join(dim)}];")

                nb = 0
                for tmp in self.analysis.dic[k]["read"] + self.analysis.dic[k]["write"]:
                    if arr in tmp:
                        lit = []

                        its = self.extract_iterator(tmp)
                        for kk, it in enumerate(its):

                            try:
                                a = self.analysis.dic[k]["TC"][it]
                            except:
                                it = it.replace("+", "")
                                it = it.replace("-", "")
                                it = it.replace("*", "")
                                it = it.replace("/", "")
                                it = it.replace("0", "")
                                it = it.replace("1", "")
                                it = it.replace("2", "")
                                it = it.replace("3", "")
                                it = it.replace("4", "")
                                it = it.replace("5", "")
                                it = it.replace("6", "")
                                it = it.replace("7", "")
                                it = it.replace("8", "")
                                it = it.replace("9", "")

                            # exit(0)
                            lb = self.analysis.dic[k]["LB_"][it]
                            ub = self.analysis.dic[k]["UB_"][it]
                            tab = self.create_tab(kk+1)

                            out.append(f"{tab}{self.create_loop(it, f'{lb}', f'{ub}+1')}")
                            lit += [it]
                            nb += 1
                        tab = self.create_tab(len(its)+1)
                        out.append("// read 11\n")

                        out.append(f"{tab}{tmp} = {self.nameR[k][arr]}.read();")
                        for l in range(nb):
                            tab = self.create_tab(len(its)-l)
                            out.append(f"{tab}}}")
                        break
            ####

            self.write_order2(subtree, out, k, 0)

            for arr in list(self.transfer_totally[k].keys()):
                # out.append(f"// end {arr}")

                nb = 0
                for tmp in self.analysis.dic[k]["read"] + self.analysis.dic[k]["write"]:
                    if arr in tmp:

                        its = self.extract_iterator(tmp)
                        for kk, it in enumerate(its):

                            # exit(0)
                            try:
                                a = self.analysis.dic[k]["TC"][it]
                            except:
                                it = it.replace("+", "")
                                it = it.replace("-", "")
                                it = it.replace("*", "")
                                it = it.replace("/", "")
                                it = it.replace("0", "")
                                it = it.replace("1", "")
                                it = it.replace("2", "")
                                it = it.replace("3", "")
                                it = it.replace("4", "")
                                it = it.replace("5", "")
                                it = it.replace("6", "")
                                it = it.replace("7", "")
                                it = it.replace("8", "")
                                it = it.replace("9", "")
                            lb = self.analysis.dic[k]["LB_"][it]
                            ub = self.analysis.dic[k]["UB_"][it]
                            tab = self.create_tab(kk+1)

                            out.append(f"{tab}{self.create_loop(it, f'{lb}', f'{ub}+1')}")
                            nb += 1
                        tab = self.create_tab(len(its)+1)
                        out.append("// write 6")

                        if arr in list(self.nameW[k].keys()):
                            # out.append(f"{tab}{self.nameW[k][arr]}.write({arr});")
                            out.append(f"{tab}{self.nameW[k][arr]}.write({tmp});")
                        for l in range(nb):
                            tab = self.create_tab(len(its)-l)
                            out.append(f"{tab}}}")
                        break
            # FIXME the reuse can be done not totally outermost
            for reuse in self.array_need_reuse[k]:
                if reuse not in self.nameW[k]:
                    continue

                loops = list(self.array_information[reuse]["loop_to_dim"].keys())
                iterator_array = []
                for tmp in self.analysis.dic[k]["read"] + self.analysis.dic[k]["write"]:
                    if reuse in tmp:
                        its = self.extract_iterator(tmp)
                        for kk, it in enumerate(its):
                            iterator_array.append(it)
                        break
                nb = 0
                last_it_loop = ""
                all_loops = []
                for j in range(1, len(self.schedule[k]), 2):
                    loop = int(self.schedule[k][j])
                    if self.iterators[loop] in iterator_array:
                        all_loops.append(loop)
                for g, loop in enumerate(all_loops):
                    it = self.iterators[loop]
                    last_it_loop = it
                    lb = self.LB_[loop]
                    ub = self.UB_[loop]
                    tab = self.create_tab((g-1)//2)

                    out.append(tab +  self.create_loop(it, f"{lb}", f"{ub}+1"))
                    nb += 1
                tab = self.create_tab(len(self.schedule[k])//2 )
                out.append("// write 4\n")

                out.append(f"{tab}{self.nameW[k][reuse]}.write({reuse}{self.reuse_it[k][reuse]});")
                if self.lastWrite[reuse] == k and f"{tab}fifo_{reuse}_to_off_chip.write({reuse}{self.reuse_it[k][reuse]});" not in out:
                    out.append(f"{tab}fifo_{reuse}_to_off_chip.write({reuse}{self.reuse_it[k][reuse]});")
                for j in range(nb):
                        tab = self.create_tab(1-j)
                        out.append(f"{tab}}}")
            self.order_per_loop_body.append(out)



    def compute(self):
        for i, stat in enumerate(self.schedule):
            str_statement = self.statements[i]
            for j in range(1, len(stat), 2):
                loop = int(self.schedule[i][j])
                it = self.iterators[loop]
                lb = self.LB_[loop]
                ub = self.UB_[loop]
                if loop not in [x.value for x in self.list_nodes]:
                    loop_str = self.create_tab((j-1)//2+1) + self.create_loop(it, f"{lb}", f"{ub}+1", self.schedule[i][j]) 
                if j == 1:
                    if loop not in [x.value for x in self.list_nodes]:
                        is_innermost = False
                        if j == len(stat)-2:
                            is_innermost = True
                        # is_reduction = self.analysis.is_reduction(loop)
                        is_reduction = False
                        node = Node(loop, loop_str, self.list_nodes, "Loop", (j-1)//2+1, it, lb, ub, is_innermost, is_reduction)
                        self.tree.add_child(node)
                else:
                    if loop not in [x.value for x in self.list_nodes]:
                        is_innermost = False
                        if j == len(stat)-2:
                            is_innermost = True
                        is_reduction = False
                        node = Node(loop, loop_str, self.list_nodes, "Loop", (j-1)//2+1, it, lb, ub, is_innermost, is_reduction)
                        parent = int(self.schedule[i][j-2])
                        parent_node = [x for x in self.list_nodes if x.value == parent][0]

                        parent_node.add_child(node)
            if ";" not in str_statement:
                str_statement += ";"
            str_statement = self.create_tab((len(stat)-1)//2+1) + str_statement
            node_statement = Node(f"S{i}", str_statement, self.list_nodes, "Statement", (len(stat)-1)//2+1)
            if len(stat) > 1:
                parent_node = [x for x in self.list_nodes if x.value == int(self.schedule[i][-2])][0]
                parent_node.add_child(node_statement)
            else:
                self.tree.add_child(node_statement)
    def create_loop(self, it, lb, ub, id_=None, inc=None):
        str_ = ""
        try:
            ub = eval(ub)
        except:
            try:
                ub = simplify(ub)
            except:
                pass
        try:
            lb = eval(lb)
        except:
            try:
                lb = simplify(lb)
            except:
                pass
        try:
            ub = int(ub)
        except:
            pass
        try:
            lb = int(lb)
        except:
            pass
        if id_ != None:
            if self.pragmas_top:
                for p in self.pragmas[id_].split(";"):
                    if p != "":
                        str_ += f"#pragma ACCEL {p}\n"
        try:
            if int(lb) < 0: # FIXME
                lb = 0
        except:
            lb = 0
        if inc is not None:
            str_ += f"for ( {it} = {lb}; {it} < {ub}; {it}+={inc}) {{\n"
        else:
            str_ += f"for ( {it} = {lb}; {it} < {ub}; {it}++) {{\n"

        if id_ != None:
            if not self.pragmas_top:
                if ";" in self.pragmas[id_]:
                    for p in self.pragmas[id_].split(";"):
                        if p != "":
                            str_ += f"#pragma HLS {p}\n"
        # remove the last \n
        str_ = str_[:-1]
        return str_

    def create_tab(self, nb):
        nb = max(0,nb)
        return self.tab * nb

    def print_ast(self):
        print(self.tree)

    def write_order(self, tree):
        tree.aready_seen = True
        if tree.kind == "Statement":
            if tree.string.split("=")[-1].replace(" ", "") == ";":
                tree.string = tree.string.replace(";", "")
                tree.string = tree.string + "0;"
            self.order.append(tree.string)
        elif tree.kind == "Loop":
            self.order.append(tree.string)
            for child in tree.children:
                if not child.aready_seen:
                    self.write_order(child)
            tab = self.create_tab(tree.depth)
            self.order.append(f"{tab}}}")
        else: # Root
            for child in tree.children:
                self.write_order(child)

    def reinit(self):
        for node in self.list_nodes:
            node.aready_seen = False

    def replace_increment(self, loop, burst_dataflow):
        loop = loop.replace("++", f"+={burst_dataflow}")
        return loop

    def write_order2(self, tree, out, id_stat, depth):
        self.reinit()
        tree.aready_seen = True
        if tree.kind == "Statement":


            str_ = self.transform_statement(tree.string, id_stat, depth)

            out.append(str_)
        elif tree.kind == "Loop":

            out.append(tree.string)
            if depth == (len(self.schedule[id_stat])-1)//2-1:
                out.append("#pragma HLS pipeline II=1")
            for key in list(self.level_read[id_stat].keys()):
                if self.level_read[id_stat][key] == depth:
                    tab = self.create_tab(tree.depth+1)
                    if key in self.array_need_reuse[id_stat]: 
                        if (not self.from_off_chip[id_stat][key] or id_stat == 0):
                            # out.append(f"{tab}if({self.condition[id_stat][key]}){{\n{tab}    {key}{self.reuse_it[id_stat][key]} = {self.nameR[id_stat][key]}.read();\n{tab}}}") # II=1 with 21.1
                            pass
                    else:

                        if key in self.nameR[id_stat]:
                            out.append("// read 1\n")
                            if key in list(self.transfer_totally[id_stat].keys()):
                                continue

                            out.append(f"{tab}{self.data_type} {key} = {self.nameR[id_stat][key]}.read();")
                        else:

                            out.append(f"{tab}{self.data_type} {key};")
            for child in tree.children:
                if not child.aready_seen:
                    self.write_order2(child, out, id_stat, depth+1)

            for key in list(self.level_read[id_stat].keys()):
                if self.level_read[id_stat][key] == depth:
                    tab = self.create_tab(tree.depth+1)
                    if key in self.array_need_reuse[id_stat]:
                        # out.append(f"{tab}if({self.condition[id_stat][key]}){{\n{tab}    {key}{self.reuse_it[id_stat][key]} = {self.nameR[id_stat][key]}.read();\n{tab}}}")
                        pass
                    else:
                        # out.append(f"{tab}{self.data_type} {key} = {self.nameR[id_stat][key]}.read();")
                        if key in self.nameW[id_stat]:
                            tab = self.create_tab(tree.depth+1)
                            if key not in self.transfer_totally[id_stat]:
                                out.append(f"// write 1 {id_stat} {key} ")
                                if key in list(self.array_dont_need_copy_per_schedule.keys()) and id_stat in self.array_dont_need_copy_per_schedule[key]:
                                    continue

                                out.append(f"{tab}{self.nameW[id_stat][key]}.write({key});")
                                if self.lastWrite[key] == id_stat and f"{tab}fifo_{key}_to_off_chip.write({key});" not in out:
                                    out.append(f"{tab}fifo_{key}_to_off_chip.write({key});")

            tab = self.create_tab(tree.depth)
            out.append(f"{tab}}}")
        else: # Root
            for child in tree.children:
                self.write_order2(child, out, id_stat, depth+1)

    def find_divisor(self, n, limit):
        for i in range(max(1, limit), n):
            if n % i == 0:
                return i
        return n



    def transform_statement(self, statement, id_stat, depth):
        # out.append(f"{tab}if({self.condition[id_stat][key]}){{\n{tab}    {key}{self.reuse_it[id_stat][key]} = {self.nameR[id_stat][key]}.read();\n{tab}}}") # II=1 with 21.1
        tab = self.create_tab(depth+1)
        tabp1 = self.create_tab(depth+2)
        str_ = ""

        need_reuse = False
        out, inp = self.extract_array_and_constant(statement)
        op = self.extract_operation(statement)

        for k, inn in enumerate(inp + [out]):
            if inn in self.array_need_reuse[id_stat]:
                need_reuse = True
                break
        
        out, inp = self.extract_array_and_constant(statement, False)
        for k1, inn1 in enumerate([out] + inp):
            for k2, inn2 in enumerate([out] + inp):
                if k2 > k1:
                    if inn1.split("[")[0] == inn2.split("[")[0]:
                        if inn1 != inn2:
                            need_reuse = True
                            break
        out, inp = self.extract_array_and_constant(statement)


        if not need_reuse:

            str_ = f"{tab}"

            if out in self.array_need_reuse[id_stat]:

                str_ += f"{out}{self.reuse_it[id_stat][out]} = "
            else:
                remove_one_op = False

                if out in list(self.transfer_totally[id_stat].keys()) and self.transfer_totally[id_stat][out]:
                    it_arr = self.array_information[out]["iterators"][id_stat][0]
                    out = f"{out}[{']['.join(it_arr)}]"
                if "+=" in statement:
                    str_ += f"{out} += "
                    remove_one_op = True
                elif "-=" in statement:
                    str_ += f"{out} -= "
                    remove_one_op = True
                elif "*=" in statement:
                    str_ += f"{out} *= "
                    remove_one_op = True
                elif "/=" in statement:
                    str_ += f"{out} /= "
                    remove_one_op = True
                else:
                    str_ += f"{out} = "

            if remove_one_op:
                op = op[1:]
            for k, inn in enumerate(inp):

                if inn in list(self.transfer_totally[id_stat].keys()) and self.transfer_totally[id_stat][inn]:
                    id_ = k
                    if remove_one_op:
                        id_ += 1
                    it_arr = self.array_information[inn]["iterators"][id_stat][id_]
                    inn = f"{inn}[{']['.join(it_arr)}]"
                if inn in self.array_need_reuse[id_stat]:
                    str_ += f"{inn}{self.reuse_it[id_stat][inn]}"
                else:
                    str_ += f"{inn}"
                if k < len(op):
                    str_ += " "
                    str_ += op[k]
                    str_ += " "
            str_ += ";"


        else:

            conditions = []
            initialization = []
            already_seen = []
            str_stat = ""

            if out in self.array_need_reuse[id_stat]:
                str_stat += f"{out}{self.reuse_it[id_stat][out]} = "
                cc = self.condition[id_stat][out]
                if cc not in conditions:
                    conditions.append(cc)
                if out not in already_seen:

                    if out in self.nameR[id_stat]:
                        if out not in self.transfer_totally[id_stat]:
                            initialization.append("// read 7\n")
                            initialization.append(f"{tabp1}{out}{self.reuse_it[id_stat][out]} = {self.nameR[id_stat][out]}.read();\n")
                            already_seen.append(out)
            else:
                str_stat += f"{out} = "
            for k, inn in enumerate(inp):
                if inn in self.array_need_reuse[id_stat]:
                    str_stat += f"{inn}{self.reuse_it[id_stat][inn]}"
                    cc = self.condition[id_stat][inn]
                    if cc not in conditions:
                        conditions.append(cc)
                    if inn not in already_seen:
                        if inn in self.nameR[id_stat]:
                            if inn not in self.transfer_totally[id_stat]:
                                initialization.append("// read 8\n")
                                initialization.append(f"{tabp1}{inn}{self.reuse_it[id_stat][inn]} = {self.nameR[id_stat][inn]}.read();\n")
                                already_seen.append(inn)
                else:
                    str_stat += inn
                if k < len(op):
                    str_stat += " "
                    str_stat += op[k]
                    str_stat += " "
            str_stat += ";"

            conds = " && ".join(conditions)
            str_stat_init = "".join(initialization) + tabp1 + str_stat
            str_ += f"{tab}if({conds}){{\n{str_stat_init}\n{tab}}}\n"
            str_ += f"{tab}else{{\n{tab}    {str_stat}\n{tab}}}\n"

        return str_

    def compute_transfer_totally(self, id_stat):
        transfer = {}
        out, inp = self.extract_array_and_constant(self.statements[id_stat], False)
        for k1, inn1 in enumerate([out] + inp):
            for k2, inn2 in enumerate([out] + inp):
                if k2 > k1:
                    if inn1.split("[")[0] == inn2.split("[")[0]:
                        if inn1 != inn2:
                            transfer[inn1.split("[")[0].replace(' ', '')] = True
        return transfer

    def extract_iterator(self, string):
        index = string.find("[")
        string = string[index:]
        string = string.replace("][", "!")
        string = string.replace("[", "")
        string = string.replace("]", "")
        string = string.split("!")
        return string

    def multi_split(self, str_, delimiters, delete_array=False):
        for delim in delimiters:
            str_ = str_.replace(delim, "@")
        res = str_.split("@")

        new_res = []
        for r in res:
            if "[" in r:
                new_res.append(r)
        res = new_res
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
    
    def remove_init_on_chip(self, all_arrays):
        # FIXME need to be sure it is not read before
        self.dont_need_load = []
        for stat in self.statements:
            out, inp = stat.split("=")
            out = out.strip().split("[")[0]
            inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
            if len(inp) == 0:
                if out in all_arrays:
                    all_arrays.remove(out)
                self.dont_need_load.append(out)
        return all_arrays
    
    def multi_split2(self, str_, delimiters, delete_array=False):
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

    def extract_array(self, statement):
        out = statement.split("=")[0]
        out = out.strip().split("[")[0]
        inp = statement.split("=")[1]
        inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
        return out, inp
    
    def extract_array_and_constant(self, statement, remove_bracket=True):
        out = statement.split("=")[0]
        if remove_bracket:
            out = out.strip().split("[")[0]
        else:
            if len(out) > 0 and "]" in out:

                while out[-1] != "]":
                    out = out[:-1]
        inp = statement.split("=")[1]
        inp = self.multi_split2(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], remove_bracket)
        return out, inp
    
    def extract_operation(self, statement):
        op = []
        inside_bracket = False
        for s in statement:
            if s == "[":
                inside_bracket = True
            if s == "]":
                inside_bracket = False
            if not inside_bracket:
                if s in ["+", "-", "*", "/"]:
                    op.append(s)
        return op

    def analyze_reuse(self):
        self.array_use_in_statement = {}
        self.Read = {}
        self.Write = {}
        self.posR = {}
        self.posW = {}
        self.nameR = {}
        self.nameW = {}
        self.lastWrite = {}
        self.from_off_chip = {}
        for id_stat, stat in enumerate(self.statements):
            self.Read[id_stat] = {}
            self.Write[id_stat] = {}
            self.posR[id_stat] = {}
            self.posW[id_stat] = {}
            self.nameR[id_stat] = {}
            self.nameW[id_stat] = {}
            self.from_off_chip[id_stat] = {}
            out, inp = self.extract_array(stat)
            self.array_use_in_statement[out] = []
            self.Write[id_stat][out] = False
            self.Read[id_stat][out] = False
            self.posW[id_stat][out] = -1
            
            for i in inp:
                self.array_use_in_statement[i] = []
                self.Read[id_stat][i] = False
                self.Write[id_stat][i] = False
                self.posR[id_stat][i] = -1
                self.posW[id_stat][i] = -1 # for next task if any
                self.nameR[id_stat][i] = f"fifo_{i}_S{id_stat}"
        for k, stat in enumerate(self.statements):
            out, inp = self.extract_array(stat)
            self.Write[k][out] = True
            if k not in self.array_use_in_statement[out]:
                self.array_use_in_statement[out].append(k)
            for i in inp:
                self.Read[k][i] = True
                if k not in self.array_use_in_statement[i]:
                    self.array_use_in_statement[i].append(k)
        

        for arr in list(self.array_use_in_statement.keys()):
            self.lastWrite[arr] = -1
            for stat in self.Write:
                if arr in self.Write[stat]:
                    if self.Write[stat][arr]:
                        self.lastWrite[arr] = stat


        for arr in list(self.array_use_in_statement.keys()):
            for l in range(len(self.array_use_in_statement[arr])):
                if l==0:
                    self.from_off_chip[self.array_use_in_statement[arr][l]][arr] = False # FIXME
                else:
                    self.from_off_chip[self.array_use_in_statement[arr][l]][arr] = False
        

        for id_stat, stat in enumerate(self.statements):
            for array in list(self.array_use_in_statement.keys()):

                if id_stat in self.array_use_in_statement[array]:
                    if self.array_use_in_statement[array].index(id_stat) != len(self.array_use_in_statement[array])-1:
                        next_stat = self.array_use_in_statement[array][self.array_use_in_statement[array].index(id_stat)+1]
                        self.nameW[id_stat][array] = f"fifo_{array}_S{next_stat}"
                    else:

                        if self.Write[id_stat][array]:
                            self.nameW[id_stat][array] = f"fifo_{array}_to_off_chip"

        statement_after_fifo = {}

        self.condition = {}
        self.reuse_it = {}
        self.reuse_it_total = {}

        for id_stat, stat in enumerate(self.statements):
            self.array_need_reuse[id_stat] = []
            self.level_read[id_stat] = {}
            self.condition[id_stat] = {}
            self.reuse_it[id_stat] = {}
            self.reuse_it_total[id_stat] = {}
            out, inp = self.extract_array(stat)
            statement_after_fifo[id_stat] = ""
            for i in unique_list_in_order(inp+[out]):
                level, need_reuse, cond, reuse_it = self.find_level(id_stat, i)
                if need_reuse:
                    self.array_need_reuse[id_stat].append(i)
                    self.condition[id_stat][i] = cond
                    self.reuse_it[id_stat][i] = reuse_it

                self.level_read[id_stat][i] = level


    def extract_iteration_per_dim(self, stat, array):
        it_per_dim = []
        ss = self.multi_split(stat.replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])
        ss = unique_list_in_order(ss)
        for s in ss:
            # tmp = ["" for k in range(self.array_information[array]["dim"])]
            if f"{array}[" in s:
                index = s.index(f"[")
                s = s[index:]
                s = s.replace("][", "*")
                s = s.replace("[", "")
                s = s.replace("]", "")
                tmp = s.split("*")
                it_per_dim.append(tmp)

        if len(it_per_dim) == 0:
            return []
        return it_per_dim[0]

    def compute_not_copy(self):
        loads = []
        writes = []
        for i, stat in enumerate(self.statements):
            out, inp = stat.split("=")
            out = out.strip().split("[")[0]
            inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
            
            writes += [out]
            loads += inp

        
        #FIXME: delete load if initiatlization on chip

        writes = unique_list_in_order(writes)
        loads = unique_list_in_order(loads)

        # all_arrays = unique_list_in_order(loads + writes)

        all_arrays = unique_list_in_order(loads+writes)
        all_arrays = self.remove_init_on_chip(all_arrays)
        for arr in all_arrays:
            if arr in list(self.array_need_more_than_one_copy.keys()) and self.array_need_more_than_one_copy[arr]:
                if arr in list(self.sched_need_different_copy_par_array.keys()):
                    if len(list(self.sched_need_different_copy_par_array[arr])):
                        statement_arr_present = self.array_information[arr]["statements"]
                        all_arr_diff = []
                        for pos1 in self.sched_need_different_copy_par_array[arr]:
                            for pos2 in pos1:
                                all_arr_diff += [pos2]
                        all_arr_diff = unique_list_in_order(all_arr_diff)
                        # sort
                        all_arr_diff = sorted(all_arr_diff)

                        load_per_stat = []
                        tmp = []
                        for stat in statement_arr_present:
                            if stat in all_arr_diff:
                                if len(tmp)  > 0:
                                    load_per_stat.append(tmp)
                                tmp = []
                            tmp += [stat]
                        if len(tmp) > 0:
                            load_per_stat.append(tmp)
                        self.array_dont_need_copy_per_schedule[arr] = [l[-1] for l in load_per_stat]
    
    def find_level(self, id_stat, array):
        need_reuse = False
        depth = 0
        cond = []
        reuse_it = []

        it = self.extract_iteration_per_dim(self.statements[id_stat], array)

        loops = []
        for l in range(1, len(self.schedule[id_stat]), 2):
            loop = int(self.schedule[id_stat][l])
            loops.append(self.iterators[loop])

        already_seen = [f"{i}" for i in it]
        for k, l in enumerate(loops):

            if l not in it:
                need_reuse = True
                cond.append(f"{l} == 0") # FIXME if does not start at 0
            else:
                already_seen.remove(l)
                reuse_it.append(l)
            if len(already_seen) == 0:
                depth = k
                break

        cond = " && ".join(cond)
        reuse_it = "[" + "][".join(reuse_it) + "]"
        return depth, need_reuse, cond, reuse_it
            



class CodeGeneration:
    def __init__(self, analysis, schedule, array_order, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top):
        self.analysis = analysis
        self.schedule = schedule
        self.UB = UB
        self.LB = LB
        self.UB_ = self.analysis.UB_
        self.LB_ = self.analysis.LB_
        
        self.array_order = array_order
        self.statements = statements
        self.iterators = iterators
        self.output = output
        self.headers = headers
        self.arguments = arguments
        self.name_function = name_function
        self.pragmas = pragmas
        self.pragmas_top = pragmas_top

        self.constants = []
        self.compute_constants()
        self.data_type = "float" # FIXME


        



        self.array_information = {}
        self.pre_treatement_statements()
        self.compute_arrays_information()
        self.array_need_more_than_one_copy = {} # for != statement
        self.sched_need_different_copy_par_array = {}
        self.condition_copy_array_between_statement = {}
        self.array_need_complete_copy_inside_task = {} 
        self.array_need_partial_copy_inside_task = {} 
        self.array_dont_need_copy_per_schedule = {}
        self.compute_array_need_more_than_one_copy()
        self.type = ""
        self.size_arrays = {}
        self.burst_dataflow = {}

        self.tab = "    "
        self.warnings = "\n/*************************************************\n This file was automatically generated by Sisyphus\n*************************************************/\n"
        self.ast = AST(schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top, self.analysis, self.array_need_more_than_one_copy, self.sched_need_different_copy_par_array, self.condition_copy_array_between_statement, self.array_need_complete_copy_inside_task,  self.array_need_partial_copy_inside_task,  self.array_dont_need_copy_per_schedule)

        self.generate_code()
    

    def compute_array_need_more_than_one_copy(self):

        all_arrays = list(self.array_information.keys())

        # self.array_need_more_than_one_copy = {} # for != statement
        # self.array_need_complete_copy_inside_task = {} 
        # self.array_need_partial_copy_inside_task = {} 

        # inside same task
        for arr in all_arrays:
            self.array_need_complete_copy_inside_task[arr] = {}
            self.array_need_partial_copy_inside_task[arr] = {}
            self.array_dont_need_copy_per_schedule[arr] = {}
            polyhedrons = self.array_information[arr]["polyhedron"]
            intersections = self.array_information[arr]["intersection"]
            size_per_dim = self.array_information[arr]["size_per_dim"]
            polyhedron_sizes = self.array_information[arr]["polyhedron_size"]
            access = self.array_information[arr]["access"]

            for id_stat in list(polyhedrons.keys()):
                self.array_need_complete_copy_inside_task[arr][id_stat] = False
                self.array_need_partial_copy_inside_task[arr][id_stat]  = False
                if len(polyhedrons[id_stat]) > 1:
                    for i in range(len(polyhedrons[id_stat])):
                        # access1 = 
                        for j in range(i+1, len(polyhedrons[id_stat])):
                            
                            # if polyhedrons[id_stat][i] != polyhedrons[id_stat][j]:
                            if access[id_stat][i] != access[id_stat][j]:
                                # FIXME not correct
                                try:
                                    access1 = access[id_stat][i]
                                    access2 = access[id_stat][j]
                                    dom1 = self.analysis.dic[id_stat]["constraint"]
                                    dom2 = self.analysis.dic[id_stat]["constraint"]
                                    dom1 = " and ".join(dom1)
                                    dom2 = " and ".join(dom2)
                                    

                                    s1 = isl.Map(f"[i,j] -> {{ {access1} : {dom1} }}")
                                    s2 = isl.Map(f"[i,j] -> {{ {access2} : {dom2} }}")




                                    
                                    if intersections[id_stat][i][j] == min(polyhedron_sizes[id_stat][i], polyhedron_sizes[id_stat][j]):
                                        self.array_need_partial_copy_inside_task[arr][id_stat] = True
                                    else:
                                        if polyhedron_sizes[id_stat][i] != polyhedron_sizes[id_stat][j]:
                                            self.array_need_partial_copy_inside_task[arr][id_stat] = True
                                except:
                                    pass
        # FIXME e.g., trisolv

        # between statements

        for arr in all_arrays:
            self.sched_need_different_copy_par_array[arr] = []
            self.condition_copy_array_between_statement[arr] = {}
            polyhedrons = self.array_information[arr]["polyhedron"]
            intersections = self.array_information[arr]["intersection"]
            size_per_dim = self.array_information[arr]["size_per_dim"]
            polyhedron_sizes = self.array_information[arr]["polyhedron_size"]
            access = self.array_information[arr]["access"]
            for k1, id_stat1 in enumerate(list(polyhedrons.keys())):
                for k2, id_stat2 in enumerate(list(polyhedrons.keys())):
                    if k2 > k1:
                        lp1 = polyhedrons[id_stat1]
                        lp2 = polyhedrons[id_stat2]
                        for k11, p1 in enumerate(lp1):
                            for k22, p2 in enumerate(lp2):
                                try:
                                    access1 = access[id_stat1][k11]
                                    access2 = access[id_stat2][k22]
                                    dom1 = self.analysis.dic[id_stat1]["constraint"]
                                    dom2 = self.analysis.dic[id_stat2]["constraint"]
                                    dom1 = " and ".join(dom1)
                                    dom2 = " and ".join(dom2)

                                    iterators1 = [self.iterators[self.schedule[id_stat1][i]] for i in range(1, len(self.schedule[id_stat1]), 2)]
                                    iterators1_bis = [self.iterators[self.schedule[id_stat1][i]] for i in range(1, len(self.schedule[id_stat1]), 2)]
                                    iterators2 = [self.iterators[self.schedule[id_stat2][i]] for i in range(1, len(self.schedule[id_stat2]), 2)]
                                    iterators2_bis = [self.iterators[self.schedule[id_stat2][i]] for i in range(1, len(self.schedule[id_stat2]), 2)]

                                    it_array1 = self.array_information[arr]["iterators"][id_stat1][k11]
                                    it_array2 = self.array_information[arr]["iterators"][id_stat2][k22]

                                    for i1 in range(len(iterators1)):
                                        if iterators1[i1] in it_array1:
                                            pass
                                        else:
                                            ub = self.UB[self.schedule[id_stat1][i1]]
                                            iterators1[i1] = f"{iterators1[i1]}={ub}"
                                            iterators1_bis[i1] = f"{iterators1_bis[i1]}=0"

                                    for i2 in range(len(iterators2)):
                                        if iterators2[i2] in it_array2:
                                            pass
                                        else:
                                            ub = self.UB[self.schedule[id_stat2][i2]]
                                            iterators2[i2] = f"{iterators2[i2]}={ub}"
                                            iterators2_bis[i2] = f"{iterators2_bis[i2]}=0"


                                    s1 = isl.Set(f"[{ ','.join(iterators1) }] -> {{ {access1} : {dom1} }}")
                                    s1_bis = isl.Set(f"[{ ','.join(iterators1_bis) }] -> {{ {access1} : {dom1} }}")
                                    s2 = isl.Set(f"[{ ','.join(iterators2) }] -> {{ {access2} : {dom2} }}")

                                    s2_bis = isl.Set(f"[{ ','.join(iterators2_bis) }] -> {{ {access2} : {dom2} }}")
                                    
                                    nb1 = s1.count_val().to_str()
                                    nb1_bis = s1_bis.count_val().to_str()
                                    nb2 = s2.count_val().to_str()
                                    nb2_bis = s2_bis.count_val().to_str()

                                    nb1 = max(int(nb1), int(nb1_bis))
                                    nb2 = max(int(nb2), int(nb2_bis))


                                    inter = s1.intersect(s2).to_str()
                                    
                                    if "false" in inter and abs(nb1 - nb2) > 1:
                                        self.array_need_more_than_one_copy[arr] = True
                                        self.sched_need_different_copy_par_array[arr].append([id_stat1, id_stat2])
                                    else:
                                        self.condition_copy_array_between_statement[arr][id_stat1] = []
                                        index_b = inter.index("[")
                                        index_e = inter.index("]")
                                        inter = inter[index_b+1:index_e]
                                        inter = inter.split(",")
                                        for inte in inter:
                                            if "=" in inte or "<" in inte or ">" in inte:
                                                self.condition_copy_array_between_statement[arr][id_stat1].append(inte)
                                except:
                                    pass   

        


    def compute_constants(self):
        for stat in self.statements:

            ss = self.multi_split0(stat.replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])

            ss = unique_list_in_order(ss)

            for s in ss:
                if "[" not in s:
                    if s not in self.constants:
                        self.constants.append(s)

    def create_tab(self, nb):
        nb = max(0,nb)
        return self.tab * nb

    def compute_arrays_information(self):
        all_arrays = []
        for stat in self.statements:
            if "=" in stat:
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
                all_arrays += [out] 
                all_arrays += inp
        all_arrays = unique_list_in_order(all_arrays)
        for arr in all_arrays:
            arr = arr.replace("[", "").replace("]", "")
            self.array_information[arr] = {"size": 0, "type": "", "W": [], "size_burst": 0, "size_vector": 0, "statements": [], "dim": 0, "loop_to_dim": {}, "part_per_dim": [], "size_per_dim": [], "iterators":{}, "polyhedron":{}, "intersection":{}, "polyhedron_size": {}, "access":{}}
            for i, stat in enumerate(self.statements):
                out, inp = stat.split("=")
                out = out.strip().split("[")[0]
                if f"{arr}[" in stat:
                    self.array_information[arr]["statements"].append(i)
                if f"{arr}" in out:
                    self.array_information[arr]["W"].append(i)
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                self.array_information[arr]["iterators"][id_stat] = []
                self.array_information[arr]["polyhedron"][id_stat] = []
                self.array_information[arr]["polyhedron_size"][id_stat] = []
                self.array_information[arr]["access"][id_stat] = []
                self.array_information[arr]["intersection"][id_stat] = []
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                stat = self.statements[id_stat]
                out, inp = self.extract_array_and_constant(stat, False)
                all_ = [out] + inp
                for id_, al_ in enumerate(all_):
                    if al_.split("[")[0] == arr:
                        # it = self.extract_iteration_per_dim(stat, arr)
                        if "[" in al_:
                            it = al_[al_.index("[") + 1:-1].split("][")
                            self.array_information[arr]["iterators"][id_stat].append(it)
                            if ("+=" in stat or "-=" in stat or "*=" in stat or "/=" in stat) and id_ == 0: # output
                                self.array_information[arr]["iterators"][id_stat].append(it)
        for arr in all_arrays:
            for arg in self.arguments:
                if arr in arg:
                    self.array_information[arr]["type"] = arg.split(" ")[0].strip()
                    self.array_information[arr]["size"] = self.extract_size_array(arg)
                    self.array_information[arr]["size_per_dim"] = self.extract_size_array_dim(arg)
                    self.array_information[arr]["dim"] = arg.count("[")
                    self.array_information[arr]["part_per_dim"] = [1 for k in range(self.array_information[arr]["dim"])]
                    break
        for arr in all_arrays:
            for stat in self.array_information[arr]["statements"]:
                it_per_dim = []
                ss = self.multi_split(self.statements[stat].replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])
                ss = unique_list_in_order(ss)
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
                        if it_ in loop_to_it:
                            it_per_dim[i][j] = it_to_loop[it_]
                        

                for pos in range(len(it_per_dim)):
                    for dim in range(len(it_per_dim[pos])):
                        self.array_information[arr]["loop_to_dim"][it_per_dim[pos][dim]] = dim
                for pos in range(len(it_per_dim)):
                    for dim in range(len(it_per_dim[pos])):
                        loop = it_per_dim[pos][dim]
                        if type(loop) == str:
                            continue
                        pragma_loop = self.pragmas[loop]
                        if pragma_loop != [""]:
                            if ";" in pragma_loop:
                                pragma_loop = pragma_loop.split(";")
                                for p in pragma_loop:
                                    if "unroll" in p.lower():
                                        factor = p.split("=")[-1].strip().replace(" ", "")
                                        self.array_information[arr]["part_per_dim"][dim] = max(self.array_information[arr]["part_per_dim"][dim], int(factor))
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                for i, it in enumerate(self.array_information[arr]["iterators"][id_stat]):
                    var1 = []
                    var2 = []
                    cond_arr1 = []
                    cond_arr2 = []
                    for j, it_ in enumerate(it):
                        if it_ != "":
                            if j < len(self.array_information[arr]['size_per_dim'])-1:
                                cond_arr1.append(f"0 <= {it_} < {self.array_information[arr]['size_per_dim'][j]}")
                                var1.append(f"{it_}")
                    cond_arr2 += self.analysis.dic[id_stat]["constraint"]
                    for conf in self.analysis.dic[id_stat]["constraint"]:
                        conf = conf.replace(" ", "").replace("+", "@").replace("-", "@").replace("0", "@").replace("1", "@").replace("2", "@").replace("3", "@").replace("4", "@").replace("5", "@").replace("6", "@").replace("7", "@").replace("8", "@").replace("9", "@").replace("=", "@").replace("<", "@").replace(">", "@")
                        conf = conf.split("@")
                        while "" in conf:
                            conf.remove("")
                        
                        var2 += conf
                    var1 = unique_list_in_order(var1)
                    var2 = unique_list_in_order(var2)
                    var = var1 + var2
                    var = unique_list_in_order(var)
                    cond1 = " and ".join(cond_arr1)
                    cond2 = " and ".join(cond_arr2)
                    # sort var
                    var1 = sorted(var1)
                    var2 = sorted(var2)
                    var = sorted(var)
                    while "" in var:
                        var.remove("")
                    str_1 = f"[{', '.join(var)}] -> {{ [{', '.join(var)}] :{cond1} }}"
                    str_2 = f"[{', '.join(var)}] -> {{ [{', '.join(var)}] :{cond2} }}"
                    try:
                        poly1 = isl.Set(str_1)
                    except:
                        continue
                    

                    try:
                        poly2 = isl.Set(str_2) #domain
                    except:
                        continue

                    poly = {} #poly1.intersect(poly2) 

                    self.array_information[arr]["polyhedron"][id_stat].append(poly)
                    self.array_information[arr]["access"][id_stat].append(f"{arr}[{']['.join(it)}]")
                    # self.array_information[arr]["polyhedron_size"][id_stat].append(int(poly.count_val().to_str()))
                    self.array_information[arr]["polyhedron_size"][id_stat].append(0)
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                self.array_information[arr]["intersection"][id_stat] = {}
                for k1, elmt1 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                    self.array_information[arr]["intersection"][id_stat][k1] = {}
                    for k2, elmt2 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                        if k2!=k1:
                            self.array_information[arr]["intersection"][id_stat][k1][k2] = 0
        for arr in all_arrays:
            for id_stat in range(len(self.statements)):
                for k1, elmt1 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                    for k2, elmt2 in enumerate(self.array_information[arr]["polyhedron"][id_stat]):
                        if k2!=k1:
                            intersection = {} #int(elmt1.intersect(elmt2).count_val().to_str())
                            self.array_information[arr]["intersection"][id_stat][k1][k2] = intersection





    def extract_size_array(self, arg):
        if "[" in arg:
            index = arg.index("[")
            arg = arg[index:]
            arg = arg.replace("][", "*")
            arg = arg.replace("[", "")
            arg = arg.replace("]", "")
            return eval(arg)
        return 1
    
    def extract_size_array_dim(self, arg):
        if "[" in arg:
            index = arg.index("[")
            arg = arg[index:]
            arg = arg.replace("][", "*")
            arg = arg.replace("[", "")
            arg = arg.replace("]", "")
        return arg.split("*")

    def change_type_arguments_to_vector(self, size_vector_for_all_program=None):
        old_arguments = self.arguments
        self.arguments = []
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
                print("not supported for now")
                self.arguments = old_arguments
                continue
            if "[" not in arg: # not an array
                self.arguments += [old_arguments[i]]
                continue
            max_size_burst = 512 // bits
            size_burst = 0
            
            size_vector = 0
            size_array = self.extract_size_array(arg)

            name_array = arg.split(" ")[-1].split("[")[0]
            self.size_arrays[name_array] = size_array


            if size_vector_for_all_program is not None:
                size_burst = size_vector_for_all_program
                size_vector = size_array//size_burst
            else:
                if size_array%16 == 0 and 16 <= max_size_burst:
                    size_burst = 16
                    size_vector = size_array//16
                elif size_array%8 == 0 and 8 <= max_size_burst:
                    size_burst = 8
                    size_vector = size_array//8
                elif size_array%4 == 0 and 4 <= max_size_burst:
                    size_burst = 4
                    size_vector = size_array//4
                elif size_array%2 == 0 and 2 <= max_size_burst:
                    size_burst = 2
                    size_vector = size_array//2
                else:
                    self.arguments += [old_arguments[i]]
                    continue
            self.arguments += [f"float{size_burst} v{old_arguments[i].split(' ')[-1].split('[')[0]}[{size_vector}]"]

    def pre_treatement_statements(self):
        # for i, stat in enumerate(self.statements):
        #     out, inp = stat.split("=")
        #     if "+" in out:
        #         out = out.split("+")[0].strip()
        #         self.statements[i] = f"{out} = {out} + {inp}"
        #     if "-" in out:
        #         out = out.split("-")[0].strip()
        #         self.statements[i] = f"{out} = {out} - {inp}"
        #     if "*" in out:
        #         out = out.split("*")[0].strip()
        #         self.statements[i] = f"{out} = {out} * {inp}"
        #     if "/" in out:
        #         out = out.split("/")[0].strip()
        #         self.statements[i] = f"{out} = {out} / {inp}"
        #FIXME too brutal

        array = []
        for arg in self.arguments:
            if "[" in arg:
                array.append(arg.replace("float", "").replace(" ", "").split("[")[0])
        # remove all call to [0] except if it is an array

        for i, stat in enumerate(self.statements):
            for arr in array:


                self.statements[i] = self.statements[i].replace(f"{arr}[0]", f"AAAA{arr}")
            self.statements[i] = self.statements[i].replace("[0]", "")
            for arr in array:
                self.statements[i] = self.statements[i].replace(f"AAAA{arr}", f"{arr}[0]")


    def multi_split0(self, str_, delimiters, delete_array=False):
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

    def multi_split(self, str_, delimiters, delete_array=False):
        if delete_array:
            new_str = ""
            inside_bracket = False
            for s in str_:
                if s == "[":
                    inside_bracket = True
                if not inside_bracket:
                    new_str += s
                if s == "]":
                    inside_bracket = False
            str_ = new_str

        for delim in delimiters:
            str_ = str_.replace(delim, "@")
        res = str_.split("@")
        # new_res = []
        # for r in res:
        #     if "[" in r:
        #         new_res.append(r)
        # res = new_res
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
    
    def multi_split2(self, str_, delimiters, delete_array=False):
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

    def load(self, arg):
        str_ = f"memcpy(v{arg}, {arg}, {self.size_arrays[arg]}*sizeof({self.type}));\n"
        return str_

    def write(self, arg):
        str_ = f"memcpy({arg}, v{arg}, {self.size_arrays[arg]}*sizeof({self.type}));\n"
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

    def generate_code(self):
        # code = f"Schedule: {self.schedule}, UB: {self.UB}, LB: {self.LB}, Statements: {self.statements}, Iterators: {self.iterators}"
        code = ""
        for header in self.headers:
            code += f"#include <{header}>\n"

        

        code += self.warnings
        code += "\n"
        code += "typedef hls::vector<float,16> float16;\n"
        code += "typedef hls::vector<float,8> float8;\n"
        code += "typedef hls::vector<float,4> float4;\n"
        code += "typedef hls::vector<float,2> float2;\n"
        code += "\n\n"

        old_arguments = self.arguments.copy()


        code += f"\nvoid {self.name_function}({', '.join(self.arguments)}) {{\n\n"

        
        for it in list(set(self.iterators)):
            code += f"{self.tab}int {it};\n"


        loads = []
        writes = []
        for i, stat in enumerate(self.statements):
            out, inp = stat.split("=")
            out = out.strip().split("[")[0]
            inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
            
            writes += [out.replace("+", "").replace("/", "").replace("-", "").replace("*", "").replace(" ", "")]
            loads += inp
        while "" in loads:
            loads.remove("")

        
        #FIXME: delete load if initiatlization on chip

        writes = unique_list_in_order(writes)
        loads = unique_list_in_order(loads)





        for o in self.ast.order:
            code += f"{o}\n"


        code += "}\n"
        
        with open(self.output, "w") as f:
            f.write(code)
        print(f"Code written to {self.output}")

    

    def remove_init_on_chip(self, all_arrays):
        # FIXME need to be sure it is not read before
        self.dont_need_load = []
        for stat in self.statements:
            out, inp = stat.split("=")
            out = out.strip().split("[")[0]
            inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
            if len(inp) == 0:
                all_arrays.remove(out)
                self.dont_need_load.append(out)
        return all_arrays

    def find_cte_declaration(self):
        self.cte_declaration_per_stat = {}
        cte = []
        for k, stat in enumerate(self.statements):
            self.cte_declaration_per_stat[k] = []
            out, inp = stat.split("=")
            out = out.strip().split("[")[0]
            inp = self.multi_split2(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], False)
            for i in inp:
                if "[" not in i or "[0]" in i:
                    

                    i = i.replace("float", "").replace(" ", "")
                    try:
                        ii = i
                        ii = ii.replace("(", "").replace(")", "") 

                        ii = float(ii)
                    except:
                        cte.append(i)
                        self.cte_declaration_per_stat[k].append(i)

        return cte


    def extract_array_and_constant(self, statement, remove_bracket=True):
        out = statement.split("=")[0]
        if remove_bracket:
            out = out.strip().split("[")[0]
        else:
            if len(out) > 0 and "]" in out:

                while out[-1] != "]":
                    out = out[:-1]
        inp = statement.split("=")[1]
        inp = self.multi_split2(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], remove_bracket)
        return out, inp

    def extract_iteration_per_dim(self, stat, array):
        it_per_dim = []
        ss = self.multi_split(stat.replace(";", "").replace(" ", ""), ["+", "-", "*", "/", "="])
        ss = unique_list_in_order(ss)
        for s in ss:
            # tmp = ["" for k in range(self.array_information[array]["dim"])]
            if f"{array}[" in s:
                index = s.index(f"[")
                s = s[index:]
                s = s.replace("][", "*")
                s = s.replace("[", "")
                s = s.replace("]", "")
                tmp = s.split("*")
                it_per_dim.append(tmp)

        if len(it_per_dim) == 0:
            return []
        return it_per_dim[0]