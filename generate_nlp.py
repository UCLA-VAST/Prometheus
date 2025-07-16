import os


ll = os.listdir("cfile")
for l in ll:
    os.system("rm -rf nlp.mod")
    try:
        os.system("python3 main.py --file cfile/"+l)
        if "nlp.mod" in os.listdir():
            name = l.split(".")[0]
            os.system(f"mv nlp.mod nlp_cfile/{name}.mod")
    except:
        pass
    