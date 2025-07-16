


void kernel_syr2k(int n,int m,float alpha,float beta,float C[1200][1200],float A[1200][1000],float B[1200][1000])
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
    
    
    
    for (i = 0; i < 1200; i++) {
      for (j = 0; j <= i; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 1200; i++) {  
      for (k = 0; k < 1000; k++) {
        for (j = 0; j <= i; j++) {
          C[i][j] += A[j][k] * alpha * B[i][k] + B[j][k] * alpha * A[i][k];
        }
      }
    }
  }
}
