


void kernel_atax(float A[390][410],float x[410],float y[410],float tmp[390])
{
  int i;
  int j;
{

  for (i = 0; i < 390; i++) {
      tmp[i] = 0.0;
    }


    for (i = 0; i < 390; i++) {
      for (j = 0; j < 410; j++) {
        tmp[i] = tmp[i] + A[i][j] * x[j];
      }
    }
    
    for (j = 0; j < 410; j++) {
      y[j] = 0.0;
    }
    
    for (i = 0; i < 390; i++) {
      for (j = 0; j < 410; j++) {
        y[j] = y[j] + A[i][j] * tmp[i];
      }
    }
  }
}
