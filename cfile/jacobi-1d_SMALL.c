


void kernel_jacobi_1d(int tsteps,int n,float A[120],float B[120])
{
  int t;
  int i;
{
    
    
    
    for (t = 0; t < 40; t++) {
      
      for (i = 1; i < 120 - 1; i++) {
        B[i] = 0.33333 * (A[i - 1] + A[i] + A[i + 1]);
      }
      
      for (i = 1; i < 120 - 1; i++) {
        A[i] = 0.33333 * (B[i - 1] + B[i] + B[i + 1]);
      }
    }
  }
}
