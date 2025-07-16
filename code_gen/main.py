import code_gen.code_generation_dataflow as code_generation_dataflow
import code_gen.code_generation_dataflow2 as code_generation_dataflow2
import code_gen.write_tcl as write_tcl
import code_gen.generate_csim as generate_csim
import code_gen.split_per_slr as split_per_slr
import code_gen.post_pass as post_pass
import os

class code_gen:

    def __init__(self, update_shape, nb_slr, nlp_file, nlp_log, cfile, output, host_name, schedule, analysis):

        folder = output.split("/")[:-1]
        folder = "/".join(folder)
        if update_shape:
            code_generation_dataflow2.CodeGeneration(nlp_file,nlp_log, output, analysis)
        else:
            code_generation_dataflow.CodeGeneration(nlp_file,nlp_log, output, analysis)
        post_pass.GeneratePostPass(update_shape, output, nlp_file, nlp_log)

        generate_csim.CSIM(cfile, output, host_name, analysis, schedule, nlp_file, nlp_log)
        split_per_slr.SplitPerSLR(output, nlp_file, nlp_log, nb_slr)