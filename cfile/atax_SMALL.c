


void kernel_atax(int m,int n,float A[116][124],float x[124],float y[124],float tmp[116])
{
  int i;
  int j;
{
    
    for (i = 0; i < 124; i++) {
      y[i] = ((float )0);
    }
    
    
    
    for (i = 0; i < 116; i++) {
      tmp[i] = 0.0;
      
    }
    for (i = 0; i < 116; i++) {
      for (j = 0; j < 124; j++) {
        tmp[i] = tmp[i] + A[i][j] * x[j];
      }
    }
    for (i = 0; i < 116; i++) {
      for (j = 0; j < 124; j++) {
        y[j] = y[j] + A[i][j] * tmp[i];
      }
    }
  }
}
