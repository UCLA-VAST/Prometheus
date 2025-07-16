


void kernel_2mm(float alpha,float beta,float tmp[1600][1800],float A[1600][2200],float B[2200][1800],float C[1800][2400],float D[1600][2400])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 1800; j++) {
        tmp[i][j] = 0.0;
      }
    }
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 1800; j++) {
        for (k = 0; k < 2200; ++k) {
          tmp[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 2400; j++) {
        D[i][j] *= beta;
      }
    }
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 2400; j++) {
        for (k = 0; k < 1800; ++k) {
          D[i][j] += tmp[i][k] * C[k][j];
        }
      }
    }
  }
}
