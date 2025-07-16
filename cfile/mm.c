


void kernel_gemm(float C[1024][1024],float A[1024][1024],float B[1024][1024])
{
  int i;
  int j;
  int k;

{
    
    

    for (i = 0; i < 1024; i++) {
      for (k = 0; k < 1024; k++) {
        for (j = 0; j < 1024; j++) {
          C[i][j] += A[i][k] * B[k][j];
        }
      }
    }
  }
}
