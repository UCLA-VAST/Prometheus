


void kernel_bicg(int m,int n,float A[2100][1900],float s[1900],float q[2100],float p[1900],float r[2100])
{
  int i;
  int j;
    
    for (i = 0; i < 1900; i++) {
      s[i] = 0.0;
    }
    
    
    
    for (i = 0; i < 2100; i++) {
      q[i] = 0.0;
    }
    for (i = 0; i < 2100; i++) {
      for (j = 0; j < 1900; j++) {
        s[j] = s[j] + r[i] * A[i][j];
      }
    }
    for (i = 0; i < 2100; i++) {
      for (j = 0; j < 1900; j++) {
        q[i] = q[i] + A[i][j] * p[j];
      }
    }
}
