


void kernel_gemm(float alpha,float beta,float C[200][220],float A[200][240],float B[240][220])
{
  int i;
  int j;
  int k;

{
    
    
    
    for (i = 0; i < 200; i++) {
      for (j = 0; j < 220; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 200; i++) {
      for (k = 0; k < 240; k++) {
        for (j = 0; j < 220; j++) {
          C[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
  }
}
