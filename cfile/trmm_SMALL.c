


void kernel_trmm(int m,int n,float alpha,float A[60][60],float B[60][80])
{
  int i;
  int j;
  int k;

    
    
    
    for (i = 0; i < 60; i++) {
      for (j = 0; j < 80; j++) {
        for (k = i + 1; k < 60; k++) {
          B[i][j] += A[k][i] * B[k][j];
        }
      }
    }
    for (i = 0; i < 60; i++) {
      for (j = 0; j < 80; j++) {
        B[i][j] = alpha * B[i][j];
      }
    }
}
