


void kernel_2mm(float alpha,float beta,float tmp[800][900],float A[800][1100],float B[1100][900],float C[900][1200],float D[800][1200])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 900; j++) {
        tmp[i][j] = 0.0;
      }
    }
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 900; j++) {
        for (k = 0; k < 1100; ++k) {
          tmp[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 1200; j++) {
        D[i][j] *= beta;
      }
    }
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 1200; j++) {
        for (k = 0; k < 900; ++k) {
          D[i][j] += tmp[i][k] * C[k][j];
        }
      }
    }
  }
}
