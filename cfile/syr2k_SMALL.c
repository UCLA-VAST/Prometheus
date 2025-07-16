


void kernel_syr2k(int n,int m,float alpha,float beta,float C[80][80],float A[80][60],float B[80][60])
{
  int i;
  int j;
  int k;
//BLAS PARAMS
//UPLO  = 'L'
//TRANS = 'N'
//A is NxM
//B is NxM
//C is NxN
{
    
    
    
    for (i = 0; i < 80; i++) {
      for (j = 0; j <= i; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 80; i++) { 
      for (k = 0; k < 60; k++) {
        for (j = 0; j <= i; j++) {
          C[i][j] += A[j][k] * alpha * B[i][k] + B[j][k] * alpha * A[i][k];
        }
      }
    }
  }
}
