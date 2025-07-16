


void kernel_trisolv(int n,float L[2000][2000],float x[2000],float b[2000])
{
  int i;
  int j;

for (i = 0; i < 2000; i++) {
      x[i] = b[i];
    }
    for (i = 0; i < 2000; i++) {
      for (j = 0; j < i; j++) {
        x[i] -= L[i][j] * x[j];
      }
    }
    for (i = 0; i < 2000; i++) {
      x[i] = x[i] / L[i][i];
    }
}
