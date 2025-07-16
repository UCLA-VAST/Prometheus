


class Identify:
    def __init__(self, file, nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top):
        self.file = file
        self.nlp_file = nlp_file
        self.analysis = analysis
        self.schedule = schedule
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

        self.array_per_statement = {}
        self.special_case = []
        ## if write (so by // loop) and then read by at least one // loop then we can split
        ## if only write (so by // loop) then we can split
        self.equivalence = {}
        self.parallel_loop = []
        self.seq_loop = []
        self.compute_array_per_statement()

        self.search_split()

    def compute_arr_boolean(self, a1, a2):
        if len(a1) != len(a2):
            return -1
        res = [True for k in range(len(a1))]
        for k in range(len(a1)):
            res[k] = a1[k] and a2[k]
        return res

    def possible_dim(self, a1):
        res = []
        for k in range(len(a1)):
            if a1[k]:
                res.append(k)
        return res

    def search_split(self):


        ## all // loops can be split

        # check if we can split now
        ## if write (so by // loop) and then read by at least one // loop then we can split
        ## if only write (so by // loop) then we can split
        all_write = []

        for k in range(len(self.schedule)):
            if len(self.array_per_statement[k]["write"]) > 0:
                if self.array_per_statement[k]["write"][0]["array"] not in all_write:
                    all_write.append((self.array_per_statement[k]["write"][0]["array"],k, self.array_per_statement[k]["write"][0]["loops"]))

        # for all write which one is read but not write in the same stat
        write_and_read = []
        for k in range(len(self.schedule)):
            if len(self.array_per_statement[k]["write"]) > 0:
                if len(self.array_per_statement[k]["read"]) > 0:
                    for arr, ori_sched, loop_w in all_write:
                        if arr != self.array_per_statement[k]["write"][0]["array"]:
                            for r_arr in self.array_per_statement[k]["read"]:
                                if arr == r_arr["array"]:
                                
                                    bloop_per_dim = [False for _ in range(len(r_arr["loops"]))]
                                    for ll in r_arr["loops"]:
                                        if ll in self.parallel_loop:
                                            bloop_per_dim[r_arr["loops"].index(ll)] = True
                                    if (arr, k, r_arr["loops"], bloop_per_dim, loop_w) not in write_and_read:
                                        write_and_read.append((arr, k, r_arr["loops"], bloop_per_dim, loop_w, ori_sched))
        possible_split = {}

        loop_eq = {}
        for pos in write_and_read:
            arr, curr_sched, curr_loops, par_loop, old_loops, old_sched = pos
            possible_split[arr] = [True for k in range(len(par_loop))]
        for pos in write_and_read:
            arr, curr_sched, curr_loops, par_loop, old_loops, old_sched = pos
            possible_split[arr] = self.compute_arr_boolean(possible_split[arr], par_loop)
        for arr in list(possible_split.keys()):
            possible_split[arr] = self.possible_dim(possible_split[arr])

        loop_to_cut = {}

        for arr in list(possible_split.keys()):
            loop_to_cut[arr] = {}
        for arr in list(possible_split.keys()):
            for id_dim in possible_split[arr]:
                loop_to_cut[arr][id_dim] = []
                # loops which itterate arr
                output_to_check = []
                for k in range(len(self.schedule)):
                    is_read = False
                    is_write = False
                    loop = -1
                    for arr_read in self.array_per_statement[k]["read"]:
                        if arr_read["array"] == arr:
                            is_read = True
                            loop_to_cut[arr][id_dim] += [arr_read["loops"][id_dim]]
                            loop = arr_read["loops"][id_dim]
                    for arr_read in self.array_per_statement[k]["write"]:
                        if arr_read["array"] == arr:
                            is_write = True
                            loop_to_cut[arr][id_dim] += [arr_read["loops"][id_dim]]
                    if is_read and not is_write:
                        dim_output = self.array_per_statement[k]["write"][0]["loops"].index(loop)
                        output_to_check += [[self.array_per_statement[k]["write"][0]["array"], dim_output]]
                # loops which iterate the output of the statement where arr is read
                # big restriction
                # for k in range(len(self.schedule)):
                #     for arr_out in output_to_check:
                #         print(arr_out)
        # pour chaque output essaye de split chaque dim
        # et pour chaque noeud du graph regarde si le node split or need to stay the same et donc
        # besoin de creer un noeud pour refusionner les deux different array
        # possibilite d'explorer les difference
        # commnet on fait si on split deux dim ? mais en fait on fait un par un et ensuite on peu
        # fus ceux qui on meme propriete
        exit(0)
         
    def compute_array_per_statement(self):
        for k in range(len(self.schedule)):
            self.array_per_statement[k] = {"read": [], "write": []}
            self.equivalence[k] = []
        
        for k in range(len(self.schedule)):
            stat = self.statements[k]
            for array_read in self.analysis.dic[k]["read"]:
                dic = {
                    "array": array_read.split("[")[0],
                    "iterator": self.extract_iterator(array_read),
                    "loops": []
                }
                
                for it in self.extract_iterator(array_read):
                    for id_loop in self.schedule[k][1::2]:
                        if it == self.iterators[id_loop]:
                            dic["loops"].append(id_loop)
                self.array_per_statement[k]["read"].append(dic)
            for array_write in self.analysis.dic[k]["write"]:
                dic = {
                    "array": array_write.split("[")[0],
                    "iterator": self.extract_iterator(array_write),
                    "loops": []
                }
                
                for it in self.extract_iterator(array_write):
                    for id_loop in self.schedule[k][1::2]:
                        if it == self.iterators[id_loop]:
                            dic["loops"].append(id_loop)
                            self.parallel_loop.append(id_loop)
                self.array_per_statement[k]["write"].append(dic)
        for k in range(len(self.schedule)):
            loops = self.schedule[k][1::2]
            for id_loop in loops:
                if id_loop not in self.parallel_loop:
                    if id_loop not in self.seq_loop:
                        self.seq_loop.append(id_loop)
                

    def extract_iterator(self, string):
        index = string.find("[")
        string = string[index:]
        string = string.replace("][", "!")
        string = string.replace("[", "")
        string = string.replace("]", "")
        string = string.split("!")
        return string
class splitKernel:
    def __init__(self, file, nlp_file, analysis, schedule, UB, LB, statements, iterators, output, headers, arguments, name_function, pragmas, pragmas_top):
        # exit(0) 
        pass