


void kernel_3mm(int ni,int nj,int nk,int nl,int nm,float E[40][50],float A[40][60],float B[60][50],float F[50][70],float C[50][80],float D[80][70],float G[40][70])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 50; j++) {
        E[i][j] = 0.0;
      }
    }
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 50; j++) {
        for (k = 0; k < 60; ++k) {
          E[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 50; i++) {
      for (j = 0; j < 70; j++) {
        F[i][j] = 0.0;
      }
    }
    for (i = 0; i < 50; i++) {
      for (j = 0; j < 70; j++) {
        for (k = 0; k < 80; ++k) {
          F[i][j] += C[i][k] * D[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 70; j++) {
        G[i][j] = 0.0;
      }
    }
    for (i = 0; i < 40; i++) {
      for (j = 0; j < 70; j++) {
        for (k = 0; k < 50; ++k) {
          G[i][j] += E[i][k] * F[k][j];
        }
      }
    }
  }
}
