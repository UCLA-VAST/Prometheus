#include "output_2.h"

void kernel_syrk(float alpha, float beta, float C[240][240], float A1[240][200],
                 float A2[240][200]) {
  int i;
  int j;
  int k;
  // BLAS PARAMS
  // TRANS = 'N'
  // UPLO  = 'L'
  //  =>  Form  C := alpha*A*A**T + beta*C.
  // A is NxM
  // C is NxN
  {

    for (i = 0; i < 240; i++) {
      for (j = 0; j <= i; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 240; i++) {
      for (k = 0; k < 200; k++) {
        for (j = 0; j <= i; j++) {
          C[i][j] += alpha * A1[i][k] * A2[j][k];
        }
      }
    }
  }
}

void kernel_nlp(float alpha, float beta, float8 vC_for_task0[7200],
                float16 vA1_for_task1[3120], float16 vA2_for_task1[3120]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float C_ori[240][240] = {0};
  float C_new_before_trans_0[240 * 240] = {0};
  float C_new_0[240 * 240] = {0};
  float A1_ori[240][200] = {0};
  float A1_new_before_trans_0[240 * 208] = {0};
  float A1_new_0[240 * 208] = {0};
  float A2_ori[240][200] = {0};
  float A2_new_before_trans_0[240 * 208] = {0};
  float A2_new_0[240 * 208] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      C_ori[i0][i1] = val;
      C_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      C_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 4; d0_0++) {
    for (int d1_0 = 0; d1_0 < 30; d1_0++) {
      for (int d0_1 = 0; d0_1 < 60; d0_1++) {
        for (int d1_1 = 0; d1_1 < 8; d1_1++) {
          int d0 = d0_0 * 60 + d0_1;
          int d1 = d1_0 * 8 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A1_ori[i0][i1] = val;
      A1_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A1_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 4; d0_0++) {
    for (int d0_1 = 0; d0_1 < 60; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 60 + d0_1;
        A1_new_0[memIndex] = A1_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A2_ori[i0][i1] = val;
      A2_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A2_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 30; d0_0++) {
    for (int d0_1 = 0; d0_1 < 8; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 8 + d0_1;
        A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  kernel_syrk(alpha_ori, beta_ori, C_ori, A1_ori, A2_ori);
  kernel_nlp(alpha_new, beta_new, (float8 *)C_new_0, (float16 *)A1_new_0,
             (float16 *)A2_new_0);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 4; d0_0++) {
    for (int d1_0 = 0; d1_0 < 30; d1_0++) {
      for (int d0_1 = 0; d0_1 < 60; d0_1++) {
        for (int d1_1 = 0; d1_1 < 8; d1_1++) {
          int d0 = d0_0 * 60 + d0_1;
          int d1 = d1_0 * 8 + d1_1;
          C_new_before_trans_0[d0 * 240 + d1 * 1] = C_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      if (abs(C_ori[i0][i1] - C_new_before_trans_0[i0 * 240 + i1 * 1]) >
          0.0001) {
        printf("Error in C... %d  %d %f %f\n", i0, i1, C_ori[i0][i1],
               C_new_before_trans_0[i0 * 240 + i1 * 1]);
        return 1;
      }
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
