#include "output.h"

#pragma ACCEL kernel

void kernel_3mm(float E[180][190], float A[180][200], float B[200][190],
                float F[190][210], float C[190][220], float D[220][210],
                float G[180][210]) {
    int i;
    int j;
    int k;
    {
        for (i = 0; i < 180; i++) {
            for (j = 0; j < 190; j++) {
                E[i][j] = 0.0;

                for (k = 0; k < 200; ++k) {
                    E[i][j] += A[i][k] * B[k][j];
                }
            }
        }

        for (i = 0; i < 190; i++) {
            for (j = 0; j < 210; j++) {
                F[i][j] = 0.0;

                for (k = 0; k < 220; ++k) {
                    F[i][j] += C[i][k] * D[k][j];
                }
            }
        }

        for (i = 0; i < 180; i++) {
            for (j = 0; j < 210; j++) {
                G[i][j] = 0.0;

                for (k = 0; k < 190; ++k) {
                    G[i][j] += E[i][k] * F[k][j];
                }
            }
        }
    }
}

void kernel_nlp(float16 vE_for_task1[2160], float16 vA_for_task1[2340],
                float16 vB_for_task1[2412], float8 vF_for_task3[5184],
                float16 vC_for_task3[2660], float8 vD_for_task3[6048],
                float8 vG_for_task5[4860]);

int main() {
    printf("Starting C-simulation...\n");
    float E_ori[180][190];
    float E_new_before_trans_0[180 * 192];
    float E_new_0[180 * 192];
    float A_ori[180][200];
    float A_new_before_trans_0[180 * 208];
    float A_new_0[180 * 208];
    float B_ori[200][190];
    float B_new_before_trans_0[201 * 192];
    float B_new_0[201 * 192];
    float F_ori[190][210];
    float F_new_before_trans_0[192 * 216];
    float F_new_0[192 * 216];
    float C_ori[190][220];
    float C_new_before_trans_0[190 * 224];
    float C_new_0[190 * 224];
    float D_ori[220][210];
    float D_new_before_trans_0[224 * 216];
    float D_new_0[224 * 216];
    float G_ori[180][210];
    float G_new_before_trans_0[180 * 216];
    float G_new_0[180 * 216];
    int memIndex = 0;
    float val;
    for (int i0 = 0; i0 < 180; i0++) {
        for (int i1 = 0; i1 < 190; i1++) {
            val = ((float)rand() / RAND_MAX);
            E_ori[i0][i1] = val;
            E_new_before_trans_0[i0 * 192 + i1 * 1] = val;
            E_new_0[i0 * 192 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
        for (int d1_0 = 0; d1_0 < 6; d1_0++) {
            for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                for (int d1_1 = 0; d1_1 < 32; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 32 + d1_1;
                    E_new_0[memIndex] = E_new_before_trans_0[d0 * 192 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
        for (int d0_1 = 0; d0_1 < 10; d0_1++) {
            for (int d1 = 0; d1 < 192; d1++) {
                int d0 = d0_0 * 10 + d0_1;
                E_new_0[memIndex] = E_new_before_trans_0[d0 * 192 + d1 * 1];
                memIndex++;
            }
        }
    }
    for (int i0 = 0; i0 < 180; i0++) {
        for (int i1 = 0; i1 < 200; i1++) {
            val = ((float)rand() / RAND_MAX);
            A_ori[i0][i1] = val;
            A_new_before_trans_0[i0 * 208 + i1 * 1] = val;
            A_new_0[i0 * 208 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
        for (int d0_1 = 0; d0_1 < 10; d0_1++) {
            for (int d1 = 0; d1 < 208; d1++) {
                int d0 = d0_0 * 10 + d0_1;
                A_new_0[memIndex] = A_new_before_trans_0[d0 * 208 + d1 * 1];
                memIndex++;
            }
        }
    }
    for (int i0 = 0; i0 < 200; i0++) {
        for (int i1 = 0; i1 < 190; i1++) {
            val = ((float)rand() / RAND_MAX);
            B_ori[i0][i1] = val;
            B_new_before_trans_0[i0 * 192 + i1 * 1] = val;
            B_new_0[i0 * 192 + i1 * 1] = val;
        }
    }
    for (int i0 = 0; i0 < 190; i0++) {
        for (int i1 = 0; i1 < 210; i1++) {
            val = ((float)rand() / RAND_MAX);
            F_ori[i0][i1] = val;
            F_new_before_trans_0[i0 * 216 + i1 * 1] = val;
            F_new_0[i0 * 216 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 19; d0_0++) {
            
                for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                    for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    F_new_0[memIndex] = F_new_before_trans_0[d0 * 216 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 19; d0_0++) {
            for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    F_new_0[memIndex] = F_new_before_trans_0[d0 * 216 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    for (int i0 = 0; i0 < 190; i0++) {
        for (int i1 = 0; i1 < 220; i1++) {
            val = ((float)rand() / RAND_MAX);
            C_ori[i0][i1] = val;
            C_new_before_trans_0[i0 * 224 + i1 * 1] = val;
            C_new_0[i0 * 224 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 19; d0_0++) {
        for (int d0_1 = 0; d0_1 < 10; d0_1++) {
            for (int d1 = 0; d1 < 224; d1++) {
                int d0 = d0_0 * 10 + d0_1;
                C_new_0[memIndex] = C_new_before_trans_0[d0 * 224 + d1 * 1];
                memIndex++;
            }
        }
    }
    for (int i0 = 0; i0 < 220; i0++) {
        for (int i1 = 0; i1 < 210; i1++) {
            val = ((float)rand() / RAND_MAX);
            D_ori[i0][i1] = val;
            D_new_before_trans_0[i0 * 216 + i1 * 1] = val;
            D_new_0[i0 * 216 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 56; d0_0++) {
            
                for (int d0_1 = 0; d0_1 < 4; d0_1++) {
                    for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                    int d0 = d0_0 * 4 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    D_new_0[memIndex] = D_new_before_trans_0[d0 * 216 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    for (int i0 = 0; i0 < 180; i0++) {
        for (int i1 = 0; i1 < 210; i1++) {
            val = ((float)rand() / RAND_MAX);
            G_ori[i0][i1] = val;
            G_new_before_trans_0[i0 * 216 + i1 * 1] = val;
            G_new_0[i0 * 216 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 18; d0_0++) {
            for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    G_new_0[memIndex] = G_new_before_trans_0[d0 * 216 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    kernel_3mm(E_ori, A_ori, B_ori, F_ori, C_ori, D_ori, G_ori);
    kernel_nlp((float16 *)E_new_0, (float16 *)A_new_0, (float16 *)B_new_0,
               (float8 *)F_new_0, (float16 *)C_new_0, (float8 *)D_new_0,
               (float8 *)G_new_0);
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
        for (int d1_0 = 0; d1_0 < 6; d1_0++) {
            for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                for (int d1_1 = 0; d1_1 < 32; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 32 + d1_1;
                    E_new_before_trans_0[d0 * 192 + d1 * 1] = E_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    for (int i0 = 0; i0 < 180; i0++) {
        for (int i1 = 0; i1 < 190; i1++) {
            if (abs(E_ori[i0][i1] - E_new_before_trans_0[i0 * 192 + i1 * 1]) >
                0.0001) {
                printf("Error in E... %d  %d %f %f\n", i0, i1, E_ori[i0][i1],
                       E_new_before_trans_0[i0 * 192 + i1 * 1]);
                return 1;
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 18; d0_0++) {
        for (int d1_0 = 0; d1_0 < 67; d1_0++) {
            for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                for (int d1_1 = 0; d1_1 < 3; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 3 + d1_1;
                    A_new_before_trans_0[d0 * 208 + d1 * 1] = A_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 19; d0_0++) {
            
                for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                    for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    F_new_before_trans_0[d0 * 216 + d1 * 1] = F_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    for (int i0 = 0; i0 < 190; i0++) {
        for (int i1 = 0; i1 < 210; i1++) {
            if (abs(F_ori[i0][i1] - F_new_before_trans_0[i0 * 216 + i1 * 1]) >
                0.0001) {
                printf("Error in F... %d  %d %f %f\n", i0, i1, F_ori[i0][i1],
                       F_new_before_trans_0[i0 * 216 + i1 * 1]);
                return 1;
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 19; d0_0++) {
        for (int d1_0 = 0; d1_0 < 56; d1_0++) {
            for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                for (int d1_1 = 0; d1_1 < 4; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 4 + d1_1;
                    C_new_before_trans_0[d0 * 224 + d1 * 1] = C_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 56; d0_0++) {
            for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                for (int d0_1 = 0; d0_1 < 4; d0_1++) {
                    int d0 = d0_0 * 4 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    D_new_before_trans_0[d0 * 216 + d1 * 1] = D_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 9; d1_0++) {
        for (int d0_0 = 0; d0_0 < 18; d0_0++) {
            
                for (int d0_1 = 0; d0_1 < 10; d0_1++) {
                    for (int d1_1 = 0; d1_1 < 24; d1_1++) {
                    int d0 = d0_0 * 10 + d0_1;
                    int d1 = d1_0 * 24 + d1_1;
                    G_new_before_trans_0[d0 * 216 + d1 * 1] = G_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    for (int i0 = 0; i0 < 180; i0++) {
        for (int i1 = 0; i1 < 210; i1++) {
            if (abs(G_ori[i0][i1] - G_new_before_trans_0[i0 * 216 + i1 * 1]) >
                0.0001) {
                printf("Error in G... %d  %d %f %f\n", i0, i1, G_ori[i0][i1],
                       G_new_before_trans_0[i0 * 216 + i1 * 1]);
                return 1;
            }
        }
    }
    printf("C-simulation passed!\n");
    return 0;
}
