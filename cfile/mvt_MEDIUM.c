


void kernel_mvt(float x1[400],float x2[400],float B[400],float C[400],float A1[400][400],float A2[400][400])
{
  int i;
  int j;
{
    
    
    
    for (i = 0; i < 400; i++) {
      
      for (j = 0; j < 400; j++) {
        x1[i] += A1[i][j] * B[j];
      }
    }
    
    
    
    for (i = 0; i < 400; i++) {
      
      for (j = 0; j < 400; j++) {
        x2[i] += A2[j][i] * C[j];
      }
    }
  }
}
