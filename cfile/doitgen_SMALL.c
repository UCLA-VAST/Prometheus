


void kernel_doitgen(int nr,int nq,int np,float A[25][20][30],float C4[30][30],float sum[30])
{
  int r;
  int q;
  int p;
  int s;
{
    
    
    for (r = 0; r < 25; r++) {
      
      
      for (q = 0; q < 20; q++) {
        
        
        for (p = 0; p < 30; p++) {
          sum[p] = 0.0;
          for (s = 0; s < 30; s++) {
            sum[p] += A[r][q][s] * C4[s][p];
          }
        }
        for (p = 0; p < 30; p++) {
          A[r][q][p] = sum[p];
        }
      }
    }
  }
}
