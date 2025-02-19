#include "output.h"

#pragma ACCEL kernel

void kernel_bicg(float A[410][390], float s[390], float q[410], float p[390],
                 float r[410]) {
    int i;
    int j;
    {
        for (j = 0; j < 390; j++) {
            s[j] = 0.0;
        }
        for (i = 0; i < 410; i++) {
            for (j = 0; j < 390; j++) {
                s[j] = s[j] + r[i] * A[i][j];
            }
        }
        for (i = 0; i < 410; i++) {
            q[i] = 0.0;
        }
        for (i = 0; i < 410; i++) {
            for (j = 0; j < 390; j++) {
                q[i] = q[i] + A[i][j] * p[j];
            }
        }
    }
}

void kernel_nlp(float16 vs_for_task1[25], float16 vr_for_task1[26],
                float16 vA_for_task1[10325], float16 vA_for_task3[10325],
                float2 vq_for_task3[205], float16 vp_for_task3[25]);

int main() {
    printf("Starting C-simulation...\n");
    float A_ori[410][390];
    float A_new_before_trans_0[413 * 400];
    float A_new_0[413 * 400];
    float A_new_before_trans_1[413 * 400];
    float A_new_1[413 * 400];
    float s_ori[390];
    float s_new_before_trans_0[400];
    float s_new_0[400];
    float q_ori[410];
    float q_new_before_trans_0[410];
    float q_new_0[410];
    float p_ori[390];
    float p_new_before_trans_0[400];
    float p_new_0[400];
    float r_ori[410];
    float r_new_before_trans_0[416];
    float r_new_0[416];
    int memIndex = 0;
    float val;
    for (int i0 = 0; i0 < 410; i0++) {
        for (int i1 = 0; i1 < 390; i1++) {
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
    for (int d1_0 = 0; d1_0 < 25; d1_0++) {
        for (int d0_0 = 0; d0_0 < 1; d0_0++) {
            
            for (int d0_1 = 0; d0_1 < 413; d0_1++) {
                for (int d1_1 = 0; d1_1 < 16; d1_1++) {
                    int d0 = d0_0 * 59 + d0_1;
                    int d1 = d1_0 * 16 + d1_1;
                    A_new_0[memIndex] = A_new_before_trans_0[d0 * 400 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 25; d1_0++) {
        for (int d0_0 = 0; d0_0 < 7; d0_0++) {
            for (int d1_1 = 0; d1_1 < 16; d1_1++) {
                for (int d0_1 = 0; d0_1 < 59; d0_1++) {
                    int d0 = d0_0 * 59 + d0_1;
                    int d1 = d1_0 * 16 + d1_1;
                    A_new_1[memIndex] = A_new_before_trans_1[d0 * 400 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 7; d0_0++) {
        for (int d0_1 = 0; d0_1 < 59; d0_1++) {
            for (int d1 = 0; d1 < 400; d1++) {
                int d0 = d0_0 * 59 + d0_1;
                A_new_1[memIndex] = A_new_before_trans_1[d0 * 400 + d1 * 1];
                memIndex++;
            }
        }
    }
    for (int i0 = 0; i0 < 390; i0++) {
        val = ((float)rand() / RAND_MAX);
        s_ori[i0] = val;
        s_new_before_trans_0[i0 * 1] = val;
        s_new_0[i0 * 1] = val;
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 25; d0_0++) {
        for (int d0_1 = 0; d0_1 < 16; d0_1++) {
            int d0 = d0_0 * 16 + d0_1;
            s_new_0[memIndex] = s_new_before_trans_0[d0 * 1];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 410; i0++) {
        val = ((float)rand() / RAND_MAX);
        q_ori[i0] = val;
        q_new_before_trans_0[i0 * 1] = val;
        q_new_0[i0 * 1] = val;
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 41; d0_0++) {
        for (int d0_1 = 0; d0_1 < 10; d0_1++) {
            int d0 = d0_0 * 10 + d0_1;
            q_new_0[memIndex] = q_new_before_trans_0[d0 * 1];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 390; i0++) {
        val = ((float)rand() / RAND_MAX);
        p_ori[i0] = val;
        p_new_before_trans_0[i0 * 1] = val;
        p_new_0[i0 * 1] = val;
    }
    for (int i0 = 0; i0 < 410; i0++) {
        val = ((float)rand() / RAND_MAX);
        r_ori[i0] = val;
        r_new_before_trans_0[i0 * 1] = val;
        r_new_0[i0 * 1] = val;
    }
    kernel_bicg(A_ori, s_ori, q_ori, p_ori, r_ori);
    kernel_nlp((float16 *)s_new_0, (float16 *)r_new_0, (float16 *)A_new_0,
               (float16 *)A_new_1, (float2 *)q_new_0, (float16 *)p_new_0);
    // if padding we need to change data order
    memIndex = 0;
    for (int d1_0 = 0; d1_0 < 25; d1_0++) {
        for (int d0_0 = 0; d0_0 < 7; d0_0++) {
            for (int d1_1 = 0; d1_1 < 16; d1_1++) {
                for (int d0_1 = 0; d0_1 < 59; d0_1++) {
                    int d0 = d0_0 * 59 + d0_1;
                    int d1 = d1_0 * 16 + d1_1;
                    A_new_before_trans_0[d0 * 400 + d1 * 1] = A_new_0[memIndex];
                    memIndex++;
                }
            }
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 25; d0_0++) {
        for (int d0_1 = 0; d0_1 < 16; d0_1++) {
            int d0 = d0_0 * 16 + d0_1;
            s_new_before_trans_0[d0 * 1] = s_new_0[memIndex];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 390; i0++) {
        if (abs(s_ori[i0] - s_new_before_trans_0[i0 * 1]) > 0.0001) {
            printf("Error in s... %d %f %f\n", i0, s_ori[i0],
                   s_new_before_trans_0[i0 * 1]);
            return 1;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 41; d0_0++) {
        for (int d0_1 = 0; d0_1 < 10; d0_1++) {
            int d0 = d0_0 * 10 + d0_1;
            q_new_before_trans_0[d0 * 1] = q_new_0[memIndex];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 410; i0++) {
        if (abs(q_ori[i0] - q_new_before_trans_0[i0 * 1]) > 0.0001) {
            printf("Error in q... %d %f %f\n", i0, q_ori[i0],
                   q_new_before_trans_0[i0 * 1]);
            return 1;
        }
    }
    printf("C-simulation passed!\n");
    return 0;
}
