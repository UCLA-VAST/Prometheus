#include "output_2.h"

void kernel_gesummv(float alpha, float beta, float A[250][250],
                    float B[250][250], float tmp[250], float w[250],
                    float r[250], float y[250]) {
  int i;
  int j;
  {

    for (i = 0; i < 250; i++) {
      tmp[i] = 0.0;
    }

    for (i = 0; i < 250; i++) {
      for (j = 0; j < 250; j++) {
        tmp[i] += A[i][j] * w[j];
      }
    }
    for (i = 0; i < 250; i++) {
      y[i] = 0.0;
    }
    for (i = 0; i < 250; i++) {
      for (j = 0; j < 250; j++) {
        y[i] += B[i][j] * r[j];
      }
    }
    for (i = 0; i < 250; i++) {
      y[i] = y[i] * beta + alpha * tmp[i];
    }
  }
}

void kernel_nlp(float alpha, float beta, float1 vtmp_for_task1[250],
                float16 vA_for_task1[4000], float16 vw_for_task1[16],
                float1 vy_for_task3[250], float16 vB_for_task3[4000],
                float16 vr_for_task3[16]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float beta_ori = {0};
  float beta_new = {0};
  float A_ori[250][250] = {0};
  float A_new_before_trans_0[250 * 256] = {0};
  float A_new_0[250 * 256] = {0};
  float B_ori[250][250] = {0};
  float B_new_before_trans_0[250 * 256] = {0};
  float B_new_0[250 * 256] = {0};
  float tmp_ori[250] = {0};
  float tmp_new_before_trans_0[250] = {0};
  float tmp_new_0[250] = {0};
  float w_ori[250] = {0};
  float w_new_before_trans_0[256] = {0};
  float w_new_0[256] = {0};
  float r_ori[250] = {0};
  float r_new_before_trans_0[256] = {0};
  float r_new_0[256] = {0};
  float y_ori[250] = {0};
  float y_new_before_trans_0[250] = {0};
  float y_new_0[250] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  val = ((float)rand() / RAND_MAX);
  beta_ori = val;
  beta_new = val;
  for (int i0 = 0; i0 < 250; i0++) {
    for (int i1 = 0; i1 < 250; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 256 + i1 * 1] = val;
      A_new_0[i0 * 256 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      for (int d1 = 0; d1 < 256; d1++) {
        int d0 = d0_0 * 5 + d0_1;
        A_new_0[memIndex] = A_new_before_trans_0[d0 * 256 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    for (int i1 = 0; i1 < 250; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 256 + i1 * 1] = val;
      B_new_0[i0 * 256 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      for (int d1 = 0; d1 < 256; d1++) {
        int d0 = d0_0 * 5 + d0_1;
        B_new_0[memIndex] = B_new_before_trans_0[d0 * 256 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    tmp_ori[i0] = val;
    tmp_new_before_trans_0[i0 * 1] = val;
    tmp_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      tmp_new_0[memIndex] = tmp_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    w_ori[i0] = val;
    w_new_before_trans_0[i0 * 1] = val;
    w_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    r_ori[i0] = val;
    r_new_before_trans_0[i0 * 1] = val;
    r_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 250; i0++) {
    val = ((float)rand() / RAND_MAX);
    y_ori[i0] = val;
    y_new_before_trans_0[i0 * 1] = val;
    y_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      y_new_0[memIndex] = y_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  kernel_gesummv(alpha_ori, beta_ori, A_ori, B_ori, tmp_ori, w_ori, r_ori,
                 y_ori);
  kernel_nlp(alpha_new, beta_new, (float1 *)tmp_new_0, (float16 *)A_new_0,
             (float16 *)w_new_0, (float1 *)y_new_0, (float16 *)B_new_0,
             (float16 *)r_new_0);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      tmp_new_before_trans_0[d0 * 1] = tmp_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    if (abs(tmp_ori[i0] - tmp_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in tmp... %d %f %f\n", i0, tmp_ori[i0],
             tmp_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 50; d0_0++) {
    for (int d0_1 = 0; d0_1 < 5; d0_1++) {
      int d0 = d0_0 * 5 + d0_1;
      y_new_before_trans_0[d0 * 1] = y_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 250; i0++) {
    if (abs(y_ori[i0] - y_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in y... %d %f %f\n", i0, y_ori[i0],
             y_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
