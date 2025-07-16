


void kernel_trisolv(int n,float L[120][120],float x[120],float b[120])
{
  int i;
  int j;
    
    
    
    for (i = 0; i < 120; i++) {
      x[i] = b[i];
    }
    for (i = 0; i < 120; i++) {
      for (j = 0; j < i; j++) {
        x[i] -= L[i][j] * x[j];
      }
    }
    for (i = 0; i < 120; i++) {
      x[i] = x[i] / L[i][i];
    }
}
