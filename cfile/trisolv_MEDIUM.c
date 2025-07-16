


void kernel_trisolv(int n,float L[400][400],float x[400],float b[400])
{
  int i;
  int j;

for (i = 0; i < 400; i++) {
      x[i] = b[i];
    }
    for (i = 0; i < 400; i++) {
      for (j = 0; j < i; j++) {
        x[i] -= L[i][j] * x[j];
      }
    }
    for (i = 0; i < 400; i++) {
      x[i] = x[i] / L[i][i];
    }
}
