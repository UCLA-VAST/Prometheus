


void kernel_symm(float alpha,float beta,float tmp[200][240],float C[200][240],float A1[200][200],float B1[200][240],float A2[200],float B2[200][240],float A3[200][200],float B3[200][240])
{
  int i;
  int j;
  int k;
    
    
    for ( i = 0; i < 200; i++) {
        for ( j = 0; j < 240; j++) {
            tmp[i][j] = 0;
        }
    }
    for ( i = 0; i < 200; i++) {
        for ( j = 0; j < 240; j++) {
            for ( k = 0; k < 200; k++) {
                tmp[i][j] += B1[k][j] * A1[i][k];
            }
        }
    }
    for ( i = 0; i < 200; i++) {
        for ( j = 0; j < 240; j++) {
            C[i][j] = beta * C[i][j] + alpha * B2[i][j] * A2[i] + alpha * tmp[i][j];
        }
    }
    for ( i = 0; i < 200; i++) {
        for ( k = 0; k < 200; k++) {
            for ( j = 0; j < 240; j++) {
                C[i][j] += alpha * B3[k][j] * A3[k][i];
            }
        }
    }
}
