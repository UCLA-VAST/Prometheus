
void Cnn( float input[256][228][228], float weight[256][256][5][5], float output[256][224][224]) {

int i;
int j;
int p;
int q;
int h;
int w;


  for ( i = 0; i < 256; ++i) {
    for ( j = 0; j < 256; ++j) {
      for ( p = 0; p < 5; ++p) {
            for ( q = 0; q < 5; ++q){
    for ( h = 0; h < 224; ++h) {
      for ( w = 0; w < 224; ++w) {
              output[i][h][w] += weight[i][j][p][q] * input[j][h + p][w + q];
            }
          }
        }
      }
    }
  }
}