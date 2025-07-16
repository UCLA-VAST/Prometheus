import islpy as isl

import islpy as isl

def count_points(polyhedron):
    return int(polyhedron.count_val().to_str())

class Polyhedron:
    def __init__(self, inequalities):
        self.ctx = isl.Context()
        self.inequalities = inequalities
        self.polyhedron = self._create_polyhedron()

    def _extract_variables(self):
        variables = []
        for inequality in self.inequalities:
            variables.append(inequality.split(" <= ")[1].replace(" ", ""))
        return variables

    def _create_polyhedron(self):
        variables = self._extract_variables()
        variables_str = ",".join(variables)
        orgi_var = variables_str.split(",")
        translate = {}
        variables_str = []
        for i in range(len(orgi_var)):
            translate[orgi_var[i]] = f"c{i}"
            variables_str.append(f"c{i}")
        variables_str = ",".join(variables_str)
        for i in range(len(self.inequalities)):
            for key in translate.keys():
                self.inequalities[i] = self.inequalities[i].replace(key, translate[key])

        constraint_str = "[" + variables_str + "] -> { [" + variables_str + "]: " + " and ".join(self.inequalities) + " }"
        return isl.Set(constraint_str, context=self.ctx)

    def get_polyhedron(self):
        return self.polyhedron

    def intersection(self, other_polyhedron):
        return self.polyhedron.intersect(other_polyhedron.get_polyhedron())

    def union(self, other_polyhedron):
        return self.polyhedron.union(other_polyhedron.get_polyhedron())

    def complement(self):
        return self.polyhedron.complement()





class ISLArray:

    def __init__(self, ctx, name, inequalities):
        self.ctx = ctx
        self.name = name
        self.inequalities = inequalities
        self.polyhedron = self._create_polyhedron()

    def _extract_variables(self):
        variables = []
        for inequality in self.inequalities:
            variables.append(inequality.split(" <= ")[1].replace(" ", ""))
        return variables
    
    def _create_polyhedron(self):
        variables = self._extract_variables()
        variables_str = ",".join(variables)

        orgi_var = variables_str.split(",")
        translate = {}
        variables_str = []
        for i in range(len(orgi_var)):
            translate[orgi_var[i]] = f"c{i}"
            variables_str.append(f"c{i}")
        variables_str = ",".join(variables_str)
        for i in range(len(self.inequalities)):
            for key in translate.keys():
                self.inequalities[i] = self.inequalities[i].replace(key, translate[key])

        ine = " and ".join(self.inequalities)
        constraint_str = f"{{ {self.name}[{variables_str}]: {ine}}}"

        return isl.Set(constraint_str, context=self.ctx)

    def get_polyhedron(self):
        return self.polyhedron

    def intersection(self, other_polyhedron):
        return self.polyhedron.intersect(other_polyhedron.get_polyhedron())

    def union(self, other_polyhedron):
        return self.polyhedron.union(other_polyhedron.get_polyhedron())

    def complement(self):
        return self.polyhedron.complement()


class ISLStatement:

    def __init__(self, ctx, id_, loops, read_, write_, sched, max_loops):
        self.ctx = ctx
        self.id_ = id_
        self.loops = loops
        self.read_ = read_
        self.write_ = write_
        self.domain, self.iterators_schedule = self._create_domain()
        self.read = []
        self.write = []
        self.max_loops = max_loops
        
        for r in self.read_:
            self.read.append(self._create_access(r))
        for r in self.write_:
            self.write.append(self._create_access(r))
        self.schedule = self.compute_schedule(sched)
        
    def compute_schedule(self, sched):
        tmp = list(map(str, sched))
        n = len(tmp)
        for k in range(self.max_loops - n):
            tmp.append("0")
        sched_ = ",".join(tmp)

        res = f"S{self.id_}[{self.iterators_schedule}]->[{sched_}]"
        return res

    def _create_domain(self):
        iterators = list(self.loops.LBs.keys()) 
        iterators_str = ",".join(iterators)
        const = []
        for i in range(len(iterators)):
            const.append(f"{self.loops.LBs[iterators[i]]} <= {iterators[i]} <= {self.loops.UBs[iterators[i]]}")
        domain = " and ".join(const)
        return isl.Set(f"{{S{self.id_}[{iterators_str}]: {domain}}}", context=self.ctx), iterators_str

    def _create_access(self, r):
        # Access_C = isl.Map("{S0[i,k]->C[i]}")
        name = r[0]
        iterators = ",".join(r[1])
        return isl.Map(f"{{S{self.id_}[{self.iterators_schedule}]->{name}[{iterators}]}}")



def ISLcompute_dep(schedule, Read, Write):
    RAW    = isl.UnionMap.apply_range( Read,  isl.UnionMap.reverse(Write) )
    WAW    = isl.UnionMap.apply_range( Write, isl.UnionMap.reverse(Write) )
    WAR    = isl.UnionMap.apply_range( Write, isl.UnionMap.reverse(Read)  )
    before = isl.UnionMap.lex_lt_union_map(schedule, schedule)
    Dep    = isl.UnionMap.intersect(isl.UnionMap.union(RAW, isl.UnionMap.union(WAW, WAR)), before)
    return Dep

def ISLcheck_if_legal(other_schedule, Dep):
    src2sinktime = isl.UnionMap.apply_range(Dep, other_schedule) 
    timesrcsink  = isl.UnionMap.apply_range(isl.UnionMap.reverse(other_schedule), src2sinktime) 

    range_  = other_schedule.range()
    Sdesc = range_.lex_ge_union_set(range_)
    src_gt_sink = timesrcsink.intersect(Sdesc);
    null_map = isl.UnionMap("[N]->{  }")
    is_empty = src_gt_sink.__eq__(null_map)
    return is_empty




inequalities_A = ["0 <= X <= 400-1", "0 <= Y <= 400-1"]
inequalities_B = ["0 <= i <= 400-1", "0 <= j <= i-1"]
# # Example usage:
# inequalities_A = ["1 <= X <= 5", "1 <= Y <= 3"]
# inequalities_B = ["2 <= X <= 6", "1 <= Y <= 4"]

polyhedron_A = Polyhedron(inequalities_A)
polyhedron_B = Polyhedron(inequalities_B)
# # Intersection
intersection_polyhedron = polyhedron_A.intersection(polyhedron_B)
pp = ["0 <= c0 <= 399", "0 <= c1 <= 399", "c1 <= c0-1"]
p = Polyhedron(pp)

constraint_str = "[c0, c1] -> { [c0, c1] :  0 <= c0 <= 399 and 0 <= c1 <= 399 and c1 < c0 }"
p = isl.Set(constraint_str)
constraint_str = "[c0, c1] -> { [c0, c1] :  0 <= c0 <= 399 and 0 <= c1 <= 399 and c1 = c0 }"
p2 = isl.Set(constraint_str)


# # Union
# union_polyhedron = polyhedron_A.union(polyhedron_B)

# # Complement
# complement_A = polyhedron_A.complement()
# complement_B = polyhedron_B.complement()

# # Count points
# count_A = polyhedron_A.count_points()
# count_B = polyhedron_B.count_points()


