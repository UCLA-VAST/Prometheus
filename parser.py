import sys
import os
import pocc


def compute_pragmas(schedule, file_):

  f = open(file_, "r")
  lines = f.readlines()
  f.close()
  pragmas = []
  pragma = ""
  for k,line in enumerate(lines):
    if "pragma" in line and "kernel" not in line and "off" not in line and "loop_tripcount" not in line and "scop" not in line:
      pragma += line.replace("#pragma", "").replace("ACCEL", "").replace("\n", " ").lower()
    if "for" in line:
      pragmas.append(pragma)
      pragma = ""
      # if "#pragma" in lines[k-1]:
      #   if "#pragma" in lines[k-2]:
      #     pragmas.append(lines[k-2].split("#pragma")[-1].replace(" ", "").replace("\n", "").lower() + lines[k-1].split("#pragma")[-1].replace(" ", "").replace("\n", "").lower())
      #   else:
      #     pragmas.append(lines[k-1].split("#pragma")[-1].replace(" ", "").replace("\n", "").lower())
      # else:
      #   pragmas.append("")

  nb_for = 0
  nb_statement = 0
  for line in lines:
      if "for" in line:
          nb_for += 1
      if "=" in line and ";" in line: # FIXME
          nb_statement += 1

  factor = [10**k for k in range(2*nb_for, 0, -1)]
  loops = []
  id_loops = [[] for k in range(nb_for)]


  statements = [[] for k in range(len(schedule))]
  for k, sched in enumerate(schedule):
    acc = 0
    for i in range(0, len(sched[1])-1, 2):
      position, iterator = sched[1][i:i+2]
      lex_position = (position + 1) * factor[i] + acc
      if [lex_position, iterator] not in loops:
        
        loops += [[lex_position, iterator]]
        id_loops[len(loops)-1].append((k, int(i//2)))
      else:
        ind = loops.index([lex_position, iterator])
        id_loops[ind].append((k, int(i//2)))
      acc = lex_position
  for k in range(len(id_loops)):
    for x,y in id_loops[k]:
      schedule[x][2][y] = pragmas[k]
  return schedule

def parser(folder, file_):
  
  scop = pocc.scop(folder, file_)
  if scop == []:
    return []
  schedules = []
  k = 0
  id_statement = 0

  while k < len(scop):
    if "# Scattering function" in scop[k] and "is provided" not in scop[k]:
      k += 1
      two_d_p_1 = int(scop[k].split()[0]) # schedule 2d+1
      d = int((two_d_p_1 - 1)//2)

      k += 1
      sched = []
      pragma = ["" for i in range(d)]
      if d == 0:
        if len(schedules) == 0:
          sched.append(0)
        else:
          sched.append(int(schedules[-1][1][0]) + 1)
      else:
        for i in range(two_d_p_1):
          if scop[k].split("##")[-1].replace(" ", "").replace("\n", "") == "fakeiter":
            break
          sched.append(scop[k].split("##")[-1].replace(" ", "").replace("\n", ""))
          k += 1

      for l in range(0, len(sched), 2):
        sched[l] = int(sched[l])
      schedules.append([f"S{id_statement}", sched, pragma])
      id_statement += 1

    k += 1
  schedules = compute_pragmas(schedules, file_)

  return schedules
