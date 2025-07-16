import ressources as res
import math
from itertools import combinations, product, permutations
import numpy as np
import pocc
import networkx as nx
import matplotlib.pyplot as plt
from collections import deque


# TODO
# for cnn bug for footprint input (there is not + for double index)
# in general bug e.g. CNN you cant reduce footprint by other index than index in left


class memoryBound:

    def __init__(self, res, folder, allow_multiple_transfer, ap_multiple_burst, file, nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top):
        self.res = res
        self.folder = folder
        self.allow_multiple_transfer = allow_multiple_transfer
        self.ap_multiple_burst = ap_multiple_burst
        self.file = file
        self.nlp_file = nlp_file
        self.analysis = analysis
        self.schedule = schedule
        self.cyclic_buffer = False
        self.size_cyclic_buffer = 16
        self.UB = UB
        self.LB = LB
        self.statements = statements
        self.iterators = iterators
        self.output = output
        self.headers = headers
        self.arguments = arguments
        self.name_function = name_function
        self.pragmas = pragmas
        self.pragmas_top = pragmas_top
        self.TC = {}
        self.compute_TC()
        self.inter_task_dependance = {}
        self.compute_inter_task_dependance()
        self.graph = {}
        self.matrix_graph = []
        self.compute_graph()

        self.array_to_focus = self.analysis.array_to_focus

        self.loop_body_independant = {}
        self.compute_loop_body_independant()

        self.info_loops = {}
        self.compute_info_loops()
        
        self.create_nlp()

        # self.compute()

    def bfs(self, start=0):
        visited = set()
        queue = deque([(start, 0)])  # Node and its level
        levels = {start: 0}
        
        while queue:
            node, level = queue.popleft()
            visited.add(node)
            for neighbor, value in enumerate(self.matrix_graph[node]):
                if value == 1 and neighbor not in visited:
                    is_all_dep_done = True
                    for k in range(len(self.matrix_graph)):                         
                        if self.matrix_graph[k][neighbor] == 1 and (k not in visited or levels[k] == level + 1):
                            is_all_dep_done = False
                            break
                    if is_all_dep_done:
                        queue.append((neighbor, level + 1))
                        visited.add(neighbor)
                        levels[neighbor] = level + 1
        level_with_id_statement = {}
        for key in list(levels.keys()):
            level = levels[key]
            if key > 0:
                level_with_id_statement[key-1] = level
        return level_with_id_statement

    def compute_graph(self):
        self.matrix_graph = np.zeros((len(self.schedule)+1, len(self.schedule)+1))
        for k1 in range(len(self.schedule)):
            previous_dependance = False
            for k2 in range(k1):
                if self.inter_task_dependance[k1][k2]:
                    previous_dependance = True

            for k2 in range(len(self.schedule)):
                if self.inter_task_dependance[k1][k2]:
                    if k2 > k1:
                        self.matrix_graph[k1+1][k2+1] = 1

        for k1 in range(len(self.matrix_graph)):
            for k2 in range(len(self.matrix_graph)):
                for k3 in range(len(self.matrix_graph)):
                    if self.matrix_graph[k1][k2] == 1 and self.matrix_graph[k2][k3] == 1:
                        self.matrix_graph[k1][k3] = 0

        # # RAR
        # # FIXME need to check the polyhedron to be sure it is a RAR
        read = {}
        read = {0: []}
        scop = pocc.scop(self.folder, self.file)
        id_statement = 0
        for k,line in enumerate(scop):
            if "# Read access informations" in line:
                k1 = k
                while "# Write access informations" not in line:
                    stat = ""
                    if "##" in line:
                        stat = line.split("##")[1].replace("\n", "").replace("\n", "").split("[")[0]
                    if stat != "":
                        read[id_statement].append(stat)
                    k1+=1
                    line = scop[k1]
                id_statement += 1
                read[id_statement] = []
        
        for sched1 in range(len(self.schedule)):
            for sched2 in range(len(self.schedule)):
                if sched1 < sched2:
                    for arr in read[sched1]:
                        if arr in read[sched2]:
                            cycle = False
                            for k in range(len(self.schedule)):
                                if self.matrix_graph[min(k+1, sched2+1)][max(k+1, sched2+1)] == 1 and self.matrix_graph[min(k+1, sched1+1)][max(k+1, sched1+1)] == 1:
                                    cycle = True
                                    break
                            if not cycle:
                                self.matrix_graph[sched1+1][sched2+1] = 1

        for k1 in range(len(self.schedule)):
            column_sum = 0
            for k2 in range(len(self.schedule)):
                column_sum += self.matrix_graph[k2+1][k1+1]
            if column_sum == 0:
                self.matrix_graph[0][k1+1] = 1
        
        G = nx.DiGraph()
        G.add_node("Root")
        for i in range(len(self.schedule)):
            G.add_node(f"S{i}")
        for i in range(len(self.matrix_graph)):
            for j in range(len(self.matrix_graph[0])):
                if self.matrix_graph[i][j] == 1:
                    node_i = ""
                    node_j = ""
                    if i == 0:
                        node_i = "Root"
                    else:
                        node_i = f"S{i-1}"
                    if j == 0:
                        node_j = "Root"
                    else:
                        node_j = f"S{j-1}"
                    G.add_edge(node_i, node_j)

        # Plot the graph
        pos = nx.spring_layout(G)  # positions for all nodes
        nx.draw(G, pos, with_labels=True, arrows=True)
        # save
        plt.savefig("graph.png")


    def compute_inter_task_dependance(self):
        # init
        for k1 in range(len(self.statements)):
            self.inter_task_dependance[k1] = {}
            for k2 in range(len(self.statements)):
                self.inter_task_dependance[k1][k2] = False

        res = pocc.candl(self.folder, self.file)
        for line in res:
            # if "RAW" in line or "WAR" in line or "WAW" in line:
            if "RAW" in line :
                id_1 = int(line.split("->")[0].replace("S", "").replace(" ", ""))
                id_2 = int(line.split("->")[1].split("[")[0].replace("S", "").replace(" ", ""))
                self.inter_task_dependance[min(id_1, id_2)][max(id_1, id_2)] = True
                # self.inter_task_dependance[id_2][id_1] = True


    def compute_TC(self):
        id_loop = 0
        for id_ in range(len(self.schedule)):
            TC = self.analysis.dic[id_]["TC"]
            for key in list(TC.keys()):
                self.TC[id_loop] = TC[key]
                id_loop += 1
    def compute_other_loops(self, id_):
        others_loops = []
        for id_2 in range(len(self.schedule)):
            if id_2 != id_:
                loops_2 = self.schedule[id_2][1::2]
                others_loops += loops_2
        others_loops = list(set(others_loops))
        return others_loops
    
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
    
    def extract_array(self, statement):
        out = statement.split("=")[0]
        out = out.strip().split("[")[0]
        inp = statement.split("=")[1]
        inp = self.multi_split(inp.strip().replace(";", "").replace(" ", ""), ["+", "-", "*", "/"], True)
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

    def compute_loop_body_independant(self):
        for id_ in range(len(self.schedule)):
            is_independant = True
            loops = self.schedule[id_][1::2]
            others_loops = self.compute_other_loops(id_)
            for loop in loops:
                if loop in others_loops:
                    is_independant = False
                    break
            self.loop_body_independant[id_] = is_independant

    def extract_iterators(self, out):
        iterators = []
        if "[" in out:
            it = out[out.index("[")+1:]
            iterators = it.replace("][", "@").replace("]", "").split("@")

        return iterators

    def compute_info_loops(self):
        self.red_loop = {}
        for id_ in range(len(self.schedule)):
            loops = self.schedule[id_][1::2]
            for loop in loops:
                self.red_loop[loop] = False
        for id_ in range(len(self.schedule)):
            loops = self.schedule[id_][1::2]
            for loop in loops:
                it = self.extract_iterators(self.analysis.dic[id_]["write"][0])
                if self.iterators[loop] not in it:
                    self.red_loop[loop] = True
        
        for id_ in range(len(self.schedule)):
            loops = self.schedule[id_][1::2]
            info_loops = {}
            statement = self.statements[id_]
            out, inp = self.extract_array(statement)
            op = self.extract_operation(statement)

            info_loops["write"] = self.analysis.dic[id_]["write"]
            it = self.extract_iterators(self.analysis.dic[id_]["write"][0])
            reduction_loop = {}
            for loop in loops:
                reduction_loop[loop] = False
                if self.iterators[loop] not in it:
                    reduction_loop[loop] = True
            info_loops["reduction_loop"] = reduction_loop
            info_loops["read"] = self.analysis.dic[id_]["read"]
            info_loops["operation"] = self.analysis.operations[id_]
            info_loops["arrays_size"] = self.analysis.arrays_size
            self.info_loops[id_] = info_loops

    def give_index(self, l, val, index):
        first_index = l.index(val)
        if index == first_index:
            return 0
        else:
            return 1

    def change_TC(self, TC):
        current_burst = 16
        if TC%16==0:
            current_burst = 16
        elif TC%8==0:
            current_burst = 8
        elif TC%4==0:
            current_burst = 4
        elif TC%2==0:
            current_burst = 2
        else:
            current_burst = 1
        
        original = TC / current_burst
        
        new_TC = 0
        for k in range(TC, 10*TC):
            if k%16==0:
                new_TC = k
                break
        new = new_TC / 16
        if new < original:
            return True, new_TC
        else:
            return False, new_TC
        

    def what_is_fuse(self):
        l = []
        all_output = {}
        for k,s in enumerate(self.statements):
            output = s.split("=")[0].split("[")[0].strip()
            if output not in list(all_output.keys()):
                all_output[output] = []
            all_output[output].append(k)

        return list(all_output.values())

    def first_use(self, array):
        for id_sched in range(len(self.schedule)):
            r = self.analysis.dic[id_sched]["read"]
            w = self.analysis.dic[id_sched]["write"]
            randw = r + w
            for r in randw:
                if array in r:
                    return id_sched
        return -1

    def all_use(self, array):
        l = []
        for id_sched in range(len(self.schedule)):
            r = self.analysis.dic[id_sched]["read"]
            w = self.analysis.dic[id_sched]["write"]
            randw = r + w
            for r in randw:
                if array in r:
                    l += [id_sched]
        return l

    def give_it_loop(self, arr, fused_task, name_var_footprint_fused):
        it_array = ""
        coresponding_loop = []
        for task2 in fused_task:
            if arr in list(name_var_footprint_fused[task2].keys()):
                r = self.info_loops[task2]["read"]
                w = self.info_loops[task2]["write"]
                randw = r + w
                for r in randw:
                    if arr in r:
                        it_array = self.extract_iterators(r)
                        cur_loop = self.schedule[task2][1::2]
                        for loop in cur_loop:
                            for it in it_array:
                                if self.iterators[loop] == it:
                                    coresponding_loop.append(loop)
                        return it_array, coresponding_loop, task2
        return -1


    def calculate_latency(self, node, dependencies, latency, shifts, memo):
        if node in memo:
            return memo[node]
        
        if not dependencies[node]:  # If there are no dependencies
            memo[node] = latency[node]
            return latency[node]
        
        dependency_latencies = []
        for dep in dependencies[node]:
            dep_latency = self.calculate_latency(dep, dependencies, latency, shifts, memo)
            shift = shifts.get((dep, node), "0")
            dependency_latencies.append(f"{shift} + {latency[node]}, {dep_latency}")
        
        if dependency_latencies:
            max_dependency_latency = f"max({', '.join(dependency_latencies)})"
        else:
            max_dependency_latency = latency[node]
        
        total_latency = max_dependency_latency
        memo[node] = total_latency
        return total_latency

    def add_parameters(self):
        param = [f"DSP_avail = {self.res.DSP};", f"ON_CHIP_MEM_SIZE = {self.res.ON_CHIP_MEM_SIZE};", f"MAX_BUFFER_SIZE = {self.res.MAX_BUFFER_SIZE};", f"CONSTRAINT_ARRAY_PARTITIONING_VALUE = {self.res.partitioning_max};", f"MAX_UF = {self.res.MAX_UF};"]
        for nb_slr in range(self.res.SLR):
            param.append(f"SLR{nb_slr}_mem = {self.res.MEM_PER_SLR};")
            param.append(f"SLR{nb_slr}_DSP = {self.res.DSP_per_SLR};")
            
        for k in range(len(self.schedule)):
            param.append(f"II_S{k}_par = 1;")
            param.append(f"II_S{k}_seq = 3;")
        
        for k in list(self.TC.keys()):
            tc = []
            param.append(f"TC{k}_ori = {self.TC[k]};")
        
        for k in range(len(self.schedule)):
            op = self.analysis.operations[k]
            loops = self.schedule[k][1::2]
            is_red = False
            for loop in loops:
                if self.red_loop[loop]:
                    is_red = True
                    break

            #FIXME suppose the red is + for now
            seq = 0
            par = 0
            if is_red:
                seq = 1 * self.res.IL["+"]
            for o in op:
                if o == "+":
                    nb = op[o]
                    if is_red:
                        nb -= 1
                    par += nb * self.res.IL["+"]
                elif o == "-":
                    nb = op[o]
                    par += nb * self.res.IL["-"]
                elif o == "*":
                    nb = op[o]
                    par += nb * self.res.IL["*"]
                elif o == "/":
                    nb = op[o]
                    par += nb * self.res.IL["/"]

            if par == 0:
                par = 1 # assignement
            if par < 0:
                par = 0
            if seq < 0:
                seq = 0
            param.append(f"IL_par_S{k} = {par};")
            param.append(f"IL_seq_S{k} = {seq};")

        DSP_used = {}
        for k in range(len(self.schedule)):
            dsp_used = 0
            DSP_used[k] = 0
            op = self.analysis.operations[k]
            for o in op:
                if o == "+":
                    nb = op[o]
                    dsp_used += nb * self.res.DSP_per_operation["+"]
                elif o == "-":
                    nb = op[o]
                    dsp_used += nb * self.res.DSP_per_operation["-"]
                elif o == "*":
                    nb = op[o]
                    dsp_used += nb * self.res.DSP_per_operation["*"]
                elif o == "/":
                    nb = op[o]
                    dsp_used += nb * self.res.DSP_per_operation["/"]
            DSP_used[k] = dsp_used
            param.append(f"DSP_S{k} = {dsp_used};")

        return param

    def add_variables(self):
        var = []

        for k in list(self.TC.keys()):
            tc = []
            tc_ori = self.TC[k]
            tc_ori_16 = 1
            for j in range(tc_ori, tc_ori*16):
                if j % 16 == 0:
                    tc_ori_16 = j
                    break
            var.append(f"TC{k} integer >= {tc_ori} <= {tc_ori_16};")

        what_is_fuse = self.what_is_fuse()
        for k in range(len(what_is_fuse)):
            for id_slr in range(self.res.SLR):
                var.append(f"is_fused_task{k}_in_SLR_{id_slr} binary;")
        return var
        


    def create_nlp(self):

        var = self.add_variables()
        constraints = []
        obj = []
        comments = []
        tot_buffer = []
        tot_buffer_per_fused_task = {}
        obj_latency_computation = []
        param = self.add_parameters()

        perms = {}

        what_is_fuse = self.what_is_fuse()
        for is_fuse in what_is_fuse:
            comments.append(f"Fuse {is_fuse}")

        for nb_slr in range(self.res.SLR):
            var.append(f"is_slr{nb_slr}_used binary;")

        
            
        for id_slr in range(self.res.SLR):
            cons = []
            for k in range(len(what_is_fuse)):
                cons.append(f"is_fused_task{k}_in_SLR_{id_slr}")
            constraints.append(f"is_slr{id_slr}_used = min(1,{' + '.join(cons)});")


        for k in range(len(what_is_fuse)):
            cons = []
            for id_slr in range(self.res.SLR):
                cons.append(f"is_fused_task{k}_in_SLR_{id_slr}")
            constraints.append(f"{' + '.join(cons)} = 1; # only one SLR for fused task {k}")


        

        write_dic = {}
        what_statement_should_write = []
        ll_array = []
        for k in range(len(self.schedule)):
            w = self.analysis.dic[k]["write"][0]
            array = w.split("[")[0]
            write_dic[k] = array
            ll_array.append(array)
        ll_array = list(set(ll_array))
        for array in ll_array:
            last_one = 0
            for k in range(len(self.schedule)):
                if write_dic[k] == array:
                    last_one = k
            what_statement_should_write.append(last_one)        
            comments.append(f"Task {last_one} writes {array} to off-chip")

        lat_comp_per_stat = {}

        for k in range(len(self.schedule)):
            str_ = f"Statement {k}: {self.statements[k]}"
            if str_ not in comments:
                comments.append(str_)

        for k in range(len(self.iterators)):
            str_ = f"Loop_{k}: {self.iterators[k]}"
            if str_ not in comments:
                comments.append(str_)

        for k in range(len(self.arguments)):
            str_ = f"Argument {k}: {self.arguments[k]}"
            if str_ not in comments:
                comments.append(str_)
        

        for k in range(len(self.schedule)):
            perms[k] = []
            loops = self.schedule[k][1::2]
            all_perms = []
            all_perms1 = list(permutations(loops))  # for the two splited loops
            # all_perms2 = list(permutations(loops))  # for the two splited loops
            # for perm1 in all_perms1:
            #     for perm2 in all_perms2:
            #         all_perms.append(perm1 + perm2)
            all_perms = all_perms1.copy()
            # all_perms_ = list(permutations(loops + loops))
            # for perm in all_perms_:
            #     if perm not in all_perms:
            #         all_perms.append(perm)
            possibilities = []
            curr_cons = []
            tot_latency = []

            

            for i, perm in enumerate(all_perms):
                perms[k].append(perm)
                perm_str = [k]
                
                for p in perm:
                    perm_str.append(p)
                    perm_str.append(0)

                # for second tile level
                for p in perm:
                    perm_str.append(p)
                    perm_str.append(0)

                var.append(f"perm{i}_S{k} binary; # {perm_str}")
                possibilities.append(f"perm{i}_S{k}")
                curr_loop = list(perm)

                curr_TC = []
                last_loop = curr_loop[-1]
                if self.red_loop[last_loop]:
                    II = f"II_S{k}_seq"
                else:
                    II = f"II_S{k}_par"
                
                for r, loop in enumerate(curr_loop[:-1]):
                    curr_TC.append(f"TC{loop}_{self.give_index(curr_loop, loop, r)}")

                tot_latency += [f"perm{i}_S{k} * (IL_par_S{k} + IL_seq_S{k} + {II} * (TC{last_loop}_1 - 1)) * {' * '.join(curr_TC)}"]
                


                next_statements = []
                arr_dep_for_each_statement = []
                succesors = False
                for k2 in range(len(self.matrix_graph)):
                    if k2 > k:
                        if self.matrix_graph[k+1][k2]==1:
                            succesors = True
                            next_statements.append(k2-1)
                            curr_arr_dep_for_each_statement = []
                            read_k = self.info_loops[k]["read"]
                            write_k = self.info_loops[k]["write"]
                            read_k2 = self.info_loops[k2-1]["read"]
                            write_k2 = self.info_loops[k2-1]["write"]

                            # randw_k = read_k + write_k
                            randw_k2 = read_k2 + write_k2
                            randw_k = write_k
                            # randw_k2 =  write_k2

                            for r_k in randw_k:
                                for r_k2 in randw_k2:
                                    if r_k.split("[")[0] == r_k2.split("[")[0]:
                                        
                                        if r_k.split("[")[0] not in curr_arr_dep_for_each_statement:
                                            curr_arr_dep_for_each_statement.append(r_k.split("[")[0])
                                            same_fused_task = False
                                            for fused_task in what_is_fuse:
                                                if k in fused_task and k2-1 in fused_task:
                                                    same_fused_task = True
                                                    break
                                            if not same_fused_task:
                                                str_1 = f"Task {k} gives {r_k.split('[')[0]} to Task {k2-1}"
                                                str_2 = f"Task {k2-1} received {r_k.split('[')[0]} from Task {k}"
                                                if str_1 not in comments:
                                                    comments.append(str_1)
                                                if str_2 not in comments:
                                                    comments.append(str_2)
                                                # we need to force the tiling factor to be the same:
                                                loops_1 = self.schedule[k][1::2]
                                                loops_2 = self.schedule[k2-1][1::2]

                                                it_1 = []
                                                it_2 = []

                                                l_1_per_dim = []
                                                l_2_per_dim = []

                                                w_1 = self.info_loops[k]["write"]
                                                w_2 = self.info_loops[k2-1]["write"]
                                                r_1 = self.info_loops[k]["read"]
                                                r_2 = self.info_loops[k2-1]["read"]

                                                for r__1 in r_1+w_1:
                                                    if r_k.split("[")[0] in r__1:
                                                        it_1 = self.extract_iterators(r__1)
                                                        break
                                                for r__2 in r_2+w_2:
                                                    if r_k2.split("[")[0] in r__2:
                                                        it_2 = self.extract_iterators(r__2)
                                                        break
                                                
                                                for it__1 in it_1:
                                                    for l_1 in loops_1:
                                                        if self.iterators[l_1] == it__1:
                                                            if not self.red_loop[l_1]:
                                                                l_1_per_dim.append(l_1)
                                                                break
                                                            else:
                                                                l_1_per_dim.append(-1)
                                                                break

                                                for it__2 in it_2:
                                                    for l_2 in loops_2:
                                                        if self.iterators[l_2] == it__2:
                                                            if not self.red_loop[l_2]:
                                                                l_2_per_dim.append(l_2)
                                                                break
                                                            else:
                                                                l_2_per_dim.append(-1)
                                                                break
                                                try:
                                                    for dd in range(len(l_1_per_dim)):
                                                        if l_1_per_dim[dd] != -1 and l_2_per_dim[dd] != -1:
                                                            constraints.append(f"TC{l_1_per_dim[dd]}_1 = TC{l_2_per_dim[dd]}_1; # same tiling factor")
                                                except:
                                                    pass   
                                                            


                                                
                                            # comments.append(f"Task {k} gives {r_k.split('[')[0]} to Task {k2-1}")
                                            # comments.append(f"Task {k2-1} received {r_k.split('[')[0]} from Task {k}")
                            arr_dep_for_each_statement.append(curr_arr_dep_for_each_statement)

                            # if f"Lat_comp_S{k}_for_S{k2-1} >= 0;" not in var:
                            #     var.append(f"Lat_comp_S{k}_for_S{k2-1} >= 0;")
                            #     var.append(f"debit_S{k}_to_S{k2-1}  >= 0;")
                            #     var.append(f"debit_S{k2-1}_from_S{k}  >= 0;")

                            arrays_to_give = []
                            is_write_in_the_current_statement = False

                            for r_k in randw_k:
                                for r_k2 in randw_k2:
                                    if r_k.split("[")[0] == r_k2.split("[")[0]:
                                        if r_k in write_k:
                                            is_write_in_the_current_statement = True
                                        if r_k.split("[")[0] not in arrays_to_give:
                                            arrays_to_give.append(r_k.split("[")[0])

                            for j, cl in enumerate(curr_loop):
                                shift = ""
                                if self.red_loop[cl]:
                                    # shift += np.prod([self.TC[cl_] for cl_ in curr_loop[j:]])
                                    shift += " * ".join([f"TC{cl_}_0" for cl_ in curr_loop[j:]])
                                    break
                            curr_cons = ["0"]

                            if f"Lat_comp_S{k}_for_S{k2-1}" not in list(lat_comp_per_stat.keys()):
                                if len(shift) > 0:
                                    lat_comp_per_stat[f"Lat_comp_S{k}_for_S{k2-1}"] = [f"perm{i}_S{k} * {shift}" ]
                                else:
                                    lat_comp_per_stat[f"Lat_comp_S{k}_for_S{k2-1}"] = [f"perm{i}_S{k}" ]
                            else:
                                if len(shift) > 0:
                                    lat_comp_per_stat[f"Lat_comp_S{k}_for_S{k2-1}"] += [f"perm{i}_S{k} * {shift}" ]
                                else:
                                    lat_comp_per_stat[f"Lat_comp_S{k}_for_S{k2-1}"] += [f"perm{i}_S{k}" ]
                            # constraints.append(f"{key} = {' + '.join(lat_comp_per_stat[key])}; # stall between task")
                if not succesors:
                    if f"Lat_comp_S{k}_for_off_chip >= 0;" not in var:
                        var.append(f"Lat_comp_S{k}_for_off_chip >= 0;")
                    array_to_write = self.info_loops[k]["write"][0]
                    name_array = array_to_write.split("[")[0]
                    it = self.extract_iterators(array_to_write)
                    
                    shift = []
                    for j, loop in enumerate(curr_loop):
                        
                        if self.red_loop[loop]:
                            shift += [f"TC{cl_}_{self.give_index(curr_loop[j:], cl_, g)}" for g, cl_ in enumerate(curr_loop[j:])]
                            break
                    last_loop = curr_loop[-1]
                    if self.red_loop[last_loop]:
                        shift += [f"II_S{k}_seq"]
                    else:
                        shift += [f"II_S{k}_par"]

                    # IO
                    read = self.info_loops[k]["read"]
                    write = self.info_loops[k]["write"]
                    randw = read + write
                    io_ = []
                    for r in randw:
                        its = self.extract_iterators(r)
                        for it in its:
                            for ll in curr_loop:
                                if self.iterators[ll] == it:
                                    io_ += [f"TC{ll}"]
                                    break

                    time_btw_copy = []

                    # shift = f"max(1, {shift})"
                    if f"Lat_comp_S{k}_for_off_chip" not in list(lat_comp_per_stat.keys()):
                        lat_comp_per_stat[f"Lat_comp_S{k}_for_off_chip"] = [f"perm{i}_S{k} * {' * '.join(shift)}" ]
                    else:
                        lat_comp_per_stat[f"Lat_comp_S{k}_for_off_chip"] += [f"perm{i}_S{k} * {' * '.join(shift)}" ]

                for j, cl in enumerate(curr_loop):
                    shift = 0
                    if self.red_loop[cl]:
                        shift += np.prod([self.TC[cl_] for cl_ in curr_loop[j:]])
                        break

                

                curr_cons.append(f"perm{i}_S{k} * {shift}")




            # constraints.append(f"Lat_comp_S{k} = {' + '.join(curr_cons)}; # stall between task")
            constraints.append(f"{' + '.join(possibilities)} = 1; # only one permutation")
            # constraints.append(f"tot_latency_S{k} = {' + '.join(tot_latency)}; # total latency of the task")
        


        # DONE intra-tile latency
        for k in range(len(self.schedule)):
            var.append(f"Lat_comp_S{k}_intra_tile >= 0;")
            loops = self.schedule[k][1::2]
            red_prod = []
            for loop in loops:
                if self.red_loop[loop]:
                    red_prod.append(f"TC{loop}_1")
            if len(red_prod) > 0:
                constraints.append(f"Lat_comp_S{k}_intra_tile = IL_par_S{k} + IL_seq_S{k} * log({' * '.join(red_prod)})/log(2); # latency of the intra-tile S{k}")
            else:
                constraints.append(f"Lat_comp_S{k}_intra_tile = IL_par_S{k} + IL_seq_S{k}; # latency of the intra-tile S{k}")



        # TODO constraint on perm for fused task
        # fuse task have the same output
        to_zero = []
        for id_fused_task, fused_task in enumerate(what_is_fuse):
            list_iterator_of_output = []
            for task in fused_task:
                list_iterator_of_output.append(self.extract_iterators(self.info_loops[task]["write"][0]))
            
            # we need output stationnary
            n = len(list_iterator_of_output[0]) # number of dimension of output
            for j, task in enumerate(fused_task):
                loop_iterate_output = list_iterator_of_output[j]
                loops = self.schedule[task][1::2]
                loops_which_iterate = []
                for l in loops:
                    if self.iterators[l] in loop_iterate_output:
                        loops_which_iterate.append(l)
                loops_which_iterate.sort()
                for id_perm, pp in enumerate(perms[task]):
                    begin_perm = list(pp[:len(loops_which_iterate)])
                    begin_perm.sort()
                    if begin_perm == loops_which_iterate:
                        pass
                    else:
                        constraints.append(f"perm{id_perm}_S{task} = 0; # because of the fused task {id_fused_task}")
                        to_zero.append(f"perm{id_perm}_S{task}")
            
        # fused_task should have same schedule to iterate output
        for id_fused_task, fused_task in enumerate(what_is_fuse):
            output_nb_dim = self.info_loops[fused_task[0]]["write"][0].count("[")
            pos_it = [d for d in range(output_nb_dim)]
            # factorielle
            all_pos_it = list(permutations(pos_it))
            for pp in all_pos_it:
                matched = []
                for task in fused_task:
                    for id_perm, perm in enumerate(perms[task]):
                        if f"perm{id_perm}_S{task}" not in to_zero:
                            convert_to_output_order = []
                            it = self.extract_iterators(self.info_loops[task]["write"][0])
                            for id_loop, loop in enumerate(perm):
                                for r, it_ in enumerate(it):
                                    if self.iterators[loop] == it_:
                                        it[r] = id_loop
                            if it == list(pp[:len(it)]):
                                matched.append(f"perm{id_perm}_S{task}")
                if len(matched) > 1:
                    all_pair = list(combinations(matched, 2))
                    for pair in all_pair:
                        # FIXME bbug for same statement
                        stat1 = pair[0].split("_")[1]
                        stat2 = pair[1].split("_")[1]
                        if stat1 != stat2:
                            constraints.append(f"{pair[0]} = {pair[1]}; # same iteration of output in FT {id_fused_task}")

        arr_per_stat_fused = {}
        for key in list(self.analysis.dic.keys()):
            read = self.analysis.dic[key]["read"]
            write = self.analysis.dic[key]["write"]
            
            # reduce in order
            randw = []
            for r in read:
                if r not in randw:
                    randw.append(r)
            for w in write:
                if w not in randw:
                    randw.append(w)
            for r in randw:
                it = self.extract_iterators(r)
                tc = []
                for loop in self.schedule[key][1::2]:
                    if self.iterators[loop] in it:
                        tc += [f"TC{loop}_1"]
                if len(tc)>0:
                    r = r.split("[")[0]
                    if r not in list(arr_per_stat_fused.keys()):
                        arr_per_stat_fused[r] = []
                    arr_per_stat_fused[r] += [key]
        name_var_footprint_fused = {}
        for fused_task in what_is_fuse:
            for task in fused_task:
                name_var_footprint_fused[task] = {}
                for arr in list(arr_per_stat_fused.keys()):
                    if task in arr_per_stat_fused[arr]:
                        name_var_footprint_fused[task][arr] = ""

        for id_fused_task, fused_task in enumerate(what_is_fuse):
            array_in_commun = {}
            for arr in list(arr_per_stat_fused.keys()):
                iterate_arr = arr_per_stat_fused[arr]
                if len(iterate_arr) == 1 and iterate_arr[0] in fused_task:
                    array_in_commun[arr] = arr_per_stat_fused[arr]
                else:
                    for ite in iterate_arr:
                        if ite in fused_task:
                            if arr not in array_in_commun:
                                array_in_commun[arr] = []
                            array_in_commun[arr].append(ite)
            for arr in list(array_in_commun.keys()):
                name = ""
                for n in array_in_commun[arr]:
                    name += f"S{n}_"
                name = name[:-1]
                tot_buffer += [f"footprint_{arr}_{name}_reuse"]
                if id_fused_task not in list(tot_buffer_per_fused_task.keys()):
                    tot_buffer_per_fused_task[id_fused_task] = []
                tot_buffer_per_fused_task[id_fused_task].append(f"footprint_{arr}_{name}_reuse")
                

                for n in range(len(array_in_commun[arr])):
                    name_var_footprint_fused[array_in_commun[arr][n]][arr] = f"footprint_{arr}_{name}"
                var.append(f"footprint_{arr}_{name} integer >= 0;")
                var.append(f"footprint_{arr}_{name}_reuse integer >= 0;")

        #per SLR
        for id_slr in range(self.res.SLR):
            cons = []
            for id_fused_task, fused_task in enumerate(what_is_fuse):
                cons_str = f"is_fused_task{id_fused_task}_in_SLR_{id_slr} * ("
                cons_str += " + ".join(tot_buffer_per_fused_task[id_fused_task])
                cons_str += ")"
                cons.append(cons_str)
            constraints.append(f"{' + '.join(cons)} <= SLR{id_slr}_mem; # memory constraint per SLR")
                
        ###
        
        for id_fused_task, fused_task in enumerate(what_is_fuse):
            name = ""
            for task in fused_task:
                name += f"S{task}_"
            name = name[:-1]
            var.append(f"Lat_comp_fused_{name} >= 0;")
            lat = []

            # for now it is reduce to parallel loop
            max_loop = 0
            max_loop = len(self.extract_iterators(self.info_loops[fused_task[0]]["write"][0]))
            # for task in fused_task:
            #     loops = self.schedule[task][1::2]
            #     if len(loops) > max_loop:
            #         max_loop = len(loops)


            all_array_for_this_fused_task = []
            for task in fused_task:
                tmp_lat = ["Lat_comp_S"+str(task)+"_intra_tile"]
                all_array_for_this_task = []
                it_for_this_task = {}
                read = self.info_loops[task]["read"]
                write = self.info_loops[task]["write"]
                randw = read + write
                # loops which iterate output can't be pipeline
                for r in randw:
                    if "[0]" in r or "[" not in r:
                        pass
                    elif r.split("[")[0] not in all_array_for_this_task:
                        all_array_for_this_task.append(r.split("[")[0])
                        if r.split("[")[0] not in all_array_for_this_fused_task:
                            all_array_for_this_fused_task.append(r.split("[")[0])
                        if r.split("[")[0] not in list(it_for_this_task.keys()):
                            it_for_this_task[r.split("[")[0]] = {}
                        it = self.extract_iterators(r)
                        it_for_this_task[r.split("[")[0]][task] = it
                
                for arr in all_array_for_this_task:
                    l1 = []
                    l2 = []
                    no_reuse = True

                    it = it_for_this_task[arr][task]
                    for loop in self.schedule[task][1::2][:max_loop]:
                        if self.iterators[loop] not in it:
                            no_reuse = False
                            break

                    for nb in range(max_loop+1):
                        str_1 = f"level_transfer_{arr}_FT{id_fused_task}_under{nb} binary;" # for latency
                        # 0 it is full transfer
                        # 1 under first loop
                        # etc
                        str_2 = f"level_reuse_{arr}_FT{id_fused_task}_under{nb} binary;" # for mem on chip
                        if str_1 not in var:
                            var.append(str_1)
                            l1 += [f"level_transfer_{arr}_FT{id_fused_task}_under{nb}"]
                        if str_2 not in var:
                            var.append(str_2)
                            l2 += [f"level_reuse_{arr}_FT{id_fused_task}_under{nb}"]
                        l_ = []
                        for nb2 in range(nb+1):
                            l_.append(f"level_reuse_{arr}_FT{id_fused_task}_under{nb2}")
                        # if arr in write[0] or no_reuse:
                        if no_reuse:
                            constraints.append(f"level_reuse_{arr}_FT{id_fused_task}_under{nb} = level_transfer_{arr}_FT{id_fused_task}_under{nb}; # reuse level have to be outermost or equal to transfer")
                        else:
                            constraints.append(f"{' + '.join(l_)} >= level_transfer_{arr}_FT{id_fused_task}_under{nb}; # reuse level have to be outermost or equal to transfer")
                        
                        if arr in write[0]:
                            cst = f"level_reuse_{arr}_FT{id_fused_task}_under{max_loop} = 1; # transfer innermost for output"
                            if cst not in constraints:
                                constraints.append(cst)

                    if len(l1) > 0:
                        constraints.append(f"{' + '.join(l1)} = 1; # only one level of transfer for {arr}")
                    if len(l2) > 0:
                        constraints.append(f"{' + '.join(l2)} = 1; # only one level of reuse for {arr}")


                loops = self.schedule[task][1::2]
                red_loops = []
                for loop in loops:
                    if self.red_loop[loop]:
                        red_loops += [f"TC{loop}_0"]
                if len(red_loops) > 0:
                    tmp_lat += [f"II_S{task}_seq * {' * '.join(red_loops)}"]
                lat.append(f"({' + '.join(tmp_lat)})")

            
            # all_array_for_this_fused_task
            
            # for task in fused_task:
                # lat.append(f"Lat_comp_S{task}_intra_tile")
            var.append(f"Lat_comp_fused_{name}_{max_loop+1} >= 0;")
            constraints.append(f"Lat_comp_fused_{name}_{max_loop+1} = ({' + '.join(lat)}); # latency of the fused task {name} level {max_loop+1}")


            # TODO cost if you unroll and you read the array

            # FIXME for now it is reduce to parallel loop
            multi_level = []

            # should write too ?
            should_write = False
            for tt in fused_task:
                if tt in what_statement_should_write:
                    should_write = True
            arr_out = self.info_loops[fused_task[0]]["write"][0].split("[")[0]
            
            for k in range(max_loop, 0, -1):
                current_TC = []
                write_out = ""
                for id_perm, pp in enumerate(perms[fused_task[0]]):
                    current_TC.append(f"perm{id_perm}_S{fused_task[0]} * TC{pp[k-1]}_0")
                current_TC = " + ".join(current_TC)
                l = [f"Lat_comp_fused_{name}_{k+1}"]
                s = f"Lat_comp_fused_{name}_{k+1}"
                trans = []
                for arr in all_array_for_this_fused_task:
                    foot = ""
                    for task in fused_task:
                        if arr in list(name_var_footprint_fused[task].keys()):
                            foot = name_var_footprint_fused[task][arr]
                            break

                    if foot != "":
                        # if write we have already for load so it is good as it is a max
                        l.append(f"level_transfer_{arr}_FT{id_fused_task}_under{k} * {foot} / burst_{arr}")
                        trans.append(f"level_transfer_{arr}_FT{id_fused_task}_under{k} * {foot} / burst_{arr}")
                    if should_write and arr == arr_out:
                        write_out = f" + level_transfer_{arr}_FT{id_fused_task}_under{k} * {foot} / burst_{arr}"
                var.append(f"Lat_comp_fused_{name}_{k} >= 0;")
                
                
                constraints.append(f"Lat_comp_fused_{name}_{k} = ({current_TC}) * max({', '.join(l)}) + {s} + max({', '.join(trans)} {write_out}); # latency of the fused task {name} level {k}")
            # exit(0)

            full_transfer = []
            for arr in all_array_for_this_fused_task:
                full_transfer += [f"level_transfer_{arr}_FT{id_fused_task}_under0 * footprint_tot_{arr}_FT{id_fused_task} / burst_{arr}"]
            full_transfer = " + ".join(full_transfer)
            constraints.append(f"Lat_comp_fused_{name} = Lat_comp_fused_{name}_1 + {full_transfer}; # latency of the fused task {name}")

        # FIXME if we want to have an accurate reuse buffer size we need to separate the case where we load and the case where we just compute


            # COmpute footprint
        for id_fused_task, fused_task in enumerate(what_is_fuse):
            all_array = []
            corresponding_task = {}
            
            for task in fused_task:
                for arr in list(name_var_footprint_fused[task].keys()):
                    foot = name_var_footprint_fused[task][arr]
                    v = (arr, foot)
                    if v not in all_array:
                        all_array.append(v)
                        corresponding_task[v] = task

            for id_, pp in enumerate(all_array):
                arr = pp[0]
                foot = pp[1]
                mem = [f"level_reuse_{arr}_FT{id_fused_task}_under0 * footprint_tot_{arr}_FT{id_fused_task}"]
                lat = [f"level_transfer_{arr}_FT{id_fused_task}_under0 * footprint_tot_{arr}_FT{id_fused_task}"]
                current_task = corresponding_task[pp]
                # FIXME can we have case we load tile by tile but in memory we reuse ?
                all_perms = perms[current_task] # as we need same order for fuse task it is equivalent to do for all
                dim = self.info_loops[fused_task[0]]["write"][0].count("[")
                for level in range(1,dim+1):
                    l_ = []
                    m_ = []
                    for id_perm, perm in enumerate(all_perms):
                        # we need to check what loop iterate which dim
                        str_l = f"perm{id_perm}_S{current_task} * footprint_tot_{arr}_FT{id_fused_task}"
                        str_m = f"perm{id_perm}_S{current_task} * footprint_tot_{arr}_FT{id_fused_task}"
                        it_array_, coresponding_loop, _ = self.give_it_loop(arr, fused_task, name_var_footprint_fused)
                        it_array = []
                        for it in it_array_:
                            it = it.replace("+", "!").replace("-", "!").replace("/", "!").replace("*", "!").split("!")
                            it_array += it
                        
                        for ll in range(level):
                            if self.iterators[perm[ll]] in it_array:
                                str_l += f"/ TC{perm[ll]}_0" 
                                str_m += f"/ TC{perm[ll]}_0"
                        if self.iterators[perm[level-1]] not in it_array:
                            constraints.append(f"perm{id_perm}_S{current_task} * level_transfer_{arr}_FT{id_fused_task}_under{level} = 0; # useless to transfer under this loop")
                            constraints.append(f"perm{id_perm}_S{current_task} * level_reuse_{arr}_FT{id_fused_task}_under{level} = 0; # useless to reuse under this loop")
                        l_.append(str_l)
                        m_.append(str_m)
                        #ici
                    # exit(0)
                    lat.append(f"level_transfer_{arr}_FT{id_fused_task}_under{level} * ({' + '.join(l_)})")
                    mem.append(f"level_reuse_{arr}_FT{id_fused_task}_under{level} * ({' + '.join(m_)})")
                constraints.append(f"{foot} = {' + '.join(lat)}; # footprint of the array {arr} for the fused task {id_fused_task}")
                constraints.append(f"{foot}_reuse = {' + '.join(mem)}; # footprint of the array {arr} for the fused task {id_fused_task}")

        # transform the matrix for fused_matrix
        fused_matrix = [[0 for i in range(len(what_is_fuse))] for j in range(len(what_is_fuse))]
        for id_fused_task, fused_task in enumerate(what_is_fuse):
            
            for task in fused_task:
                for k in range(len(self.matrix_graph)):
                    if self.matrix_graph[task+1][k] == 1:
                        for id_fused_task2, fused_task2 in enumerate(what_is_fuse):
                            if k-1 in fused_task2:
                                if id_fused_task != id_fused_task2:
                                    # fused_matrix[id_fused_task][id_fused_task2] = 1
                                    fused_matrix[min(id_fused_task, id_fused_task2)][max(id_fused_task, id_fused_task2)] = 1
        

        # TODO technically we should count the time  fused_task received their data 
        for id_fused_task, fused_task in enumerate(what_is_fuse):
            for id_fused_task2, fused_task2 in enumerate(what_is_fuse):
                
                if id_fused_task2>id_fused_task:
                    if fused_matrix[id_fused_task][id_fused_task2] == 1:
                        var.append(f"shift_{id_fused_task}_to_{id_fused_task2} >= 0;")
                        shift = "("
                        for task in fused_task:
                            shift_tmp = f"Lat_comp_S{task}_intra_tile"
                            red_loop = ""
                            loops = self.schedule[task][1::2]
                            for loop in loops:
                                if self.red_loop[loop]:
                                    red_loop += f"* TC{loop}_0"
                            if len(red_loop) > 1:
                                shift_tmp += f" + II_S{task}_seq {red_loop}"
                            if len(shift) == 0:
                                shift += shift_tmp
                            else:
                                shift += " + " + shift_tmp
                        # + time to transfer the array
                        output = self.info_loops[fused_task[0]]["write"][0].split("[")[0]

                        # the size of the output as it is stationnary should be the same as the tile
                        v1 = ""
                        v2 = ""
                        for t1 in fused_task:
                            if output in list(name_var_footprint_fused[t1].keys()):
                                v1 = name_var_footprint_fused[t1][output]
                                break
                        for t2 in fused_task2:
                            if output in list(name_var_footprint_fused[t2].keys()):
                                v2 = name_var_footprint_fused[t2][output]
                                break
                        if v1 != "" and v2 != "":
                            ratio = f"{v2} / {v1}"
                        else:
                            ratio = "1"
                        try:
                            shift += f" + {name_var_footprint_fused[fused_task[0]][output]}) * {ratio}"
                            constraints.append(f"shift_{id_fused_task}_to_{id_fused_task2} = {shift};")
                        except:
                            pass # FIXME 

        
        # fused_matrix = [
        #     [0,0,0,0,1,0,0,0],
        #     [0,0,0,0,1,0,0,0],
        #     [0,0,0,0,0,1,0,0],
        #     [0,0,0,0,0,1,0,0],
        #     [0,0,0,0,0,0,0,1],
        #     [0,0,0,0,0,0,1,0],
        #     [0,0,0,0,0,0,0,1],
        #     [0,0,0,0,0,0,0,0]
        #     ]
        depend_on_what = {}
        for k1 in range(len(fused_matrix)):
            depend_on_what[k1] = []
            sum_column = 0
            for k2 in range(len(fused_matrix)):
                sum_column += fused_matrix[k2][k1]
            if sum_column >= 1:
                argument_of_max = []
                for k2 in range(len(fused_matrix)):
                    if fused_matrix[k2][k1] == 1:
                        argument_of_max.append(k2)
                        # deja_vu.append(k2)
                depend_on_what[k1] = argument_of_max
        
        dependencies = depend_on_what
        latency = {}

        for id_task_fused, task_fused in enumerate(what_is_fuse):
            name = ""
            for task in task_fused:
                name += f"S{task}_"
            name = name[:-1]
            latency[id_task_fused] = f"Lat_comp_fused_{name}"
        shifts = {}
        for key in list(dependencies.keys()):
            for elemt in dependencies[key]:
                shifts[(elemt, key)] = f"shift_{elemt}_to_{key}"

        memo = {}
        total_latencies = {node: self.calculate_latency(node, dependencies, latency, shifts, memo) for node in dependencies}

        for key in list(total_latencies.keys()):
            # if not future dependencies according to fused_matrix add to obj
            if sum(fused_matrix[key]) == 0:
                obj.append(total_latencies[key])

        for stat in range(len(self.schedule)):
            read = self.analysis.dic[stat]["read"]
            write = self.analysis.dic[stat]["write"]
            randw = []
            for rr in read:
                if "[" in rr and "[0]" not in rr:
                    randw.append(rr.split("[")[0])
            for ww in write:
                if "[" in ww and "[0]" not in ww:
                    randw.append(ww.split("[")[0])
            randw = list(set(randw))

        # reuse, broadcast, comm_off_chip
        for stat in range(len(self.schedule)):
            read = self.analysis.dic[stat]["read"]
            write = self.analysis.dic[stat]["write"]
            randw = []
            for rr in read:
                if "[" in rr and "[0]" not in rr:
                    randw.append(rr.split("[")[0])
            for ww in write:
                if "[" in ww and "[0]" not in ww:
                    randw.append(ww.split("[")[0])
            randw = list(set(randw))
            loops = self.schedule[stat][1::2]
            
        # DSP constraints
        dsp = []
        dsp_per_fused_task = {}
        
        for k in range(len(self.schedule)):
            dsp_ = []
            loops = self.schedule[k][1::2]
            id_fused_task = -1
            for id_ft, ft in enumerate(self.what_is_fuse()):
                if k in ft:
                    id_fused_task = id_ft
                    break
            for l in loops:
                dsp_.append(f"TC{l}_1")
            is_red = False
            for loop in loops:
                if self.red_loop[loop]:
                    is_red = True
                    break
            if is_red:
                dsp.append(f"{' * '.join(dsp_)} * DSP_S{k} / II_S{k}_seq")
                if id_fused_task not in list(dsp_per_fused_task.keys()):
                    dsp_per_fused_task[id_fused_task] = []
                dsp_per_fused_task[id_fused_task].append(f"{' * '.join(dsp_)} * DSP_S{k} / II_S{k}_seq")
            else:
                dsp.append(f"{' * '.join(dsp_)} * DSP_S{k} ")
                if id_fused_task not in list(dsp_per_fused_task.keys()):
                    dsp_per_fused_task[id_fused_task] = []
                dsp_per_fused_task[id_fused_task].append(f"{' * '.join(dsp_)} * DSP_S{k}")
            constraints.append(f"{' * '.join(dsp_)} <= MAX_UF;")
        constraints.append(f"{' + '.join(dsp)} <= DSP_avail; # DSP constraint")

        for id_slr in range(self.res.SLR):
            curr_cons = []
            var.append(f"nb_dsp_used_SLR{id_slr} >= 0;")
            for key in list(dsp_per_fused_task.keys()):
                curr_cons.append(f"is_fused_task{key}_in_SLR_{id_slr} * ({' + '.join(dsp_per_fused_task[key])})")
            constraints.append(f"nb_dsp_used_SLR{id_slr} = {' + '.join(curr_cons)}; # DSP constraint per SLR")
            constraints.append(f"nb_dsp_used_SLR{id_slr} <= SLR{id_slr}_DSP; # DSP constraint per SLR")


        for fuses in self.what_is_fuse():
            info_arr = {}
            for id_fuse in fuses:
                read = self.analysis.dic[id_fuse]["read"]
                write = self.analysis.dic[id_fuse]["write"]
                for arr in read+write:
                    name_arr = arr.split("[")[0]
                    if name_arr not in list(info_arr.keys()):
                        info_arr[name_arr] = {}
                    its = self.extract_iterators(arr)
                    for jj in range(len(its)):
                        if jj not in list(info_arr[name_arr].keys()):
                            info_arr[name_arr][jj] = []
                    looop = []
                    
                    for l in self.schedule[id_fuse][1::2]:
                        for jjj in range(len(its)):
                            if self.iterators[l] == its[jjj]:
                                if l not in info_arr[name_arr][jjj]:
                                    info_arr[name_arr][jjj].append(l)
                                    break

                    
                    

            for arr in list(info_arr.keys()):
                dd = []
                for dim in list(info_arr[arr].keys()):
                    dd.append(info_arr[arr][dim])
                combi = list(product(*dd))
                
                for pos in combi:
                    concon= []
                    for y in range(len(pos)):
                        concon += [f"TC{pos[y]}_1"]
                    constraints.append(f"{' * '.join(concon)} <= CONSTRAINT_ARRAY_PARTITIONING_VALUE; # array part for array {arr} ")
                

        for key in list(lat_comp_per_stat.keys()):
            array_RAW = ""
            S0 = key.split("_")[2].replace("S", "")
            S1 = key.split("_")[4].replace("S", "").replace(";", "").split(" ")[0]

            if "off" not in key:

                write_array_S0 = self.analysis.dic[int(S0)]["write"][0].split("[")[0]
                cost = []

                array_in_common = []
                rS0 = self.analysis.dic[int(S0)]["read"]
                wS0 = self.analysis.dic[int(S0)]["write"]
                rS1 = self.analysis.dic[int(S1)]["read"]
                wS1 = self.analysis.dic[int(S1)]["write"]

                randw_S0 = rS0 + wS0
                randw_S1 = rS1 + wS1

                for r in randw_S0:
                    for r2 in randw_S1:
                        if r.split("[")[0] == r2.split("[")[0]:
                            array_in_common.append((r, r2))
                            break
                


                perms_S0 = perms[int(S0)]
                perms_S1 = perms[int(S1)]

                if len(array_in_common) > 0:

                    for p0 in range(len(perms_S0)):
                        for p1 in range(len(perms_S1)):
                            for a in array_in_common:
                                it0 = self.extract_iterators(a[0])
                                it1 = self.extract_iterators(a[1])
                                id_loop0 = []
                                id_loop1 = []
                                loops_S0 = self.schedule[int(S0)][1::2]
                                loops_S1 = self.schedule[int(S1)][1::2]
                                dic_S0 = {}
                                dic_S1 = {}
                                for id_dim, it in enumerate(it0):
                                    for l in loops_S0:
                                        if self.iterators[l] == it:
                                            id_loop0.append(l)
                                            dic_S0[l] = id_dim
                                for id_dim, it in enumerate(it1):
                                    for l in loops_S1:
                                        if self.iterators[l] == it:
                                            id_loop1.append(l)
                                            dic_S1[l] = id_dim
                                pp0 = [dic_S0[l] for l in perms_S0[p0] if l in id_loop0]
                                pp1 = [dic_S1[l] for l in perms_S1[p1] if l in id_loop1]
                                if pp0 != pp1:
                                    arr = a[0].split("[")[0]
                                    cost += [f"perm{p0}_S{S0} * perm{p1}_S{S1} * 2 * footprint_tot_{arr}"]
                cost = " + ".join(cost)

                UF = [f"loop{l}_UF" for l in self.schedule[int(S0)][1::2]]

                UF = " * ".join(UF)

            else:

                constraints.append(f"{key} = {' + '.join(lat_comp_per_stat[key])}; # stall between task")

        #compute cost of schedule different
        
        for k in range(len(self.schedule)):
            op = self.analysis.operations[k]
            loops = self.schedule[k][1::2]
            is_red = False
            for loop in loops:
                if self.red_loop[loop]:
                    is_red = True
                    break

            #FIXME suppose the red is + for now
            seq = 0
            par = 0
            if is_red:
                seq = 1 * self.res.IL["+"]
            for o in op:
                if o == "+":
                    nb = op[o]
                    if is_red:
                        nb -= 1
                    par += nb * self.res.IL["+"]
                elif o == "-":
                    nb = op[o]
                    par += nb * self.res.IL["-"]
                elif o == "*":
                    nb = op[o]
                    par += nb * self.res.IL["*"]
                elif o == "/":
                    nb = op[o]
                    par += nb * self.res.IL["/"]

            if par == 0:
                par = 1 # assignement
            # param.append(f"IL_par_S{k} = {par};")
            # param.append(f"IL_seq_S{k} = {seq};")
        

        header = ["#option solver baron;", "#option baron_options 'maxtime=60 trace=nlp.trace sumfile=nlp.sum';"]
        header += ["option solver gurobi;", "option gurobi_options 'lim:time=169200 tech:logfile=gurobi.log qp:nonconvex=2';"]
        header += ["#option solver octeract;", "#option octeract_options 'max_solver_time=60';"]

        

        for k in list(self.TC.keys()):
            tc = []

            for j in range(2):
                var += [f"TC{k}_{j} integer >= 1;"]
                constraints.append(f"TC{k}_{j} <= TC{k}; # TC of split loop")
                tc += [f"TC{k}_{j}"]
            is_burst_without_tiling = False
            for v in var:
                if f"cte_burst_without_tiling_TC{k}" in v:
                    is_burst_without_tiling = True

            constraints.append(f"{' * '.join(tc)} = TC{k}; # product of the TC of split loop = original TC" )


        # Max Array part and # Array part modulo
        arrays = []
        dim_array = {}
        for key in list(self.analysis.dic.keys()):
            read = self.analysis.dic[key]["read"]
            write = self.analysis.dic[key]["write"]
            for r in read:
                if "[0]" not in r:
                    nb = r.count("[")
                    arrays.append(r.split("[")[0])
                    dim_array[r.split("[")[0]] = nb 
            for w in write:
                if "[0]" not in w:
                    nb = w.count("[")
                    arrays.append(w.split("[")[0])
                    dim_array[w.split("[")[0]] = nb 
        arrays = list(set(arrays))
        self.info_arrays = {}
        for array in arrays:
            self.info_arrays[array] = {}
            for dim in range(dim_array[array]):
                self.info_arrays[array][dim] = []
        for array in arrays:
            for key in list(self.analysis.dic.keys()):
                read = self.analysis.dic[key]["read"]
                write = self.analysis.dic[key]["write"]
                randw = read + write
                for r in randw:
                    if array in r:
                        its = self.extract_iterators(r)
                        loops = self.schedule[key][1::2]
                        for id_dim, lit in enumerate(its):
                            if "+" in lit or "-" in lit or "*" in lit or "/" in lit:
                                lit = lit.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                            else:
                                lit = [lit]
                            for it in lit:
                                for loop in loops:
                                    if self.iterators[loop] == it:
                                        if loop not in self.info_arrays[array][id_dim]:
                                            self.info_arrays[array][id_dim].append(loop)

        
        # each loop which iterate same dimension need to have intra tile equal
        for array in arrays:
            l_array = []
            for dim in range(dim_array[array]):
                list_loop = self.info_arrays[array][dim]


                # tc_1 > burst size if last dimension TODO

                pairs = list(combinations(list_loop, 2))
                if len(pairs) > 0:
                    for pair in pairs:
                        p1 = pair[0]
                        p2 = pair[1]
                        # TODO only for fuse task
                        for fused in what_is_fuse:
                            stat_of_p1 = -1
                            stat_of_p2 = -1
                            for id_sched, schedd in enumerate(self.schedule):
                                loops = schedd[1::2]
                                if p1 in loops:
                                    stat_of_p1 = id_sched
                                if p2 in loops:
                                    stat_of_p2 = id_sched


                            if stat_of_p1 in fused and stat_of_p2 in fused:
                                constraints.append(f"TC{p1}_1 = TC{p2}_1; # same intra tile for the same dimension of the array {array} in the fused task")

                l_array += list_loop

            l_array = list(set(l_array))

        id_cte = 0
        for array in arrays:
            list_loop = []
            for dim in range(dim_array[array]):

                list_loop += [f"TC{self.info_arrays[array][dim][0]}_1"]
            
            cons_burst = []
            only_one = []
            last_dim = dim_array[array]-1
            for last_dim_loop in self.info_arrays[array][last_dim]:
                # last_dim_loop = self.info_arrays[array][last_dim][0]
                last_stat = 0
                id_FT = 0   
                for id_sched, schedd in enumerate(self.schedule):
                    loops = schedd[1::2]
                    if last_dim_loop in loops:
                        last_stat = id_sched
                        break
                for id_task_ in range(len(self.what_is_fuse())):
                    if last_stat in self.what_is_fuse()[id_task_]:
                        id_FT = id_task_
                        break
                cons = f"{array}_is_fully_transfered_on_last_dim_FT{id_FT} binary;"
                if cons not in var:

                    var.append(cons)


                first_statement_see_the_array = -1
                for id_sched in range(len(self.schedule)):
                    loops = self.schedule[id_sched][1::2]
                    if last_dim_loop in loops:
                        first_statement_see_the_array = id_sched
                        break

                id_task = 0
                for id_, dd in enumerate(self.what_is_fuse()):
                    if first_statement_see_the_array in dd:
                        id_task = id_
                        break
                cc = [f"level_transfer_{array}_FT{id_task}_under0"]
                max_loop = len(self.extract_iterators(self.info_loops[first_statement_see_the_array]["write"][0]))
                for id_perm, perm in enumerate(perms[first_statement_see_the_array]):

                    str_ = f"perm{id_perm}_S{first_statement_see_the_array}"
                    ccc = []
                    for o in range(len(perm)):
                        if o < max_loop:
                            if perm[o] != last_dim_loop:
                                ccc.append(f"level_transfer_{array}_FT{id_task}_under{o+1}")
                            else:
                                break
                    if len(ccc) > 0:
                        cc.append(f"{str_} * ({' + '.join(ccc)})")
                

                constraints.append(f"{array}_is_fully_transfered_on_last_dim_FT{id_task} = {' + '.join(cc)}; # the array {array} is fully transfered on the last dimension")
                
            
            for k in [1,2,4,8,16]:
                var.append(f"burst_{array}_is_{k} binary;")
                # var.append(f"cte_{id_cte} integer >=0;")
                only_one.append(f"burst_{array}_is_{k}")
                # what task read first the array
                
                first_uses = self.all_use(array)

                for first_use in first_uses:
                    var.append(f"cte_{id_cte} integer >=0;")

                    
                    last_dim_loop = ""
                    last_dim = max(list(self.info_arrays[array].keys()))

                    for ll in self.info_arrays[array][last_dim]:
                        last_dim_loop = ll
                        if last_dim_loop in self.schedule[first_use][1::2]:
                            break
                    id_task = 0
                    for id_, dd in enumerate(self.what_is_fuse()):
                        if first_use in dd:
                            id_task = id_
                            break

                    # try:
                    #     foot = name_var_footprint_fused[first_use][array]
                    # except:
                    #     foot = "10000" #f"footprint_tot_{array}_FT{id_task}"
                    
                    constraints.append(f"burst_{array}_is_{k} * cte_{id_cte} * {k} = burst_{array}_is_{k} * ( \
                        (1-is_tc{last_dim_loop}_burst_witout_tiling_for_{array}) * (\
                        TC{last_dim_loop}_1 * (1-{array}_is_fully_transfered_on_last_dim_FT{id_task}) +\
                        TC{last_dim_loop} * ({array}_is_fully_transfered_on_last_dim_FT{id_task}) \
                        ) \
                        + \
                        is_tc{last_dim_loop}_burst_witout_tiling_for_{array} * (cte_burst_without_tiling_TC{last_dim_loop}_for_{array} + TC{last_dim_loop}) \
                        );".replace(" ", "").replace("*", " * ").replace("=", " = ").replace("+", " + "))
            

                    ori_tc = self.TC[last_dim_loop]
                    shift = 0
                    for e in range(ori_tc):
                        if (e+ori_tc)%16==0:
                            shift = e
                            break
                    ccc = f"cte_burst_without_tiling_TC{last_dim_loop}_for_{array} integer >= 0 <= {shift};"
                    ccc1 = f"is_tc{last_dim_loop}_burst_witout_tiling_for_{array} binary;"
                    if ccc not in var:
                        var.append(ccc)
                    if ccc1 not in var:
                        var.append(ccc1)
                        constraints.append(f"is_tc{last_dim_loop}_burst_witout_tiling_for_{array} =  min(1, cte_burst_without_tiling_TC{last_dim_loop}_for_{array});")
                        # constraints.append(f"is_tc{last_dim_loop}_burst_witout_tiling * 1 >=  is_tc{last_dim_loop}_burst_witout_tiling * cte_burst_without_tiling_TC{last_dim_loop};")
                    if f"burst_{array}_is_{k} * {k}" not in cons_burst:
                        cons_burst.append(f"burst_{array}_is_{k} * {k}")
                    id_cte += 1
            constraints.append(f"burst_{array} = {' + '.join(cons_burst)}; # burst size of the array {array}")
            constraints.append(f"{' + '.join(only_one)} = 1; # only one burst size for the array {array}")

            for v in var:
                id_task = 0
                if f"burst_witout_tiling_for_{array}" in v and "is" in v:
                    id_loop = v.split("_")[1].replace("tc", "")
                    id_stat = 0
                    for k in range(len(self.schedule)):
                        loops = self.schedule[k][1::2]
                        if int(id_loop) in loops:
                            id_stat = k
                            break
                    for id_, dd in enumerate(self.what_is_fuse()):
                        if int(id_stat) in dd:
                            id_task = id_
                            break

                    is_ = f"is_tc{id_loop}_burst_witout_tiling_for_{array}"
                    is_present = False
                    for v2 in var:
                        if f"{array}_is_fully_transfered_on_last_dim_FT{id_task}" in v2:
                            is_present = True
                            break
                    if is_present:
                        # ccc = f"{is_} = {is_} * {array}_is_fully_transfered_on_last_dim_FT{id_task};"
                        ccc = f"{is_} <= {array}_is_fully_transfered_on_last_dim_FT{id_task};"
                        if ccc not in constraints:
                            constraints.append(ccc)


        all_loops = []
        for k in range(len(self.schedule)):
            loops = self.schedule[k][1::2]
            all_loops += loops
        all_loops = list(set(all_loops))
        for loop in all_loops:
            if self.red_loop[loop]:
                comments.append(f" {loop} is a reduction loop")

        first_time_array_appear = {}
        is_write = {}
        is_init_on_board = {}
        for array in arrays:
            first_time_array_appear[array] = -1
            is_write[array] = False
            is_init_on_board[array] = False
            for key in list(self.analysis.dic.keys()):
                read = self.analysis.dic[key]["read"]
                write = self.analysis.dic[key]["write"]
                randw = read + write
                for r in randw:
                    if array in r:
                        if r in write:
                            is_write[array] = True
                        
                        # if first_time_array_appear[array] == -1:
                        if not is_write[array]:
                            first_time_array_appear[array] = key
                            comments.append(f"Task {key} reads {array} from off-chip")
                            arr = array.split("[")[0]
                        # if first_time_array_appear[array] != -1 and is_write[array]:
                        if first_time_array_appear[array] == -1 and is_write[array]:
                            first_time_array_appear[array] = key

                            stat = self.statements[key]
                            right = stat.split("=")[1].replace(";", "").replace("\n", "")
                            try:
                                x = float(right)
                                is_init_on_board[array] = True
                            except:
                                pass
                            if not is_init_on_board[array]:

                                comments.append(f"Task {key} reads {array} from off-chip")
                                arr = array.split("[")[0]

                        break
            
        footprint_array = {}
        burst_size = {}
        list_foot = []
        already_seen = []
        for array in arrays:
            footprint_array[array] = 0
            burst_size[array] = 0
            if array not in already_seen:
                for key in list(self.analysis.dic.keys()):
                    read = self.analysis.dic[key]["read"]
                    write = self.analysis.dic[key]["write"]
                    randw = read + write
                    for r in randw:
                        if array in r:
                            id_fused_task = -1
                            for id_, dd in enumerate(self.what_is_fuse()):
                                if key in dd:
                                    # id_fused_task = id_
                                    # break
                                    cons = f"footprint_tot_{array}_FT{id_} integer >= 1;"
                                    if cons not in var:
                                        var.append(cons)
                        if array not in already_seen:
                            if array in r:
                                footprint_array[array] = np.prod(self.analysis.arrays_size[array])
                                if footprint_array[array] % 16 == 0:
                                    burst_size[array] =  16
                                elif footprint_array[array] % 8 == 0:
                                    burst_size[array] =  8
                                elif footprint_array[array] % 4 == 0:
                                    burst_size[array] =  4
                                elif footprint_array[array] % 2 == 0:
                                    burst_size[array] =  2


                                var.append(f"burst_{array} integer >= 0;")
                                # var.append(f"footprint_{array} integer >= 0;")
                                # for val in name_var_footprint_fused
                                arr_foot = []
                                for key in list(name_var_footprint_fused.keys()):
                                    for key2 in list(name_var_footprint_fused[key].keys()):
                                        if name_var_footprint_fused[key][key2] not in arr_foot:
                                            arr_foot.append(name_var_footprint_fused[key][key2])
                                            if f"{name_var_footprint_fused[key][key2]} <= MAX_BUFFER_SIZE;" not in constraints:
                                                pass


                                list_foot.append(f"footprint_tot_{array}_FT{id_fused_task}")
                                already_seen.append(array)
                                break

        in_last_dim = []
        all_loops = []
        for array in list(self.info_arrays.keys()):
            nb_time_call = len(self.info_arrays[array][0])
            for nb in range(nb_time_call):
                l = []
                for dim in range(len(list(self.info_arrays[array].keys()))):
                    all_loops += self.info_arrays[array][dim]
                    # if len(self.info_arrays[array][dim]) > 1:
                    # FIXME EG 3MM create bug for footprint tot


                    if True:
                    
                        if dim == len(list(self.info_arrays[array].keys()))-1:


                            burst_without_tiling_present = False
                            for v in var:
                                if f"cte_burst_without_tiling_TC{self.info_arrays[array][dim][nb]}_for_{array}" in v:
                                    burst_without_tiling_present = True
                            if burst_without_tiling_present:
                                l.append(f"TC{self.info_arrays[array][dim][nb]}_0 * (TC{self.info_arrays[array][dim][nb]}_1 + cte_burst_without_tiling_TC{self.info_arrays[array][dim][nb]}_for_{array})")
                            else:
                                l.append(f"TC{self.info_arrays[array][dim][nb]}")
                            in_last_dim.append(self.info_arrays[array][dim][nb])
                        else:
                            l.append(f"TC{self.info_arrays[array][dim][nb]}_ori")

                    last_sched = -1
                    curr_schedd = 0
                    id_arg = 0
                    for lloop in range(len(self.info_arrays[array][dim])):
                        for cs in range(len(self.schedule)):
                            if str(self.info_arrays[array][dim][lloop]) in list(map(str, self.schedule[cs][1::2])):
                                curr_schedd = cs
                                break
                        if last_sched != curr_schedd:
                            last_sched = curr_schedd
                            id_arg = 0
                        comments.append(f"Array {array} has for tc in dim {dim} TC{self.info_arrays[array][dim][lloop]} (ori=TC{self.info_arrays[array][dim][lloop]}_ori) arg{id_arg}")
                        id_arg += 1
                    if dim == len(list(self.info_arrays[array].keys()))-1:
                        if self.ap_multiple_burst:
                            # we need to make that loop which iterate the last dimension of array multiple of burst size
                            var.append(f"cte_burst_TC{self.info_arrays[array][dim][nb]}_for_{array} integer >= 1;")
                            constraints.append(f"TC{self.info_arrays[array][dim][nb]}_1 = burst_{array} * cte_burst_TC{self.info_arrays[array][dim][nb]}_for_{array};")
                
                
                
                id_fused_task = -1
                id_stat = -1
                if nb < len(self.info_arrays[array][dim]):
                    target_loop = self.info_arrays[array][dim][nb]
                    for id_sched in range(len(self.schedule)):
                        loops = self.schedule[id_sched][1::2]
                        if target_loop in loops:
                            id_stat = id_sched
                    for id_, dd in enumerate(self.what_is_fuse()):
                        if id_stat in dd:
                            id_fused_task = id_
                            break
                    constraints.append(f"footprint_tot_{array}_FT{id_fused_task} = {' * '.join(l)};")
        all_loops = list(set(all_loops))
        for loop in all_loops:
            if loop not in in_last_dim:
                constraints.append(f"TC{loop} = TC{loop}_ori;")

        for array in arrays:
            schedule_with_array = []
            curr_cons = []
            current_cost = []
            curr_perm = []
            for key in list(self.analysis.dic.keys()):
                read = self.analysis.dic[key]["read"]
                write = self.analysis.dic[key]["write"]
                randw = read + write
                for r in randw:
                    if array in r:
                        schedule_with_array.append(key)
                        curr_perm.append(perms[key])
                        break

            possibilities = product(*curr_perm)
            ll = [k for k in range(dim_array[array])] + [k for k in range(dim_array[array])] # because of tiling
            order = list(permutations(ll))


        # try to maximize the burst as "lexico"
        ll = []
        for v in var:
            if "burst" in v and "is" not in v and "cte" not in v:
                name = v.split(" integer")[0]
                obj.append(f"1/{name}")
        cc = []
        for id_slr in range(self.res.SLR):
            cc += [f"is_slr{id_slr}_used"]
        obj.append(f"1/({' + '.join(cc)})")

        one_path = {}

        for stat in range(1, len(self.matrix_graph)):
            one_path[stat-1] = []
        for stat in range(1, len(self.matrix_graph)):
            if np.sum(self.matrix_graph[stat][1:]) == 1: # Remove the root
                for k in range(len(self.matrix_graph[stat])):
                    if self.matrix_graph[stat][k] == 1:
                        column_sum = 0
                        for j in range(len(self.matrix_graph)):
                            column_sum += self.matrix_graph[j][k]
                        if column_sum == 1:
                            one_path[stat-1].append(k-1)

        need_to_be_delete = []
        for key in list(one_path.keys()):
            current_key = key
            
            while len(one_path[current_key]) > 0:
                current_key = one_path[current_key][0]
                need_to_be_delete.append(current_key)
                if current_key not in one_path[key]:
                    one_path[key].append(current_key)

        for key in need_to_be_delete:
            one_path[key] = []



        id_lat = {}
        for key in list(one_path.keys()):
            if len(one_path[key]) > 0:
                id_stat = [key] + one_path[key]
                #sort id_stat
                id_stat = sorted(id_stat)
                var.append(f"Lat_comp_{'_'.join(list(map(str,id_stat)))} >= 0;")
                for id_ in id_stat:
                    id_lat[id_] = []
                    last_one = id_stat[-1]
                    succesor = []
                    for k in range(len(self.matrix_graph)):
                        if self.matrix_graph[last_one+1][k] == 1:
                            succesor.append(k-1)
                    if len(succesor) == 0:
                        succesor = ["off_chip"]
                    for d in range(len(succesor)):
                        id_lat[id_] += [f"Lat_comp_{'_'.join(list(map(str,id_stat)))}_for_S{succesor[d]}"]

                
                successors_of_last_one = []
                
                last_one = id_stat[-1]
                for k in range(len(self.matrix_graph)):
                    if self.matrix_graph[last_one+1][k] == 1:
                        successors_of_last_one += [k-1]

                # [f'Lat_comp_S{k}_for_S{succesor}' for k in id_stat]
                for succ in successors_of_last_one:
                    curr_lat_comp = []
                    curr_debut_comp = []
                    for h in range(len(id_stat)-1):
                        curr_lat_comp.append(f'Lat_comp_S{id_stat[h]}_for_S{id_stat[h+1]}')
                        curr_debut_comp.append(f'debit_S{id_stat[h]}_to_S{id_stat[h+1]}')
                    curr_lat_comp.append(f'Lat_comp_S{id_stat[-1]}_for_S{succ}')
                    curr_debut_comp.append(f'debit_S{id_stat[-1]}_to_S{succ}')


        for k in range(len(self.schedule)):
            if k not in list(id_lat.keys()):
                id_lat[k] = []
                successors_of_last_one = []
                last_one = k
                for j in range(1,len(self.matrix_graph)):
                    if self.matrix_graph[last_one+1][j] == 1:
                        successors_of_last_one += [j-1]
                        id_lat[k] += [f"Lat_comp_S{k}_for_S{j-1}"]
                if len(successors_of_last_one) == 0:
                    successors_of_last_one = ["off_chip"]
                    id_lat[k] += [f"Lat_comp_S{k}_for_off_chip"]
                    array = self.analysis.dic[k]["write"][0].split("[")[0]
                    # comments.append(f"Task {k} writes {array} to off-chip")
                    arr = array.split("[")[0]

        deja_vu = []
        for k1 in range(1, len(self.matrix_graph)):
            sum_column = 0
            for k2 in range(1, len(self.matrix_graph)):
                sum_column += self.matrix_graph[k2][k1]
            if sum_column > 1:
                argument_of_max = []
                for k2 in range(1, len(self.matrix_graph)):
                    if self.matrix_graph[k2][k1] == 1:
                        argument_of_max.append(k2-1)
                        deja_vu.append(k2-1)
                        # append all statement which dep of k2-1
                        for elemt in id_lat[k2-1]:
                            if f"for_S{k2-1}" in elemt:
                                if "Lat_comp_S" not in elemt:
                                    stat_to_add = id_lat[k2-1].split("_for")[0].replace("Lat_comp_", "").split("_")
                                    stat_to_add = list(map(int, stat_to_add))
                                    for stat in stat_to_add:
                                        if stat not in deja_vu:
                                            deja_vu.append(stat)

                list_max = []
                list_min = []
                for k in argument_of_max:
                    for j in range(len(id_lat[k])):
                        if f"for_S{k1-1}" in id_lat[k][j]:
                            list_max.append(id_lat[k][j])
                            list_min.append(id_lat[k][j].replace("Lat_comp_", "debit_").replace("for", "to"))
                list_max = ', '.join(list_max)
                list_min = ', '.join(list_min)

        
        off_chip_per_stat = {}
        deja_vu = {}


        for v in var:
            if "debit" in v and "from_off_chip" in v:
                stat = v.split("_")[1].replace("S", "")
                if stat not in off_chip_per_stat:
                    off_chip_per_stat[stat] = []
                if stat not in deja_vu:
                    deja_vu[stat] = []
                off_chip_per_stat[stat].append(v.split(" ")[0])

        for v in var:
            if "debit" in v and "before" in v:
                target = v.split("_")[-1].replace("S", "").split(" ")[0]
                lll = []
                for w in constraints:
                    if v.split(" ")[0] in w:
                        
                        lll = w.split("min(")[-1].split(")")[0].split(", ")
                        break

                for l in lll:
                    if l.count("S") == 2:
                        ori = l.split("_")[1].replace("S", "")
                        if target not in deja_vu:
                            deja_vu[target] = []
                        deja_vu[target].append(ori)
                    elif l.count("S") == 1:
                        ori = l.split("debit_")[-1].split("_to")[0].split("_")
                        if target not in deja_vu:
                            deja_vu[target] = []
                        for o in ori:
                            deja_vu[target].append(o)
                if target not in off_chip_per_stat:
                    off_chip_per_stat[target] = []
                off_chip_per_stat[target].append(v.split(" ")[0])
        
        for v in var:
            if "debit" in v and v.count("S") == 1 and "off" not in v and "before" not in v:
                target = v.split("to_")[-1].replace("S", "").split(" ")[0]
                ori = l.split("debit_")[-1].split("_to")[0].split("_")
                dd = True
                for o in ori:
                    if o in deja_vu[target]:
                        dd = False
                if dd:
                    deja_vu[target] += ori
                    off_chip_per_stat[target].append(v.split(" ")[0])
        
        for v in var:
            if "debit" in v and v.count("S") == 2 and "before" not in v and "off" not in v and "to" in v:
                ori = v.split("_")[1].replace("S", "")
                target = v.split("_")[-1].replace("S", "").split(" ")[0]
                if ori not in deja_vu[target]:
                    deja_vu[target].append(ori)
                    off_chip_per_stat[target].append(v.split(" ")[0])


        
        list_off_chip = []
        list_previous = []
        dependence_list_off_chip = []
        for k in range(len(self.schedule)):
            if k not in deja_vu:
                for j in range(len(id_lat[k])):
                    if "off_chip" in id_lat[k][j]:
                        list_off_chip.append(id_lat[k][j]) # by construction independant 
        
                        
                    else:
                        list_previous.append(id_lat[k][j])
                
        for l, elemt in enumerate(list_off_chip):
            stat = elemt.replace("Lat_comp_", "").replace("_for_off_chip", "").replace("S", "")
            if "_" in stat:
                stat = stat.split("_")[0]
            stat = int(stat)
            previous = ""
            for k in range(len(self.matrix_graph)-1, 0, -1):
                if self.matrix_graph[k][stat+1] == 1:
                    previous = k-1
                    break
            prev = ""
            if previous != "":
                for elemt2 in id_lat[previous]:
                    if f"for_S{stat}" in elemt2:
                        id_stat = ""
                        if "Lat_comp_S" in elemt2:
                            id_stat = elemt2.split("_for")[0].replace("Lat_comp_", "").replace("S", "")
                            if int(id_stat) not in deja_vu:
                                prev = elemt2
                        # prev = elemt2
                if len(prev) > 0:
                    elemt += " + " + prev
                list_off_chip[l] = elemt


        var.append("obj >= 0;")

        constraints.append(f"obj = {' + '.join(obj)};")
        arr_per_stat_fused = {}
        for key in list(self.analysis.dic.keys()):
            read = self.analysis.dic[key]["read"]
            write = self.analysis.dic[key]["write"]
            
            # reduce in order
            randw = []
            for r in read:
                if r not in randw:
                    randw.append(r)
            for w in write:
                if w not in randw:
                    randw.append(w)
            for r in randw:
                it = self.extract_iterators(r)
                
                # if len(it) == len(self.schedule[key][1::2]):
                #     pass
                # else:
                tc = []
                for loop in self.schedule[key][1::2]:
                    if self.iterators[loop] in it:
                        tc += [f"TC{loop}_1"]
                if len(tc)>0:
                    r = r.split("[")[0]

                    if r not in list(arr_per_stat_fused.keys()):
                        arr_per_stat_fused[r] = []
                    arr_per_stat_fused[r] += [key]
        
        info_per_array = {}
        for key in list(self.analysis.dic.keys()):
            read = self.analysis.dic[key]["read"]
            write = self.analysis.dic[key]["write"]
            randw = read + write
            for r in randw:
                name_array = r.split("[")[0]
                dim = r.count("[")
                info_per_array[name_array] = {}
                for d in range(dim):
                    info_per_array[name_array][d] = []
        for key in list(self.analysis.dic.keys()):
            read = self.analysis.dic[key]["read"]
            write = self.analysis.dic[key]["write"]
            randw = read + write
            for r in randw:
                name_array = r.split("[")[0]
                dim = r.count("[")
                it = self.extract_iterators(r)
                for loop in self.schedule[key][1::2]:
                    if self.iterators[loop] in it:
                        curr_dim = it.index(self.iterators[loop])
                        if loop not in info_per_array[name_array][curr_dim]:
                            info_per_array[name_array][curr_dim].append(loop)

        id_cte = 0
        for arr in list(info_per_array.keys()):
            for dim in list(info_per_array[arr].keys()):
                if len(info_per_array[arr][dim]) > 1:
                    # create all pair
                    all_pairs = list(combinations(info_per_array[arr][dim], 2))
                    for pair in all_pairs:
                        # constraints.append(f"TC{pair[0]}_1 = TC{pair[1]}_1; # same tiling for {arr} in dim {dim}")
                        var.append(f"cte_tiling_{id_cte} integer >= 0;")
                        id_FT1 = -1
                        id_FT2 = -1
                        id_stat1 = -1
                        id_stat2 = -1
                        for k in range(len(self.schedule)):
                            if pair[0] in self.schedule[k][1::2]:
                                id_stat1 = k
                            if pair[1] in self.schedule[k][1::2]:
                                id_stat2 = k
                        for id_, dd in enumerate(self.what_is_fuse()):
                            if id_stat1 in dd:
                                id_FT1 = id_
                            if id_stat2 in dd:
                                id_FT2 = id_
                        cc1  = f"{arr}_is_fully_transfered_on_last_dim_FT{id_FT1}"
                        cc2  = f"{arr}_is_fully_transfered_on_last_dim_FT{id_FT2}"
                        constraints.append(f"{cc1} * {cc2} * max(TC{pair[0]}_1, TC{pair[1]}_1) = {cc1} * {cc2} * min(TC{pair[0]}_1, TC{pair[1]}_1) * cte_tiling_{id_cte}; # should divide for {arr} in dim {dim}") 
                        id_cte += 1

        if len(tot_buffer) > 0:
            var.append("buffer_size >= 0;")
            var.append("fifo_size >= 0;")
            constraints.append(f"buffer_size = {' + '.join(tot_buffer)}; # total buffer size")
            con_fifo = []
            for v in var:
                if "debit" in v and "to" in v and "off_chip" not in v and v.count("S") == 2:
                    S0 = v.split("_")[1].replace("S", "")
                    S1 = v.split("_")[3].replace("S", "").split(" ")[0]
                    var.append(f"remplissage_from_{S0}_to_{S1} integer >= 0;")
                    var.append(f"nb_element_read_{S1}_from_{S0} integer >= 0;")
                    output_name = self.analysis.dic[int(S1)]["write"][0].split("[")[0]
                    size_output = f"footprint_{output_name}"
                    d_write = f"debit_S{S0}_to_S{S1}"
                    constraints.append(f"remplissage_from_{S0}_to_{S1} = {size_output} / {d_write};")
                    d_read = f"debit_S{S1}_from_S{S0}"
                    constraints.append(f"nb_element_read_{S1}_from_{S0} = remplissage_from_{S0}_to_{S1} * {d_read};")
                    con_fifo += [f"{size_output} - nb_element_read_{S1}_from_{S0}"]
            if len(con_fifo) > 0:
                constraints.append(f"fifo_size = {' + '.join(con_fifo)}; # total fifo size")
            else:
                constraints.append(f"fifo_size = 0; # total fifo size")
            constraints.append(f"buffer_size + fifo_size <= ON_CHIP_MEM_SIZE; # on-chip mem size")


        # constraints.append(f"IO = {' + '.join(IO)}; # total IO in number of elements")

        ######
        # if one task write an arr and on other task read the arr
        # we need to make sure it is read / write in the same order
        # or fully transfered
        ######


        
        for arr in list(self.info_arrays.keys()):
            write = []
            read = []
            nb_call = len(self.info_arrays[arr][0])
            for id_call in range(nb_call):
                curr_loop = self.info_arrays[arr][0][id_call]
                id_sched = -1
                for id_sched2 in range(len(self.schedule)):
                    loops_ = self.schedule[id_sched2][1::2]
                    if curr_loop in loops_:
                        id_sched = id_sched2
                        break
                w = self.analysis.dic[id_sched]["write"][0]
                name_array = w.split("[")[0]
                if name_array == arr:
                    write.append(id_sched)
                else:
                    r = self.analysis.dic[id_sched]["read"]
                    for rr in r:
                        name_array = rr.split("[")[0]
                        if name_array == arr:
                            read.append(id_sched)
                            break
            if len(read) > 0 and len(write) > 0:
                for id_sched_write in write:
                    for id_sched_read in read:
                        if id_sched_write < id_sched_read:
                            id_FT1 = -1
                            id_FT2 = -1
                            for id_, dd in enumerate(self.what_is_fuse()):
                                if id_sched_write in dd:
                                    id_FT1 = id_
                                if id_sched_read in dd:
                                    id_FT2 = id_
                            loop_order_dim_write = []
                            loop_order_dim_read = []
                            for dim in range(len(self.info_arrays[arr])):
                                for loop in self.info_arrays[arr][dim]:
                                    if loop in self.schedule[id_sched_write][1::2]:
                                        loop_order_dim_write.append(loop)
                                    if loop in self.schedule[id_sched_read][1::2]:
                                        loop_order_dim_read.append(loop)
                            for perm_sched1 in range(len(perms[id_sched_write])):
                                for perm_sched2 in range(len(perms[id_sched_read])):
                                    order_for_sched1 = []
                                    order_for_sched2 = []
                                    for l1 in perms[id_sched_write][perm_sched1]:
                                        for d1 in range(len(loop_order_dim_write)):
                                            if loop_order_dim_write[d1] == l1:
                                                order_for_sched1.append(d1)
                                    for l2 in perms[id_sched_read][perm_sched2]:
                                        for d2 in range(len(loop_order_dim_read)):
                                            if loop_order_dim_read[d2] == l2:
                                                order_for_sched2.append(d2)
                                    if order_for_sched1 != order_for_sched2:
                                        cons = f"perm{perm_sched1}_S{id_sched_write} * perm{perm_sched2}_S{id_sched_read} * level_transfer_{name_array}_FT{id_FT2}_under0 = perm{perm_sched1}_S{id_sched_write} * perm{perm_sched2}_S{id_sched_read} * 1;"
                                        if cons not in constraints:
                                            constraints.append(cons)
                            
                                    




                


        ######
        # if array transfered under loop which does not iterate the array
        # need to have full reuse
        ######

        
        for arr in list(self.info_arrays.keys()):
            for nb_call in range(len(self.info_arrays[arr][0])):
                loops = []
                for id_dim in list(self.info_arrays[arr].keys()):
                    loops += [self.info_arrays[arr][id_dim][nb_call]]
                #find corresponding schedule
                id_sched = -1
                for id_sched2 in range(len(self.schedule)):
                    loops_ = self.schedule[id_sched2][1::2]
                    if loops[0] in loops_:
                        id_sched = id_sched2
                        break
                id_FT = -1
                for id_, dd in enumerate(self.what_is_fuse()):
                    if id_sched in dd:
                        id_FT = id_
                        break
                if not self.allow_multiple_transfer:
                    for id_perm, perm in enumerate(perms[id_sched]):
                        if perm[0] not in loops:
                            cc = f"perm{id_perm}_S{id_sched} * level_reuse_{arr}_FT{id_FT}_under0 = perm{id_perm}_S{id_sched} * 1;"
                            if cc not in constraints:
                                constraints.append(cc)

                    # FIXME there is more case than that

        ######



        for k in range(len(self.schedule)):
            read = self.analysis.dic[k]["read"]
            write = self.analysis.dic[k]["write"]
            randw = read + write
            iterator_loops = []
            deja_vu = []

            for j in range(1, len(self.schedule[k]), 2):
                iterator_loops.append((self.schedule[k][j], self.iterators[self.schedule[k][j]]))
            name = []
            for r in randw:
                # if r.count("[") == len(iterator_loops): # same number of loops as dim
                #     continue
                n = r.split("[")[0]
                size = r[r.index("[")+1:-1].split("][")
                for id_, itt in enumerate(iterator_loops):
                    id_loop, it = itt
                    # if it == "0":
                    #     continue
                    for l, s in enumerate(size):
                        if "+" in s or "-" in s or "*" in s or "/" in s:
                            subsize = s.replace("+", "!").replace("-", "!").replace("*", "!").replace("/", "!").split("!")
                        else:
                            subsize = [s]
                        for ll,ss in enumerate(subsize):
                            if it == ss:
                                size[l] = size[l].replace(it, f"TC{id_loop}_1")
                if r.split("[")[0] + "[" + "][".join(size) + "]" not in name:
                    str_ = r.split("[")[0] + "[" + "][".join(size) + "]"
                    name.append(str_)

            for n in name:
                if "[0]" not in n:
                    comments.append(f"Sched {k} has reuse buffer {n}")
        
        


        f = open(self.nlp_file, "w")
        for head in header:
            f.write(head + "\n")
        f.write("\n")
        for p in param:
            f.write("param " + p + "\n")
        f.write("\n")
        for v in var:
            f.write("var " + v + "\n")
        f.write("\n")

        for c in comments:
            f.write("#comment: " + c + "\n")
        f.write("\n")

        # f.write(f"minimize cost: {' + '.join(obj)};\n")
        f.write(f"minimize cost: obj;\n")
        f.write("\n")

        for k, c in enumerate(constraints):
            if ";" not in c:
                c = c + ";"
            if "#" in c.split(";")[0]:
                f.write(f"#subject to con{k}:" + c[1:] + "\n")
            else:
                f.write(f"subject to con{k}: " + c + "\n")

        f.write("solve;\n")
        for k in var:
            k = k.split(" ")[0]
            f.write(f"display " + k + ";\n")
        f.write("display _total_solve_time;\n")
        f.close()
        
    def create_max_constraint(self, v1, v2):
        str_ = f"({v1} + {v2} + abs({v1}-{v2}))/2"
        return str_
    
    def create_min_constraint(self, v1, v2):
        str_ = f"({v1} + {v2} - abs({v1}-{v2}))/2"
        return str_
