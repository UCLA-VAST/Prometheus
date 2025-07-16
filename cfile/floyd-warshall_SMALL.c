


void kernel_floyd_warshall(int n,int path[180][180])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (k = 0; k < 180; k++) {
      
      
      
      for (i = 0; i < 180; i++) {
        
        for (j = 0; j < 180; j++) {
          path[i][j] = (path[i][j] < path[i][k] + path[k][j]?path[i][j] : path[i][k] + path[k][j]);
        }
      }
    }
  }
}
