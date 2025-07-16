import os


class SplitPerSLR:
    def __init__(self, cfile, nlp_file, log_file, slr_count=3):
        self.not_define_in_slr0 = []
        self.data_type = "float"
        self.contains_cte = False
        self.slr1_used = False
        self.slr2_used = False
        self.slr_count = slr_count
        self.cfile = cfile
        self.nlp_file = nlp_file
        self.log_file = log_file
        self.check_cte()
        self.check_slr()
        
        self.lines_per_slr = {}
        for k in range(slr_count):
            self.lines_per_slr[k] = []
        f = open(nlp_file, "r")
        self.nlp = f.readlines()
        f.close()
        f = open(log_file, "r")
        self.log = f.readlines()
        f.close()
        f = open(cfile, "r")
        self.lines = f.readlines()
        f.close()
        self.split_per_slr()
        

        self.update_host()
        self.write_files()
        self.read_files()
        self.update_k2k()
        self.write_files()
        self.read_files()
        self.update_header()
        self.write_files()
        self.update_prometheus()

    def update_prometheus(self):
        script = "/".join(self.cfile.split("/")[0:-2]) + "/prometheus.sh"
        f = open(script, "r")
        lines = f.readlines()
        f.close()

        if not self.slr1_used and not self.slr2_used:
            for k, line in enumerate(lines):
                if "VITIS_HLS_CPP[1]=\"slr1.cpp\"" in line:
                    lines[k] = ""
                if "VITIS_HLS_CPP[2]=\"slr2.cpp\"" in line:
                    lines[k] = ""
                if "VITIS_HLS_KERNEL[1]=\"kernel_nlp_slr1\"" in line:
                    lines[k] = ""
                if "VITIS_HLS_KERNEL[2]=\"kernel_nlp_slr2\"" in line:
                    lines[k] = ""
        if not self.slr2_used and self.slr1_used:
            for k, line in enumerate(lines):
                if "VITIS_HLS_CPP[2]=\"slr2.cpp\"" in line:
                    lines[k] = ""
                if "VITIS_HLS_KERNEL[2]=\"kernel_nlp_slr2\"" in line:
                    lines[k] = ""
        if not self.slr1_used and self.slr2_used:
            for k, line in enumerate(lines):
                if "VITIS_HLS_CPP[1]=\"slr1.cpp\"" in line:
                    lines[k] = "VITIS_HLS_CPP[1]=\"slr2.cpp\"\n"
                if "VITIS_HLS_KERNEL[1]=\"kernel_nlp_slr1\"" in line:
                    lines[k] = "VITIS_HLS_KERNEL[1]=\"kernel_nlp_slr2\"\n"
                if "VITIS_HLS_CPP[2]=\"slr2.cpp\"" in line:
                    lines[k] = ""
                if "VITIS_HLS_KERNEL[2]=\"kernel_nlp_slr2\"" in line:
                    lines[k] = ""
        if not self.slr1_used and not self.slr2_used:
            for k, line in enumerate(lines):
                if "bin/workload-${VITIS_HLS_KERNEL[2]}-$EMU_TYPE.xo" in line:
                    lines[k] = ""
                if "bin/workload-${VITIS_HLS_KERNEL[1]}-$EMU_TYPE.xo" in line:
                    lines[k] = ""
                if "src/bin/workload-${VITIS_HLS_KERNEL[2]}-hw.xo" in line:
                    lines[k] = ""
                if "src/bin/workload-${VITIS_HLS_KERNEL[1]}-hw.xo" in line:
                    lines[k] = ""

        if (not self.slr1_used and self.slr2_used) or (not self.slr2_used and self.slr1_used):
            for k, line in enumerate(lines):
                if "bin/workload-${VITIS_HLS_KERNEL[2]}-$EMU_TYPE.xo" in line:
                    lines[k] = ""
                if "src/bin/workload-${VITIS_HLS_KERNEL[2]}-hw.xo" in line:
                    lines[k] = ""

        f = open(script, "w")
        for line in lines:
            f.write(line)
        f.close()

    def update_files_for_fifo_on_same_slr(self, name_fifo):
        need_to_create_def = []
        for j, slr_line in enumerate(self.lines_per_slr[0]):
            if name_fifo in slr_line:

                should_update = True
                if "void" in slr_line:
                    if "write" in slr_line:
                        should_update = False
                    if "read" in slr_line:
                        should_update = False
                    if "load" in slr_line:
                        should_update = False
                    if "store" in slr_line:
                        should_update = False
                if should_update:
                    self.lines_per_slr[0][j] = self.lines_per_slr[0][j].replace(f"hls::stream<ap_axiu<512,0,0,0>>& {name_fifo}", f"hls::stream<float16>& {name_fifo}")
                    self.lines_per_slr[0][j] = self.lines_per_slr[0][j].replace(f"hls::stream<ap_axiu<256,0,0,0>>& {name_fifo}", f"hls::stream<float8>& {name_fifo}")
                    self.lines_per_slr[0][j] = self.lines_per_slr[0][j].replace(f"hls::stream<ap_axiu<128,0,0,0>>& {name_fifo}", f"hls::stream<float4>& {name_fifo}")
                    self.lines_per_slr[0][j] = self.lines_per_slr[0][j].replace(f"hls::stream<ap_axiu<64,0,0,0>>& {name_fifo}", f"hls::stream<float2>& {name_fifo}")
                    self.lines_per_slr[0][j] = self.lines_per_slr[0][j].replace(f"hls::stream<ap_axiu<32,0,0,0>>& {name_fifo}", f"hls::stream<float1>& {name_fifo}")
                    slr_line = self.lines_per_slr[0][j]

                
                if "#pragma HLS" in slr_line and  "INTERFACE axis port" in slr_line and name_fifo in slr_line: # there is already name_fifo
                    self.lines_per_slr[0][j] = ""
                if ("void kernel_nlp" in slr_line): # or ("void FT" in slr_line):
                    name_fct = slr_line.split("(")[0].split(" ")[-1]
                    arg = slr_line.split("(")[1].split(")")[0]
                    new_arg = []
                    # because of "," in arg
                    arg = arg.replace("ap_axiu<512,0,0,0>", "F16")
                    arg = arg.replace("ap_axiu<256,0,0,0>", "F8")
                    arg = arg.replace("ap_axiu<128,0,0,0>", "F4")
                    arg = arg.replace("ap_axiu<64,0,0,0>", "F2")
                    arg = arg.replace("ap_axiu<32,0,0,0>", "F1")
                    for arg_ in arg.split(","):
                        if name_fifo not in arg_:
                            new_arg.append(arg_)
                        else:
                            arg = arg_.replace("F16", "float16")
                            arg = arg.replace("F8", "float8")
                            arg = arg.replace("F4", "float4")
                            arg = arg.replace("F2", "float2")
                            arg = arg.replace("F1", "float1")
                            need_to_create_def.append(arg_)
                    new_arg = ",".join(new_arg)
                    new_arg = new_arg.replace("F16", "ap_axiu<512,0,0,0>")
                    new_arg = new_arg.replace("F8", "ap_axiu<256,0,0,0>")
                    new_arg = new_arg.replace("F4", "ap_axiu<128,0,0,0>")
                    new_arg = new_arg.replace("F2", "ap_axiu<64,0,0,0>")
                    new_arg = new_arg.replace("F1", "ap_axiu<32,0,0,0>")
                    self.lines_per_slr[0][j] = f"void {name_fct}({new_arg}){{\n"
        index_ = -1
        for j, slr_line in enumerate(self.lines_per_slr[0]):
            if "#pragma HLS dataflow" in slr_line:
                index_ = j+1
        
        for arg in need_to_create_def:
            arg = arg.replace("&", "").replace("", "")
            name = arg.split(" ")[-1].replace(";", "").replace("\n", "")
            arg += f";\n#pragma HLS stream variable = {name} depth = 1024\n"
            self.lines_per_slr[0].insert(index_, f"{arg}")
            index_ += 1


    def check_slr(self):
        f = open(self.log_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if f"SLR_1 = 1" in line:
                self.slr1_used = True
            if f"SLR_2 = 1" in line:
                self.slr2_used = True

    def check_cte(self):
        f = open(self.nlp_file, "r")
        lines = f.readlines()
        f.close()
        for line in lines:
            if "#comment: Argument" in line:
                if "[" not in line:
                    self.contains_cte = True
                    break

    def update_k2k(self):
        lstream_per_FT = self.extract_stream_per_FT()
        pp = self.cfile.split("/")
        pp[-1] = "k2k.cfg"
        name_k2k = "/".join(pp)
        f = open(name_k2k, "r")
        lines = f.readlines()
        f.close()
        cte_elents = []
        for arg in self.original_arg:
            if "[" not in arg:
                cte_elents.append(arg.split(" ")[-1])
        for k, line in enumerate(lines):
            lines[k] = line.replace("kernel_nlp", "kernel_nlp_slr0")
            # to fix a bug
            for elmt in cte_elents:
                if elmt in line:
                    lines[k] = ""
        lines.append("\n")
        lines.append(f"slr=kernel_nlp_slr0_1:SLR0\n")
        if self.slr1_used:
            lines.append(f"slr=kernel_nlp_slr1_1:SLR1\n")
        if self.slr2_used:
            lines.append(f"slr=kernel_nlp_slr2_1:SLR2\n")
        lines.append("\n")
        if self.contains_cte:
            if self.slr1_used:
                lines.append(f"stream_connect=kernel_nlp_slr0_1.fifo_cte_1:kernel_nlp_slr1_1.fifo_cte_1:512\n")
            if self.slr2_used:
                lines.append(f"stream_connect=kernel_nlp_slr0_1.fifo_cte_2:kernel_nlp_slr2_1.fifo_cte_2:512\n")


        for element in self.lstream:
            if "off_chip" in element:
                name_fifo = element.split(">")[-1].replace(";", "").replace("\n", "").replace(" ", "")
                id_slr_sent = 0
                id_slr_recv = 0

                if "to_off_chip" in name_fifo:
                    id_slr_recv = 0
                    for ft in list(lstream_per_FT.keys()):
                        
                        if name_fifo in lstream_per_FT[ft]:
                            id_ft_sent = ft
                            id_slr_sent = self.dic_name_to_slr[str(id_ft_sent)]
                            break
                if "from_off_chip" in name_fifo:
                    id_slr_sent = 0
                    id_stat = name_fifo.split("to_S")[-1]
                    id_slr_recv = self.dic_intra_task_to_slr[id_stat]
                if id_slr_sent != id_slr_recv:
                    lines.append(f"stream_connect=kernel_nlp_slr{id_slr_sent}_1.{name_fifo}:kernel_nlp_slr{id_slr_recv}_1.{name_fifo}:2048\n")
                else:
                    self.update_files_for_fifo_on_same_slr(name_fifo)


        
        id_slr_sent = 0
        id_slr_recv = 0
        all_fifos = []
        for ft in list(lstream_per_FT.keys()):
            for element in lstream_per_FT[ft]:
                all_fifos.append(element)
        all_fifos = list(set(all_fifos))
        for element in all_fifos:
            if element.count("task") >= 2:
                id_stat = element.split("from_task")[-1].split("_to_task")[0]
                id_slr_sent = self.dic_intra_task_to_slr[id_stat]
                id_stat = element.split("to_task")[-1]
                id_slr_recv = self.dic_intra_task_to_slr[id_stat]
                if id_slr_sent != id_slr_recv:
                    lines.append(f"stream_connect=kernel_nlp_slr{id_slr_sent}_1.{element}:kernel_nlp_slr{id_slr_recv}_1.{element}:2048\n")
                else:
                    self.update_files_for_fifo_on_same_slr(element)


        f = open(name_k2k, "w")
        for line in lines:
            f.write(line)
        f.close()

    def update_header(self):
        defi = []
        for id_slr in range(self.slr_count):
            for k, line in enumerate(self.lines_per_slr[id_slr]):
                if "void" in line:
                    index = line.index(")")
                    line = line[0:index+1]
                    defi += [line.replace("\n", "").replace(";", "").replace("{", "") + ";"]
        old = self.cfile.replace(".cpp", ".h")
        new = self.cfile.replace(".cpp", "_2.h")
        os.system(f"cp {old} {new}")
        f = open(self.cfile, "r")
        lines = f.readlines()
        f.close()

        for k, line in enumerate(lines):
            if "output.h" in line:
                lines[k] = line.replace("output.h", "output_2.h")
        f = open(self.cfile, "w")
        for line in lines:
            f.write(line)
        f.close()


        f = open(self.cfile.replace(".cpp", ".h"), "r")
        lines = f.readlines()
        f.close()
        
        begin_def = 0
        for k, line in enumerate(lines):
            if "void" in line:
                begin_def = k
                break
        
        lines = lines[0:begin_def]
        for line in defi:
            lines.append(line + "\n")
        lines.append("#endif // PROMETHEUS_H\n")
        f = open(self.cfile.replace(".cpp", ".h"), "w")
        for line in lines:
            f.write(line)
        f.close()
        
    def change_stream_type(self):
        for k, line in enumerate(self.lines):
            
            if "hls::stream<float2>" in line:
                self.lines[k] = line.replace("hls::stream<float2>", "hls::stream<ap_axiu<64,0,0,0>>")
            if "hls::stream<float4>" in line:
                self.lines[k] = line.replace("hls::stream<float4>", "hls::stream<ap_axiu<128,0,0,0>>")
            if "hls::stream<float8>" in line:
                self.lines[k] = line.replace("hls::stream<float8>", "hls::stream<ap_axiu<256,0,0,0>>")
            if "hls::stream<float16>" in line:
                self.lines[k] = line.replace("hls::stream<float16>", "hls::stream<ap_axiu<512,0,0,0>>")
            if "hls::stream<float1>" in line:
                self.lines[k] = line.replace("hls::stream<float1>", "hls::stream<ap_axiu<32,0,0,0>>")

    def split_per_slr(self):

        # mem in slr0
        ft_in_slr = [[] for k in range(self.slr_count)]
        self.dic_name_to_slr = {}
        self.dic_intra_task_to_slr = {}
        intra_task_in_ft = []
        for k, line in enumerate(self.log):
            if "is_fused_task" in line and "_in_SLR" in line and "= 1" in line:
                id_ft = line.split("is_fused_task")[1].split("_in_SLR")[0]
                slr = int(line.split("in_SLR_")[1].split(" =")[0])
                ft_in_slr[slr].append(id_ft)
                self.dic_name_to_slr[id_ft] = slr
        for k, line in enumerate(self.nlp):
            if "#comment:" in line and "Fuse" in line:
                index_brr = line.index("[")
                index_brl = line.index("]")
                curr_it = line[index_brr+1:index_brl].split(",")
                intra_task_in_ft.append(curr_it)
                id_ft = len(intra_task_in_ft) - 1
                for it in curr_it:
                    it = it.replace(" ", "")
                    self.dic_intra_task_to_slr[it] = self.dic_name_to_slr[str(id_ft)]

        for line in self.lines:
            if "void" in line:
                break
            for k in range(self.slr_count):
                self.lines_per_slr[k].append(line)
        self.change_stream_type()
        self.lstream = self.extract_stream()
        self.lstream_per_FT = self.extract_stream_per_FT()
        self.original_arg = self.extract_original_arg()
        self.call_from_main = self.extract_call_from_main()
        name_fct = self.extract_name_fct()
        self.original_pragma = self.extract_original_pragma()

        for k, name in enumerate(name_fct):
            if "load" in name:
                #add slr0
                fct = self.extract_fct(name)
                for line in fct.copy():
                    line = line.replace("ap_axiu<512,0,0,0>", "float16")
                    line = line.replace("ap_axiu<256,0,0,0>", "float8")
                    line = line.replace("ap_axiu<128,0,0,0>", "float4")
                    line = line.replace("ap_axiu<64,0,0,0>", "float2")
                    line = line.replace("ap_axiu<32,0,0,0>", "float1")
                    self.lines_per_slr[0].append(line)
                fct = self.update_load(fct)
                for line in fct:
                    self.lines_per_slr[0].append(line)
            if "store" in name:
                #add slr0
                fct = self.extract_fct(name)
                for line in fct.copy():
                    line = line.replace("ap_axiu<512,0,0,0>", "float16")
                    line = line.replace("ap_axiu<256,0,0,0>", "float8")
                    line = line.replace("ap_axiu<128,0,0,0>", "float4")
                    line = line.replace("ap_axiu<64,0,0,0>", "float2")
                    line = line.replace("ap_axiu<32,0,0,0>", "float1")
                    self.lines_per_slr[0].append(line)
                fct = self.update_store(fct)
                for line in fct:
                    self.lines_per_slr[0].append(line)
            if "read" in name:
                id_ft = int(name.split("FT")[1])
                id_slr = self.dic_name_to_slr[str(id_ft)]
                fct = self.extract_fct(name)
                for line in fct.copy():
                    line = line.replace("ap_axiu<512,0,0,0>", "float16")
                    line = line.replace("ap_axiu<256,0,0,0>", "float8")
                    line = line.replace("ap_axiu<128,0,0,0>", "float4")
                    line = line.replace("ap_axiu<64,0,0,0>", "float2")
                    line = line.replace("ap_axiu<32,0,0,0>", "float1")
                    self.lines_per_slr[int(id_slr)].append(line)
                fct = self.update_read(fct)
                for line in fct:
                    self.lines_per_slr[int(id_slr)].append(line)
            if "write" in name:
                id_ft = int(name.split("FT")[1])
                id_slr = self.dic_name_to_slr[str(id_ft)]
                fct = self.extract_fct(name)
                for line in fct.copy():
                    line = line.replace("ap_axiu<512,0,0,0>", "float16")
                    line = line.replace("ap_axiu<256,0,0,0>", "float8")
                    line = line.replace("ap_axiu<128,0,0,0>", "float4")
                    line = line.replace("ap_axiu<64,0,0,0>", "float2")
                    line = line.replace("ap_axiu<32,0,0,0>", "float1")
                    self.lines_per_slr[int(id_slr)].append(line)
                fct = self.update_write(fct)
                for line in fct:
                    self.lines_per_slr[int(id_slr)].append(line)
            if "task" in name and "intra" in name:
                id_it = name.split("task")[1].split("_intra")[0]
                id_slr = self.dic_intra_task_to_slr[id_it]
                fct = self.extract_fct(name)
                fct = self.update_fct(fct)
                for line in fct:
                    self.lines_per_slr[int(id_slr)].append(line)
            if f"FT" in name and "_level" in name:
                id_it = name.split("FT")[1].split("_level")[0]
                id_slr = self.dic_name_to_slr[id_it]
                fct = self.extract_fct(name)
                fct = self.update_fct(fct)
                for line in fct:
                    self.lines_per_slr[int(id_slr)].append(line)
        for id_slr in range(self.slr_count):
            self.lines_per_slr[int(id_slr)] += [self.create_main_fct_per_slr(id_slr)]

    def extract_name_fct(self):
        l = []
        for k, line in enumerate(self.lines):
            if "void" in line:
                l.append(line.split("void")[-1].split("(")[0])
        return l

    def update_fct(self, fct):
        for k, line in enumerate(fct):
            fct[k] = fct[k].replace("float16", "ap_axiu<512,0,0,0>")
            fct[k] = fct[k].replace("float8", "ap_axiu<256,0,0,0>")
            fct[k] = fct[k].replace("float4", "ap_axiu<128,0,0,0>")
            fct[k] = fct[k].replace("float2", "ap_axiu<64,0,0,0>")
            fct[k] = fct[k].replace("float1", "ap_axiu<32,0,0,0>")
        return fct


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
        return self.lines[begin:end+1]
        


    def extract_stream(self):
        l = []
        inside_main = False
        for k, line in enumerate(self.lines):
            if "void kernel_nlp" in line:
                inside_main = True
            if "hls::stream" in line and ";" in line:
                l.append(line.replace("\n", "").replace(";", ""))
        return l

    def extract_stream_per_FT(self):
        d = {}
        inside_main = False
        for k, line in enumerate(self.lines):
            if "void kernel_nlp" in line:
                inside_main = True
            if "FT" in line and "level0" in line:
                arg = line.split("(")[1].split(")")[0]
                id_ft = line.split("FT")[1].split("_level0")[0]
                d[id_ft] = []
                for arg_ in arg.split(","):
                    if "fifo" in arg_:
                        arg_ = arg_.replace(" ", "")
                        d[id_ft].append(arg_)
        return d

    def extract_original_pragma(self):
        l = []
        inside_main = False
        for k, line in enumerate(self.lines):
            if "void kernel_nlp" in line:
                inside_main = True
            if "#pragma" in line and inside_main and "stream" not in line:
                l.append(k)
        return l

    def extract_original_arg(self):
        for k, line in enumerate(self.lines):
            if "void kernel_nlp" in line:
                arg = line.split("(")[1].split(")")[0]
                return arg.split(",")
        return []

    def update_load(self, fct):
        type = ""
        name_fifo = ""
        name_array = ""
        for k, line in enumerate(fct):
            if "void" in line:
                arg = line.split("(")[-1].split(")")[0]
                arg = arg.replace("ap_axiu<512,0,0,0>", "float16")
                arg = arg.replace("ap_axiu<256,0,0,0>", "float8")
                arg = arg.replace("ap_axiu<128,0,0,0>", "float4")
                arg = arg.replace("ap_axiu<64,0,0,0>", "float2")
                arg = arg.replace("ap_axiu<32,0,0,0>", "float1")

                arg = arg.split(", ")
        name_fifo = arg[0].split("&")[-1].replace(" ", "")
        type, name_array = arg[1].split(" ")
        name_array = name_array.split("[")[0]
        for k, line in enumerate(fct):
            if ".write" in line:
                fct[k] = f""
                nb = 1
                # by default it is i
                fct[k] += f"{type} {name_array}_off = {name_array}[i];\n"
                if type == "float1":
                    fct[k] += f"ap_axiu<32, 0, 0, 0> {name_array}_on;\n"
                    nb = 1
                elif type == "float2":
                    fct[k] += f"ap_axiu<64, 0, 0, 0> {name_array}_on;\n"
                    nb = 2
                elif type == "float4":
                    fct[k] += f"ap_axiu<128, 0, 0, 0> {name_array}_on;\n"
                    nb = 4
                elif type == "float8":
                    fct[k] += f"ap_axiu<256, 0, 0, 0> {name_array}_on;\n"
                    nb = 8
                elif type == "float16":
                    fct[k] += f"ap_axiu<512, 0, 0, 0> {name_array}_on;\n"
                    nb = 16
                else:
                    fct[k] += f"ap_axiu<32, 0, 0, 0> {name_array}_on;\n"
                    nb = 1

                for i in range(nb):
                    fct[k] += f"{name_array}_on.data.range({32*(i+1)-1},{32*i}) = *(uint32_t*)(&{name_array}_off[{i}]);\n"

                fct[k] += f"{name_fifo}.write({name_array}_on);\n"
        return fct
        
    def update_store(self, fct):
        type = ""
        name_fifo = ""
        name_array = ""
        for k, line in enumerate(fct):
            if "void" in line:
                arg = line.split("(")[-1].split(")")[0]
                arg = arg.replace("ap_axiu<512,0,0,0>", "float16")
                arg = arg.replace("ap_axiu<256,0,0,0>", "float8")
                arg = arg.replace("ap_axiu<128,0,0,0>", "float4")
                arg = arg.replace("ap_axiu<64,0,0,0>", "float2")
                arg = arg.replace("ap_axiu<32,0,0,0>", "float1")

                arg = arg.split(", ")
        name_fifo = arg[0].split("&")[-1].replace(" ", "")
        type, name_array = arg[1].split(" ")
        name_array = name_array.split("[")[0]

        for k, line in enumerate(fct):
            if ".read" in line:
                fct[k] = f""
                nb = 1
                # by default it is i
                fct[k] += f"{type} {name_array}_off;\n"
                if type == "float1":
                    fct[k] += f"ap_axiu<32, 0, 0, 0> {name_array}_on = {name_fifo}.read();\n"
                    nb = 1
                elif type == "float2":
                    fct[k] += f"ap_axiu<64, 0, 0, 0> {name_array}_on = {name_fifo}.read();\n"
                    nb = 2
                elif type == "float4":
                    fct[k] += f"ap_axiu<128, 0, 0, 0> {name_array}_on = {name_fifo}.read();\n"
                    nb = 4
                elif type == "float8":
                    fct[k] += f"ap_axiu<256, 0, 0, 0> {name_array}_on = {name_fifo}.read();\n"
                    nb = 8
                elif type == "float16":
                    fct[k] += f"ap_axiu<512, 0, 0, 0> {name_array}_on = {name_fifo}.read();\n"
                    nb = 16
                fct[k] += f"uint32_t {name_array}_tmp[{nb}];\n"
                for i in range(nb):
                    fct[k] += f"{name_array}_tmp[{i}] = {name_array}_on.data.range({32*(i+1)-1},{32*i});\n"
                    fct[k] += f"{name_array}_off[{i}] = *(float*)(&{name_array}_tmp[{i}]);"

                fct[k] += f"{name_array}[i] = {name_array}_off;\n"
        return fct


    def update_read(self, fct):
        type = ""
        name_fifo = ""
        name_array = ""
        read_with_if = False
        seen_first_loop = False
        for k, line in enumerate(fct):
            if "void" in line:
                arg = line.split("(")[-1].split(")")[0]
                arg = arg.replace("ap_axiu<512,0,0,0>", "float16")
                arg = arg.replace("ap_axiu<256,0,0,0>", "float8")
                arg = arg.replace("ap_axiu<128,0,0,0>", "float4")
                arg = arg.replace("ap_axiu<64,0,0,0>", "float2")
                arg = arg.replace("ap_axiu<32,0,0,0>", "float")

                arg = arg.split(", ")
        name_fifo = arg[1].split("&")[-1].replace(" ", "")
        type, name_array = arg[0].split(" ")
        name_array = name_array.split("[")[0]

        is_declare = False
        name_tmp = ""
        for k, line in enumerate(fct):
            if "if " in line and seen_first_loop:
                read_with_if = True
            if "for" in line:
                seen_first_loop = True
            if is_declare and "if " not in line and "}" not in line and "=" in line:
                id_ = line.split(f"tmp_fifo[")[-1].split("]")[0]
                tmp = fct[k].replace(f"tmp_fifo[{id_}]", f"tmp_fifo.data.range({32*int(id_)+31},{32*int(id_)})")
                out_, in_ = tmp.split("=")
                in_ = in_.replace(";", "").replace("\n", "")
                fct[k] = ""
                if read_with_if:
                    fct[k] += "{\n" # if there is a if..
                fct[k] += f"uint32_t tmp_{id_} = {in_};\n"
                fct[k] += f"{out_} = *(float*)(&tmp_{id_});\n"
                if read_with_if:
                    fct[k] += "}\n"

            for vec_size in [16,2,4,8,1]:
                if f"float{vec_size}" in line:
                    fct[k] = fct[k].replace(f"float{vec_size}", f"ap_axiu<{32*vec_size}, 0, 0, 0>")
                    is_declare = True

            
            
        return fct

    
    
    def update_write(self, fct):
        type = ""
        name_fifo = ""
        name_array = ""
        read_with_if = False
        seen_first_loop = False
        id_w = 0
        for k, line in enumerate(fct):
            if "void" in line:
                arg = line.split("(")[-1].split(")")[0]
                arg = arg.replace("ap_axiu<512,0,0,0>", "float16")
                arg = arg.replace("ap_axiu<256,0,0,0>", "float8")
                arg = arg.replace("ap_axiu<128,0,0,0>", "float4")
                arg = arg.replace("ap_axiu<64,0,0,0>", "float2")
                arg = arg.replace("ap_axiu<32,0,0,0>", "float")

                arg = arg.split(", ")
        name_fifo = arg[1].split("&")[-1].replace(" ", "")
        type, name_array = arg[0].split(" ")
        name_array = name_array.split("[")[0]
        is_declare = False
        name_tmp = ""
        for k, line in enumerate(fct):
            if "if " in line and seen_first_loop:
                read_with_if = True
            if "for" in line:
                seen_first_loop = True
            if is_declare and "if " not in line and "}" not in line and "=" in line:
                id_ = line.split(f"tmp_fifo[")[-1].split("]")[0]
                tmp = fct[k].replace(f"tmp_fifo[{id_}]", f"tmp_fifo.data.range({32*int(id_)+31},{32*int(id_)})")
                out_, in_ = tmp.split("=")
                in_ = in_.replace(";", "").replace("\n", "")
                fct[k] = ""
                if read_with_if:
                    fct[k] += "{\n" # if there is a if..
                # fct[k] += f"uint32_t tmp_{id_} = {in_};\n"
                fct[k] += f"{self.data_type} tmp_{id_w} = {in_};\n"
                fct[k] += f"{out_} = *(uint32_t*)(&tmp_{id_w});\n"
                id_w += 1
                if read_with_if:
                    fct[k] += "}\n"

            for vec_size in [16,2,4,8,1]:
                if f"float{vec_size}" in line:
                    fct[k] = fct[k].replace(f"float{vec_size}", f"ap_axiu<{32*vec_size}, 0, 0, 0>")
                    is_declare = True
                    

            
            
        return fct


    def update_host(self):
        name_host = "/".join(self.cfile.split("/")[0:-1]) + "/host.cpp"
        f = open(name_host, "r")
        lines = f.readlines()
        f.close()

        for k, line in enumerate(lines):
            if "OCL_CHECK(err, cl::Kernel kernel(program" in line:
                lines[k] = line.replace("kernel_nlp", "kernel_nlp_slr0")
        
        f = open(name_host, "w")
        for line in lines:
            f.write(line)
        f.close()

    def create_main_fct_per_slr(self, id_slr):
        cte_elents = []
        for arg in self.original_arg:
            if "[" not in arg:
                cte_elents.append(arg)
        


        line = f"void kernel_nlp_slr{id_slr}("
        cur_arg = []
        if id_slr == 0:
            for arg in self.original_arg:
                line += f"{arg.replace('>>', '>>&')},"
            if len(cte_elents) > 0:
                if self.slr1_used:
                    line += f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_1,"
                if self.slr2_used:
                    line += f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_2,"
                if self.slr1_used:
                    cur_arg.append(f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_1")
                if self.slr2_used:
                    cur_arg.append(f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_2")
            for element in self.lstream:
                if "off_chip" in element:
                    line += f"{element.replace('>>', '>>&')},"
                    cur_arg.append(f"{element.replace('>>', '>>&')}")
        else:
            if len(cte_elents) > 0:
                if id_slr == 1 and self.slr1_used:
                    line += f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_{id_slr},"
                    cur_arg.append(f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_1")
                if id_slr == 2 and self.slr2_used:
                    line += f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_{id_slr},"
                    cur_arg.append(f"hls::stream<ap_axiu<32, 0, 0, 0>>& fifo_cte_2")
        for ft in list(self.lstream_per_FT.keys()):
            if self.dic_name_to_slr[ft] == id_slr:
                for element in self.lstream_per_FT[ft]:
                    name = element
                    
                    if name not in line:
                        dec = ""
                        for element2 in self.lstream:
                            if name in element2:
                                dec = element2
                                break
                        line += f"{dec.replace('>>', '>>&')},"
                        cur_arg.append(f"{dec.replace('>>', '>>&')}")
            
        if line[-1] != "(":
            line = line[:-1]

        line += f"){{\n"

        if id_slr == 0:
            id_cte = 0
            if len(cte_elents) > 0:
                # add new fifo
                if len(cte_elents) > 0:
                    if self.slr1_used:
                        line += f"#pragma HLS INTERFACE axis port=fifo_cte_1\n"
                    if self.slr2_used:
                        line += f"#pragma HLS INTERFACE axis port=fifo_cte_2\n"

                    
            for element in self.lstream:
                # if "off_chip" in element:
                name = element.split(">")[-1].replace(" ", "")
                if name in " ".join(cur_arg):
                    line += f"#pragma HLS INTERFACE axis port={name}\n"
                else:
                    self.not_define_in_slr0 += [f"{name}"]
            for k in self.original_pragma:
                line += self.lines[k]
                

            for arg in cte_elents:
                name = arg.replace("float", "").replace(" ", "")
                if self.slr1_used:
                    
                    line += f"ap_axiu<32, 0, 0, 0> cte_{id_cte};\n"
                    line += f"cte_{id_cte}.data.range(31, 0) = *(uint32_t *)(&{name});"
                    line += f"fifo_cte_1.write(cte_{id_cte});\n"
                    id_cte += 1
                if self.slr2_used:
                    line += f"ap_axiu<32, 0, 0, 0> cte_{id_cte};\n"
                    line += f"cte_{id_cte}.data.range(31, 0) = *(uint32_t *)(&{name});"
                    line += f"fifo_cte_2.write(cte_{id_cte});\n"
                    id_cte += 1
        else:
            id_cte_read = 0
            line += "#pragma HLS interface ap_ctrl_none port=return\n#pragma HLS inline off\n"
            for element in self.lstream:
                # if "off_chip" in element:
                name = element.split(">")[-1].replace(" ", "")
                if name in " ".join(cur_arg) and name not in self.not_define_in_slr0:
                    line += f"#pragma HLS INTERFACE axis port={name}\n"

            if len(cte_elents) > 0:
                for arg in cte_elents:
                    if (id_slr == 1 and self.slr1_used) or (id_slr == 2 and self.slr2_used):
                        line += f"ap_axiu<32, 0, 0, 0> fifo_read_{id_cte_read} = fifo_cte_{id_slr}.read();\n"
                        line += f"uint32_t cte_{id_cte_read} = fifo_read_{id_cte_read}.data.range(31,0);\n"
                        line += f"{arg} = *(float *)(&cte_{id_cte_read});\n"
                        id_cte_read += 1
        for cc in self.call_from_main:
            if "load" in cc or "store" in cc:
                if id_slr == 0:
                    line += cc

            else:
                id_ft = int(cc.split("FT")[1].split("_level0")[0])
                if int(id_slr) == int(self.dic_name_to_slr[str(id_ft)]):
                    line += cc


        line += f"}}\n"
        return f"\n{line}\n"

    def extract_call_from_main(self):
        l = []
        inside_main = False
        for k, line in enumerate(self.lines):
            if "void kernel_nlp" in line:
                inside_main = True
            if inside_main and "#pragma" not in line and "hls::stream" not in line:
                if "load" in line or "FT" in line or "store" in line:
                    l.append(line)
        return l

    def write_files(self):
        path = "/".join(self.cfile.split("/")[0:-1])
        for k in range(self.slr_count):
            f = open(f"{path}/slr{k}.cpp", "w")
            for line in self.lines_per_slr[k]:
                f.write(line)
            f.close()

    def read_files(self):
        path = "/".join(self.cfile.split("/")[0:-1])
        for k in range(self.slr_count):
            f = open(f"{path}/slr{k}.cpp", "r")
            lines = f.readlines()
            self.lines_per_slr[k] = lines
            f.close()


    