


void kernel_doitgen(int nr,int nq,int np,float A[50][40][60],float C4[60][60],float sum[50][40][60])
{
  int r;
  int q;
  int p;
  int s;
{
    
    
    
    for (r = 0; r < 50; r++) {
      
      
      
      for (q = 0; q < 40; q++) {
        
        
        
        for (p = 0; p < 60; p++) {
          sum[r][q][p] = 0.0;
          
          for (s = 0; s < 60; s++) {
            sum[r][q][p] += A[r][q][s] * C4[s][p];
          }
        }
      }
    }
    for (r = 0; r < 50; r++) {
      for (q = 0; q < 40; q++) {
        for (p = 0; p < 60; p++) {
          A[r][q][p] = sum[r][q][p];
        }
      }
    }
  }
}
