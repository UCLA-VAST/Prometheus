#include <math.h>



void kernel_deriche(int w,int h,float alpha,float imgIn[4096][2160],float imgOut[4096][2160],float y1[4096][2160],float y2[4096][2160])
{
  int i;
  int j;
  float xm1;
  float tm1;
  float ym1;
  float ym2;
  float xp1;
  float xp2;
  float tp1;
  float tp2;
  float yp1;
  float yp2;
  float k;
  float a1;
  float a2;
  float a3;
  float a4;
  float a5;
  float a6;
  float a7;
  float a8;
  float b1;
  float b2;
  float c1;
  float c2;
{
    k = (1.0f - expf(-alpha)) * (1.0f - expf(-alpha)) / (1.0f + 2.0f * alpha * expf(-alpha) - expf(2.0f * alpha));
    a1 = a5 = k;
    a2 = a6 = k * expf(-alpha) * (alpha - 1.0f);
    a3 = a7 = k * expf(-alpha) * (alpha + 1.0f);
    a4 = a8 = -k * expf(- 2.0f * alpha);
    b1 = powf(2.0f,-alpha);
    b2 = -expf(- 2.0f * alpha);
    c1 = c2 = ((float )1);
    
    
    
    for (i = 0; i < 4096; i++) {
      ym1 = 0.0f;
      ym2 = 0.0f;
      xm1 = 0.0f;
      
      for (j = 0; j < 2160; j++) {
        y1[i][j] = a1 * imgIn[i][j] + a2 * xm1 + b1 * ym1 + b2 * ym2;
        xm1 = imgIn[i][j];
        ym2 = ym1;
        ym1 = y1[i][j];
      }
    }
    
    
    
    for (i = 0; i < 4096; i++) {
      yp1 = 0.0f;
      yp2 = 0.0f;
      xp1 = 0.0f;
      xp2 = 0.0f;
      
      for (j = 0; j <= 2159; j++) {
        int _in_j = 2159 + -1 * j;
        y2[i][_in_j] = a3 * xp1 + a4 * xp2 + b1 * yp1 + b2 * yp2;
        xp2 = xp1;
        xp1 = imgIn[i][_in_j];
        yp2 = yp1;
        yp1 = y2[i][_in_j];
      }
      j = 0 + -1;
    }
    
    
    
    for (i = 0; i < 4096; i++) {
      
      for (j = 0; j < 2160; j++) {
        imgOut[i][j] = c1 * (y1[i][j] + y2[i][j]);
      }
    }
    
    
    
    for (j = 0; j < 2160; j++) {
      tm1 = 0.0f;
      ym1 = 0.0f;
      ym2 = 0.0f;
      
      for (i = 0; i < 4096; i++) {
        y1[i][j] = a5 * imgOut[i][j] + a6 * tm1 + b1 * ym1 + b2 * ym2;
        tm1 = imgOut[i][j];
        ym2 = ym1;
        ym1 = y1[i][j];
      }
    }
    
    
    
    for (j = 0; j < 2160; j++) {
      tp1 = 0.0f;
      tp2 = 0.0f;
      yp1 = 0.0f;
      yp2 = 0.0f;
      
      for (i = 0; i <= 4095; i++) {
        int _in_i = 4095 + -1 * i;
        y2[_in_i][j] = a7 * tp1 + a8 * tp2 + b1 * yp1 + b2 * yp2;
        tp2 = tp1;
        tp1 = imgOut[_in_i][j];
        yp2 = yp1;
        yp1 = y2[_in_i][j];
      }
      i = 0 + -1;
    }
    
    
    
    for (i = 0; i < 4096; i++) {
      
      for (j = 0; j < 2160; j++) {
        imgOut[i][j] = c2 * (y1[i][j] + y2[i][j]);
      }
    }
  }
}
