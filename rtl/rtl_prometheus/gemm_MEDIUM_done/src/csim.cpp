#include "output_2.h"

void kernel_gemm(float alpha, float beta, float C[200][220], float A[200][240],
                 float B[240][220]) {
  int i;
  int j;
  int k;

  {

    for (i = 0; i < 200; i++) {
      for (j = 0; j < 220; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 200; i++) {
      for (k = 0; k < 240; k++) {
        for (j = 0; j < 220; j++) {
          C[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
  }
}

void kernel_nlp(float alpha, float beta, float16 vC_for_task0[2800],
                float16 vA_for_task1[3000], float16 vB_for_task1[3360]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float C_ori[200][220] = {0};
  float C_new_before_trans_0[200 * 224] = {0};
  float C_new_0[200 * 224] = {0};
  float A_ori[200][240] = {0};
  float A_new_before_trans_0[200 * 240] = {0};
  float A_new_0[200 * 240] = {0};
  float B_ori[240][220] = {0};
  float B_new_before_trans_0[240 * 224] = {0};
  float B_new_0[240 * 224] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      val = ((float)rand() / RAND_MAX);
      C_ori[i0][i1] = val;
      C_new_before_trans_0[i0 * 224 + i1 * 1] = val;
      C_new_0[i0 * 224 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 5; d0_0++) {
    for (int d1_0 = 0; d1_0 < 14; d1_0++) {
      for (int d0_1 = 0; d0_1 < 40; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 40 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 224 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      A_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 5; d0_0++) {
    for (int d0_1 = 0; d0_1 < 40; d0_1++) {
      for (int d1 = 0; d1 < 240; d1++) {
        int d0 = d0_0 * 40 + d0_1;
        A_new_0[memIndex] = A_new_before_trans_0[d0 * 240 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 224 + i1 * 1] = val;
      B_new_0[i0 * 224 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 14; d1_0++) {
    for (int d0_0 = 0; d0_0 < 80; d0_0++) {
      for (int d0_1 = 0; d0_1 < 3; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 3 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B_new_0[memIndex] = B_new_before_trans_0[d0 * 224 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  kernel_gemm(alpha_ori, beta_ori, C_ori, A_ori, B_ori);
  kernel_nlp(alpha_new, beta_new, (float16 *)C_new_0, (float16 *)A_new_0,
             (float16 *)B_new_0);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 5; d0_0++) {
    for (int d1_0 = 0; d1_0 < 14; d1_0++) {
      for (int d0_1 = 0; d0_1 < 40; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 40 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_before_trans_0[d0 * 224 + d1 * 1] = C_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      if (abs(C_ori[i0][i1] - C_new_before_trans_0[i0 * 224 + i1 * 1]) >
          0.0001) {
        printf("Error in C... %d  %d %f %f\n", i0, i1, C_ori[i0][i1],
               C_new_before_trans_0[i0 * 224 + i1 * 1]);
        return 1;
      }
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
