


void kernel_lu(int n,float A[2000][2000])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 2000; i++) {
      
      for (j = 0; j < i; j++) {
        for (k = 0; k < j; k++) {
          A[i][j] -= A[i][k] * A[k][j];
        }
        A[i][j] /= A[j][j];
      }
      
      for (j = i; j < 2000; j++) {
        for (k = 0; k < i; k++) {
          A[i][j] -= A[i][k] * A[k][j];
        }
      }
    }
  }
}
