import ressources as res
import math
from itertools import combinations, product
import numpy as np

class computationBound:

    def __init__(self, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top, optimize_burst):
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
        self.optimize_burst = optimize_burst
        self.TC = {}
        self.compute_TC()

        self.array_to_focus = self.analysis.array_to_focus

        self.loop_body_independant = {}
        self.compute_loop_body_independant()

        self.info_loops = {}
        self.compute_info_loops()

        self.create_nlp()

        # self.compute()

    def compute_TC(self):
        id_loop = 0
        for i in range(len(self.schedule)):
            TC = self.analysis.dic[i]["TC"]
            for j in range(1, len(self.schedule[i]), 2):
                id_loop = self.schedule[i][j]
                self.TC[id_loop] = TC[self.iterators[id_loop]]



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


    def create_nlp(self):
        var = []
        constraints = []
        obj = []
        param = [f"DSP_avail = {res.Ressources().DSP};", f"#ON_CHIP_MEM_SIZE = {res.Ressources().ON_CHIP_MEM_SIZE};", f"ON_CHIP_MEM_SIZE = {res.Ressources().ON_CHIP_MEM_SIZE//4};", "CONSTRAINT_ARRAY_PARTITIONING_VALUE = 1024;", "BRAM = 4320;", "size_data_type = 32;", "optimist_reuse_dsp=1;"]
        for key in self.TC:
            param.append(f"TC{key} = {self.TC[key]};")
            for k in range(3):
                var.append(f"TC{key}_{k} integer >= 1 <=TC{key};")

            constraints.append(f"TC{key} = TC{key}_0 * TC{key}_1 * TC{key}_2;")
        loop_UF_per_stat = {}

        
        
        for key in self.TC:
            loop_UF_per_stat[key] = []
            if not self.red_loop[key]:
                var.append(f"loop{key}_UF integer >= 1 <=TC{key};")
                constraints.append(f"loop{key}_UF = 1;")
        for k in range(len(self.schedule)):
            loop_UF_per_stat[k] = []
            loops = self.schedule[k][1::2]
            for loop in loops:
                if not self.red_loop[loop]:
                    loop_UF_per_stat[k].append(f"loop{loop}_UF")
        
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

        DSP_pessimiste = []
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

        header = ["option solver baron;", "option baron_options 'maxtime=90 trace=nlp.trace sumfile=nlp.sum';"]
        # var.append("nb_DSP integer >= 0;")
        all_DSP = []
        for k in range(len(self.schedule)):
            if DSP_used[k] > 0:
                prod = []
                loops = self.schedule[k][1::2]
                for loop in loops:
                    prod.append(f"TC{loop}_2")
                prod = " * ".join(prod)
                if len(loop_UF_per_stat[k]) > 0:
                    prod += " * " + " * ".join(loop_UF_per_stat[k])
                if self.cyclic_buffer:
                    prod += f" + {self.size_cyclic_buffer} * {res.Ressources().DSP_per_operation['+']}"
                constraints.append(f"DSP_S{k} * {prod} <= DSP_avail * II_S{k};")
                DSP_pessimiste.append(f"(DSP_S{k} * {prod}) / II_S{k}")
                all_DSP.append(f"(DSP_S{k} * {prod}) / II_S{k}")
        # constraints.append(f"nb_DSP = {' + '.join(all_DSP)};")
        constraints.append(f"(1-optimist_reuse_dsp) * {' + '.join(DSP_pessimiste)} <= DSP_avail;")
        for k in range(len(self.schedule)):
            obj += [f"Lat_comp_S{k}"]
            var += [f"Lat_comp_S{k} >= 0;"]
        

        for k in range(len(self.schedule)):
            var += [f"II_S{k} integer >= 1;"]

        for k in range(len(self.schedule)):
            CG = []
            IL = []
            FG = []
            PIP = []

            loops = self.schedule[k][1::2]
            for loop in loops:
                if self.red_loop[loop]:
                    CG.append(f"TC{loop}_0")
                else:
                    CG.append(f"TC{loop}_0 / loop{loop}_UF")
                    constraints.append(f"loop{loop}_UF <= TC{loop}_0;")
                
                # FG.append(f"TC{loop}_2")
                PIP.append(f"TC{loop}_1")
            IL.append(f"IL_par_S{k}")

            is_red = False
            red_loops = []
            for loop in loops:
                if self.red_loop[loop]:
                    red_loops.append(f"TC{loop}_2")
                    is_red = True
            if is_red:
                if self.cyclic_buffer:
                    IL.append(f"IL_seq_S{k} + {math.ceil(math.log(self.size_cyclic_buffer, 2))} * {res.Ressources().DSP_per_operation['+']}")
                else:
                    pp = " * ".join(red_loops)
                    IL.append(f"IL_seq_S{k} * log({pp})/log(2)")


            CG = " * ".join(CG)
            IL = " + ".join(IL)
            FG = ""
            PIP = " * ".join(PIP)
            constraints.append(f"Lat_comp_S{k} = {CG} * ({IL} + II_S{k} * ({PIP} - 1))")

        for k in range(len(self.schedule)):
            is_red = False
            red_loops = []
            loops = self.schedule[k][1::2]
            for loop in loops:
                if self.red_loop[loop]:
                    red_loops.append(f"TC{loop}_1")
                    is_red = True
            if not is_red:
                pos = []
                constraints.append(f"II_S{k} = 1;")
                for loop in loops:
                    var.append(f"is_loop{loop}_pip binary;")
                    pos.append(f"is_loop{loop}_pip")
                    ol = []
                    for other_loops in loops:
                        if other_loops != loop:
                            ol.append(f"TC{other_loops}_1")
                    if len(ol)>0:
                        constraints.append(f"is_loop{loop}_pip * {' * '.join(ol)} = is_loop{loop}_pip * 1;")
                    constraints.append(f"is_loop{loop}_pip * TC{loop}_1 >= is_loop{loop}_pip * 2;")
                pos = " + ".join(pos)
                constraints.append(f"{pos} = 1;")
                #even if it is not a reduction we need to have one loop pipelined
            else:
                pos = []
                for loop in loops:
                    var.append(f"is_loop{loop}_pip binary;")
                    pos.append(f"is_loop{loop}_pip")
                    # here the other loops have to be to 1 to have loop pipeline
                    ol = []
                    for other_loops in loops:
                        if other_loops != loop:
                            ol.append(f"TC{other_loops}_1")
                    constraints.append(f"is_loop{loop}_pip * {' * '.join(ol)} = is_loop{loop}_pip * 1;")
                    constraints.append(f"is_loop{loop}_pip * TC{loop}_1 >= is_loop{loop}_pip * 2;")
                pos = " + ".join(pos)
                #FIXME depend of the operation
                cons_II = ""
                for i, loop in enumerate(loops):
                    if self.red_loop[loop]:
                        cons_II += f"{res.Ressources().IL['+']-1} * is_loop{loop}_pip"
                    else:
                        cons_II += f"1 * is_loop{loop}_pip"
                    if i < len(loops) - 1:
                        cons_II += " + "

                constraints.append(f"{pos} = 1;")
                constraints.append(f"II_S{k} = {cons_II};")

        
                
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
                                if self.iterators[loop] in it:
                                    cc = ""
                                    if not self.red_loop[loop]:
                                        cc = f"loop{loop}_UF * TC{loop}_2"
                                    else:
                                        cc = f"TC{loop}_2"
                                    
                                    if cc not in self.info_arrays[array][id_dim]:
                                        self.info_arrays[array][id_dim].append(cc)



        # FIXME for partial array we need to multiply by loop which does not iterate the array but above the array

        array_information = {}
        for array in arrays:
            array_information[array] = {"schedule":[], "write": []}
            for sched in range(len(self.schedule)):
                read = self.analysis.dic[sched]["read"]
                write = self.analysis.dic[sched]["write"]
                for r in read:
                    if array == r.split("[")[0]:
                        array_information[array]["schedule"].append(sched)
                for w in write:
                    if array == w.split("[")[0]:
                        if sched not in array_information[array]["schedule"]:
                            array_information[array]["schedule"].append(sched)
                        array_information[array]["write"].append(sched)



                                        

        id_cte = 0
        # FIXME here we dont need constraint if we transfer the array many times
        for array in arrays:
            l = []
            constraint_array_part = []
            constraint_array_part_per_schedule = {}
            for k in range(len(self.schedule)):
                constraint_array_part_per_schedule[k] = []
            for dim in range(dim_array[array]):
                var.append(f"AP_{array}_{dim} integer >= 1;")


                # constraint_array_part.append(f"transfer_{array}_total * AP_{array}_{dim}")
                constraint_array_part.append(f"AP_{array}_{dim}")
                l.append(self.info_arrays[array][dim])
                # FIXME if many iterators then maybe not add
                for elmt in [" + ".join(self.info_arrays[array][dim])]:
                    var.append(f"cte_{id_cte} integer >= 1;")
                    # constraints.append(f"transfer_{array}_total * {elmt} <= transfer_{array}_total * AP_{array}_{dim};")
                    constraints.append(f"{elmt} <= AP_{array}_{dim};")
                    cur_sched = -1
                    index = elmt.index("TC")
                    cur_loop = elmt[index:].split("_")[0].replace("TC", "")
                    cur_sced = -1
                    for kl, sched_ in enumerate(self.schedule):
                        if int(cur_loop) in sched_[1::2]:
                            cur_sched = kl
                            break

                    # if f"(1 - transfer_{array}_total) * AP_{array}_{dim}_S{cur_sched}" not in constraint_array_part_per_schedule[cur_sched]:
                    #     constraint_array_part_per_schedule[cur_sched].append(f"(1 - transfer_{array}_total) * AP_{array}_{dim}_S{cur_sched}")

                    # if f"(1 - transfer_{array}_total) * {elmt} <= (1 - transfer_{array}_total) * AP_{array}_{dim}_S{cur_sched};" not in constraints:
                    #     constraints.append(f"(1 - transfer_{array}_total) * {elmt} <= (1 - transfer_{array}_total) * AP_{array}_{dim}_S{cur_sched};")
                    # if f"transfer_{array}_total * AP_{array}_{dim} = transfer_{array}_total * {elmt} * cte_{id_cte};" not in constraints:
                    #     constraints.append(f"transfer_{array}_total * AP_{array}_{dim} = transfer_{array}_total * {elmt} * cte_{id_cte};")

                    if f"AP_{array}_{dim} = ({elmt}) * cte_{id_cte};" not in constraints:
                        constraints.append(f"AP_{array}_{dim} = ({elmt}) * cte_{id_cte};")
                    id_cte += 1
                    # if f"AP_{array}_{dim}_S{cur_sched} = {elmt} * cte_{id_cte};" not in constraints:
                    #     var.append(f"cte_{id_cte} integer >= 1;")
                    #     constraints.append(f"(1 - transfer_{array}_total) * AP_{array}_{dim}_S{cur_sched} = (1 - transfer_{array}_total) * {elmt} * cte_{id_cte};")
                    #     id_cte += 1
                    # if f"transfer_{array}_total * AP_{array}_{dim} <= {self.analysis.arrays_size[array][dim]};" not in constraints:
                    #     constraints.append(f"transfer_{array}_total * AP_{array}_{dim} <= {self.analysis.arrays_size[array][dim]};")
                    # if f"AP_{array}_{dim}_S{cur_sched} <= {self.analysis.arrays_size[array][dim]};" not in constraints:
                    #     constraints.append(f"(1 - transfer_{array}_total) * AP_{array}_{dim}_S{cur_sched} <= {self.analysis.arrays_size[array][dim]};")

                    if f"AP_{array}_{dim} <= {self.analysis.arrays_size[array][dim]};" not in constraints:
                        constraints.append(f"AP_{array}_{dim} <= {self.analysis.arrays_size[array][dim]};")
                    

                



                # pos = list(combinations(self.info_arrays[array][dim], 2))
                # for pair in pos:
                #     cte = f"cte_{id_cte}"
                #     m = f"m_{id_cte}"
                #     M = f"M_{id_cte}"
                #     bb = f"bool_{id_cte}"
                #     id_cte += 1
                #     var.append(f"{cte} integer >= 1;")
                #     var.append(f"{m} integer >= 1;")
                #     var.append(f"{M} integer >= 1;")
                #     var.append(f"{bb} binary;")

                    
                #     maxi = self.create_max_constraint(pair[0], pair[1])
                #     mini = self.create_min_constraint(pair[0], pair[1])
                    # too complex
                    # constraints.append(f"{M} = {maxi};")
                    # constraints.append(f"{m} = {mini};")


                    # constraints.append(f"{bb} * {pair[0]} >= {bb} * {pair[1]};")
                    # constraints.append(f"{M} = {bb} * {pair[0]} + (1-{bb}) * {pair[1]};")
                    # constraints.append(f"{m} = {bb} * {pair[1]} + (1-{bb}) * {pair[0]};")

                    # constraints.append(f"{M} = {m} * {cte};")

            cc = " * ".join(constraint_array_part)
            constraints.append(f"{cc} <= CONSTRAINT_ARRAY_PARTITIONING_VALUE;")


            # for key_ in list(constraint_array_part_per_schedule.keys()):
            #     if len(constraint_array_part_per_schedule[key_]) > 0:
            #         cc = " + ".join(constraint_array_part_per_schedule[key_])
            #         constraints.append(f"{cc} <= CONSTRAINT_ARRAY_PARTITIONING_VALUE;")

        # Communication latency
        # for array in arrays:
        obj += [f"Lat_comm"]
        var += [f"Lat_comm >= 0;"]

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
                        break

        # var.append("footprint integer >= 0;")
        # constraints.append("footprint <= ON_CHIP_MEM_SIZE;")
        for array in arrays:
            var.append(f"transfer_{array}_total binary;")
        footprint_array = {}
        burst_size = {}
        list_foot = []
        already_seen = []
        initialization = {}
        for array in arrays:
            initialization[array] = False
            for key in list(self.analysis.dic.keys()):
                write = self.analysis.dic[key]["write"][0]
                if array == write.split("[")[0]:
                    read = self.analysis.dic[key]["read"]
                    if len(read) == 0:
                        initialization[array] = True
                        break
        constraint_per_array_per_schedule = {}
        constraint_per_array_per_schedule_lat = {}
        
        id_cte_burst = 0
        for array in arrays:
            constraint_per_array_per_schedule[array] = {}
            constraint_per_array_per_schedule_lat[array] = {}
            
            for key in list(self.analysis.dic.keys()):
                current_con = []
                constraint_per_array_per_schedule[array][key] = []
                constraint_per_array_per_schedule_lat[array][key] = []
                write = self.analysis.dic[key]["write"]
                read = self.analysis.dic[key]["read"]
                wr = write + read
                all_access = []
                last_iterators = []
                for w in wr:
                    
                    if array == w.split("[")[0]:
                        all_access += self.extract_iterators(w)
                        last_iterators += [self.extract_iterators(w)[-1]]

                all_access = list(set(all_access))
                for it in all_access:
                    for l1, loop in enumerate(self.schedule[key][1::2]):
                        if self.iterators[loop] == it:
                            var.append(f"transfer_{array}_S{key}_under_loop{loop} binary;")
                            current_con.append(f"transfer_{array}_S{key}_under_loop{loop}")
                            cur_array_size = self.analysis.arrays_size[array].copy()
                            curr_size = ""
                            curr_lat = ""
                            last_dim = int(cur_array_size[-1])
                            id_loop_terate_last_dim = -1
                            if len(list(set(last_iterators))) == 1:
                                for l_bis in range(len(self.schedule[key][1::2])):
                                    if self.iterators[self.schedule[key][1::2][l_bis]] == last_iterators[0]:
                                        id_loop_terate_last_dim = l_bis
                                        break
                            else:
                                pass
                                #FIXME todo
                            for l2, loop2 in enumerate(self.schedule[key][1::2]):
                                if l2 <= l1:
                                    # curr_burst = 1
                                    # if id_loop_terate_last_dim == l2:
                                    if self.iterators[loop2] in all_access:
                                        curr_size += f"TC{loop2}_0 * "
                            curr_size += f"1"
                            # curr_lat += f" / burst_{array}_S{key}_under_loop{loop}"
                            var.append(f"burst_{array}_S{key}_under_loop{loop} integer >= 1 <=burst_size_tot_{array};")

                            # slowdown ?
                            # for kk in [16, 8, 4, 2, 1]:
                            #     var.append(f"is_burst_{array}_S{key}_under_loop{loop}_{kk} binary >= 0;")
                            #     var.append(f"cte_burst_{id_cte_burst} integer >= 1;")
                            #     constraints.append(f"is_burst_{array}_S{key}_under_loop{loop}_{kk} * TC{id_loop_terate_last_dim}_0 = is_burst_{array}_S{key}_under_loop{loop}_{kk} * {kk} * cte_burst_{id_cte_burst};")
                            #     id_cte_burst += 1

                            # constraints.append(f"burst_{array}_S{key}_under_loop{loop} = 16 * is_burst_{array}_S{key}_under_loop{loop}_16 + 8 * is_burst_{array}_S{key}_under_loop{loop}_8 + 4 * is_burst_{array}_S{key}_under_loop{loop}_4 + 2 * is_burst_{array}_S{key}_under_loop{loop}_2 + 1 * is_burst_{array}_S{key}_under_loop{loop}_1;")
                            
                            constraints.append(f"burst_{array}_S{key}_under_loop{loop} = 1;")

                            str__ = f"transfer_{array}_S{key}_under_loop{loop} * footprint_{array}_S{key} / {curr_size}"
                            if str__ not in constraint_per_array_per_schedule[array][key]:
                                constraint_per_array_per_schedule[array][key].append(str__)
                            time_transfer = 1
                            is_write_ = loop in array_information[array]["write"]
                            is_last_schedule = key == array_information[array]["schedule"][-1]
                            is_first_schedule = key == array_information[array]["schedule"][0]
                            if  is_first_schedule and initialization[array]:
                                time_transfer = 1
                            elif is_last_schedule and not is_write_:
                                time_transfer = 1
                            elif is_last_schedule and is_write_:
                                time_transfer = 2
                            else:
                                time_transfer = 2
                            # il faut diviser mais aussi multiplier par TC donc ca revient au meme
                            # str__ = f"transfer_{array}_S{key}_under_loop{loop} * {time_transfer} * footprint_{array}_S{key}  / burst_{array}_S{key}_under_loop{loop}"
                            str__ = f"transfer_{array}_S{key}_under_loop{loop} * footprint_{array}_S{key}  / burst_{array}_S{key}_under_loop{loop}"
                            if str__ not in constraint_per_array_per_schedule_lat[array][key]:
                                constraint_per_array_per_schedule_lat[array][key].append(str__)
                if len(current_con) >= 1:
                    constraints.append(f"{' + '.join(current_con)} + transfer_{array}_total = 1;")
        
        constraint_per_schedule = {}
        array_already_seen = []
        for k in range(len(self.schedule)):
            current_con = []
            constraint_per_schedule[k] = []
            # list_foot.append(f"transfer_{array}_total * footprint_tot_{array} + {' + '.join(curr_cons)}")
            arry_in_sched = []
            write = self.analysis.dic[k]["write"]
            read = self.analysis.dic[k]["read"]
            wr = write + read
            for w in wr:
                for array in arrays:
                    if array == w.split("[")[0]:
                        arry_in_sched.append(array)
                        array_already_seen.append(array)
            arry_in_sched = list(set(arry_in_sched))
            for array in array_already_seen:
                # if f"transfer_{array}_total * footprint_tot_{array}" not in current_con:
                if f"footprint_tot_{array}" not in current_con:
                    if array_information[array]["schedule"][-1] >= k:
                        current_con += [f"transfer_{array}_total * footprint_tot_{array}"]
                        # current_con += [f"footprint_tot_{array}"]
            for array in arry_in_sched:
                
                current_con += constraint_per_array_per_schedule[array][k]
            
            if len(current_con) >= 1:
                constraints.append(f"{' + '.join(current_con)} <= ON_CHIP_MEM_SIZE;")

        for key in list(self.analysis.dic.keys()):
            current_arrays = []
            read = self.analysis.dic[key]["read"]
            write = self.analysis.dic[key]["write"]
            randw = read + write
            for r in randw:
                for array in arrays:
                    if array == r.split("[")[0]:
                        if array not in current_arrays:
                            current_arrays.append(array)
            for array in current_arrays:
                # FIXME it is false
                param.append(f"footprint_{array}_S{key} = {np.prod(self.analysis.arrays_size[array])};")


        for array in arrays:
            footprint_array[array] = 0
            burst_size[array] = 1
            if array not in already_seen:
                for key in list(self.analysis.dic.keys()):
                    read = self.analysis.dic[key]["read"]
                    write = self.analysis.dic[key]["write"]
                    randw = read + write
                    for r in randw:
                        if array not in already_seen:
                            if array in r:
                                # only last dimension
                                footprint_array[array] = np.prod(self.analysis.arrays_size[array])
                                if self.analysis.arrays_size[array][-1] % 16 == 0:
                                    burst_size[array] =  16
                                elif self.analysis.arrays_size[array][-1] % 8 == 0:
                                    burst_size[array] =  8
                                elif self.analysis.arrays_size[array][-1] % 4 == 0:
                                    burst_size[array] =  4
                                elif self.analysis.arrays_size[array][-1] % 2 == 0:
                                    burst_size[array] =  2
                                else:
                                    burst_size[array] =  1

                                # footprint_array[array] = np.prod(self.analysis.arrays_size[array])
                                # if footprint_array[array] % 16 == 0:
                                #     burst_size[array] =  16
                                # elif footprint_array[array] % 8 == 0:
                                #     burst_size[array] =  8
                                # elif footprint_array[array] % 4 == 0:
                                #     burst_size[array] =  4
                                # elif footprint_array[array] % 2 == 0:
                                #     burst_size[array] =  2
                                param.append(f"footprint_tot_{array} = {footprint_array[array]};")
                                param.append(f"burst_size_tot_{array} = {burst_size[array]};")
                                var.append(f"burst_size_{array} integer >= 1 <={burst_size[array]};")
                                var.append(f"cte_burst_size_{array} integer >= 1;")
                                for k in [16, 8, 4, 2, 1]:
                                    var.append(f"is_burst_size_{array}_{k} binary;")

                                str_ = ""
                                str_2 = ""
                                for k in [16, 8, 4, 2, 1]:
                                    str_ += f"is_burst_size_{array}_{k}"
                                    str_2 += f"is_burst_size_{array}_{k} * {k}"
                                    if k != 1:
                                        str_ += " + "
                                        str_2 += " + "
                                dim = len(self.analysis.arrays_size[array])
                                constraints.append(f"{str_} = 1;")
                                constraints.append(f"burst_size_{array} = {str_2};")
                                constraints.append(f"AP_{array}_{dim-1} >= {str_2};")
                                for k in [16, 8, 4, 2, 1]:
                                    if k > burst_size[array]:
                                        constraints.append(f"is_burst_size_{array}_{k} = 0;")

                                
                                str_ = ""
                                str_ += f"AP_{array}_{dim-1} = ("
                                for k in [16, 8, 4, 2, 1]:
                                    str_ += f"is_burst_size_{array}_{k} * {k}"
                                    if k != 1:
                                        str_ += " + "
                                str_ += f") * cte_burst_size_{array};"
                                constraints.append(str_)
                                curr_cons_lat = []
                                curr_cons = []
                                for sched in range(len(self.schedule)):
                                    if sched in constraint_per_array_per_schedule[array]:
                                        for c in constraint_per_array_per_schedule[array][sched]:
                                            if c not in curr_cons:
                                                curr_cons.append(c)
                                    if sched in constraint_per_array_per_schedule_lat[array]:
                                        for c in constraint_per_array_per_schedule_lat[array][sched]:
                                            if c not in curr_cons_lat:
                                                curr_cons_lat.append(c)


                                # if is_write[array] and not initialization[array]:
                                #     constraints.append(f"Lat_comm_{array} = transfer_{array}_total * 2 * footprint_tot_{array}/burst_size_tot_{array} + {' + '.join(curr_cons_lat)};")
                                # elif is_write[array] and initialization[array]:
                                #     constraints.append(f"Lat_comm_{array} = transfer_{array}_total * footprint_tot_{array}/burst_size_tot_{array} + {' + '.join(curr_cons_lat)};")
                                # else:
                                #     constraints.append(f"Lat_comm_{array} = transfer_{array}_total * footprint_tot_{array}/burst_size_tot_{array} + {' + '.join(curr_cons_lat)};")
                                
                                # list_foot.append(f"transfer_{array}_total * footprint_tot_{array} + {' + '.join(curr_cons)}")
                                # constraint_per_schedule[]
                                already_seen.append(array)
                                break
        const_comm = []


        # FIXME we need to do all possible cases i.e. even when only one or two array transfer on the n 
        for k in range(len(self.schedule)):
            con_read = []
            con_write = []
            var_r = f"Lat_comm_read_S{k}"
            var_w = f"Lat_comm_write_S{k}"
            var.append(f"{var_r} integer >= 0;")
            var.append(f"{var_w} integer >= 0;")
            const_comm.append(var_r)
            const_comm.append(var_w)

            larray = []
            read = self.analysis.dic[k]["read"]
            write = self.analysis.dic[k]["write"]
            randw = read + write
            array_write = write[0].split("[")[0]
            for r in randw:
                for array in arrays:
                    if array == r.split("[")[0]:
                        larray.append(array)
            larray = list(set(larray))

            first_time_see = []
            for arr in larray:
                if first_time_array_appear[arr] == k:
                    first_time_see.append(f"transfer_{arr}_total * footprint_tot_{arr}/burst_size_{arr}")
            if len(first_time_see) > 0:
                con_read.append(self.write_list_of_max(first_time_see))

            last_time_see = []
            for arr in larray:
                if array_information[arr]["schedule"][-1] == k:
                    if len(array_information[arr]["write"]) > 0:
                        last_time_see.append(f"transfer_{arr}_total * footprint_tot_{arr}/burst_size_{arr}")

            if len(last_time_see) > 0:
                con_write.append(self.write_list_of_max(last_time_see))



            # var.append(f"transfer_{array}_S{key}_under_loop{loop} binary;")

            for loop in self.schedule[k][1::2]:
                read_level = []
                write_level = []
                write_array = self.analysis.dic[k]["write"][0].split("[")[0]
                for array in arrays:
                    if f"transfer_{array}_S{k}_under_loop{loop} binary;" in var:
                        read_level.append(f"transfer_{array}_S{k}_under_loop{loop} * footprint_{array}_S{k}  / burst_{array}_S{k}_under_loop{loop}")
                        if array_information[array]["schedule"][-1] < k or array == write_array:
                            write_level.append(f"transfer_{array}_S{k}_under_loop{loop} * footprint_{array}_S{k}  / burst_{array}_S{k}_under_loop{loop}")

                if len(read_level) > 0:
                    con_read.append(self.write_list_of_max(read_level))
                if len(write_level) > 0:
                    con_write.append(self.write_list_of_max(write_level))

            
            
            if len(con_read) > 0:
                constraints.append(f"{var_r} = {' + '.join(con_read)};")
            else:
                constraints.append(f"{var_r} = 0;")
            if len(con_write) > 0:
                constraints.append(f"{var_w} = {' + '.join(con_write)};")
            else:
                constraints.append(f"{var_w} = 0;")


            



        constraints.append(f"Lat_comm = {' + '.join(const_comm)};")

        # FIXME should be per statement ??
        id_ceil = 0
        BRAM_CONSTRAINTS = []
        for k in range(len(self.schedule)):
            lstr_ = []
            
            
            for array in arrays:
                if k <= max(array_information[array]["schedule"]) and k >= min(array_information[array]["schedule"]):
                    str_ = ""
                    str_ceil = ""
                    dim = len(self.analysis.arrays_size[arr])
                    # math.ceil(800*900/200/5/16000)*200*5

                    # FIXME add all possibilities of footprint

                    str_ceil += f"transfer_{array}_total * footprint_tot_{array} / ("
                    for dd in range(dim):
                        str_ceil += f"AP_{array}_{dd} * "
                    str_ceil += f"16000 / size_data_type"
                    str_ceil += ")"
                    all_access = []
                    read = self.analysis.dic[k]["read"]
                    write = self.analysis.dic[k]["write"]
                    randw = read + write
                    for r in randw:
                        if array in r:
                            all_access += self.extract_iterators(r)
                    for l1, loop in enumerate(self.schedule[k][1::2]):
                        if f"transfer_{array}_S{k}_under_loop{loop} binary;" in var:
                            str_ceil += " + "
                            tc = ""
                            for l2, loop2 in enumerate(self.schedule[k][1::2]):
                                if l2 <= l1:
                                    if self.iterators[loop2] in all_access:
                                        tc += f"TC{loop2}_0 * "
                            tc += "1"
                            str_ceil += f"transfer_{array}_S{k}_under_loop{loop} * footprint_{array}_S{k} / ({tc}) / ("
                            for dd in range(dim):
                                str_ceil += f"AP_{array}_{dd} * "
                            str_ceil += f"16000 / size_data_type"
                            str_ceil += ")"

                    var.append(f"ceil{id_ceil} integer >= 0;")
                    # constraints.append(f"{str_ceil} >= ceil{id_ceil} - 1;")
                    constraints.append(f"#{str_ceil} <= ceil{id_ceil};") # AMPL does not like these constraints lol
                    # 512000 = 16000/32 * 1024 (max array part)
                    cc = ""
                    for kk in range(dim):
                        cc += f"AP_{array}_{kk}"
                        if kk < dim - 1:
                            cc += " * "
                    # constraints.append(f"(footprint_tot_{array} / (500 * {cc})) <= ceil{id_ceil}")
                    str_ += f"ceil{id_ceil} * "

                    # str_ += f"(footprint_tot_{array} / 512000) * "
                    # str_ += f"{footprint_array[array]} / (500 * {cc}) * "
                    id_ceil += 1
                    for kk in range(dim):
                        str_ += f"AP_{array}_{kk}"
                        if kk < dim - 1:
                            str_ += " * "
                    lstr_.append(str_)
                    if str_ not in BRAM_CONSTRAINTS:
                        BRAM_CONSTRAINTS.append(str_)
            if len(lstr_) > 0:
                if f"{' + '.join(lstr_)} <= BRAM;" not in constraints:
                    constraints.append(f"#{' + '.join(lstr_)} <= BRAM;")
                # if f"{' + '.join(lstr_)}" not in BRAM_CONSTRAINTS:
                #     BRAM_CONSTRAINTS.append(f"{' + '.join(lstr_)}")
        if len(BRAM_CONSTRAINTS) > 0:
            constraints.append(f"#{' + '.join(BRAM_CONSTRAINTS)} <= BRAM;")
        
                
        f = open("nlp.mod", "w")
        for head in header:
            f.write(head + "\n")
        f.write("\n")
        for k in range(len(self.schedule)):
            f.write(f"#schedule {' '.join(list(map(str, self.schedule[k])))}\n")
            iter_ = []
            for l in range(1, len(self.schedule[k]), 2):
                iter_.append(self.iterators[self.schedule[k][l]])
            f.write(f"#iterators {' '.join(iter_)}\n")
            for l in range(1, len(self.schedule[k]), 2):
                f.write(f"#loop_{self.schedule[k][l]} := {self.red_loop[self.schedule[k][l]]}\n")
        for p in param:
            if "#" in p:
                p = p.replace("#", "")
                f.write(f"#param {p}\n")
            else:
                f.write("param " + p + "\n")
        f.write("\n")
        for v in var:
            f.write("var " + v + "\n")
        f.write("\n")

        f.write(f"minimize cost: {' + '.join(obj)};\n")
        f.write("\n")

        for k, c in enumerate(constraints):
            if ";" not in c:
                c = c + ";"
            if "#" in c:
                c = c.replace("#", "")
                f.write(f"#subject to con{k}: " + c + "\n")
            else:
                f.write(f"subject to con{k}: " + c + "\n")

        f.write("solve;\n")
        for k in var:
            k = k.split(" ")[0]
            f.write(f"display " + k + ";\n")
        f.write("display _total_solve_time;\n")
        f.close()
        
    def write_list_of_max(self, l):
        if len(l) == 1:
            return l[0]
        # elif len(l) == 2:
        #     c1 = l[0].split("*")[0]
        #     c2 = l[1].split("*")[0]
        #     l1 = " * ".join(l[0].split("*")[1:])
        #     l2 = " * ".join(l[1].split("*")[1:])
        #     str_ = f"{c1} * {c2} * {self.create_max_constraint(l1, l2)}"
        #     str_ += f" + {c1} * (1 - {c2}) * {l1}"
        #     str_ += f" + {c2} * (1 - {c1}) * {l2}"
        #     return str_
        else:
            cc = []
            ll = []
            for i in range(len(l)):
                c = l[i].split("*")[0]
                l_ = " * ".join(l[i].split("*")[1:])
                cc.append(c)
                ll.append(l_)

            prod_ = list(product(*[[0,1] for i in range(0, len(ll))]))
            x = tuple([0 for k in range(len(ll))])

            prod_.remove(x)
            
            str_ = []
            for pos in prod_:
                if sum(pos) == 0:
                    continue
                elif sum(pos) == 1:
                    c = []
                    l = []
                    for i, p in enumerate(pos):
                        if p == 1:
                            c.append(cc[i])
                            l.append(ll[i])
                        else:
                            c.append(f"(1 - {cc[i]})")
                    str_ += [f"{' * '.join(c)} * {l[0]}"]

                else:
                    c = []
                    l = []
                    for i, p in enumerate(pos):
                        if p == 1:
                            c.append(cc[i])
                            l.append(ll[i])
                        else:
                            c.append(f"(1 - {cc[i]})")
                    str_ += [f"{' * '.join(c)} * {self.create_max_constraint2(l)}"]
            # c1 = l[0].split("*")[0]
            # c2 = l[1].split("*")[0]
            # l1 = " * ".join(l[0].split("*")[1:])
            # l2 = " * ".join(l[1].split("*")[1:])
            # cc += [c1, c2]
            # ll += [l1, l2]
            # current_const = f"{self.create_max_constraint(l1, l2)}"
            # for i in range(2, len(l)):
            #     c = l[i].split("*")[0]
            #     l_ = " * ".join(l[i].split("*")[1:])
            #     cc += [c]
            #     current_const = self.create_max_constraint(current_const, l_)
            return " + ".join(str_)


    def create_max_constraint2(self, l):
        if len(l) == 1:
            return l[0]
        elif len(l) == 2:
            return self.create_max_constraint(l[0], l[1])
        else:
            current_const = self.create_max_constraint(l[0], l[1])
            for i in range(2, len(l)):
                current_const = self.create_max_constraint(current_const, l[i])
            return current_const

    def create_max_constraint(self, v1, v2):
        v1 = v1.replace(" ", "")
        v2 = v2.replace(" ", "")
        str_ = f"({v1} + {v2} + abs({v1} - {v2}))/2"
        return str_
    
    def create_min_constraint(self, v1, v2):
        str_ = f"({v1} + {v2} - abs({v1}-{v2}))/2"
        return str_

# split each loop 3 times
# make sure prod(TC) = TC
# check that we have the correct array partitioning
# plus part on the same dim with divisor
# Midlle only one should have TC more than 1
# loop_UF for cg on only one loop ?
# compute footprint