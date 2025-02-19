#include "output_2.h"

void kernel_mvt(float x1[400], float x2[400], float B[400], float C[400],
                float A1[400][400], float A2[400][400]) {
  int i;
  int j;
  {

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        x1[i] += A1[i][j] * B[j];
      }
    }

    for (i = 0; i < 400; i++) {

      for (j = 0; j < 400; j++) {
        x2[i] += A2[j][i] * C[j];
      }
    }
  }
}

void kernel_nlp(float4 vx1_for_task0[100], float16 vA1_for_task0[10000],
                float16 vB_for_task0[25], float16 vx2_for_task1[25],
                float16 vA2_for_task1[10000], float16 vC_for_task1[25]);

int main() {
  printf("Starting C-simulation...\n");
  float x1_ori[400] = {0};
  float x1_new_before_trans_0[400] = {0};
  float x1_new_0[400] = {0};
  float x2_ori[400] = {0};
  float x2_new_before_trans_0[400] = {0};
  float x2_new_0[400] = {0};
  float B_ori[400] = {0};
  float B_new_before_trans_0[400] = {0};
  float B_new_0[400] = {0};
  float C_ori[400] = {0};
  float C_new_before_trans_0[400] = {0};
  float C_new_0[400] = {0};
  float A1_ori[400][400] = {0};
  float A1_new_before_trans_0[400 * 400] = {0};
  float A1_new_0[400 * 400] = {0};
  float A2_ori[400][400] = {0};
  float A2_new_before_trans_0[400 * 400] = {0};
  float A2_new_0[400 * 400] = {0};
  int memIndex = 0;
  float val;
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    x1_ori[i0] = val;
    x1_new_before_trans_0[i0 * 1] = val;
    x1_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      int d0 = d0_0 * 4 + d0_1;
      x1_new_0[memIndex] = x1_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    x2_ori[i0] = val;
    x2_new_before_trans_0[i0 * 1] = val;
    x2_new_0[i0 * 1] = val;
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd0_1']
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      x2_new_0[memIndex] = x2_new_before_trans_0[d0 * 1];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    B_ori[i0] = val;
    B_new_before_trans_0[i0 * 1] = val;
    B_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    val = ((float)rand() / RAND_MAX);
    C_ori[i0] = val;
    C_new_before_trans_0[i0 * 1] = val;
    C_new_0[i0 * 1] = val;
  }
  for (int i0 = 0; i0 < 400; i0++) {
    for (int i1 = 0; i1 < 400; i1++) {
      val = ((float)rand() / RAND_MAX);
      A1_ori[i0][i1] = val;
      A1_new_before_trans_0[i0 * 400 + i1 * 1] = val;
      A1_new_0[i0 * 400 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d0_0', 'd1_0', 'd0_1', 'd1_1']
  for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      for (int d1 = 0; d1 < 400; d1++) {
        int d0 = d0_0 * 4 + d0_1;
        A1_new_0[memIndex] = A1_new_before_trans_0[d0 * 400 + d1 * 1];
        memIndex++;
      }
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    for (int i1 = 0; i1 < 400; i1++) {
      val = ((float)rand() / RAND_MAX);
      A2_ori[i0][i1] = val;
      A2_new_before_trans_0[i0 * 400 + i1 * 1] = val;
      A2_new_0[i0 * 400 + i1 * 1] = val;
    }
  }
  // if padding we need to change data order
  memIndex = 0;
  //['d1_0', 'd0_0', 'd0_1', 'd1_1']
  for (int d1_0 = 0; d1_0 < 25; d1_0++) {
    for (int d0_0 = 0; d0_0 < 8; d0_0++) {
      for (int d0_1 = 0; d0_1 < 50; d0_1++) {
        for (int d1_1 = 0; d1_1 < 16; d1_1++) {
          int d0 = d0_0 * 50 + d0_1;
          int d1 = d1_0 * 16 + d1_1;
          A2_new_0[memIndex] = A2_new_before_trans_0[d0 * 400 + d1 * 1];
          memIndex++;
        }
      }
    }
  }
  kernel_mvt(x1_ori, x2_ori, B_ori, C_ori, A1_ori, A2_ori);
  kernel_nlp((float4 *)x1_new_0, (float16 *)A1_new_0, (float16 *)B_new_0,
             (float16 *)x2_new_0, (float16 *)A2_new_0, (float16 *)C_new_0);
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 100; d0_0++) {
    for (int d0_1 = 0; d0_1 < 4; d0_1++) {
      int d0 = d0_0 * 4 + d0_1;
      x1_new_before_trans_0[d0 * 1] = x1_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    if (abs(x1_ori[i0] - x1_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in x1... %d %f %f\n", i0, x1_ori[i0],
             x1_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  memIndex = 0;
  for (int d0_0 = 0; d0_0 < 25; d0_0++) {
    for (int d0_1 = 0; d0_1 < 16; d0_1++) {
      int d0 = d0_0 * 16 + d0_1;
      x2_new_before_trans_0[d0 * 1] = x2_new_0[memIndex];
      memIndex++;
    }
  }
  for (int i0 = 0; i0 < 400; i0++) {
    if (abs(x2_ori[i0] - x2_new_before_trans_0[i0 * 1]) > 0.0001) {
      printf("Error in x2... %d %f %f\n", i0, x2_ori[i0],
             x2_new_before_trans_0[i0 * 1]);
      return 1;
    }
  }
  printf("C-simulation passed!\n");
  return 0;
}
