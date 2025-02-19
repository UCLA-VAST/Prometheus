#include "output_2.h"

void kernel_gemver(float alpha, float beta, float A[400][400], float u1[400],
                   float e1[400], float u2[400], float e2[400], float w[400],
                   float x[400], float y[400], float z[400]) {
  int i;
  int j;
  {

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        A[i][j] = A[i][j] + u1[i] * e1[j] + u2[i] * e2[j];
      }
    }

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        x[i] = x[i] + beta * A[j][i] * y[j];
      }
    }

    for (i = 0; i < 400; i++) {
      x[i] = x[i] + z[i];
    }

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        w[i] = w[i] + alpha * A[i][j] * x[j];
      }
    }
  }
}

void kernel_nlp(float alpha, float beta, float16 vA_for_task0[10000],
                float16 vu1_for_task0[25], float16 ve1_for_task0[25],
                float16 vu2_for_task0[25], float16 ve2_for_task0[25],
                float16 vx_for_task1[25], float16 vy_for_task1[25],
                float16 vz_for_task2[25], float8 vw_for_task3[50]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float A_ori[400][400] = {0};
  float A_new_before_trans_0[400 * 400] = {0};
  float A_new_0[400 * 400] = {0};
  float u1_ori[400] = {0};
  float u1_new_before_trans_0[400] = {0};
  float u1_new_0[400] = {0};
  float e1_ori[400] = {0};
  float e1_new_before_trans_0[400] = {0};
  float e1_new_0[400] = {0};
  float u2_ori[400] = {0};
  float u2_new_before_trans_0[400] = {0};
  float u2_new_0[400] = {0};
  float e2_ori[400] = {0};
  float e2_new_before_trans_0[400] = {0};
  float e2_new_0[400] = {0};
  float w_ori[400] = {0};
  float w_new_before_trans_0[400] = {0};
  float w_new_0[400] = {0};
  float x_ori[400] = {0};
  float x_new_before_trans_0[400] = {0};
  float x_new_0[400] = {0};
  float y_ori[400] = {0};
  float y_new_before_trans_0[400] = {0};
  float y_new_0[400] = {0};
  float z_ori[400] = {0};
  float z_new_before_trans_0[400] = {0};
  float z_new_0[400] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 400; i0++) {
    for (int i1 = 0; i1 < 400; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 400 + i1 * 1] = val;
      A_new_0[i0 * 400 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 25; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 40; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 40 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          A_new_0[memIndex] = A_new_before_trans_0[d0 * 400 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    u1_ori[i0] = val;
    u1_new_before_trans_0[i0 * 1] = val;
    u1_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    e1_ori[i0] = val;
    e1_new_before_trans_0[i0 * 1] = val;
    e1_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      e1_new_0[memIndex] = e1_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    u2_ori[i0] = val;
    u2_new_before_trans_0[i0 * 1] = val;
    u2_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    e2_ori[i0] = val;
    e2_new_before_trans_0[i0 * 1] = val;
    e2_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    w_ori[i0] = val;
    w_new_before_trans_0[i0 * 1] = val;
    w_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 10; d0_0++) {
    for (int d0_1 = 0; d0_1 < 40; d0_1++) {
      int d0 = d0_0 * 40 + d0_1;
      w_new_0[memIndex] = w_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    x_ori[i0] = val;
    x_new_before_trans_0[i0 * 1] = val;
    x_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      x_new_0[memIndex] = x_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    y_ori[i0] = val;
    y_new_before_trans_0[i0 * 1] = val;
    y_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    z_ori[i0] = val;
    z_new_before_trans_0[i0 * 1] = val;
    z_new_0[i0 * 1] = val;
  }
  kernel_gemver(alpha_ori, beta_ori, A_ori, u1_ori, e1_ori, u2_ori, e2_ori,
                w_ori, x_ori, y_ori, z_ori);
  kernel_nlp(alpha_new, beta_new, (float16 *)A_new_0, (float16 *)u1_new_0,
             (float16 *)e1_new_0, (float16 *)u2_new_0, (float16 *)e2_new_0,
             (float16 *)x_new_0, (float16 *)y_new_0, (float16 *)z_new_0,
             (float8 *)w_new_0);
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 25; d1_0++) {
    for (int d0_0 = 0; d0_0 < 10; d0_0++) {
      for (int d0_1 = 0; d0_1 < 40; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 40 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          A_new_before_trans_0[d0 * 400 + d1 * 1] = A_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    for (int i1 = 0; i1 < 400; i1++) {
      if (abs(A_ori[i0][i1] - A_new_before_trans_0[i0 * 400 + i1 * 1]) >
          0.0001) {
        printf("Error in A... %d  %d %f %f\n", i0, i1, A_ori[i0][i1],
               A_new_before_trans_0[i0 * 400 + i1 * 1]);
        return 1;
      }
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 10; d0_0++) {
    for (int d0_1 = 0; d0_1 < 40; d0_1++) {
      int d0 = d0_0 * 40 + d0_1;
      w_new_before_trans_0[d0 * 1] = w_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    if (abs(w_ori[i0] - w_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in w... %d %f %f\n", i0, w_ori[i0],
             w_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      x_new_before_trans_0[d0 * 1] = x_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    if (abs(x_ori[i0] - x_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in x... %d %f %f\n", i0, x_ori[i0],
             x_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
