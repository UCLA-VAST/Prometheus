import os
import utilities
import copy
import code_generation
import analysis
import itertools


# ISCC_CMD = "/opt/polyopt/default/sources/polyopt-hls/pocc/math/barvinok/iscc"
ISCC_CMD = "apptainer exec /opt/public/apptainer/pocc/pocc.sif iscc"

class ISCC:

    def __init__(self, no_distribution, folder, schedule, dic, operations, arrays_size, dep, operation_list):
        self.no_distribution = no_distribution
        self.folder = folder
        self.schedule = schedule
        self.dic = dic
        self.operations = operations
        self.arrays_size = arrays_size
        self.dep = dep
        self.operation_list = operation_list

        # self.create_iscc()
        self.run_iscc()

    def create_iscc(self, schedule_ori, schedule, dic):
        sched = []
        f = open(f"{self.folder}/iscc.iscc", "w")
        # Domain := [n] -> {
        #     S[k] : k <= -2 + 2n and k >= 0;
        #     T[i, j] : i >= 0 and i <= -1 + n and j <= -1 + n and j >= 0;
        # };
        f.write("Domain := [] -> {\n")
        for i in range(len(schedule_ori)):
            sched.append(schedule_ori[i][1])
            its = schedule_ori[i][1][1::2]
            ss = list(map(str, schedule_ori[i][1]))
            dd = []
            for it in its:
                dd.append(f"{it} >= {dic[i]['LB'][it]} and {it} <= {dic[i]['UB'][it]}")
            if len(its) > 0 and len(dd) > 0:
                f.write(f"    S{i}[{', '.join(its)}] : {' and '.join(dd)};\n")
        f.write("};\n")

        # Read := [n] -> {
        #     T[i, j] -> C[i + j];
        #     T[i, j] -> B[j];
        #     T[i, j] -> A[i];
        # } * Domain;

        f.write("Read := [] -> {\n")
        for i in range(len(schedule_ori)):
            sched.append(schedule_ori[i][1])
            its = schedule_ori[i][1][1::2]
            ss = list(map(str, schedule_ori[i][1]))
            for arr in dic[i]['read']:
                
                if len(its) > 0 and len(arr) > 0:
                    f.write(f"    S{i}[{', '.join(its)}] -> {arr};\n")
        f.write("} * Domain;\n")

        # Write := [n] -> {
        #     S[k] -> C[k];
        #     T[i, j] -> C[i + j];
        # } * Domain;
        f.write("Write := [] -> {\n")
        for i in range(len(schedule_ori)):
            sched.append(schedule_ori[i][1])
            its = schedule_ori[i][1][1::2]
            ss = list(map(str, schedule_ori[i][1]))
            for arr in dic[i]['write']:
                f.write(f"    S{i}[{', '.join(its)}] -> {arr};\n")
        f.write("} * Domain;\n")

        #         Schedule := [n] -> {
        #     T[i, j] -> [1, i, j];
        #     S[k] -> [0, k, 0];
        # };
        f.write("Schedule := [] -> {\n")
        for i in range(len(schedule_ori)):
            sched.append(schedule_ori[i][1])
            it = schedule_ori[i][1][1::2]
            ss = list(map(str, schedule_ori[i][1]))

            f.write(f"    S{i}[{', '.join(it)}] -> [{', '.join(ss)}];\n")
        f.write("};\n")
        f.write("print Schedule;\n")
        f.write("Before := Schedule << Schedule;\n")


        f.write("RaW := (Write . (Read^-1)) * Before;\n")
        f.write("WaW := (Write . (Write^-1)) * Before;\n")
        f.write("WaR := (Read . (Write^-1)) * Before;\n")


        #f.write("IslSchedule := schedule Domain respecting (RaW+WaW+WaR) minimizing RaW;\n")
        #f.write("IslSchedule := IslSchedule + {}; # flatten the schedule tree\n")

        f.write("IslSchedule := [] -> {\n")
        for i in range(len(schedule)):
            sched.append(schedule[i][1])
            it = schedule[i][1][1::2]
            ss = list(map(str, schedule[i][1]))

            f.write(f"    S{i}[{', '.join(it)}] -> [{', '.join(ss)}];\n")
        f.write("};\n")


        f.write("IslBefore := IslSchedule << IslSchedule;\n")


        f.write("print \"Does IslSchedule respects RaW deps?\";\n")
        f.write("print RaW <= IslBefore;\n")

        f.write("print \"Does IslSchedule respects WaW deps?\";\n")
        f.write("print WaW <= IslBefore;\n")

        f.write("print \"Does IslSchedule respects WaR deps?\";\n")
        f.write("print WaR <= IslBefore;\n")

        f.close()

    def delete_impossible(self, dd):
        new_dd = []
        for pos in dd:
            correct = True
            if pos[0] != 0:
                correct = False
            
            for j in range(1, len(pos)):
                if pos[j-1] > pos[j] :
                    correct = False
                    break
                if pos[j] - pos[j-1] >= 2:
                    correct = False
                    break
            if correct:
                new_dd.append(pos)

        return new_dd

    def generate_numbers(self, n):
        results = []

        # Helper function to generate numbers recursively
        def generate_helper(current, remaining):
            if remaining == 0:
                if tuple(current) not in results:
                    results.append(tuple(current))
                return
            if not current or current[-1] < n:
                current.append(current[-1] + 1 if current else 0)
                generate_helper(current, remaining - 1)
                current.pop()
            if not current or current[-1] != n:
                current.append(current[-1] if current else 0)
                generate_helper(current, remaining - 1)
                current.pop()

        generate_helper([], n)
        return results
        
    def run_iscc(self):
        schedule_ori = copy.deepcopy(self.schedule)
        n = len(self.schedule)
        if self.no_distribution:
            all_pos = []
        else:
            dd = self.generate_numbers(n)
            all_pos = sorted(dd, key=lambda x: sum(x), reverse=True)
        for pos in all_pos:
            schedule = copy.deepcopy(self.schedule)
            for i in range(len(schedule)):
                schedule[i][1][0] = pos[i]
                # for j in range(2, len(schedule[i][1]), 2):
                #     schedule[i][1][j] = 0


            dic = copy.deepcopy(self.dic)
            
            self.create_iscc(schedule_ori, schedule, dic)
            res = utilities.launch(f"{ISCC_CMD} < {self.folder}/iscc.iscc")
            res = ' '.join(res)

            # if res.count("True") == 3:
            RaW = eval(res.split("\"Does IslSchedule respects RaW deps?\" ")[-1].split(" ")[0].replace(" ", ""))
            WaW = eval(res.split("\"Does IslSchedule respects WaW deps?\" ")[-1].split(" ")[0].replace(" ", ""))
            WaR = eval(res.split("\"Does IslSchedule respects WaR deps?\" ")[-1].split(" ")[0].replace(" ", ""))


            if RaW and WaW and WaR:

                analysis_ = analysis.Analysis(schedule, dic, self.operations, self.arrays_size, self.dep, self.operation_list)
                UB = analysis_.UB
                LB = analysis_.LB
                operations = self.operations
                statements = analysis_.statements
                iterators = analysis_.iterators

                schedule = analysis_.only_schedule
                output = "output.cpp"
                headers = ['ap_int.h', 'hls_stream.h', 'hls_vector.h', 'cstring'] 
                arguments = analysis_.arguments
                name_function = "kernel_nlp"
                pragmas = [[] for k in range(len(UB))]
                pragmas_top = False
                optimize_burst = False
                
                code_generation_ = code_generation.CodeGeneration(analysis_, schedule, {}, UB, LB, statements, iterators, f"{self.folder}/new.cpp", headers, arguments, name_function, pragmas, pragmas_top)
                return


        dic = copy.deepcopy(self.dic)
        analysis_ = analysis.Analysis(schedule_ori, dic, self.operations, self.arrays_size, self.dep, self.operation_list)
        UB = analysis_.UB
        LB = analysis_.LB
        operations = self.operations
        statements = analysis_.statements
        iterators = analysis_.iterators
        schedule = analysis_.only_schedule
        output = "output.cpp"
        headers = ['ap_int.h', 'hls_stream.h', 'hls_vector.h', 'cstring'] 
        arguments = analysis_.arguments
        name_function = "kernel_nlp"
        pragmas = [[] for k in range(len(UB))]
        pragmas_top = False
        optimize_burst = False
        
        code_generation_ = code_generation.CodeGeneration(analysis_, schedule, {}, UB, LB, statements, iterators, f"{self.folder}/new.cpp", headers, arguments, name_function, pragmas, pragmas_top)