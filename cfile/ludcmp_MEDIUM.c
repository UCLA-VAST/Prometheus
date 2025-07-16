


void kernel_ludcmp(int n,float A[400][400],float b[400],float x[400],float y[400])
{
  int i;
  int j;
  int k;
  float w;
{
    
    
    
    for (i = 0; i < 400; i++) {
      
      for (j = 0; j < i; j++) {
        w = A[i][j];
        for (k = 0; k < j; k++) {
          w -= A[i][k] * A[k][j];
        }
        A[i][j] = w / A[j][j];
      }
      
      for (j = i; j < 400; j++) {
        w = A[i][j];
        for (k = 0; k < i; k++) {
          w -= A[i][k] * A[k][j];
        }
        A[i][j] = w;
      }
    }
    
    
    
    for (i = 0; i < 400; i++) {
      w = b[i];
      for (j = 0; j < i; j++) {
        w -= A[i][j] * y[j];
      }
      y[i] = w;
    }
    
    
    
    for (i = 0; i <= 399; i++) {
      int _in_i = 399 + -1 * i;
      w = y[_in_i];
      for (j = _in_i + 1; j < 400; j++) {
        w -= A[_in_i][j] * x[j];
      }
      x[_in_i] = w / A[_in_i][_in_i];
    }
    i = 0 + -1;
  }
}
