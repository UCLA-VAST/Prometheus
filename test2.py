

# for ( j = 0; j < 41; j++) {
#         for ( i = 0; i < 39; i++) {
#             for ( i = 0; i < 10; i++) {
#                 for ( j = 0; j < 10; j++) {
#                     y[j] = y[j] + A[i][j] * tmp[i];
#         }
#     }

# for tj in range(2):
#     for ti in range(2):
#         for i1 in range(4):
#             for j1 in range(4):
#                 i = ti * 4 + i1
#                 j = tj * 4 + j1
#                 print(ti,tj,i,j)
#                 print(f"y[{j}] = y[{j}] + A[{i}][{j}] * tmp[{i}]")
#             print()
#         print()
#     print()
# A[2][2]
count = 0
A = [[0,0], [0,0]]
for tj in range(2):
    for ti in range(2):
        for i1 in range(2):
            for j1 in range(2):
                for tk in range(2):
                    for k1 in range(2):
                        i = ti * 2 + i1
                        j = tj * 2 + j1
                        k = tk * 2 + k1
                        A[i1][k1] = f"A[{i}][{k}]"
                        print(ti,tj,tk,i1,j1,k1, A)
                        
                        if i == 0 and k == 0:
                            count += 1
                        # C[i][j] += A[i][k] * B[k][j]
                        print(f"C[{i}][{j}] = C[{i}][{j}] + A[{i}][{k}] * B[{k}][{j}]\n")
print(count)