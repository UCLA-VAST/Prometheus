#include "output_2.h"

void kernel_syr2k(float alpha, float beta, float C[240][240],
                  float A1[240][200], float B1[240][200], float A2[240][200],
                  float B2[240][200]) {
  int i;
  int j;
  int k;
  // BLAS PARAMS
  // UPLO  = 'L'
  // TRANS = 'N'
  // A is NxM
  // B is NxM
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
          C[i][j] += A1[j][k] * alpha * B1[i][k] + B2[j][k] * alpha * A2[i][k];
        }
      }
    }
  }
}

void kernel_nlp(float alpha, float beta, float4 vC_for_task0[14400],
                float16 vA1_for_task1[3120], float16 vB1_for_task1[3120],
                float16 vB2_for_task1[3120], float16 vA2_for_task1[3120]);

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
  float B1_ori[240][200] = {0};
  float B1_new_before_trans_0[240 * 208] = {0};
  float B1_new_0[240 * 208] = {0};
  float A2_ori[240][200] = {0};
  float A2_new_before_trans_0[240 * 208] = {0};
  float A2_new_0[240 * 208] = {0};
  float B2_ori[240][200] = {0};
  float B2_new_before_trans_0[240 * 208] = {0};
  float B2_new_0[240 * 208] = {0};
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
  for (int d0_0 = 0; d0_0 < 8; d0_0++) {
    for (int d1_0 = 0; d1_0 < 20; d1_0++) {
      for (int d0_1 = 0; d0_1 < 30; d0_1++) {
        for (int d1_1 = 0; d1_1 < 12; d1_1++) {
          int d0 = d0_0 * 30 + d0_1;
          int d1 = d1_0 * 12 + d1_1;
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
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d0_1 = 0; d0_1 < 12; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 12 + d0_1;
        A1_new_0[memIndex] = A1_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      B1_ori[i0][i1] = val;
      B1_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      B1_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 8; d0_0++) {
    for (int d0_1 = 0; d0_1 < 30; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 30 + d0_1;
        B1_new_0[memIndex] = B1_new_before_trans_0[d0 * 208 + d1 * 1];
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
  for (int d0_0 = 0; d0_0 < 8; d0_0++) {
    for (int d0_1 = 0; d0_1 < 30; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 30 + d0_1;
        A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 240; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      B2_ori[i0][i1] = val;
      B2_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      B2_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d0_1 = 0; d0_1 < 12; d0_1++) {
      for (int d1 = 0; d1 < 208; d1++) {
        int d0 = d0_0 * 12 + d0_1;
        B2_new_0[memIndex] = B2_new_before_trans_0[d0 * 208 + d1 * 1];
        memIndex++;
      }
    }
  }
  kernel_syr2k(alpha_ori, beta_ori, C_ori, A1_ori, B1_ori, A2_ori, B2_ori);
  kernel_nlp(alpha_new, beta_new, (float4 *)C_new_0, (float16 *)A1_new_0,
             (float16 *)B1_new_0, (float16 *)B2_new_0, (float16 *)A2_new_0);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 8; d0_0++) {
    for (int d1_0 = 0; d1_0 < 20; d1_0++) {
      for (int d0_1 = 0; d0_1 < 30; d0_1++) {
        for (int d1_1 = 0; d1_1 < 12; d1_1++) {
          int d0 = d0_0 * 30 + d0_1;
          int d1 = d1_0 * 12 + d1_1;
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
