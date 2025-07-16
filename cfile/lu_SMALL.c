


void kernel_lu(int n,float A[120][120])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 120; i++) {
      
      for (j = 0; j < i; j++) {
        for (k = 0; k < j; k++) {
          A[i][j] -= A[i][k] * A[k][j];
        }
        A[i][j] /= A[j][j];
      }
      
      for (j = i; j < 120; j++) {
        for (k = 0; k < i; k++) {
          A[i][j] -= A[i][k] * A[k][j];
        }
      }
    }
  }
}
