


TI = 2
I = 3
TJ = 4
J = 5

for ti in range(TI):
    for tj in range(TJ):
        for i in range(I):
            for j in range(J):
                print(f"i={i} j={j} ti={ti} tj={tj}")
                # print(f"x[{tj*J + j}]")
                print(f"tmp[{ti*I + i}]")