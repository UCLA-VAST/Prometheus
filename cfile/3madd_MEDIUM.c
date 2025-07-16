


void madd3(float A1[220][200], float B1[220][200], float B2[220][200], float B3[220][200], float C1[220][200], float C2[220][200], float C3[220][200]) {

  int i;
  int j;

  for (i = 0; i < 220; i++) {
    for (j = 0; j < 200; j++) {
      C1[i][j] += A1[i][j] + B1[i][j];
    }
}
for (i = 0; i < 220; i++) {
    for (j = 0; j < 200; j++) {
      C2[i][j] += C1[i][j] + B2[i][j];
    }
}
for (i = 0; i < 220; i++) {
    for (j = 0; j < 200; j++) {
      C3[i][j] += C2[i][j] + B3[i][j];
    }
  }
}