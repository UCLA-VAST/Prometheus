#include "output_2.h"

void kernel_2mm(float alpha, float beta, float tmp[180][190], float A[180][210],
                float B[210][190], float C[190][220], float D[180][220]) {
  int i;
  int j;
  int k;
  {

    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        tmp[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        for (k = 0; k < 210; ++k) {
          tmp[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }

    for (i = 0; i < 180; i++) {
      for (j = 0; j < 220; j++) {
        D[i][j] *= beta;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 220; j++) {
        for (k = 0; k < 190; ++k) {
          D[i][j] += tmp[i][k] * C[k][j];
        }
      }
    }
  }
}

void kernel_nlp(float alpha, float beta, float8 vtmp_for_task1[4320],
                float16 vA_for_task1[2520], float16 vB_for_task1[2520],
                float4 vD_for_task2[9900], float16 vC_for_task3[2688]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float tmp_ori[180][190] = {0};
  float tmp_new_before_trans_0[180 * 192] = {0};
  float tmp_new_0[180 * 192] = {0};
  float A_ori[180][210] = {0};
  float A_new_before_trans_0[180 * 224] = {0};
  float A_new_0[180 * 224] = {0};
  float B_ori[210][190] = {0};
  float B_new_before_trans_0[210 * 192] = {0};
  float B_new_0[210 * 192] = {0};
  float C_ori[190][220] = {0};
  float C_new_before_trans_0[192 * 224] = {0};
  float C_new_0[192 * 224] = {0};
  float D_ori[180][220] = {0};
  float D_new_before_trans_0[180 * 220] = {0};
  float D_new_0[180 * 220] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      val = ((float)rand() / RAND_MAX);
      tmp_ori[i0][i1] = val;
      tmp_new_before_trans_0[i0 * 192 + i1 * 1] = val;
      tmp_new_0[i0 * 192 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d1_0 = 0; d1_0 < 8; d1_0++) {
      for (int d0_1 = 0; d0_1 < 9; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 9 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 192 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 210; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 224 + i1 * 1] = val;
      A_new_0[i0 * 224 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d0_1 = 0; d0_1 < 9; d0_1++) {
      for (int d1 = 0; d1 < 224; d1++) {
        int d0 = d0_0 * 9 + d0_1;
        A_new_0[memIndex] = A_new_before_trans_0[d0 * 224 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 210; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 192 + i1 * 1] = val;
      B_new_0[i0 * 192 + i1 * 1] = val;
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
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      val = ((float)rand() / RAND_MAX);
      D_ori[i0][i1] = val;
      D_new_before_trans_0[i0 * 220 + i1 * 1] = val;
      D_new_0[i0 * 220 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d1_0 = 0; d1_0 < 11; d1_0++) {
      for (int d0_1 = 0; d0_1 < 9; d0_1++) {
        for (int d1_1 = 0; d1_1 < 20; d1_1++) {
          int d0 = d0_0 * 9 + d0_1;
          int d1 = d1_0 * 20 + d1_1;
          D_new_0[memIndex] = D_new_before_trans_0[d0 * 220 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  kernel_2mm(alpha_ori, beta_ori, tmp_ori, A_ori, B_ori, C_ori, D_ori);
  kernel_nlp(alpha_new, beta_new, (float8 *)tmp_new_0, (float16 *)A_new_0,
             (float16 *)B_new_0, (float4 *)D_new_0, (float16 *)C_new_0);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d1_0 = 0; d1_0 < 8; d1_0++) {
      for (int d0_1 = 0; d0_1 < 9; d0_1++) {
        for (int d1_1 = 0; d1_1 < 24; d1_1++) {
          int d0 = d0_0 * 9 + d0_1;
          int d1 = d1_0 * 24 + d1_1;
          tmp_new_before_trans_0[d0 * 192 + d1 * 1] = tmp_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 190; i1++) {
      if (abs(tmp_ori[i0][i1] - tmp_new_before_trans_0[i0 * 192 + i1 * 1]) >
          0.0001) {
        printf("Error in tmp... %d  %d %f %f\n", i0, i1, tmp_ori[i0][i1],
               tmp_new_before_trans_0[i0 * 192 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 20; d0_0++) {
    for (int d1_0 = 0; d1_0 < 11; d1_0++) {
      for (int d0_1 = 0; d0_1 < 9; d0_1++) {
        for (int d1_1 = 0; d1_1 < 20; d1_1++) {
          int d0 = d0_0 * 9 + d0_1;
          int d1 = d1_0 * 20 + d1_1;
          D_new_before_trans_0[d0 * 220 + d1 * 1] = D_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 180; i0++) {
    for (int i1 = 0; i1 < 220; i1++) {
      if (abs(D_ori[i0][i1] - D_new_before_trans_0[i0 * 220 + i1 * 1]) >
          0.0001) {
        printf("Error in D... %d  %d %f %f\n", i0, i1, D_ori[i0][i1],
               D_new_before_trans_0[i0 * 220 + i1 * 1]);
        return 1;
      }
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
