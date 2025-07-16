


void kernel_covariance(int m,int n,float float_n,float data[1400][1200],float cov[1200][1200],float mean[1200])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (j = 0; j < 1200; j++) {
      mean[j] = 0.0;
      
      for (i = 0; i < 1400; i++) {
        mean[j] += data[i][j];
      }
      mean[j] /= float_n;
    }
    
    
    
    for (i = 0; i < 1400; i++) {
      
      for (j = 0; j < 1200; j++) {
        data[i][j] -= mean[j];
      }
    }
    
    
    
    for (i = 0; i < 1200; i++) {
      
      for (j = i; j < 1200; j++) {
        cov[i][j] = 0.0;
        
        for (k = 0; k < 1400; k++) {
          cov[i][j] += data[k][i] * data[k][j];
        }
        cov[i][j] /= float_n - 1.0;
        cov[j][i] = cov[i][j];
      }
    }
  }
}
