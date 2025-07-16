import ressources as res
import math
from itertools import combinations, product, permutations
import numpy as np
import pocc

import networkx as nx
import matplotlib.pyplot as plt
from collections import deque



class memoryBound:

    def __init__(self, file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top):
        self.file = file
        
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
            # if not previous_dependance:
            #     self.matrix_graph[0][k1+1] = 1 # Root to k1
            for k2 in range(len(self.schedule)):
                if self.inter_task_dependance[k1][k2]:
                    if k2 > k1:
                        self.matrix_graph[k1+1][k2+1] = 1

        # delete cycle if any
        for k1 in range(len(self.matrix_graph)):
            for k2 in range(len(self.matrix_graph)):
                for k3 in range(len(self.matrix_graph)):
                    if self.matrix_graph[k1][k2] == 1 and self.matrix_graph[k2][k3] == 1:
                        self.matrix_graph[k1][k3] = 0

        # # RAR
        # # FIXME need to check the polyhedron to be sure it is a RAR
        read = {}
        read = {0: []}
        scop = pocc.scop(self.file)
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

        res = pocc.candl(self.file)
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
        # FIXME here we suppose it is consecutive
        return list(all_output.values())





    def create_nlp(self):


        var = []
        constraints = []
        obj = []
        comments = []
        tot_buffer = []
        obj_latency_computation = []
        param = [f"DSP_avail = {res.Ressources().DSP};", f"ON_CHIP_MEM_SIZE = {res.Ressources().ON_CHIP_MEM_SIZE};", f"MAX_BUFFER_SIZE = {res.Ressources().MAX_BUFFER_SIZE};", f"CONSTRAINT_ARRAY_PARTITIONING_VALUE = {res.Ressources().partitioning_max};"]
        perms = {}
        # IO = []
        # var += ["IO integer >=0;"]

        # param.append("min_IO = 0;")
        # param.append("min_latency = 1;")
        what_is_fuse = self.what_is_fuse()
        for is_fuse in what_is_fuse:
            comments.append(f"Fuse {is_fuse}")

        lat_comp_per_stat = {}

        for k in range(len(self.schedule)):
            str_ = f"Statement {k}: {self.statements[k]}"
            if str_ not in comments:
                comments.append(str_)
            # comments.append(f"Statement {k}: {self.statements[k]}")
        for k in range(len(self.iterators)):
            str_ = f"Loop_{k}: {self.iterators[k]}"
            if str_ not in comments:
                comments.append(str_)
            # var.append(f"loop{k}_UF integer >= 1;")
        for k in range(len(self.arguments)):
            str_ = f"Argument {k}: {self.arguments[k]}"
            if str_ not in comments:
                comments.append(str_)
        for k in range(len(self.schedule)):
            param.append(f"II_S{k}_par = 1;")
            param.append(f"II_S{k}_seq = 3;")
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
                # need to know which array need to be give to the next one
                # if f"tot_latency_S{k} >= 0;" not in var:
                #     var.append(f"tot_latency_S{k} >= 0;")
                #FIXME TODO lala
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

                            randw_k = read_k + write_k
                            randw_k2 = read_k2 + write_k2

                            for r_k in randw_k:
                                for r_k2 in randw_k2:
                                    if r_k.split("[")[0] == r_k2.split("[")[0]:
                                        if r_k.split("[")[0] not in curr_arr_dep_for_each_statement:
                                            curr_arr_dep_for_each_statement.append(r_k.split("[")[0])
                                            str_1 = f"Task {k} gives {r_k.split('[')[0]} to Task {k2-1}"
                                            str_2 = f"Task {k2-1} received {r_k.split('[')[0]} from Task {k}"
                                            if str_1 not in comments:
                                                comments.append(str_1)
                                            if str_2 not in comments:
                                                comments.append(str_2)
                                            # comments.append(f"Task {k} gives {r_k.split('[')[0]} to Task {k2-1}")
                                            # comments.append(f"Task {k2-1} received {r_k.split('[')[0]} from Task {k}")
                            arr_dep_for_each_statement.append(curr_arr_dep_for_each_statement)

                            if f"Lat_comp_S{k}_for_S{k2-1} >= 0;" not in var:
                                var.append(f"Lat_comp_S{k}_for_S{k2-1} >= 0;")
                                var.append(f"debit_S{k}_to_S{k2-1}  >= 0;")
                                var.append(f"debit_S{k2-1}_from_S{k}  >= 0;")

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
                    #FIXME add var buffer size

                    # IO += [f"{'_0 * '.join(io_) + '_0'} * {'_1 * '.join(io_) + '_1'}"]
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
                constraints.append(f"Lat_comp_S{k}_intra_tile = IL_par_S{k} + IL_seq_S{k} * {' * '.join(red_prod)}; # latency of the intra-tile S{k}")
            else:
                constraints.append(f"Lat_comp_S{k}_intra_tile = IL_par_S{k} + IL_seq_S{k}; # latency of the intra-tile S{k}")

        # TODO latency per fused function (same output so dependency)

        # TODO constraint on perm for fused task

        # TODO shift per connection
        # TODO buffer size per connection


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
            for r in randw:
                var.append(f"stationary_{r}_S{stat} binary >= 0;")
                var.append(f"fill_out_{r}_S{stat} binary >= 0;") # TODO
                var.append(f"reuse_{r}_S{stat} binary >= 0;")
                var.append(f"comm_off_chip_{r}_S{stat} binary >= 0;")
                var.append(f"broadcast_{r}_S{stat} binary >= 0;")
                var.append(f"reuse_{r}_S{stat}_size integer >= 0;")

                constraints.append(f"stationary_{r}_S{stat} + reuse_{r}_S{stat} + comm_off_chip_{r}_S{stat} = 1; # only one type of reuse")
                # constraints.append(f"reuse_{r}_S{stat}_size = footprint_tot_{r};")

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
            
            
            for arr in randw:
                it = self.extract_iterators(arr)
                if len(loops) == len(it):
                    ar = arr.split("[")[0]
                    constraints.append(f"reuse_{ar}_S{stat} = 0;")
                    constraints.append(f"comm_off_chip_{ar}_S{stat} = 0;")
                    constraints.append(f"stationary_{ar}_S{stat} = 1;")
                else:
                    for id_perm, perm in enumerate(perms[stat]):
                        # if reduction for this array innermost then stationnary
                        non_iterator = []
                        statio = True
                        for kk, l in enumerate(loops):
                            if l not in it:
                                non_iterator.append(l)
                            else:
                                if len(non_iterator) > 0:
                                    statio = False
                                    ar = arr.split("[")[0]
                                    constraints.append(f"perm{id_perm}_S{stat} * stationary_{ar}_S{stat} = perm{id_perm}_S{stat} * 0;")
                                    break
                        if statio:
                            ar = arr.split("[")[0]
                            constraints.append(f"perm{id_perm}_S{stat} * reuse_{ar}_S{stat} = perm{id_perm}_S{stat} * 0;")
                            constraints.append(f"perm{id_perm}_S{stat} * comm_off_chip_{ar}_S{stat} = perm{id_perm}_S{stat} * 0;")
                            constraints.append(f"perm{id_perm}_S{stat} * stationary_{ar}_S{stat} = perm{id_perm}_S{stat} * 1;")
                            




        # DSP constraints
        dsp = []
        
        for k in range(len(self.schedule)):
            dsp_ = []
            loops = self.schedule[k][1::2]
            for l in loops:
                dsp_.append(f"TC{l}_1")
            dsp.append(f"{' * '.join(dsp_)} * DSP_S{k}")
        constraints.append(f"{' + '.join(dsp)} <= DSP_avail; # DSP constraint")



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
                if len(cost)> 0:
                    constraints.append(f"{key} = {' + '.join(lat_comp_per_stat[key])} + {cost}; # stall between task")
                else:
                    constraints.append(f"{key} = {' + '.join(lat_comp_per_stat[key])}; # stall between task")
                UF = [f"loop{l}_UF" for l in self.schedule[int(S0)][1::2]]

                UF = " * ".join(UF)
                constraints.append(f"debit_S{S0}_to_S{S1} = min(128 * burst_{write_array_S0}, footprint_{write_array_S0} / Lat_comp_S{S0}_for_S{S1})  ;")   
                constraints.append(f"debit_S{S1}_from_S{S0} = debit_S{S0}_to_S{S1};")
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
                seq = 1 * res.Ressources().IL["+"]
            for o in op:
                if o == "+":
                    nb = op[o]
                    if is_red:
                        nb -= 1
                    par += nb * res.Ressources().IL["+"]
                elif o == "-":
                    nb = op[o]
                    par += nb * res.Ressources().IL["-"]
                elif o == "*":
                    nb = op[o]
                    par += nb * res.Ressources().IL["*"]
                elif o == "/":
                    nb = op[o]
                    par += nb * res.Ressources().IL["/"]

            if par == 0:
                par = 1 # assignement
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
                    dsp_used += nb * res.Ressources().DSP_per_operation["+"]
                elif o == "-":
                    nb = op[o]
                    dsp_used += nb * res.Ressources().DSP_per_operation["-"]
                elif o == "*":
                    nb = op[o]
                    dsp_used += nb * res.Ressources().DSP_per_operation["*"]
                elif o == "/":
                    nb = op[o]
                    dsp_used += nb * res.Ressources().DSP_per_operation["/"]
            DSP_used[k] = dsp_used
            param.append(f"DSP_S{k} = {dsp_used};")

        header = ["#option solver baron;", "#option baron_options 'maxtime=30 trace=nlp.trace sumfile=nlp.sum';"]
        header += ["option solver gurobi;", "option gurobi_options 'lim:time=30 tech:logfile=nlp.log qp:nonconvex=2';"]
        header += ["#option solver octeract;", "#option octeract_options 'max_solver_time=30';"]



        # for k in range(len(self.schedule)):
        #     # obj += [f"Lat_comp_S{k}"]
        #     var += [f"Lat_comp_S{k} >= 0;"]
        

        for k in list(self.TC.keys()):
            tc = []
            param.append(f"TC{k}_ori = {self.TC[k]};")
            var.append(f"TC{k} integer >= TC{k}_ori <= 2*TC{k}_ori;")

            for j in range(2):
                var += [f"TC{k}_{j} integer >= 1;"]
                constraints.append(f"TC{k}_{j} <= TC{k}; # TC of split loop")
                tc += [f"TC{k}_{j}"]
            constraints.append(f"{' * '.join(tc)} = TC{k}; # product of the TC of split loop = original TC" )

        for k in range(len(self.schedule)):
            pass
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
                        for id_dim, it in enumerate(its):
                            for loop in loops:
                                if self.iterators[loop] == it:
                                    # cc = ""
                                    # if not self.red_loop[loop]:
                                    #     cc = f"loop{loop}_UF * TC{loop}_2"
                                    # else:
                                    #     cc = f"TC{loop}_2"
                                    # if cc not in self.info_arrays[array][id_dim]:
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
                        # constraints.append(f"TC{p1}_1 = TC{p2}_1; # same intra tile for the same dimension of the array {array}")
                        # constraints.append(f"loop{p1}_UF = loop{p2}_UF; # same intra tile for the same dimension of the array {array}")
                        # if red UF = 1
                        # if self.red_loop[p1]:
                        #     constraints.append(f"loop{p1}_UF = 1; # reduction => UF = 1")
                        # if self.red_loop[p2]:
                        #     constraints.append(f"loop{p2}_UF = 1; # reduction => UF = 1")
                l_array += list_loop
                #     pair = pairs[0]
                #     p1 = pair[0]
                #     p2 = pair[1]
                #     constraints.append(f"footprint_{array} = {' * '.join([f'TC{p1}_1' for _ in range(dim_array[array])])}; # footprint of the intra tile of the array {array}")
                # else:
                #     pass
            l_array = list(set(l_array))
            # if len(l_array) > 0:
            #     dd = ', '.join([f"loop{l}_UF" for l in l_array])
            #     constraints.append(f"nb_read_{array} = max({dd})")
            #     constraints.append(f"nb_write_{array} = max({dd})")
        
        
        # exit(0)
        id_cte = 0
        for array in arrays:
            list_loop = []
            for dim in range(dim_array[array]):
                list_loop += [f"TC{self.info_arrays[array][dim][0]}_1"]
            constraints.append(f"footprint_{array} = {' * '.join(list_loop)}; # footprint of the intra tile of the array {array}")
            
            cons_burst = []
            only_one = []
            last_dim = dim_array[array]-1
            last_dim_loop = self.info_arrays[array][last_dim][0]
            for k in [1,2,4,8,16]:
                var.append(f"burst_{array}_is_{k} binary;")
                var.append(f"cte_{id_cte} integer >=0;")
                only_one.append(f"burst_{array}_is_{k}")
                
                constraints.append(f"burst_{array}_is_{k} * cte_{id_cte} * {k} = burst_{array}_is_{k} * TC{last_dim_loop}_1;")
                cons_burst.append(f"burst_{array}_is_{k} * {k}")
                id_cte += 1
            constraints.append(f"burst_{array} = {' + '.join(cons_burst)}; # burst size of the array {array}")
            constraints.append(f"{' + '.join(only_one)} = 1; # only one burst size for the array {array}")


        # Communication latency
        for array in arrays:

            
            # obj += [f"Lat_comm_{array}"]
            var += [f"Lat_comm_{array} >= 0;"]
            var += [f"nb_read_{array} integer >= 0;"]
            var += [f"nb_write_{array} integer >= 0;"]

        first_time_array_appear = {}
        is_write = {}
        for array in arrays:
            first_time_array_appear[array] = -1
            is_write[array] = False
            for key in list(self.analysis.dic.keys()):
                read = self.analysis.dic[key]["read"]
                write = self.analysis.dic[key]["write"]
                randw = read + write
                for r in randw:
                    if array in r:
                        if r in write:
                            is_write[array] = True
                        if first_time_array_appear[array] == -1:
                            first_time_array_appear[array] = key
                            comments.append(f"Task {key} reads {array} from off-chip")
                            arr = array.split("[")[0]
                            var.append(f"debit_S{key}_{arr}_from_off_chip  >= 0;")
                            # constraints.append(f"debit_S{key}_{arr}_from_off_chip = burst_{array} / nb_read_{arr};")
                            constraints.append(f"debit_S{key}_{arr}_from_off_chip = 1 / ((footprint_{array} / burst_{array}) / nb_read_{arr});")
                        break
            
            # if is_write[array]:
            #     IO += [f"2*footprint_tot_{array}"]
            # else:
            #     IO += [f"footprint_tot_{array}"]

        # var.append("footprint integer >= 0;")
        # constraints.append("footprint <= ON_CHIP_MEM_SIZE;")
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
                                var.append(f"footprint_tot_{array} integer >= 1;")
                                #ici
                                # param.append(f"burst_size_tot_{array} = {burst_size[array]};")
                                var.append(f"burst_{array} integer >= 0;")
                                var.append(f"footprint_{array} integer >= 0;")
                                constraints.append(f"footprint_{array} <= MAX_BUFFER_SIZE;")

                                list_foot.append(f"footprint_tot_{array}")
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
                    if dim == len(list(self.info_arrays[array].keys()))-1:
                        l.append(f"TC{self.info_arrays[array][dim][nb]}")
                        in_last_dim.append(self.info_arrays[array][dim][nb])
                    else:
                        l.append(f"TC{self.info_arrays[array][dim][nb]}_ori")
                constraints.append(f"footprint_tot_{array} = {' * '.join(l)};")
        all_loops = list(set(all_loops))
        for loop in all_loops:
            if loop not in in_last_dim:
                constraints.append(f"TC{loop} = TC{loop}_ori;")
        # exit(0)

        for array in arrays:
            if dim_array[array] == 1:
                constraints.append(f"Lat_comm_{array} = 0;")
                continue
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

        # for key in list(one_path.keys()):
        #     if len(one_path[key]) > 0:
        #         for k in range(len(self.matrix_graph)):
        #             if self.matrix_graph[k][key] == 1:
        #                 self.matrix_graph[k][key] = 0
        #         for k in one_path[key]:
        #             self.matrix_graph[key][k] = 1

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
                    var.append(f"Lat_comp_{'_'.join(list(map(str,id_stat)))}_for_S{succ} >= 0;")
                    var.append(f"debit_{'_'.join(list(map(str,id_stat)))}_to_S{succ} >= 0;")
                    constraints.append(f"Lat_comp_{'_'.join(list(map(str,id_stat)))}_for_S{succ} = {' + '.join(curr_lat_comp) }; # chain of task")
                    constraints.append(f"debit_{'_'.join(list(map(str,id_stat)))}_to_S{succ} = min({', '.join(curr_debut_comp) }); # chain of task")

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
                    comments.append(f"Task {k} writes {array} to off-chip")
                    arr = array.split("[")[0]
                    var.append(f"debit_S{key}_{arr}_to_off_chip  >= 0;")
                    constraints.append(f"debit_S{key}_{arr}_to_off_chip =  footprint_{arr} / burst_{array} / Lat_comp_S{key}_for_off_chip;")

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

                var.append(f"Lat_comp_parallel_before_S{k1-1} >= 0;")
                var.append(f"debit_parallel_before_S{k1-1} >= 0;")
                list_max = []
                list_min = []
                for k in argument_of_max:
                    for j in range(len(id_lat[k])):
                        if f"for_S{k1-1}" in id_lat[k][j]:
                            list_max.append(id_lat[k][j])
                            list_min.append(id_lat[k][j].replace("Lat_comp_", "debit_").replace("for", "to"))
                # {', '.join([id_lat[k] for k in argument_of_max])}
                list_max = ', '.join(list_max)
                list_min = ', '.join(list_min)

                constraints.append(f"Lat_comp_parallel_before_S{k1-1} = max({list_max}); # critical path path before S{k1-1}")
                constraints.append(f"debit_parallel_before_S{k1-1} = min({list_min}); # critical path path before S{k1-1}")
                obj.append(f"Lat_comp_parallel_before_S{k1-1}")
        
        off_chip_per_stat = {}
        deja_vu = {}
        # to_chip_per_stat = {}

        # for v in var:
        #     if "debit" in v and "to_off_chip" in v:
        #         obj += [v.split(" ")[0]]

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

        # if len(list_off_chip) > 1:
        #     obj += [f"max({', '.join(list_off_chip)})"]
        # else:
        #     obj += list_off_chip
        var.append("obj >= 0;")
        # param.append("min_IO = 0;")
        # param.append("min_latency = 1;")
        # constraints.append(f"obj = min_latency * ({' + '.join(obj)}) + min_IO * IO;")
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
                #     constraints.append(f"{' * '.join(tc)} <= MAX_BUFFER_SIZE; # buffer for {r} in statement {key}")
                    # tot_buffer += [f"(1 - reuse_{r}_S{key}) * {' * '.join(tc)} + reuse_{r}_S{key} * reuse_{r}_S{key}_size"]
                    # tot_buffer += [f"{' * '.join(tc)} "]
                    if r not in list(arr_per_stat_fused.keys()):
                        arr_per_stat_fused[r] = []
                    arr_per_stat_fused[r] += [key]
        
        for fused_task in what_is_fuse:
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
                tot_buffer += [f"footprint_{arr}_{name}"]
                var.append(f"footprint_{arr}_{name} integer >= 0;")
                # TODO read footprint of the array with reuse


        # exit(0)
        # exit(0)
        # for each loop which iterate same dim we need to have the same tiling
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
                        constraints.append(f"max(TC{pair[0]}_1, TC{pair[1]}_1) = min(TC{pair[0]}_1, TC{pair[1]}_1) * cte_tiling_{id_cte}; # should divide for {arr} in dim {dim}") 
                        id_cte += 1
                        # constraints.append(f"TC{pair[0]}_0 = TC{pair[1]}_0; # same tiling for {arr} in dim {dim}")


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
                        if it == s:
                            size[l] = f"TC{id_loop}_1"
                if r.split("[")[0] + "[" + "][".join(size) + "]" not in name:
                    name.append(r.split("[")[0] + "[" + "][".join(size) + "]")
            for n in name:
                if "[0]" not in n:
                    comments.append(f"Sched {k} has reuse buffer {n}")
        

# TODO
# should be constraint RaR also
# separate the Lat per array
# if two parallel path read the same array ??

        f = open("nlp3.mod", "w")
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

# TODO
# minimize lat
# create lat per function
# create shift per link
# create var for where we transfer array
# fix the problem of stationnary