


void kernel_atax(float B1[195][410], float B2[195][410],float A11[195][410], float A21[195][410],float A12[195][410], float A22[195][410],float x[410], float y1[205], float y2[205],float tmp1[195],float tmp2[195])
{
  int i;
  int j;

    for (i = 0; i < 195; i++) {
      tmp1[i] = 0.0;
    }
    for (i = 0; i < 195; i++) {
      tmp2[i] = 0.0;
    }


    for (i = 0; i < 195; i++) {
      for (j = 0; j < 410; j++) {
        tmp1[i] = tmp1[i] + B1[i][j] * x[j];
      }
    }
    for (i = 0; i < 195; i++) {
      for (j = 0; j < 410; j++) {
        tmp2[i] = tmp2[i] + B2[i][j] * x[j];
      }
    }
    
    for (j = 0; j < 205; j++) {
      y1[j] = 0.0;
    }
    for (j = 0; j < 205; j++) {
      y2[j] = 0.0;
    }

    for (i = 0; i < 195; i++) {
      for (j = 0; j < 205; j++) {
        y1[j] = y1[j] + A11[i][j] * tmp1[i];
      }
    }
    for (i = 0; i < 195; i++) {
      for (j = 0; j < 205; j++) {
        y2[j] = y2[j] + A12[i][j] * tmp1[i];
      }
    }
    for (i = 0; i < 195; i++) {
      for (j = 0; j < 205; j++) {
        y1[j] = y1[j] + A21[i][j] * tmp2[i];
      }
    }
    for (i = 0; i < 195; i++) {
      for (j = 0; j < 205; j++) {
        y2[j] = y2[j] + A22[i][j] * tmp2[i];
      }
    }
}
