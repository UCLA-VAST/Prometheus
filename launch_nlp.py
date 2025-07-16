import os


ll = os.listdir("nlp_cfile")

for l in ll:
    name = l.split(".")[0]
    f = open("nlp_cfile/"+l, "r")
    lines = f.readlines()
    f.close()
    for k, line in enumerate(lines):
        if "baron_options" in line:
            lines[k] = f"option baron_options 'maxtime=14400 trace=nlp_cfile/{name}.trace sumfile=nlp_cfile/{name}.sum';\n"
    f = open("nlp_cfile/"+l, "w")
    f.writelines(lines)
    f.close()

f = open("launch_nlp.sh", "w")
f.write("#!/bin/bash\n")
id_ = 0
log = []
for l in ll:
    name = l.split(".")[0]
    f.write(f"command{id_}=\"/workspaces/ampl.linux-intel64/ampl\"\n")
    log.append(f"nlp_cfile/{l} > nlp_cfile/{name}.log 2>&1")
    id_ += 1
for k in range(id_):
    f.write(f"$command{k} {log[k]} &\n")
    if k > 0 and k%20 == 0:
        f.write("wait\n")
f.write("wait\n")
f.close()

os.system("chmod +x launch_nlp.sh")
os.system("./launch_nlp.sh")