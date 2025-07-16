


void kernel_trmm(float alpha,float A[200][200],float B[200][240],float C[200][240])
{
  int i;
  int j;
  int k;

    
    
    for (i = 0; i < 200; i++) {
      for (j = 0; j < 240; j++) {
        for (k = i + 1; k < 200; k++) {
          B[i][j] += A[k][i] * C[k][j];
        }
      }
    }
    for (i = 0; i < 200; i++) {
      for (j = 0; j < 240; j++) {
        B[i][j] *= alpha;
      }
    }
}
