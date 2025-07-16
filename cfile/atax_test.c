


void kernel_atax(float A1[195][410], float A2[195][410],float x[410],float y[410],float tmp1[195],float tmp2[195])
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
        tmp1[i] = tmp1[i] + A1[i][j] * x[j];
      }
    }
    for (i = 0; i < 195; i++) {
      for (j = 0; j < 410; j++) {
        tmp2[i] = tmp2[i] + A2[i][j] * x[j];
      }
    }
    
    for (j = 0; j < 410; j++) {
      y[j] = 0.0;
    }

    for (i = 0; i < 195; i++) {
      for (j = 0; j < 410; j++) {
        y[j] = y[j] + A1[i][j] * tmp1[i];
      }
    }
    for (i = 0; i < 195; i++) {
      for (j = 0; j < 410; j++) {
        y[j] = y[j] + A2[i][j] * tmp2[i];
      }
    }
}
