


void kernel_syr2k(float alpha,float beta,float C[240][240],float A1[240][200],float B1[240][200],float A2[240][200],float B2[240][200])
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
    
    
    
    for (i = 0; i < 240; i++) {
      for (j = 0; j <= i; j++) {
        C[i][j] *= beta;
      }
    }
    for (i = 0; i < 240; i++) { 
      for (k = 0; k < 200; k++) {
        for (j = 0; j <= i; j++) {
          C[i][j] += A1[j][k] * alpha * B1[i][k] + B2[j][k] * alpha * A2[i][k];
        }
      }
    }
  }
}
