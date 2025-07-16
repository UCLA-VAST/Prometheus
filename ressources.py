

class Ressources:
    """
    Define the ressources of the FPGA
    LUT:              Number of LUT
    FF:               Number of FF
    DSP:              Number of DSP
    BRAM:             Number of BRAM
    partitioning_max: Partitioning max (usually 1024)
    """
    def __init__(self):

        self.sizeof = 32


        ### RTL
        self.SLR = 1
        self.factor = 1
        self.partitioning_max = 1024
        self.MAX_BUFFER_SIZE = 4096
        self.MAX_UF = 4096
        self.ON_CHIP_MEM_SIZE = 1512000
        ###

        # self.SLR = 3
        # self.factor = 0.45
        # self.partitioning_max = 256

        # self.SLR = 1
        # self.factor = 0.10
        # self.partitioning_max = 128

        # self.SLR = 3
        # self.factor = 0.50
        # self.partitioning_max = 128

        # self.SLR = 3
        # self.factor = 0.50
        # self.partitioning_max = 256

        # self.SLR = 1
        # self.factor = 0.10
        # self.partitioning_max = 256


        self.DSP = int(9024*self.factor) 
        self.BRAM = int(4032*self.factor)


        self.DSP_per_SLR = int(self.DSP/self.SLR)
        self.BRAM_per_SLR = int(self.BRAM/self.SLR)
        self.MEM_PER_SLR = int(self.ON_CHIP_MEM_SIZE/self.SLR)

        self.DSP_per_operation = {}
        if self.sizeof == 32:
            self.DSP_per_operation = {"+": 2, "-":2, "*": 3, "=": 0,"/":0}
        elif self.sizeof == 64:
            self.DSP_per_operation = {"+": 3, "-":3, "*": 8, "=": 0,"/":0}

        self.IL = {}
        if self.sizeof == 32:
            # self.IL = {"+": 5, "*": 3, "=": 1, "-":7, "/": 12}
            self.IL = {"+": 7, "*": 4, "=": 1, "-":7, "/": 12}
        elif self.sizeof == 64:
            self.IL = {"+": 5, "*": 6, "=": 1, "-":5, "/": 12}
        