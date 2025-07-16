


void kernel_gemm(int ni,int nj,int nk,float alpha,float beta,float C[60][70],float A[60][80],float B[80][70])
{
  int i;
  int j;
  int k;

{
    
    
    
    for (i = 0; i < 60; i++) {
      for (j = 0; j < 70; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 60; i++) {
      for (k = 0; k < 80; k++) {
        for (j = 0; j < 70; j++) {
          C[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
  }
}
