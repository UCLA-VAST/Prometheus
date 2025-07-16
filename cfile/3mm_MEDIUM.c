


void kernel_3mm(float E[180][190],float A[180][200],float B[200][190],float F[190][210],float C[190][220],float D[220][210],float G[180][210])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        E[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        for (k = 0; k < 200; ++k) {
          E[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 190; i++) {
      for (j = 0; j < 210; j++) {
        F[i][j] = 0.0;
      }
    }
    for (i = 0; i < 190; i++) {
      for (j = 0; j < 210; j++) {
        for (k = 0; k < 220; ++k) {
          F[i][j] += C[i][k] * D[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 210; j++) {
        G[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 210; j++) {
        for (k = 0; k < 190; ++k) {
          G[i][j] += E[i][k] * F[k][j];
        }
      }
    }
  }
}
