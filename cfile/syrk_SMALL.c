


void kernel_syrk(int n,int m,float alpha,float beta,float C[80][80],float A[80][60])
{
  int i;
  int j;
  int k;
//BLAS PARAMS
//TRANS = 'N'
//UPLO  = 'L'
// =>  Form  C := alpha*A*A**T + beta*C.
//A is NxM
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
          C[i][j] += alpha * A[i][k] * A[j][k];
        }
      }
    }
  }
}
