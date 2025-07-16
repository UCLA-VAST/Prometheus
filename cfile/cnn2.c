
void Cnn( float input[256][228][228], float weight[256][256][5][5], float output[256][224][224]) {

int i;
int j;
int p;
int q;
int h;
int w;


  for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h][w + 0];
      }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h][w + 1];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h][w + 2];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h][w + 3];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h][w + 4];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 1][w + 0];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 1][w + 1];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 1][w + 2];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 1][w + 3];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 1][w + 4];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 2][w + 0];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 2][w + 1];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 2][w + 2];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 2][w + 3];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 2][w + 4];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 3][w + 0];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 3][w + 1];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 3][w + 2];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 3][w + 3];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 3][w + 4];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 4][w + 0];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 4][w + 1];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 4][w + 2];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 4][w + 3];
                    }
    }
    }
  }
    for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + 4][w + 4];
            }
          }
        }
  }
}