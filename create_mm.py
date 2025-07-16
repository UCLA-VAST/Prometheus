
import random
import string

def get_random_letter():
    return random.choice(string.ascii_letters)


def get_random_word(length):
    return ''.join(get_random_letter() for i in range(length))

def generate_cpp_code(depth, N):
    node = 2**depth-1
    leaf = 2**(depth-1)
    dico = {}
    header = []
    for k in range(node):
        dico[f"O{k}"] = get_random_word(5)
        header.append(f"float {dico[f'O{k}']}[{N}][{N}]")
    
    for k in range(leaf):
        dico[f"A{k}"] = get_random_word(5)
        dico[f"B{k}"] = get_random_word(5)
        header.append(f"float {dico[f'A{k}']}[{N}][{N}]")
        header.append(f"float {dico[f'B{k}']}[{N}][{N}]")
    
    header_str = ", ".join(header)
    cpp_code = f"""
    void mm({header_str}) {{
        int i, j, k;
    """

    for k in range(leaf):
        O = dico[f"O{k}"]
        A = dico[f"A{k}"]
        B = dico[f"B{k}"]
        cpp_code += f"""
        for (int i = 0; i < {N}; i++)
            for (int j = 0; j < {N}; j++)
                for (int k = 0; k < {N}; k++)
                    {O}[i][j] += {A}[i][k] * {B}[k][j];
        """
    
    id_mat = 0
    already_visited = set()
    for k in range(leaf, node):
        O = dico[f"O{k}"]
        I1 = dico[f"O{id_mat}"]
        I2 = dico[f"O{id_mat+1}"]
        cpp_code += f"""
        for (i = 0; i < {N}; i++)
            for (j = 0; j < {N}; j++)
                for (k = 0; k < {N}; k++)
                    {O}[i][j] += {I1}[i][k] * {I2}[k][j];
        """
        already_visited.add(id_mat)
        already_visited.add(id_mat+1)
        id_mat += 2

    cpp_code += f"""
    }}
    """
    return cpp_code

# Example usage:
ff = []
for N in [64, 128, 256, 512, 1024, 2048, 4096]:
    for depth in [1, 2, 3, 4, 5, 6]:
        cpp_code = generate_cpp_code(depth, N)
        ff += [f"generated_tree_{depth}_{N}.c"]
        with open(f"mm/generated_tree_{depth}_{N}.c", "w") as file:
            file.write(cpp_code)
