


void kernel_heat_3d(int tsteps,int n,float A[20][20][20],float B[20][20][20])
{
  int t;
  int i;
  int j;
  int k;
{
    
    
    
    for (t = 1; t <= 40; t++) {
      
      
      for (i = 1; i < 20 - 1; i++) {
        
        
        for (j = 1; j < 20 - 1; j++) {
          for (k = 1; k < 20 - 1; k++) {
            B[i][j][k] = 0.125 * (A[i + 1][j][k] - 2.0 * A[i][j][k] + A[i - 1][j][k]) + 0.125 * (A[i][j + 1][k] - 2.0 * A[i][j][k] + A[i][j - 1][k]) + 0.125 * (A[i][j][k + 1] - 2.0 * A[i][j][k] + A[i][j][k - 1]) + A[i][j][k];
          }
        }
      }
      
      
      for (i = 1; i < 20 - 1; i++) {
        
        
        for (j = 1; j < 20 - 1; j++) {
          for (k = 1; k < 20 - 1; k++) {
            A[i][j][k] = 0.125 * (B[i + 1][j][k] - 2.0 * B[i][j][k] + B[i - 1][j][k]) + 0.125 * (B[i][j + 1][k] - 2.0 * B[i][j][k] + B[i][j - 1][k]) + 0.125 * (B[i][j][k + 1] - 2.0 * B[i][j][k] + B[i][j][k - 1]) + B[i][j][k];
          }
        }
      }
    }
  }
}
