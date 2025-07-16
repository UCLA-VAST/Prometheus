


void kernel_seidel_2d(int tsteps,int n,float A[2000][2000])
{
  int t;
  int i;
  int j;
{
    
    
    
    for (t = 0; t <= 500 - 1; t++) {
      
      
      
      for (i = 1; i <= 2000 - 2; i++) {
        
        for (j = 1; j <= 2000 - 2; j++) {
          A[i][j] = (A[i - 1][j - 1] + A[i - 1][j] + A[i - 1][j + 1] + A[i][j - 1] + A[i][j] + A[i][j + 1] + A[i + 1][j - 1] + A[i + 1][j] + A[i + 1][j + 1]) / 9.0;
        }
      }
    }
  }
}
