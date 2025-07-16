


void kernel_2mm(float alpha,float beta,float tmp[180][190],float A[180][210],float B[210][190],float C[190][220],float D[180][220])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        tmp[i][j] = 0.0;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 190; j++) {
        for (k = 0; k < 210; ++k) {
          tmp[i][j] += alpha * A[i][k] * B[k][j];
        }
      }
    }
    
    
    
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 220; j++) {
        D[i][j] *= beta;
      }
    }
    for (i = 0; i < 180; i++) {
      for (j = 0; j < 220; j++) {
        for (k = 0; k < 190; ++k) {
          D[i][j] += tmp[i][k] * C[k][j];
        }
      }
    }
  }
}
