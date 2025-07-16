import os

class GenerateCodeComputation:
    def __init__(self, cfile, nlp_file, log_file):
        self.cfile = cfile
        self.nlp_file = nlp_file
        self.log_file = log_file
        
        
        self.lines_cfile = self.readfile(self.cfile)
        self.lines_nlp_file = self.readfile(self.nlp_file)
        self.lines_log_file = self.readfile(self.log_file)
        self.schedule = []
        self.iterators = {}
        self.is_red = {}
        self.cte = []
        self.extract_cte()
        self.compute_schedule()
        self.log = {}
        self.extract_log()
        self.statements = []
        self.extract_statements()
        is_one_statement_per_loop_body = self.check_one_statement_per_loop_body()
        if is_one_statement_per_loop_body:
            self.generate_code()

    def extract_cte(self):
        for line in self.lines_cfile:
            if "void" in line:
                line = line.split("(")[-1].split(")")[0]
                l = line.split(",")
                for cte in l:
                    if "[" not in cte:
                        self.cte.append(cte.replace("float", "").replace(" ", ""))


    def extract_statements(self):
        for line in self.lines_cfile:
            if "=" in line and "float" not in line and "int" not in line and "for" not in line and "//" not in line:
                l = line.replace("\n", "").replace(" ", "")
                self.statements.append(l)

    def readfile(self, file):
        f = open(file, "r")
        lines = f.readlines()
        f.close()
        return lines
    
    def extract_log(self):
        for line in self.lines_log_file:
            if "=" in line:
                l = line.split("=")
                l[0] = l[0].replace(" ", "")
                l[1] = l[1].replace(" ", "").replace("\n", "")
                self.log[l[0]] = l[1].replace("\n", "")
    
    def compute_schedule(self):
        id_iterator = 0
        current_sched = []
        for line in self.lines_nlp_file:
            if "#schedule" in line:
                line = line.replace("#schedule ", "").replace("\n", "")
                l = line.split(" ")
                current_sched = l
                self.schedule.append(l)
            if "#iterators" in line:
                line = line.replace("#iterators ", "").replace("\n", "")
                l = line.split(" ")
                for k in range(1, len(current_sched), 2):
                    self.iterators[current_sched[k]] = l[(k-1)//2]
                # id_iterator += 1
            if "#loop" in line:
                l, b = line.split(":=")
                b = b.replace("\n", "").replace(" ", "")
                b = eval(b)
                l = l.replace("#loop_", "").replace("\n", "").replace(" ", "")
                self.is_red[l] = b

    def check_one_statement_per_loop_body(self):
        loops = []
        for k in range(len(self.schedule)):
            loops += self.schedule[k][1::2]
        for loop in loops:
            if loops.count(loop) > 1:
                return False
        return True

    def compute_tab(self, n):
        str_ = ""
        for k in range(n):
            str_ += "    "
        return str_

    def generate_code(self):
        lines = []

        lines += ["#include <ap_int.h>\n"]
        lines += ["#include <hls_stream.h>\n"]
        lines += ["#include <hls_vector.h>\n"]
        lines += ["#include <cstring>\n"]
        lines += ["\n"]
        for k in range(len(self.schedule)):
            arg = []
            nb_loop = 0
            lines += [f"void task{k}({' ,'.join(arg)}) {{\n"]
            lines += [f"#pragma HLS inline false\n"]
            for tile_level in range(3):
                # FIXME change order
                for j in range(1, len(self.schedule[k]), 2):
                    it = f"{self.iterators[self.schedule[k][j]]}{tile_level}"
                    loop = self.schedule[k][j]
                    ub = self.log[f"TC{loop}_{tile_level}"]
                    if tile_level == 1 and self.log[f"is_loop{loop}_pip"] == "0":
                        pass
                    else:
                        lines += [f"{self.compute_tab(nb_loop+1)}for (int {it} = 0; {it} < {ub}; {it}++) {{\n"]
                        if tile_level == 2:
                            lines += ["#pragma HLS unroll\n"]
                        elif tile_level == 1:
                            lines += ["#pragma HLS pipeline\n"]
                    
                        nb_loop += 1
            for j in range(1, len(self.schedule[k]), 2):
                it = f"{self.iterators[self.schedule[k][j]]}"
                loop = self.schedule[k][j]
                if self.log[f"is_loop{loop}_pip"] == "0":
                    str_ = f"{it} = {it}0 * {self.log[f'TC{loop}_2']} + {it}2;"
                else:
                    val = int(self.log[f'TC{loop}_2']) * int(self.log[f'TC{loop}_1'])
                    str_ = f"{it} = {it}0 * {val} + {it}1 * {self.log[f'TC{loop}_2']} + {it}2;"
                lines += [f"{self.compute_tab(nb_loop+1)}{str_}\n"]
            lines += [f"{self.compute_tab(nb_loop+1)}{self.statements[k]}\n"]
            for j in range(nb_loop):
                lines += [f"{self.compute_tab(nb_loop-j)}}}\n"]
            lines += [f"}}\n\n"]

        lines += ["int main() {\n"]
        lines += ["\n"]
        arrays = []
        for key in list(self.log.keys()):
            if "AP" in key:
                # _, var, dim = key.split("_")
                dd = key.split("_")
                dim = dd[-1]
                var = "_".join(dd[1:-1])
                if var not in arrays:
                    arrays.append(var)
        for cte in self.cte:
            lines += [f"#pragma HLS INTERFACE m_axi port={cte} offset=slave bundle=kernel_{cte}\n"]
        for arr in arrays:
            lines += [f"#pragma HLS INTERFACE m_axi port={arr} offset=slave bundle=kernel_{arr}\n"]
        
        for cte in self.cte:
            lines += [f"#pragma HLS INTERFACE s_axilite port={cte} bundle=control\n"]
        for arr in arrays:
            lines += [f"#pragma HLS INTERFACE s_axilite port={arr} bundle=control\n"]
        lines += [f"#pragma HLS INTERFACE s_axilite port=return bundle=control\n"]
        lines += ["\n"]
        for key in list(self.log.keys()):
            if "AP" in key:
                tab = self.compute_tab(1)
                dd = key.split("_")
                dim = dd[-1]
                var = "_".join(dd[1:-1])
                factor = self.log[key]
                lines += [f"#pragma HLS ARRAY_PARTITION variable={var} cyclic factor={factor} dim={int(dim)+1}\n"]
        lines += ["\n"]
        for k in range(len(self.schedule)):
            tab = self.compute_tab(1)
            lines += [f"{tab}task{k}();\n"]
        lines += ["}\n"]

        print("code_generated.cpp")
        f = open("code_generated.cpp", "w")
        f.writelines(lines)
        f.close()



# GenerateCodeComputation("cfile/symm_MEDIUM.c", "nlp_cfile/symm_MEDIUM_dsp_pessimist.mod", "nlp_cfile/symm_MEDIUM_dsp_pessimist.log")