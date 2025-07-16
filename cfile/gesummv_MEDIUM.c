


void kernel_gesummv(float alpha,float beta,float A[250][250],float B[250][250],float tmp[250],float w[250],float r[250],float y[250])
{
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
