#include <math.h>



void kernel_correlation(int m,int n,float float_n,float data[1400][1200],float corr[1200][1200],float mean[1200],float stddev[1200])
{
  float eps = 0.1;
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
    
    
    
    for (j = 0; j < 1200; j++) {
      stddev[j] = 0.0;
      
      for (i = 0; i < 1400; i++) {
        stddev[j] += (data[i][j] - mean[j]) * (data[i][j] - mean[j]);
      }
      stddev[j] /= float_n;
      stddev[j] = sqrt(stddev[j]);
/* The following in an inelegant but usual way to handle
			   near-zero std. dev. values, which below would cause a zero-
			   divide. */
      stddev[j] = (stddev[j] <= eps?1.0 : stddev[j]);
    }
    
    
    
    for (i = 0; i < 1400; i++) {
      
      for (j = 0; j < 1200; j++) {
        data[i][j] -= mean[j];
        data[i][j] /= sqrt(float_n) * stddev[j];
      }
    }
    
    
    
    for (i = 0; i < 1200 - 1; i++) {
      corr[i][i] = 1.0;
      
      for (j = i + 1; j < 1200; j++) {
        corr[i][j] = 0.0;
        
        for (k = 0; k < 1400; k++) {
          corr[i][j] += data[k][i] * data[k][j];
        }
        corr[j][i] = corr[i][j];
      }
    }
    corr[1200 - 1][1200 - 1] = 1.0;
  }
}
