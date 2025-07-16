#include "output_2.h"

void kernel_trmm(float alpha, float A[200][200], float B[200][240],
                 float C[200][240]) {
  int i;
  int j;
  int k;

  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      for (k = i + 1; k < 200; k++) {
        B[i][j] += A[k][i] * C[k][j];
      }
    }
  }
  for (i = 0; i < 200; i++) {
    for (j = 0; j < 240; j++) {
      B[i][j] *= alpha;
    }
  }
}

void kernel_nlp(float alpha, float16 vB_for_task0[3000],
                float16 vA_for_task0[2600], float16 vC_for_task0[3000]);

int main() {
  printf("Starting C-simulation...\n");
  float alpha_ori = {0};
  float alpha_new = {0};
  float A_ori[200][200] = {0};
  float A_new_before_trans_0[200 * 208] = {0};
  float A_new_0[200 * 208] = {0};
  float B_ori[200][240] = {0};
  float B_new_before_trans_0[200 * 240] = {0};
  float B_new_0[200 * 240] = {0};
  float C_ori[200][240] = {0};
  float C_new_before_trans_0[200 * 240] = {0};
  float C_new_0[200 * 240] = {0};
  int memIndex = 0;
  float val;
  val = ((float)rand() / RAND_MAX);
  alpha_ori = val;
  alpha_new = val;
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 200; i1++) {
      val = ((float)rand() / RAND_MAX);
      A_ori[i0][i1] = val;
      A_new_before_trans_0[i0 * 208 + i1 * 1] = val;
      A_new_0[i0 * 208 + i1 * 1] = val;
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      val = ((float)rand() / RAND_MAX);
      B_ori[i0][i1] = val;
      B_new_before_trans_0[i0 * 240 + i1 * 1] = val;
      B_new_0[i0 * 240 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 4; d0_0++) {
      for (int d0_1 = 0; d0_1 < 50; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 50 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B_new_0[memIndex] = B_new_before_trans_0[d0 * 240 + d1 * 1];
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
    for (int d0_0 = 0; d0_0 < 40; d0_0++) {
      for (int d0_1 = 0; d0_1 < 5; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 5 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          C_new_0[memIndex] = C_new_before_trans_0[d0 * 240 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  kernel_trmm(alpha_ori, A_ori, B_ori, C_ori);
  kernel_nlp(alpha_new, (float16 *)B_new_0, (float16 *)A_new_0,
             (float16 *)C_new_0);
  memIndex = 0;
  for (int d1_0 = 0; d1_0 < 15; d1_0++) {
    for (int d0_0 = 0; d0_0 < 4; d0_0++) {
      for (int d0_1 = 0; d0_1 < 50; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 50 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          B_new_before_trans_0[d0 * 240 + d1 * 1] = B_new_0[memIndex];
          memIndex++;
        }
      }
    }
  }
  for (int i0 = 0; i0 < 200; i0++) {
    for (int i1 = 0; i1 < 240; i1++) {
      if (abs(B_ori[i0][i1] - B_new_before_trans_0[i0 * 240 + i1 * 1]) >
          0.0001) {
        printf("Error in B... %d  %d %f %f\n", i0, i1, B_ori[i0][i1],
               B_new_before_trans_0[i0 * 240 + i1 * 1]);
        return 1;
      }
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
