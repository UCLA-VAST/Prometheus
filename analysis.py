
from itertools import permutations
import copy

# FIXME REDO all the file

class Analysis:
    def __init__(self, schedule, dic, operations, arrays_size, dep, operation_list):
        self.data_type = "float" # FIXME find datatype
        self.schedule = schedule
        self.is_reduction_innermost = None
        self.dic = dic
        self.operations = operations
        self.arrays_size = arrays_size
        self.dep = dep
        self.operation_list = operation_list

        
        self.is_memory_bound = False
        self.is_computation_bound = False
        self.array_to_focus = []
        
        self.analysis()
        

        # exit(0)
        self.only_schedule = []
        self.LB = []
        self.UB = []
        self.LB_ = []
        self.UB_ = []
        self.TC = []
        
        self.statements = []
        self.iterators = []
        self.arguments = []


        self.formate_data()


    def inside(self, pos, tmp):
        for k in range(len(tmp)):
            if tmp[k]["lexico"] == pos["lexico"] and tmp[k]["it"] == pos["it"]:
                return True
        return False
    
    def find_index(self, pos, tmp):
        for k in range(len(tmp)):
            if tmp[k]["lexico"] == pos["lexico"] and tmp[k]["it"] == pos["it"]:
                return k
        return -1

    def formate_data(self):
        

        for key in list(self.arrays_size.keys()):
            elmt = "][".join(list(map(str, self.arrays_size[key])))
            self.arguments.append(f"{self.data_type} {key}[{elmt}]")
        map_schedule_to_id_loop = {}
        for k in range(len(self.schedule)):
            map_schedule_to_id_loop[k] = {}
            for j in range(1, len(self.schedule[k][1]), 2):
                map_schedule_to_id_loop[k][(j-1)//2] = {"id": -1, "it": ""}
        for k in range(len(self.schedule)):
            self.only_schedule.append(self.schedule[k][1])
        tmp = []
        for k in range(len(self.schedule)):
            for j in range(1, len(self.schedule[k][1]), 2):


                pos = {
                    "statement": k,
                    "pos_in_schedule": (j-1)//2,
                    "lexico": [],
                    "it": self.schedule[k][1][j],
                    "id": -1,
                    "LB": self.dic[k]["LB"][self.schedule[k][1][j]],
                    "UB": self.dic[k]["UB"][self.schedule[k][1][j]],
                    "LB_": self.dic[k]["LB_"][self.schedule[k][1][j]],
                    "UB_": self.dic[k]["UB_"][self.schedule[k][1][j]],
                    "TC": self.dic[k]["UB"][self.schedule[k][1][j]] - self.dic[k]["LB"][self.schedule[k][1][j]] + 1
                }
                for jj in range(0, j, 2):
                    pos["lexico"].append(self.schedule[k][1][jj])
                if not self.inside(pos, tmp):
                    pos["id"] = len(tmp)
                    
                    self.only_schedule[k][j] = len(tmp)
                    tmp.append(pos)
                else:
                    # index = 
                    self.only_schedule[k][j] = len(tmp[:self.find_index(pos, tmp)])

        for k in range(len(tmp)):
            self.LB.append(tmp[k]["LB"])
            self.UB.append(tmp[k]["UB"])
            self.LB_.append(tmp[k]["LB_"])
            self.UB_.append(tmp[k]["UB_"])
            self.iterators.append(tmp[k]["it"])
            self.TC.append(tmp[k]["TC"])

        self.statements = []
        for k in range(len(self.schedule)):
            self.statements.append(self.dic[k]["statement_body"].replace("\n", ""))

        for k in range(len(self.only_schedule)):
            self.only_schedule[k] = list(map(int, self.only_schedule[k]))
    
    def extract_cte(self, stat):

        # pre-process
        if "/=" in stat:
            out = stat.split("/=")[0]
            inn = stat.split("/=")[1]
            stat = out + "=" + out + "/" + inn
        if "*=" in stat:
            out = stat.split("*=")[0]
            inn = stat.split("*=")[1]
            stat = out + "=" + out + "*" + inn
        if "+=" in stat:
            out = stat.split("+=")[0]
            inn = stat.split("+=")[1]
            stat = out + "=" + out + "+" + inn
        if "-=" in stat:
            out = stat.split("-=")[0]
            inn = stat.split("-=")[1]
            stat = out + "=" + out + "-" + inn

        stat = stat.split("=")[1]


        new_stat = ""
        inside_bracket = False
        for c in stat:
            if c == "[":
                inside_bracket = True
            if not inside_bracket:
                new_stat += c
            if c == "]":
                inside_bracket = False
        new_stat = new_stat.replace("+", "@").replace("-", "@").replace("*", "@").replace("/", "@").replace("=", "@").replace("\n", "").replace(";", "").replace(" ", "")
        new_stat = new_stat.split("@")
        while "" in new_stat:
            new_stat.remove("")

        cte = []
        for elmt in new_stat:
            try:
                float(elmt)
                cte.append(elmt)
            except:
                pass
        return cte, new_stat

    def product(self, list):
        p = 1
        for i in list:
            p *= i
        return p

    def analysis(self):
        computation = []
        memory = []
        for key in list(self.dic.keys()):
            computation.append(self.product(list(self.dic[key]["TC"].values())))
        for key in list(self.arrays_size.keys()):
            memory.append(self.product(self.arrays_size[key]))
        

        max_comp = max(computation)
        max_comm = max(memory)
        min_comm = min(memory)

        
        if max_comp >  max_comm * 1.05:   # useful the 1.05 factor?
            self.is_computation_bound = True
        else:
            self.is_computation_bound = False
        self.is_memory_bound = not self.is_computation_bound


        
        # if self.is_memory_bound:
        for key in list(self.arrays_size.keys()):
            if self.product(self.arrays_size[key]) > (max_comm+min_comm)/2: # FIXME: be less strict
                self.array_to_focus.append(key)
        # if self.is_memory_bound:
        
        self.analysis_array_to_focus()


    def extract_iterator(self, string):
        index = string.find("[")
        string = string[index:]
        string = string.replace("][", "!")
        string = string.replace("[", "")
        string = string.replace("]", "")
        string = string.split("!")
        return string

    def analysis_array_to_focus(self):
        statements_with_array_to_focus = {}
        dimension_iterate_per_order = {}
        for array in self.array_to_focus:
            statements_with_array_to_focus[array] = []
            dimension_iterate_per_order[array] = []
            for stat in list(list(self.dic.keys())):
                read = self.dic[stat]["read"]
                write = self.dic[stat]["write"]
                arrays = read + write
                arrays_name = ["" for i in range(len(arrays))]
                for k in range(len(arrays)):
                    arrays_name[k] = arrays[k].split("[")[0]
                if array in arrays_name:
                    statements_with_array_to_focus[array].append(stat)
                    # dimension_iterate_per_order[array] = []
                    order_loop = self.schedule[stat][1][1::2]
                    order_access = []
                    for i in range(len(arrays)):
                        if array in arrays[i]:
                            order_access = self.extract_iterator(arrays[i])
                    dimension_iterate_per_order[array].append([stat, order_loop, order_access])
            if len(dimension_iterate_per_order[array]) > 0:
                original = dimension_iterate_per_order[array][0][2]
                for k in range(1, len(dimension_iterate_per_order[array])):
                    new = dimension_iterate_per_order[array][k][2]

        
        self.find_schedule(dimension_iterate_per_order)
        

    def factorial(self, n):
        # non recursive
        p = 1
        for i in range(1, n+1):
            p *= i
        return p
    
    def find_schedule_dd(self, dimension_iterate_per_order):

        


        # self.change_loop_iterator_name()
        self.reduction_loops_per_schedule = {}
        for stat in range(len(self.schedule)):
            sched = self.schedule[stat][1]
            self.reduction_loops_per_schedule[stat] = self.find_reduction_loops(sched, self.dic[stat]["write"][0])
        possibilities = []
        all_loops_who_should_care = []
        for array in list(dimension_iterate_per_order.keys()):
            all_loops_who_should_care += dimension_iterate_per_order[array][0][1]
            
        # remove duplicate with same order of appearance
        all_loops_who_should_care = [all_loops_who_should_care[i] for i in range(len(all_loops_who_should_care)) if all_loops_who_should_care[i] not in all_loops_who_should_care[:i]]

        # Reformating the schedule



        # FIXME at this point we need to check what are the loops in the same loop bodies
        nb_possibilities = self.factorial(len(all_loops_who_should_care))
        perms = permutations(all_loops_who_should_care)
        original_schedule = [self.schedule[k][1].copy() for k in range(len(self.schedule))]
        

        is_red_innermost_for_all = {}
        for id_perm, sched in enumerate(perms):
            is_red_innermost_for_all[id_perm] = {}

            curr_dic = copy.deepcopy(self.dic)
            curr_schedule = []
            is_innermost_reduction = False
            is_same_as_original = False
            sched_0 = self.schedule[0][1].copy()
            loops = sched_0[1::2]
            min_dim = len(dimension_iterate_per_order[list(dimension_iterate_per_order.keys())[0]][0][2])
            for k in range(len(self.schedule)):
                sched_0 = self.schedule[k][1].copy()
                loops = sched_0[1::2]
                nb_loop = 0
                for l in sched:
                    if l in loops:
                        nb_loop += 1
                if nb_loop >= min_dim:
                    break
            

            id_loop = 0
            for l in sched:
                if l in loops:
                    sched_0[id_loop*2 + 1] = l
                    id_loop += 1

            
            if self.is_permutation_legal(original_schedule, sched_0, 0):
                curr_schedule.append(sched_0)

            all_first_order_access = {}
            for array in list(dimension_iterate_per_order.keys()):

                all_first_order_access[array], curr_dic = self.update_iterator_name_for_array(dimension_iterate_per_order[array][0][2], sched_0.copy(), original_schedule[0].copy(), curr_dic, 0)

            for stat in range(len(self.schedule)):
                sched = self.schedule[stat][1].copy()

                #trick just change iterator name in function of access
                for arr in list(dimension_iterate_per_order.keys()):
                    for access in dimension_iterate_per_order[arr]:
                        if access[0] == stat: # if the access is the same as the current statement
                            array_access = access[2]

                            sched, array_access, curr_dic = self.update_iterator_name_for_schedule(sched, all_first_order_access[array], array_access, all_first_order_access[arr], curr_dic, stat)



                loops = sched[1::2]
                id_loop = 0
                for l in sched:
                    if l in loops:
                        sched[id_loop*2 + 1] = l
                        id_loop += 1
                if self.is_permutation_legal(original_schedule, sched, stat):
                    curr_schedule.append(sched)
            nb_reduction = 0
            for i in range(len(curr_schedule)):

                is_red_innermost_for_all[id_perm][i] = False
                # if curr_schedule[i][-2] in self.reduction_loops_per_schedule[i]:

                if curr_schedule[i][-2] in self.find_reduction_loops(sched, curr_dic[i]["write"][0]):
                    is_innermost_reduction = True
                    nb_reduction += 1
                    is_red_innermost_for_all[id_perm][i] = True
            possibilities.append([curr_schedule, is_innermost_reduction, nb_reduction, curr_dic])

        id_min = 0
        min_nb_reduction = possibilities[0][2]
        self.is_reduction_innermost = is_red_innermost_for_all[0]
        for p in possibilities:
            if p[2] < min_nb_reduction:
                min_nb_reduction = p[2]
                id_min = possibilities.index(p)
                self.is_reduction_innermost = is_red_innermost_for_all[id_min]

        format_schedule = []
        for k in range(len(self.schedule)):
            format_schedule.append([f"S{k}", possibilities[id_min][0][k], ["" for i in range((len(possibilities[id_min][0][k])-1)//2)]])

        self.schedule = format_schedule

        self.dic = possibilities[id_min][3]



        # FIXME for now let suppose we want to minimize the number of reduction loops
        

    def find_schedule(self, dimension_iterate_per_order):


        # self.change_loop_iterator_name()
        self.reduction_loops_per_schedule = {}
        for stat in range(len(self.schedule)):
            sched = self.schedule[stat][1]
            self.reduction_loops_per_schedule[stat] = self.find_reduction_loops(sched, self.dic[stat]["write"][0])
        possibilities = []
        all_loops_who_should_care = []
        for array in list(dimension_iterate_per_order.keys()):
            if len(dimension_iterate_per_order[array]) > 0:
                all_loops_who_should_care += dimension_iterate_per_order[array][0][1]
            # all_loops_who_should_care += dimension_iterate_per_order[array][0][1]
        # all_loops_who_should_care = list(set(all_loops_who_should_care))
            
        # remove duplicate with same order of appearance
        all_loops_who_should_care = [all_loops_who_should_care[i] for i in range(len(all_loops_who_should_care)) if all_loops_who_should_care[i] not in all_loops_who_should_care[:i]]
            

        # FIXME at this point we need to check what are the loops in the same loop bodies
        nb_possibilities = self.factorial(len(all_loops_who_should_care))
        perms = permutations(all_loops_who_should_care)
        original_schedule = [self.schedule[k][1].copy() for k in range(len(self.schedule))]
        

        is_red_innermost_for_all = {}
        for id_perm, sched in enumerate(perms):
            is_red_innermost_for_all[id_perm] = {}

            curr_dic = copy.deepcopy(self.dic)
            curr_schedule = []
            is_innermost_reduction = False
            is_same_as_original = False
            sched_0 = self.schedule[0][1].copy()
            loops = sched_0[1::2]
            id_loop = 0
            for l in sched:
                if l in loops:
                    sched_0[id_loop*2 + 1] = l
                    id_loop += 1

            
            if self.is_permutation_legal(original_schedule, sched_0, 0):
                curr_schedule.append(sched_0)

            all_first_order_access = {}
            for array in list(dimension_iterate_per_order.keys()):
                if len(dimension_iterate_per_order[array]) > 0:
                    all_first_order_access[array], curr_dic = self.update_iterator_name_for_array(dimension_iterate_per_order[array][0][2], sched_0.copy(), original_schedule[0].copy(), curr_dic, 0)

            for stat in range(1, len(self.schedule)):
                sched = self.schedule[stat][1].copy()

                #trick just change iterator name in function of access
                for arr in list(dimension_iterate_per_order.keys()):
                    for access in dimension_iterate_per_order[arr]:
                        if access[0] == stat: # if the access is the same as the current statement
                            array_access = access[2]

                            sched, array_access, curr_dic = self.update_iterator_name_for_schedule(sched, all_first_order_access[array], array_access, all_first_order_access[arr], curr_dic, stat)



                loops = sched[1::2]
                id_loop = 0
                for l in sched:
                    if l in loops:

                        if id_loop*2 + 1 < len(sched):
                            sched[id_loop*2 + 1] = l
                            id_loop += 1
                if self.is_permutation_legal(original_schedule, sched, stat):
                    curr_schedule.append(sched)
            nb_reduction = 0
            for i in range(len(curr_schedule)):

                is_red_innermost_for_all[id_perm][i] = False
                # if curr_schedule[i][-2] in self.reduction_loops_per_schedule[i]:

                if len(curr_schedule[i]) >= 2 and curr_schedule[i][-2] in self.find_reduction_loops(sched, curr_dic[i]["write"][0]):
                    is_innermost_reduction = True
                    nb_reduction += 1
                    is_red_innermost_for_all[id_perm][i] = True
            possibilities.append([curr_schedule, is_innermost_reduction, nb_reduction, curr_dic])

        id_min = 0
        min_nb_reduction = possibilities[0][2]
        self.is_reduction_innermost = is_red_innermost_for_all[0]
        for p in possibilities:
            if p[2] < min_nb_reduction:
                min_nb_reduction = p[2]
                id_min = possibilities.index(p)
                self.is_reduction_innermost = is_red_innermost_for_all[id_min]

        format_schedule = []
        for k in range(len(self.schedule)):
            format_schedule.append([f"S{k}", possibilities[id_min][0][k], ["" for i in range((len(possibilities[id_min][0][k])-1)//2)]])

        

    def update_iterator_name_for_array(self, access, new_schedule, original_schedule, curr_dic, id_schedule):
        
        original_access = access.copy()
        sched_str = "#".join(list(map(str, original_schedule)))
        array_access_str = "#".join(list(map(str, access)))
        for i in range(1, min(len(new_schedule), len(original_schedule)), 2):
            if new_schedule[i] in original_access:

                sched_str = sched_str.replace(original_schedule[i], f"@{i}")
                array_access_str = array_access_str.replace(original_schedule[i], f"@{i}")
        sched = sched_str.split("#")

        for k in range(1, len(new_schedule), 2):
            new_it = new_schedule[k]
            old_it = sched[k]
            array_access_str = array_access_str.replace(old_it, new_it)

        array_access = array_access_str.split("#")
        return array_access, curr_dic

    def change_dic(self, dic_, id_, old_names, new_names):
        
        name_tmp = [f"@{i}" for i in range(1, len(old_names)+1)]
        dic1 = self.change_dic2(dic_, id_, old_names, name_tmp)
        dic2 = self.change_dic2(dic1, id_, name_tmp, new_names)
        return dic2

    def change_dic2(self, dic_, id_, old_names, new_names):
        new_dic = {}
        dic = copy.deepcopy(dic_)
        read = dic[id_]["read"]
        write = dic[id_]["write"]
        TC = dic[id_]["TC"]
        LB = dic[id_]["LB"]
        UB = dic[id_]["UB"]

        new_read = []
        new_write = []
        new_TC = {}
        new_LB = {}
        new_UB = {}

        for key in list(TC.keys()):
            new_TC[new_names[old_names.index(key)]] = TC[key]
            new_LB[new_names[old_names.index(key)]] = LB[key]
            new_UB[new_names[old_names.index(key)]] = UB[key]

        for r in read:
            for old, new in zip(old_names, new_names):
                r = r.replace(old, new)
            new_read.append(r)

        for w in write:
            for old, new in zip(old_names, new_names):
                w = w.replace(old, new)
            new_write.append(w)


        new_dic["read"] = new_read
        new_dic["write"] = new_write
        new_dic["TC"] = new_TC
        new_dic["LB"] = new_LB
        new_dic["UB"] = new_UB

        dic[id_] = new_dic
        return dic

    def update_iterator_name_for_schedule(self, sched, access_to_check, array_access, original_access, curr_dic, id_schedule):

        sched_str = "#".join(list(map(str, sched)))
        array_access_str = "#".join(list(map(str, array_access)))


        
        ori = []
        new = []
        for i in range(1, len(sched), 2):
            if sched[i] in array_access:

                sched_str = sched_str.replace(sched[i], f"@{i}")
                array_access_str = array_access_str.replace(sched[i], f"@{i}")
                new.append(original_access[array_access.index(sched[i])])
                ori.append(array_access[array_access.index(sched[i])])

        array_access = array_access_str.split("#")

        for k, elmt in enumerate(array_access):
            sched_str = sched_str.replace(elmt, original_access[k])
            array_access[k] = original_access[k]
            
        sched = sched_str.split("#")
        return sched, array_access, curr_dic
    
    def can_be_create_on_chip(self):
        pass

    def is_reduction_loop(self):
        pass

    def is_permutation_legal(self, original, permuted, id_schedule):
        return True

    def find_reduction_loops(self, sched, array):
        red = []
        iterators = self.extract_iterator(array)
        for loop in sched[1::2]:
            if loop in iterators:
                pass
            else:
                red.append(loop)
        return red
