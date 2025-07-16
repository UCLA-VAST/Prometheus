


void kernel_floyd_warshall(int n,int path[500][500])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (k = 0; k < 500; k++) {
      
      
      
      for (i = 0; i < 500; i++) {
        
        for (j = 0; j < 500; j++) {
          path[i][j] = (path[i][j] < path[i][k] + path[k][j]?path[i][j] : path[i][k] + path[k][j]);
        }
      }
    }
  }
}
