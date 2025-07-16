


void kernel_3mm(float E[1600][1800],float A[1600][2000],float B[2000][1800],float F[1800][2200],float C[1800][2400],float D[2400][2200],float G[1600][2200])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 1800; j++) {
        E[i][j] = 0.0;
      }
    }
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 1800; j++) {
        for (k = 0; k < 2000; ++k) {
          E[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 1800; i++) {
      for (j = 0; j < 2200; j++) {
        F[i][j] = 0.0;
      }
    }
    for (i = 0; i < 1800; i++) {
      for (j = 0; j < 2200; j++) {
        for (k = 0; k < 2400; ++k) {
          F[i][j] += C[i][k] * D[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 2200; j++) {
        G[i][j] = 0.0;
      }
    }
    for (i = 0; i < 1600; i++) {
      for (j = 0; j < 2200; j++) {
        for (k = 0; k < 1800; ++k) {
          G[i][j] += E[i][k] * F[k][j];
        }
      }
    }
  }
}
