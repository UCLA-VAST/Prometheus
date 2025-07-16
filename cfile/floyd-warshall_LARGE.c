


void kernel_floyd_warshall(int n,int path[2800][2800])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (k = 0; k < 2800; k++) {
      
      
      
      for (i = 0; i < 2800; i++) {
        
        for (j = 0; j < 2800; j++) {
          path[i][j] = (path[i][j] < path[i][k] + path[k][j]?path[i][j] : path[i][k] + path[k][j]);
        }
      }
    }
  }
}
