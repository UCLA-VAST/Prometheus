#include "output_2.h"

void kernel_symm(float alpha, float beta, float tmp[200][240],
                 float C[200][240], float A1[200][200], float B1[200][240],
                 float A2[200], float B2[200][240], float A3[200][200],
                 float B3[200][240]) {
  int i;
  int j;
  int k;

  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      tmp[i][j] = 0;
    }
  }
  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      for (k = 0; k < 200; k++) {
        tmp[i][j] += B1[k][j] * A1[i][k];
      }
    }
  }
  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      C[i][j] = beta * C[i][j] + alpha * B2[i][j] * A2[i] + alpha * tmp[i][j];
    }
  }
  for (i = 0; i < 200; i++) {
    for (k = 0; k < 200; k++) {
      for (j = 0; j < 240; j++) {
        C[i][j] += alpha * B3[k][j] * A3[k][i];
      }
    }
  }
}

void kernel_nlp(float alpha, float beta, float16 vtmp_for_task1[3000],
                float16 vB1_for_task1[3120], float16 vA1_for_task1[2600],
                float16 vC_for_task2[3000], float16 vB2_for_task2[3000],
                float4 vA2_for_task2[50], float16 vB3_for_task3[3000],
                float16 vA3_for_task3[2600]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float tmp_ori[200][240] = {0};
  float tmp_new_before_trans_0[200 * 240] = {0};
  float tmp_new_0[200 * 240] = {0};
  float C_ori[200][240] = {0};
  float C_new_before_trans_0[200 * 240] = {0};
  float C_new_0[200 * 240] = {0};
  float A1_ori[200][200] = {0};
  float A1_new_before_trans_0[200 * 208] = {0};
  float A1_new_0[200 * 208] = {0};
  float B1_ori[200][240] = {0};
  float B1_new_before_trans_0[208 * 240] = {0};
  float B1_new_0[208 * 240] = {0};
  float A2_ori[200] = {0};
  float A2_new_before_trans_0[200] = {0};
  float A2_new_0[200] = {0};
  float B2_ori[200][240] = {0};
  float B2_new_before_trans_0[200 * 240] = {0};
  float B2_new_0[200 * 240] = {0};
  float A3_ori[200][200] = {0};
  float A3_new_before_trans_0[200 * 208] = {0};
  float A3_new_0[200 * 208] = {0};
  float B3_ori[200][240] = {0};
  float B3_new_before_trans_0[200 * 240] = {0};
  float B3_new_0[200 * 240] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      tmp_ori[i0][i1] = val;
      tmp_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      tmp_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      C_ori[i0][i1] = val;
      C_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      C_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A1_ori[i0][i1] = val;
      A1_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A1_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B1_ori[i0][i1] = val;
      B1_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B1_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 52; d0_0++) {
      for (int d0_1 = 0; d0_1 < 4; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 4 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B1_new_0[memIndex] = B1_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    val = ((float)rand() / RAND_MAX);
    A2_ori[i0] = val;
    A2_new_before_trans_0[i0 * 1] = val;
    A2_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 10; d0_0++) {
    for (int d0_1 = 0; d0_1 < 20; d0_1++) {
      int d0 = d0_0 * 20 + d0_1;
      A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B2_ori[i0][i1] = val;
      B2_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B2_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B2_new_0[memIndex] = B2_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A3_ori[i0][i1] = val;
      A3_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A3_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B3_ori[i0][i1] = val;
      B3_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B3_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 40; d0_0++) {
      for (int d0_1 = 0; d0_1 < 5; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 5 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B3_new_0[memIndex] = B3_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  kernel_symm(alpha_ori, beta_ori, tmp_ori, C_ori, A1_ori, B1_ori, A2_ori,
              B2_ori, A3_ori, B3_ori);
  kernel_nlp(alpha_new, beta_new, (float16 *)tmp_new_0, (float16 *)B1_new_0,
             (float16 *)A1_new_0, (float16 *)C_new_0, (float16 *)B2_new_0,
             (float4 *)A2_new_0, (float16 *)B3_new_0, (float16 *)A3_new_0);
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          tmp_new_before_trans_0[d0 * 240 + d1 * 1] = tmp_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      if (abs(tmp_ori[i0][i1] - tmp_new_before_trans_0[i0 * 240 + i1 * 1]) >
          0.0001) {
        printf("Error in tmp... %d  %d %f %f\n", i0, i1, tmp_ori[i0][i1],
               tmp_new_before_trans_0[i0 * 240 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 20; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 20 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_before_trans_0[d0 * 240 + d1 * 1] = C_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
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
