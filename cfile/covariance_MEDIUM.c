


void kernel_covariance(int m,int n,float float_n,float data[260][240],float cov[240][240],float mean[240])
{
  int i;
  int j;
  int k;
{
    
    
    
    for (j = 0; j < 240; j++) {
      mean[j] = 0.0;
    }
    for (j = 0; j < 240; j++) {
      for (i = 0; i < 260; i++) {
        mean[j] += data[i][j];
      }
    }
    for (j = 0; j < 240; j++) {
      mean[j] /= float_n;
    }
    
    
    
    for (i = 0; i < 260; i++) {
      
      for (j = 0; j < 240; j++) {
        data[i][j] -= mean[j];
      }
    }
    
    
    
    for (i = 0; i < 240; i++) {
      
      for (j = i; j < 240; j++) {
        cov[i][j] = 0.0;
      }
    }
    for (i = 0; i < 240; i++) {
      
      for (j = i; j < 240; j++) {
        
        for (k = 0; k < 260; k++) {
          cov[i][j] += data[k][i] * data[k][j];
        }
      }
    }
    for (i = 0; i < 240; i++) {
      
      for (j = i; j < 240; j++) {
        cov[i][j] /= float_n - 1.0;
      }
    }
    for (i = 0; i < 240; i++) {
      
      for (j = i; j < 240; j++) {
        cov[j][i] = cov[i][j];
      }
    }
  }
}
