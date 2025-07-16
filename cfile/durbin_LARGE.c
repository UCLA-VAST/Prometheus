


void kernel_durbin(int n,float r[2000],float y[2000])
{
  float z[2000];
  float alpha;
  float beta;
  float sum;
  int i;
  int k;
{
    y[0] = -r[0];
    beta = 1.0;
    alpha = -r[0];
    
    
    
    for (k = 1; k < 2000; k++) {
      beta = (((float )1) - alpha * alpha) * beta;
      sum = 0.0;
      for (i = 0; i < k; i++) {
        sum += r[k - i - 1] * y[i];
      }
      alpha = -(r[k] + sum) / beta;
      for (i = 0; i < k; i++) {
        z[i] = y[i] + alpha * y[k - i - 1];
      }
      for (i = 0; i < k; i++) {
        y[i] = z[i];
      }
      y[k] = alpha;
    }
  }
}
