#include <math.h>



void kernel_cholesky(int n,float A[120][120])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (i = 0; i < 120; i++) {
//j<i
      
      for (j = 0; j < i; j++) {
        for (k = 0; k < j; k++) {
          A[i][j] -= A[i][k] * A[j][k];
        }
        A[i][j] /= A[j][j];
      }
// i==j case
      for (k = 0; k < i; k++) {
        A[i][i] -= A[i][k] * A[i][k];
      }
      A[i][i] = sqrt(A[i][i]);
    }
  }
}
