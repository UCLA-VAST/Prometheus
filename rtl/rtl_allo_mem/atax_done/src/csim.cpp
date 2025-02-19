#include "output.h"

#pragma ACCEL kernel

void kernel_atax(float A[390][410], float x[410], float y[410],
                 float tmp[390]) {
    int i;
    int j;

    for (i = 0; i < 390; i++) {
        tmp[i] = 0.0;
    }

    for (i = 0; i < 390; i++) {
        for (j = 0; j < 410; j++) {
            tmp[i] = tmp[i] + A[i][j] * x[j];
        }
    }

    for (j = 0; j < 410; j++) {
        y[j] = 0.0;
    }

    for (i = 0; i < 390; i++) {
        for (j = 0; j < 410; j++) {
            y[j] = y[j] + A[i][j] * tmp[i];
        }
    }
}

void kernel_nlp(float16 vtmp_for_task1[25], float16 vA_for_task1[10400],
                float16 vA_for_task3[10400], float16 vx_for_task1[26],
                float16 vy_for_task3[26]);

int main() {
    printf("Starting C-simulation...\n");
    float A_ori[390][410];
    float A_new_before_trans_0[400 * 416];
    float A_new_0[400 * 416];
    float A_new_before_trans_1[400 * 416];
    float A_new_1[400 * 416];
    float x_ori[410];
    float x_new_before_trans_0[416];
    float x_new_0[416];
    float y_ori[410];
    float y_new_before_trans_0[416];
    float y_new_0[416];
    float tmp_ori[390];
    float tmp_new_before_trans_0[400];
    float tmp_new_0[400];
    int memIndex = 0;
    float val;
    for (int i0 = 0; i0 < 390; i0++) {
        for (int i1 = 0; i1 < 410; i1++) {
            val = ((float)rand() / RAND_MAX);
            A_ori[i0][i1] = val;
            A_new_before_trans_0[i0 * 416 + i1 * 1] = val;
            A_new_0[i0 * 416 + i1 * 1] = val;
            A_new_before_trans_1[i0 * 416 + i1 * 1] = val;
            A_new_1[i0 * 416 + i1 * 1] = val;
        }
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 1; d0_0++) {
        for (int d1_0 = 0; d1_0 < 26; d1_0++) {
            for (int d0_1 = 0; d0_1 < 400; d0_1++) {
                for (int d1_1 = 0; d1_1 < 16; d1_1++) {
                    int d0 = d0_0 * 400 + d0_1;
                    int d1 = d1_0 * 16 + d1_1;
                    A_new_1[memIndex] = A_new_before_trans_1[d0 * 416 + d1 * 1];
                    memIndex++;
                }
            }
        }
    }
    for (int i0 = 0; i0 < 410; i0++) {
        val = ((float)rand() / RAND_MAX);
        x_ori[i0] = val;
        x_new_before_trans_0[i0 * 1] = val;
        x_new_0[i0 * 1] = val;
    }
    for (int i0 = 0; i0 < 410; i0++) {
        val = ((float)rand() / RAND_MAX);
        y_ori[i0] = val;
        y_new_before_trans_0[i0 * 1] = val;
        y_new_0[i0 * 1] = val;
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 26; d0_0++) {
        for (int d0_1 = 0; d0_1 < 16; d0_1++) {
            int d0 = d0_0 * 16 + d0_1;
            y_new_0[memIndex] = y_new_before_trans_0[d0 * 1];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 390; i0++) {
        val = ((float)rand() / RAND_MAX);
        tmp_ori[i0] = val;
        tmp_new_before_trans_0[i0 * 1] = val;
        tmp_new_0[i0 * 1] = val;
    }
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 1; d0_0++) {
        for (int d0_1 = 0; d0_1 < 400; d0_1++) {
            int d0 = d0_0 * 400 + d0_1;
            tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 1];
            memIndex++;
        }
    }
    kernel_atax(A_ori, x_ori, y_ori, tmp_ori);
    kernel_nlp((float16 *)tmp_new_0, (float16 *)A_new_0, (float16 *)A_new_1,
               (float16 *)x_new_0, (float16 *)y_new_0);
    // if padding we need to change data order
    memIndex = 0;
    for (int d0_0 = 0; d0_0 < 26; d0_0++) {
        for (int d0_1 = 0; d0_1 < 16; d0_1++) {
            int d0 = d0_0 * 16 + d0_1;
            y_new_before_trans_0[d0 * 1] = y_new_0[memIndex];
            memIndex++;
        }
    }
    for (int i0 = 0; i0 < 390; i0++) {
        if (abs(tmp_ori[i0] - tmp_new_0[i0 * 1]) > 0.0001) {
            printf("Error in tmp...\n");
            return 1;
        }
    }
    for (int i0 = 0; i0 < 410; i0++) {
        if (abs(y_ori[i0] - y_new_before_trans_0[i0 * 1]) > 0.0001) {
            printf("Error in y... %d %f %f\n", i0, y_ori[i0],
                   y_new_before_trans_0[i0 * 1]);
            return 1;
        }
    }
    
    printf("C-simulation passed!\n");
    return 0;
}
