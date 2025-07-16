


void kernel_syrk(int n,int m,float alpha,float beta,float C[1200][1200],float A[1200][1000])
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
    
    
    
    for (i = 0; i < 1200; i++) {
      for (j = 0; j <= i; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 1200; i++) { 
      for (k = 0; k < 1000; k++) {
        for (j = 0; j <= i; j++) {
          C[i][j] += alpha * A[i][k] * A[j][k];
        }
      }
    }
  }
}
