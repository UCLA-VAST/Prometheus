


void kernel_trmm(int m,int n,float alpha,float A[1000][1000],float B[1000][1200])
{
  int i;
  int j;
  int k;

    
    
    
    for (i = 0; i < 1000; i++) {
      for (j = 0; j < 1200; j++) {
        for (k = i + 1; k < 1000; k++) {
          B[i][j] += A[k][i] * B[k][j];
        }
      }
    }
    for (i = 0; i < 1000; i++) {
      for (j = 0; j < 1200; j++) {
        B[i][j] = alpha * B[i][j];
      }
    }
}
