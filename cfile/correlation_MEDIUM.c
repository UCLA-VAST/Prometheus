#include <math.h>



void kernel_correlation(int m,int n,float float_n,float data[260][240],float corr[240][240],float mean[240],float stddev[240])
{
  int i;
  int j;
  int k;
  float eps = 0.1;
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
    
    
    
    for (j = 0; j < 240; j++) {
      stddev[j] = 0.0;
    }
    for (j = 0; j < 240; j++) {
      for (i = 0; i < 260; i++) {
        stddev[j] += (data[i][j] - mean[j]) * (data[i][j] - mean[j]);
      }
    for (j = 0; j < 240; j++) {
      stddev[j] /= float_n;
    }
    for (j = 0; j < 240; j++) {
      stddev[j] = sqrt(stddev[j]);
    }

    for (j = 0; j < 240; j++) {
      stddev[j] = (stddev[j] <= eps?1.0 : stddev[j]);
    }
    
    
    
    for (i = 0; i < 260; i++) {
      
      for (j = 0; j < 240; j++) {
        data[i][j] -= mean[j];
      }
    }
    for (i = 0; i < 260; i++) {
      
      for (j = 0; j < 240; j++) {
        data[i][j] /= sqrt(float_n) * stddev[j];
      }
    }
    
    
    
    for (i = 0; i < 240 - 1; i++) {
      corr[i][i] = 1.0;
      
    }
    for (i = 0; i < 240 - 1; i++) {
      for (j = i + 1; j < 240; j++) {
        corr[i][j] = 0.0;
      }
    }
    for (i = 0; i < 240 - 1; i++) {
      for (j = i + 1; j < 240; j++) {
        for (k = 0; k < 260; k++) {
          corr[i][j] += data[k][i] * data[k][j];
        }
      }
    }
    for (i = 0; i < 240 - 1; i++) {
      for (j = i + 1; j < 240; j++) {
        corr[j][i] = corr[i][j];
      }
    }
  }
}


