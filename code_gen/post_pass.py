import os

class GeneratePostPass:
    def __init__(self, bool_update_shape, output, nlp_file, nlp_log):
        self.output = output
        self.nlp_file = nlp_file
        self.nlp_log = nlp_log
        self.bool_update_shape = bool_update_shape

        self.create_fct_when_triple_buffer()
        self.update_slr()
        self.update_shape()

    def update_shape(self):
        if not self.bool_update_shape:
            return
        

    def update_slr(self):
        # if the specific case that no one use slr1 and use slr2 then we shift all the slr2 to slr1
        f = open(self.nlp_log, "r")
        lines = f.readlines()
        f.close()
        at_least_one_slr1 = False
        at_least_one_slr2 = False
        need_to_put_to_1 = []
        need_to_put_to_0 = []
        for k, line in enumerate(lines):
            if "_in_SLR_2 = 1" in line:
                at_least_one_slr2 = True
                var = line.split("=")[0].replace(" ", "")
                need_to_put_to_0.append(var)
                need_to_put_to_1.append(var.replace("_in_SLR_2", "_in_SLR_1"))
            if "_in_SLR_1 = 1" in line:
                at_least_one_slr1 = True
        if at_least_one_slr2 and not at_least_one_slr1:
            for k, line in enumerate(lines):
                var = line.split("=")[0].replace(" ", "")
                if var in need_to_put_to_0:
                    lines[k] = lines[k].replace("= 1", "= 0")
                if var in need_to_put_to_1:
                    lines[k] = lines[k].replace("= 0", "= 1")
            f = open(self.nlp_log, "w")
            f.writelines(lines)
            f.close()

    def extract_fct(self, name):
        begin = -1
        end = -1
        inside = False
        seen_one = False
        nb_bracket = 0
        for k, line in enumerate(self.lines):
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
        return self.lines[begin:end+1], begin, end

    def create_fct_when_triple_buffer(self):
        f = open(self.output, "r")
        self.lines = f.readlines()
        f.close()

        ft_fct = []
        for k, line in enumerate(self.lines):
            if "void" in line and "FT" in line and "level" in line:
                ft_fct.append(line.split(" ")[1].split("(")[0])
        fct_triple_buffer = []
        fct_double_buffer = []
        for fct in ft_fct:
            is_triple_buffer = False
            is_double_buffer = False
            fct_lines, _, _ = self.extract_fct(fct)
            for k, line in enumerate(fct_lines):
                if ("if" in line and "% 3" in line):
                    is_triple_buffer = True
                    fct_triple_buffer.append(fct)
                    break
                if ("if" in line and "% 2" in line):
                    nb_bracket = 0
                    seen = False
                    id_ = k
                    is_under_level = False
                    while (id_ < k+10):
                        if "{" in fct_lines[id_]:
                            seen = True
                            nb_bracket += 1
                        if "}" in fct_lines[id_]:
                            nb_bracket -= 1
                        if nb_bracket == 0 and seen:
                            break
                        if "FT" in fct_lines[id_] and "level" in fct_lines[id_]:
                            is_under_level = True
                            break
                        id_ += 1
                    if not is_under_level:

                        is_double_buffer = True
                        fct_double_buffer.append(fct)
                        break
        
        order = [[1,0,2], [2,1,0], [0,2,1]]
        for k, fct in enumerate(fct_triple_buffer):
            str_compute_fct = ""
            not_double_triple_buffer = []
            fct_lines, begin, end = self.extract_fct(fct)
            inside_if = False
            nb_bracket = 0
            args = []
            it = ""
            decl = []
            decl_fct = []
            level_buffer = -1
            inside_fct = []
            array_need_to_be_transferred_also = []
            for id_line, line in enumerate(fct_lines):
                if "void" in line:
                    args = line.split("(")[1].split(")")[0].split(",")
                    all_name = []
                    for arg in args:
                        nn = arg.split(" ")[-1]
                        all_name.append(nn)
                    for k1, n1 in enumerate(all_name):
                        for k2, n2 in enumerate(all_name):
                            if k2>k1:
                                if "_0" in n1:
                                    if "_1" in n2:
                                        if n1.replace("_0", "_1") == n2:
                                            ell = n1.replace("_0", "").split("[")[0]
                                            if ell not in array_need_to_be_transferred_also:
                                                array_need_to_be_transferred_also.append(ell)
                
                if "void" not in line and (f"float" in line or "int" in line or "unsigned" in line or "double" in line):
                    decl.append(line)
                if "for" in line:
                    it = line.split("int ")[-1].split("=")[0].strip()
                if "if" in line and "% 3" in line:
                    inside_if = True
                    if "== 0" in line:
                        level_buffer = 0
                    if "== 1" in line:
                        level_buffer = 1
                    if "== 2" in line:
                        level_buffer = 2
                if inside_if:
                    if "{" in line:
                        nb_bracket += 1 
                    if "}" in line:
                        nb_bracket -= 1
                    if nb_bracket == 0:
                        if level_buffer == 0:
                            str_compute_fct += f"void compute_{fct}("
                        fct_lines[id_line] = f"compute_{fct}("
                        for arg in args:
                            
                            if level_buffer == 0:
                                is_present = False
                                for elemt in array_need_to_be_transferred_also:
                                    if elemt in arg and "[" in arg:
                                        is_present = True
                                if not is_present:
                                    fct_lines[id_line] += f"{arg.split(' ')[-1].split('[')[0]}, "
                                    str_compute_fct += f"{arg}, "
                            else:
                                is_present = False
                                for elemt in array_need_to_be_transferred_also:
                                    if elemt in arg and "[" in arg:
                                        is_present = True
                                if not is_present:
                                    fct_lines[id_line] += f"{arg.split(' ')[-1].split('[')[0]}, "
                        fct_lines[id_line] += f" {it},"
                        if level_buffer == 0:
                            str_compute_fct += f"int {it}, "
                        # array to triple buffer
                        array_to_buffer = []
                        
                        array_size = {}
                        data_type = {}
                        for decl_line in decl + args: # pas sur pr le + arg
                            if "[" in decl_line:
                                is_double_buffer = False
                                if decl_line.split(" ")[-1].split("[")[0][-2:] == "_0":
                                    is_double_buffer = True
                                elif decl_line.split(" ")[-1].split("[")[0][-2:] == "_1":
                                    is_double_buffer = True
                                elif decl_line.split(" ")[-1].split("[")[0][-2:] == "_2":
                                    is_double_buffer = True

                                
                                

                                
                                if is_double_buffer:
                                    str_ = decl_line.split(" ")[-1].split("[")[0][:-2]
                                    if str_ not in array_to_buffer:
                                        if str_ != "":
                                            array_to_buffer.append(str_) #-2 to remove the id
                                            index = decl_line.index("[")
                                            array_size[str_] = decl_line[index:].replace("\n", "").replace(" ", "").replace(";", "")
                                            tmp_ = decl_line.split(" ")
                                            while "" in tmp_:
                                                tmp_.remove("")
                                            data_type[str_] = tmp_[0]
                                else:
                                    str_ = decl_line.split(" ")[-1].split("[")[0]
                                    if str_ not in not_double_triple_buffer:
                                        if str_ != "":
                                            tmp_ = decl_line.split(" ")
                                            while "" in tmp_:
                                                tmp_.remove("")
                                            data_type[str_] = tmp_[0]
                                            index = decl_line.index("[")
                                            array_size[str_] = decl_line[index:].replace("\n", "").replace(" ", "").replace(";", "")
                                            if f"{tmp_[0]} {str_}{array_size[str_]}," not in str_compute_fct:
                                                not_double_triple_buffer.append(str_)
                                                
                                                
                                                
                        curr_order = order[level_buffer]
                        # level_buffer
                        for array in array_to_buffer:
                            for h in range(3):
                                fct_lines[id_line] += f" {array}_{curr_order[h]},"
                                if level_buffer == 0:
                                    str_compute_fct += f"{data_type[array]} {array}_{h}{array_size[array]},"

                        for array in not_double_triple_buffer:

                            fct_lines[id_line] += f" {array},"
                            if level_buffer == 0:
                                str_compute_fct += f"{data_type[array]} {array}{array_size[array]},"

                        fct_lines[id_line] = fct_lines[id_line][:-1]
                        if level_buffer == 0:
                            str_compute_fct = str_compute_fct[:-1]
                        fct_lines[id_line] += f"); "
                        if level_buffer == 0:
                            str_compute_fct += ") {\n"
                            str_compute_fct += "#pragma HLS inline off\n"
                            str_compute_fct += "#pragma HLS dataflow\n"
                        fct_lines[id_line] += f"\n"
                        fct_lines[id_line] += f"{line}"
                        inside_if = False
                        # if level_buffer == 0:
                        #     str_compute_fct += "}"
                if inside_if:
                    if "read" in line or "task" in line or "write" in line:
                        fct_lines[id_line] = f"// {line}"
                        if level_buffer == 0:
                            inside_fct += [f"{line}"]
            
            for line in inside_fct:
                if "read" in line:
                    name_arr = line.split("_FT")[0].split("read_")[-1]
                    if name_arr not in array_to_buffer:
                        array_to_buffer.append(name_arr)
                    for array in array_to_buffer:
                        for h in range(3):
                            if f"{array}_{h}" in line:
                                line = line.replace(f"{array}_{h}", f"{array}_0")
                if "task" in line and line.count("task") <= 1:
                    for array in array_to_buffer:
                        for h in range(3):
                            if f"{array}_{h}" in line:
                                line = line.replace(f"{array}_{h}", f"{array}_1")
                if "write" in line:
                    name_arr = line.split("_FT")[0].split("write_")[-1]
                    if name_arr not in array_to_buffer:
                        array_to_buffer.append(name_arr)
                    for array in array_to_buffer:
                        for h in range(3):
                            if f"{array}_{h}" in line:
                                line = line.replace(f"{array}_{h}", f"{array}_2")
                str_compute_fct += f"{line}"
            str_compute_fct += f"}}\n"



            new_fct_lines = [str_compute_fct + "\n"]
            self.lines[begin:end+1] = new_fct_lines + fct_lines 
        

        order = [[0,1], [1,0]]
        is_read_only = False
        is_write_only = False
        array_need_to_be_transferred_also = []
        
        for k, fct in enumerate(fct_double_buffer):
            str_compute_fct = ""
            not_double_triple_buffer = []
            fct_lines, begin, end = self.extract_fct(fct)
            for id_line, line in enumerate(fct_lines):
                if "void" in line:
                    args = line.split("(")[1].split(")")[0].split(",")
                    all_name = []
                    for arg in args:
                        nn = arg.split(" ")[-1]
                        all_name.append(nn)
                    for k1, n1 in enumerate(all_name):
                        for k2, n2 in enumerate(all_name):
                            if k2>k1:
                                if "_0" in n1:
                                    if "_1" in n2:
                                        if n1.replace("_0", "_1") == n2:
                                            ell = n1.replace("_0", "").split("[")[0]
                                            if ell not in array_need_to_be_transferred_also:
                                                array_need_to_be_transferred_also.append(ell)
                if "read" in line: # is it possible ? lol
                    is_read_only = True
                if "write" in line: 
                    is_write_only = True

            inside_if = False
            nb_bracket = 0
            args = []
            it = ""
            decl = []
            level_buffer = -1
            inside_fct = []
            for id_line, line in enumerate(fct_lines):
                if "void" in line:
                    args = line.split("(")[1].split(")")[0].split(",")
                if "void" not in line and (f"float" in line or "int" in line or "unsigned" in line or "double" in line):
                    decl.append(line)
                if "for" in line:
                    it = line.split("int ")[-1].split("=")[0].strip()
                if "if" in line and "% 2" in line:
                    inside_if = True
                    if "== 0" in line:
                        level_buffer = 0
                    if "== 1" in line:
                        level_buffer = 1
                    if "== 2" in line:
                        level_buffer = 2
                if inside_if:
                    if "{" in line:
                        nb_bracket += 1 
                    if "}" in line:
                        nb_bracket -= 1
                    if nb_bracket == 0:
                        if level_buffer == 0:
                            str_compute_fct += f"void compute_{fct}("
                        fct_lines[id_line] = f"compute_{fct}("
                        for arg in args:
                            
                            if level_buffer == 0:
                                is_present = False
                                for elemt in array_need_to_be_transferred_also:
                                    if elemt in arg and "[" in arg:
                                        is_present = True
                                if not is_present:
                                    fct_lines[id_line] += f"{arg.split(' ')[-1].split('[')[0]}, "
                                    str_compute_fct += f"{arg}, "
                            else:
                                is_present = False
                                for elemt in array_need_to_be_transferred_also:
                                    if elemt in arg and "[" in arg:
                                        is_present = True
                                if not is_present:
                                    fct_lines[id_line] += f"{arg.split(' ')[-1].split('[')[0]}, "
                        fct_lines[id_line] += f" {it},"
                        if level_buffer == 0:
                            str_compute_fct += f"int {it}, "
                        # array to triple buffer
                        array_to_buffer = []
                        
                        array_size = {}
                        data_type = {}
                        for decl_line in decl + args: # pas sur pr le + arg
                            if "[" in decl_line:
                                is_double_buffer = False
                                if decl_line.split(" ")[-1].split("[")[0][-2:] == "_0":
                                    is_double_buffer = True
                                elif decl_line.split(" ")[-1].split("[")[0][-2:] == "_1":
                                    is_double_buffer = True
                                elif decl_line.split(" ")[-1].split("[")[0][-2:] == "_2":
                                    is_double_buffer = True

                                if is_double_buffer:
                                    str_ = decl_line.split(" ")[-1].split("[")[0][:-2]
                                    if str_ not in array_to_buffer:
                                        if str_ != "":
                                            array_to_buffer.append(str_) #-2 to remove the id
                                            index = decl_line.index("[")
                                            array_size[str_] = decl_line[index:].replace("\n", "").replace(" ", "").replace(";", "")
                                            tmp_ = decl_line.split(" ")
                                            while "" in tmp_:
                                                tmp_.remove("")
                                            data_type[str_] = tmp_[0]
                                else:
                                    str_ = decl_line.split(" ")[-1].split("[")[0]
                                    if str_ not in not_double_triple_buffer:
                                        if str_ != "":
                                            tmp_ = decl_line.split(" ")
                                            while "" in tmp_:
                                                tmp_.remove("")
                                            data_type[str_] = tmp_[0]
                                            index = decl_line.index("[")
                                            array_size[str_] = decl_line[index:].replace("\n", "").replace(" ", "").replace(";", "")
                                            if f"{tmp_[0]} {str_}{array_size[str_]}," not in str_compute_fct:
                                                not_double_triple_buffer.append(str_)
                                                
                                                
                        curr_order = order[level_buffer]
                        # level_buffer
                        for array in array_to_buffer:
                            for h in range(2):
                                fct_lines[id_line] += f" {array}_{curr_order[h]},"
                                if level_buffer == 0:
                                    str_compute_fct += f"{data_type[array]} {array}_{h}{array_size[array]},"
                        for array in not_double_triple_buffer:

                            fct_lines[id_line] += f" {array},"
                            if level_buffer == 0:
                                dt = "float"
                                try:
                                    dt = data_type[array]
                                except:
                                    pass
                                str_compute_fct += f"{dt} {array}{array_size[array]},"

                        fct_lines[id_line] = fct_lines[id_line][:-1]
                        if level_buffer == 0:
                            str_compute_fct = str_compute_fct[:-1]
                        fct_lines[id_line] += f"); "
                        if level_buffer == 0:
                            str_compute_fct += ") {\n"
                            str_compute_fct += "#pragma HLS inline off\n"
                            str_compute_fct += "#pragma HLS dataflow\n"
                        fct_lines[id_line] += f"\n"
                        fct_lines[id_line] += f"{line}"
                        inside_if = False
                        # if level_buffer == 0:
                        #     str_compute_fct += "}"
                if inside_if:
                    if "read" in line or "task" in line or "write" in line:
                        fct_lines[id_line] = f"// {line}"
                        if level_buffer == 0:
                            inside_fct += [f"{line}"]
            
            for line in inside_fct:
                if "read" in line:
                    name_arr = line.split("_FT")[0].split("read_")[-1]
                    if name_arr not in array_to_buffer:
                        array_to_buffer.append(name_arr)
                    for array in array_to_buffer:
                        for h in range(2):
                            if f"{array}_{h}" in line:
                                line = line.replace(f"{array}_{h}", f"{array}_1")
                if "task" in line and line.count("task") <= 1:
                    for array in array_to_buffer:
                        for h in range(2):
                            if f"{array}_{h}" in line:
                                line = line.replace(f"{array}_{h}", f"{array}_0")
                if "write" in line:
                    name_arr = line.split("_FT")[0].split("write_")[-1]
                    if name_arr not in array_to_buffer:
                        array_to_buffer.append(name_arr)
                    for array in array_to_buffer:
                        for h in range(2):
                            if f"{array}_{h}" in line:
                                line = line.replace(f"{array}_{h}", f"{array}_1")
                str_compute_fct += f"{line}"
            str_compute_fct += f"}}\n"



            new_fct_lines = [str_compute_fct + "\n"]
            self.lines[begin:end+1] = new_fct_lines + fct_lines 
        

        f = open(self.output, "w")
        f.writelines(self.lines)
        f.close()



                    
