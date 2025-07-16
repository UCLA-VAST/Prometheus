


void kernel_gemver(int n,float alpha,float beta,float A[2000][2000],float u1[2000],float v1[2000],float u2[2000],float v2[2000],float w[2000],float x[2000],float y[2000],float z[2000])
{
  int i;
  int j;
{
    
    

    for (i = 0; i < 2000; i++) {
      
      for (j = 0; j < 2000; j++) {
        A[i][j] = A[i][j] + u1[i] * v1[j] + u2[i] * v2[j];
      }
    }
    
    
    
    for (i = 0; i < 2000; i++) {
      
      for (j = 0; j < 2000; j++) {
        x[i] = x[i] + beta * A[j][i] * y[j];
      }
    }
    
    for (i = 0; i < 2000; i++) {
      x[i] = x[i] + z[i];
    }
    
    
    
    for (i = 0; i < 2000; i++) {
      
      for (j = 0; j < 2000; j++) {
        w[i] = w[i] + alpha * A[i][j] * x[j];
      }
    }
  }

}
