


void kernel_bicg(float A[410][390],float s[390],float q[410],float p[390],float r[410])
{
  int i;
  int j;
{
    
    for (j = 0; j < 390; j++) {
      s[j] = 0.0;
    }

    for (i = 0; i < 410; i++) {
      for (j = 0; j < 390; j++) {
        s[j] = s[j] + r[i] * A[i][j];
      }
    }
    
    
    
    for (i = 0; i < 410; i++) {
      q[i] = 0.0;
    }
    
    for (i = 0; i < 410; i++) {
      for (j = 0; j < 390; j++) {
        q[i] = q[i] + A[i][j] * p[j];
      }
    }
  }
}
