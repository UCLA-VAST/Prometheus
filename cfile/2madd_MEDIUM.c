

void madd2(float A[220][200], float B[220][200], float D[220][200], float C[220][200], float F[220][200]) {

  int i;
  int j;

  for (i = 0; i < 220; i++) {
    for (j = 0; j < 200; j++) {
      C[i][j] += A[i][j] + B[i][j];
    }
}
for (i = 0; i < 220; i++) {
    for (j = 0; j < 200; j++) {
      F[i][j] += C[i][j] + D[i][j];
    }
  }
}