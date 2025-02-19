#include "output.h"

#pragma ACCEL kernel

void kernel_mvt(float x1[400], float x2[400], float y1[400], float y2[400],
                float A[400][400]) {
    int i;
    int j;
    {
        for (i = 0; i < 400; i++) {
            for (j = 0; j < 400; j++) {
                x1[i] = x1[i] + A[i][j] * y1[j];
            }
        }

        for (i = 0; i < 400; i++) {
            for (j = 0; j < 400; j++) {
                x2[i] = x2[i] + A[j][i] * y2[j];
            }
        }
    }
}

void kernel_nlp(float4 vx1_for_task0[100], float16 vA_for_task0[10000],
                float16 vA_for_task1[10000], float16 vy1_for_task0[25],
                float16 vx2_for_task1[25], float16 vy2_for_task1[25]);

int main() {
    printf("Starting C-simulation...\n");
    float x1_ori[400];
    float x1_new_before_trans_0[400];
    float x1_new_0[400];
    float x2_ori[400];
    float x2_new_before_trans_0[400];
    float x2_new_0[400];
    float y1_ori[400];
    float y1_new_before_trans_0[400];
    float y1_new_0[400];
    float y2_ori[400];
    float y2_new_before_trans_0[400];
    float y2_new_0[400];
    float A_ori[400][400];
    float A_new_before_trans_0[400 * 400];
    float A_new_0[400 * 400];
    float A_new_before_trans_1[400 * 400];
    float A_new_1[400 * 400];
    int memIndex = 0;
    float val;
    for (int i0 = 0; i0 < 400; i0++) {
        val = ((float)rand() / RAND_MAX);
        val = 0.0;
        x1_ori[i0] = val;
        x1_new_before_trans_0[i0 * 1] = val;
        x1_new_0[i0 * 1] = val;
    }
    // if padding we need to change data order
    memIndex = 0;
    // for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    //     for (int d0_1 = 0; d0_1 < 4; d0_1++) {
    //         int d0 = d0_0 * 4 + d0_1;
    //         x1_new_0[memIndex] = x1_new_before_trans_0[d0 * 1];
    //         memIndex++;
    //     }
    // }
    for (int i0 = 0; i0 < 400; i0++) {
        val = ((float)rand() / RAND_MAX);
        x2_ori[i0] = val;
        x2_new_before_trans_0[i0 * 1] = val;
        x2_new_0[i0 * 1] = val;
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 25; d0_0++) {
        for (int d0_1 = 0; d0_1 < 16; d0_1++) {
            int d0 = d0_0 * 16 + d0_1;
            x2_new_0[memIndex] = x2_new_before_trans_0[d0 * 1];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 400; i0++) {
        val = ((float)rand() / RAND_MAX);
        y1_ori[i0] = val;
        y1_new_before_trans_0[i0 * 1] = val;
        y1_new_0[i0 * 1] = val;
    }
    for (int i0 = 0; i0 < 400; i0++) {
        val = ((float)rand() / RAND_MAX);
        y2_ori[i0] = val;
        y2_new_before_trans_0[i0 * 1] = val;
        y2_new_0[i0 * 1] = val;
    }
    for (int i0 = 0; i0 < 400; i0++) {
        for (int i1 = 0; i1 < 400; i1++) {
            val = ((float)rand() / RAND_MAX);
            A_ori[i0][i1] = val;
            A_new_before_trans_0[i0 * 400 + i1 * 1] = val;
            A_new_0[i0 * 400 + i1 * 1] = val;
            A_new_before_trans_1[i0 * 400 + i1 * 1] = val;
            A_new_1[i0 * 400 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 100; d0_0++) {
        for (int d0_1 = 0; d0_1 < 4; d0_1++) {
            for (int d1 = 0; d1 < 400; d1++) {
                int d0 = d0_0 * 4 + d0_1;
                A_new_0[memIndex] = A_new_before_trans_0[d0 * 400 + d1 * 1];
                memIndex++;
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 25; d1_0++) {
        for (int d0_1 = 0; d0_1 < 400; d0_1++) {
            for (int d1_1 = 0; d1_1 < 16; d1_1++) {
                int d0 =  d0_1;
                int d1 = d1_0 * 16 + d1_1;
                A_new_1[memIndex] = A_new_before_trans_1[d0 * 400 + d1 * 1];
                memIndex++;
            }
        }
    }
    // if padding we need to change data order
    // memIndex = 0;
    // for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    //     for (int d1_0 = 0; d1_0 < 4; d1_0++) {
    //         for (int d0_1 = 0; d0_1 < 4; d0_1++) {
    //             for (int d1_1 = 0; d1_1 < 100; d1_1++) {
    //                 int d0 = d0_0 * 4 + d0_1;
    //                 int d1 = d1_0 * 100 + d1_1;
    //                 A_new_1[memIndex] = A_new_before_trans_1[d0 * 400 + d1 * 1];
    //                 memIndex++;
    //             }
    //         }
    //     }
    // }
    kernel_mvt(x1_ori, x2_ori, y1_ori, y2_ori, A_ori);
    kernel_nlp((float4 *)x1_new_0, (float16 *)A_new_0, (float16 *)A_new_1,
               (float16 *)y1_new_0, (float16 *)x2_new_0, (float16 *)y2_new_0);
    // if padding we need to change data order
    // memIndex = 0;
    // for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    //     for (int d0_1 = 0; d0_1 < 4; d0_1++) {
    //         int d0 = d0_0 * 4 + d0_1;
    //         x1_new_before_trans_1[d0 * 1] = x1_new_1[memIndex];
    //         memIndex++;
    //     }
    // }
    for (int i0 = 0; i0 < 400; i0++) {
        if (abs(x1_ori[i0] - x1_new_0[i0 * 1]) > 0.0001) {
            printf("Error in x1... %d %f %f\n", i0, x1_ori[i0],
                   x1_new_0[i0 * 1]);
            return 1;
        }
    }
    // // if padding we need to change data order
    // memIndex = 0;
    // for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    //     for (int d0_1 = 0; d0_1 < 16; d0_1++) {
    //         int d0 = d0_0 * 16 + d0_1;
    //         x2_new_before_trans_1[d0 * 1] = x2_new_1[memIndex];
    //         memIndex++;
    //     }
    // }
    for (int i0 = 0; i0 < 400; i0++) {
        if (abs(x2_ori[i0] - x2_new_0[i0 * 1]) > 0.0001) {
            printf("Error in x2... %d %f %f\n", i0, x2_ori[i0],
                   x2_new_0[i0 * 1]);
            return 1;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 100; d0_0++) {
        for (int d1_0 = 0; d1_0 < 4; d1_0++) {
            for (int d0_1 = 0; d0_1 < 4; d0_1++) {
                for (int d1_1 = 0; d1_1 < 100; d1_1++) {
                    int d0 = d0_0 * 4 + d0_1;
                    int d1 = d1_0 * 100 + d1_1;
                    A_new_before_trans_1[d0 * 400 + d1 * 1] = A_new_1[memIndex];
                    memIndex++;
                }
            }
        }
    }
    printf("C-simulation passed!\n");
    return 0;
}
