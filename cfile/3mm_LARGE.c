


void kernel_3mm(float E[800][900],float A[800][1000],float B[1000][900],float F[900][1100],float C[900][1200],float D[1200][1100],float G[800][1100])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 900; j++) {
        E[i][j] = 0.0;
      }
    }
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 900; j++) {
        for (k = 0; k < 1000; ++k) {
          E[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 900; i++) {
      for (j = 0; j < 1100; j++) {
        F[i][j] = 0.0;
      }
    }
    for (i = 0; i < 900; i++) {
      for (j = 0; j < 1100; j++) {
        for (k = 0; k < 1200; ++k) {
          F[i][j] += C[i][k] * D[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 1100; j++) {
        G[i][j] = 0.0;
      }
    }
    for (i = 0; i < 800; i++) {
      for (j = 0; j < 1100; j++) {
        for (k = 0; k < 900; ++k) {
          G[i][j] += E[i][k] * F[k][j];
        }
      }
    }
  }
}
