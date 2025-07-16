


void kernel_bicg(int m,int n,float A[124][116],float s[116],float q[124],float p[116],float r[124])
{
  int i;
  int j;
{
    
    for (i = 0; i < 116; i++) {
      s[i] = ((float )0);
    }
    
    
    
    for (i = 0; i < 124; i++) {
      q[i] = 0.0;
    }
    for (i = 0; i < 124; i++) {
      for (j = 0; j < 116; j++) {
        s[j] = s[j] + r[i] * A[i][j];
      }
    }
    for (i = 0; i < 124; i++) {
      for (j = 0; j < 116; j++) {
        q[i] = q[i] + A[i][j] * p[j];
      }
    }
  }
}
