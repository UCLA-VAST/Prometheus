import os


ll = ["2mm_MEDIUM.cpp", "3mm_MEDIUM.cpp", "atax_MEDIUM.cpp", "bicg_MEDIUM.cpp", "gemver_MEDIUM.cpp", "mvt_MEDIUM.cpp",]
for l in ll:
    os.system("rm nlp.mod")
    # os.system(f"pocc tmp/{l} --output-scop")
    os.system('python3 main.py --file cfile/' + l)
    name = l.split(".")[0]
    os.system(f'mv prometheus prometheus_{name}')