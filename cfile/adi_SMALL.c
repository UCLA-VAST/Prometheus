


void kernel_adi(int tsteps,int n,float u[60][60],float v[60][60],float p[60][60],float q[60][60])
{
  int t;
  int i;
  int j;
  float DX;
  float DY;
  float DT;
  float B1;
  float B2;
  float mul1;
  float mul2;
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
{
    DX = 1.0 / ((float )60);
    DY = 1.0 / ((float )60);
    DT = 1.0 / ((float )40);
    B1 = 2.0;
    B2 = 1.0;
    mul1 = B1 * DT / (DX * DX);
    mul2 = B2 * DT / (DY * DY);
    a = -mul1 / 2.0;
    b = 1.0 + mul1;
    c = a;
    d = -mul2 / 2.0;
    e = 1.0 + mul2;
    f = d;
    
    
    
    for (t = 1; t <= 40; t++) {
//Column Sweep
      
      
      
      for (i = 1; i < 60 - 1; i++) {
        v[0][i] = 1.0;
        p[i][0] = 0.0;
        q[i][0] = v[0][i];
        
        for (j = 1; j < 60 - 1; j++) {
          p[i][j] = -c / (a * p[i][j - 1] + b);
          q[i][j] = (-d * u[j][i - 1] + (1.0 + 2.0 * d) * u[j][i] - f * u[j][i + 1] - a * q[i][j - 1]) / (a * p[i][j - 1] + b);
        }
        v[60 - 1][i] = 1.0;
        
        for (j = 0; j <= 57; j++) {
          int _in_j_0 = 58 + -1 * j;
          v[_in_j_0][i] = p[i][_in_j_0] * v[_in_j_0 + 1][i] + q[i][_in_j_0];
        }
        j = 1 + -1;
      }
//Row Sweep
      
      
      
      for (i = 1; i < 60 - 1; i++) {
        u[i][0] = 1.0;
        p[i][0] = 0.0;
        q[i][0] = u[i][0];
        
        for (j = 1; j < 60 - 1; j++) {
          p[i][j] = -f / (d * p[i][j - 1] + e);
          q[i][j] = (-a * v[i - 1][j] + (1.0 + 2.0 * a) * v[i][j] - c * v[i + 1][j] - d * q[i][j - 1]) / (d * p[i][j - 1] + e);
        }
        u[i][60 - 1] = 1.0;
        
        for (j = 0; j <= 57; j++) {
          int _in_j = 58 + -1 * j;
          u[i][_in_j] = p[i][_in_j] * u[i][_in_j + 1] + q[i][_in_j];
        }
        j = 1 + -1;
      }
    }
  }
}
