


void kernel_2mm(int ni,int nj,int nk,int nl,float alpha,float beta,float tmp[40][50],float A[40][70],float B[70][50],float C[50][80],float D[40][80])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 50; j++) {
        tmp[i][j] = 0.0;
      }
    }
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 50; j++) {
        for (k = 0; k < 70; ++k) {
          tmp[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 80; j++) {
        D[i][j] *= beta;
      }
    }
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 80; j++) {
        for (k = 0; k < 50; ++k) {
          D[i][j] += tmp[i][k] * C[k][j];
        }
      }
    }
  }
}
