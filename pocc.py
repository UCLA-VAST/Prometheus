import os
import utilities
import parser
import random

# POCC_CMD = "/opt/polyopt/default/sources/polyopt-hls/pocc/bin/pocc"
POCC_CMD = "apptainer exec /opt/public/apptainer/pocc/pocc.sif pocc"

def tile(name_file, output_name_file):

    cloogf, cloogl = utilities.compute_cloogl_cloof(name_file)

    res = utilities.launch(f"{POCC_CMD} --pluto-fuse maxfuse {name_file} --verbose --output {output_name_file} --pluto-tile --pluto-noskew --cloog-cloogl 42 --cloog-cloogf 42 --pluto-bounds 1")
    return res

def tile_no_codegen(name_file):
    res = utilities.launch(f"{POCC_CMD} --pluto-fuse maxfuse {name_file} --verbose  --pluto-tile -n")
    return res

def ponos(name_file):
    try:
        res = utilities.launch(f"timeout 1m {POCC_CMD} --pluto --letsee {name_file} --verbose")

    except:
        res = ""
        print(f"Error Ponos {name_file}")
    return res

def extract_flops(name_file):
    res = utilities.launch(f"{POCC_CMD} {name_file} --polyfeat --verbose")
    gf = 0
    for line in res:
        if "Flops executed" in line:
            gf = line.split(":")[1].split("(")[0].replace(" ", "")
            gf = float(gf)
    return gf


def scoplib(folder, file_):
    """
    Processes a given C file to generate SCOPLib output.

    Args:
        folder (str): The folder where temporary files will be created.
        file_ (str): The path to the input C file.

    Returns:
        str: The output of the POCC command execution.
    """
    # Extract the path and file name
    path = "/".join(file_.split("/")[:-1])
    name_file = file_.split("/")[-1].split(".c")[0]

    # Create the temporary directory if it doesn't already exist
    temp_folder = f"{folder}/tmp"
    if not os.path.exists(temp_folder):
        os.mkdir(temp_folder)

    # Copy the file to the temporary location with a modified name
    temp_file = f"{temp_folder}/.tmp2{name_file}.c"
    os.system(f"cp {file_} {temp_file}")

    # Process the file to add and delete pragmas
    utilities.delete_pragma(temp_file)
    utilities.add_pragma_scop(temp_file)

    # Execute the POCC command and capture the result
    res = utilities.launch(f"{POCC_CMD} {temp_file} --output-scop --verbose")

    return res

def candl(folder, file_):
    """
    Processes a given C file to generate dependencies using the CANDL tool.

    Args:
        folder (str): The folder where temporary files will be created.
        file_ (str): The path to the input C file.

    Returns:
        str: The output of the POCC command execution with CANDL options.
    """
    # Extract the path and file name
    path = "/".join(file_.split("/")[:-1])
    name_file = file_.split("/")[-1].split(".c")[0]

    # Create the temporary directory if it doesn't already exist
    temp_folder = f"{folder}/tmp"
    if not os.path.exists(temp_folder):
        os.mkdir(temp_folder)

    # Copy the file to the temporary location with a modified name
    temp_file = f"{temp_folder}/.tmp2{name_file}.c"
    os.system(f"cp {file_} {temp_file}")

    # Process the file to add and delete pragmas
    utilities.delete_pragma(temp_file)
    utilities.add_pragma_scop(temp_file)

    # Execute the POCC command with CANDL options and capture the result
    res = utilities.launch(f"{POCC_CMD} {temp_file} --candl-dep-isl-simp --verbose -n")

    return res

def candl_ddv(file_):
    res = utilities.launch(f"{POCC_CMD} {file_} --candl-ddv --candl-dep-prune --red-commute --verbose -n")
    return res


def scop(folder, file_):
    """
    Processes a given C file to generate SCOP output using POCC.

    Args:
        folder (str): The folder where temporary files will be created.
        file_ (str): The path to the input C file.

    Returns:
        list: Lines from the generated SCOP output file.
    """
    # Ensure the temporary directory exists
    temp_folder = f"{folder}/tmp"
    if not os.path.exists(temp_folder):
        os.mkdir(temp_folder)

    # Extract the file name without extension
    name_file = file_.split("/")[-1].split(".c")[0]

    # Prepare the temporary file path
    temp_file = f"{temp_folder}/.tmp2{name_file}.c"

    # Copy and preprocess the input file
    os.system(f"cp {file_} {temp_file}")
    utilities.delete_pragma(temp_file)
    utilities.add_pragma_scop(temp_file)

    # Run the POCC command to generate SCOP output
    res = utilities.launch(f"{POCC_CMD} {temp_file} --output-scop")

    # Read the generated SCOP file
    scop_file = f"{temp_folder}/.tmp2{name_file}.pocc.c.scop"
    with open(scop_file, "r") as f:
        lines = f.readlines()

    return lines

def compute_schedule(folder, fil):
    if not os.path.exists("tmp"):
        os.mkdir("tmp")
    # os.system(f"cp {fil} tmp/.{fil}")
    # utilities.delete_bracket(f"tmp/.{fil}")
    # utilities.delete_comment(f"tmp/.{fil}")
    # utilities.rename_register(f"tmp/.{fil}")
    # utilities.delete_pragma_scop(f"tmp/.{fil}")
    sched = parser.parser(folder, fil)
    # os.system(f"rm tmp/.{fil}")

    return sched