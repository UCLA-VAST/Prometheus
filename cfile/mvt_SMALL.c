


void kernel_mvt(int n,float x1[120],float x2[120],float y_1[120],float y_2[120],float A[120][120])
{
  int i;
  int j;
{
    
    
    
    for (i = 0; i < 120; i++) {
      
      for (j = 0; j < 120; j++) {
        x1[i] = x1[i] + A[i][j] * y_1[j];
      }
    }
    
    
    
    for (i = 0; i < 120; i++) {
      
      for (j = 0; j < 120; j++) {
        x2[i] = x2[i] + A[j][i] * y_2[j];
      }
    }
  }
}
