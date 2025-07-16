


void kernel_gemm(float alpha,float beta,float C[2000][2300],float A[2000][2600],float B[2600][2300])
{
  int i;
  int j;
  int k;

{
    
    
    
    for (i = 0; i < 2000; i++) {
      for (j = 0; j < 2300; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 2000; i++) {
      for (k = 0; k < 2600; k++) {    
        for (j = 0; j < 2300; j++) {
          C[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
  }
}
