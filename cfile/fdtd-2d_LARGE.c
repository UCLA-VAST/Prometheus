


void kernel_fdtd_2d(int tmax,int nx,int ny,float ex[1000][1200],float ey[1000][1200],float hz[1000][1200],float _fict_[500])
{
  int t;
  int i;
  int j;
{
    
    
    
    for (t = 0; t < 500; t++) {
      
      for (j = 0; j < 1200; j++) {
        ey[0][j] = _fict_[t];
      }
      
      
      
      for (i = 1; i < 1000; i++) {
        
        for (j = 0; j < 1200; j++) {
          ey[i][j] = ey[i][j] - 0.5 * (hz[i][j] - hz[i - 1][j]);
        }
      }
      
      
      
      for (i = 0; i < 1000; i++) {
        
        for (j = 1; j < 1200; j++) {
          ex[i][j] = ex[i][j] - 0.5 * (hz[i][j] - hz[i][j - 1]);
        }
      }
      
      
      
      for (i = 0; i < 1000 - 1; i++) {
        
        for (j = 0; j < 1200 - 1; j++) {
          hz[i][j] = hz[i][j] - 0.7 * (ex[i][j + 1] - ex[i][j] + ey[i + 1][j] - ey[i][j]);
        }
      }
    }
  }
}
