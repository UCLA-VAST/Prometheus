


void kernel_mvt(int n,float x1[2000],float x2[2000],float y_1[2000],float y_2[2000],float A[2000][2000])
{
  int i;
  int j;
{
    
    
    
    for (i = 0; i < 2000; i++) {
      
      for (j = 0; j < 2000; j++) {
        x1[i] = x1[i] + A[i][j] * y_1[j];
      }
    }
    
    
    
    for (i = 0; i < 2000; i++) {
      
      for (j = 0; j < 2000; j++) {
        x2[i] = x2[i] + A[j][i] * y_2[j];
      }
    }
  }
}
