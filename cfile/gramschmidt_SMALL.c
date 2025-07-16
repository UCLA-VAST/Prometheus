#include <math.h>



void kernel_gramschmidt(int m,int n,float A[60][80],float R[80][80],float Q[60][80])
{
  int i;
  int j;
  int k;
  float nrm;
{
    
    
    
    for (k = 0; k < 80; k++) {
      nrm = 0.0;
      
      for (i = 0; i < 60; i++) {
        nrm += A[i][k] * A[i][k];
      }
      R[k][k] = sqrt(nrm);
      
      for (i = 0; i < 60; i++) {
        Q[i][k] = A[i][k] / R[k][k];
      }
      
      for (j = k + 1; j < 80; j++) {
        R[k][j] = 0.0;
        
        for (i = 0; i < 60; i++) {
          R[k][j] += Q[i][k] * A[i][j];
        }
        
        for (i = 0; i < 60; i++) {
          A[i][j] = A[i][j] - Q[i][k] * R[k][j];
        }
      }
    }
  }
}
