



void gnn_softmax1(float A[100][100], float X[100][64], float W[64][8], float B[8], float F[100][8], float C[100][64], float temp[100][8], float sum[100]) {
    
    int n, i, j, k;

    // Step 1: Neighborhood aggregation (AX)
    for (n = 0; n < 100; n++) {
        for (i = 0; i < 64; i++) {
            C[n][i] = 0;
        }
    }
    for (n = 0; n < 100; n++) {
        for (i = 0; i < 64; i++) {
            for (j = 0; j < 100; j++) {
                C[n][i] += A[n][j] * X[j][i];
            }
        }
    }

    // Step 2: Dense layer (C × W + B), ReLU, then softmax
    for (n = 0; n < 100; n++) {
        for (i = 0; i < 8; i++) {
            temp[n][i] = B[i];
        }
    }
    for (n = 0; n < 100; n++) {
        for (i = 0; i < 8; i++) {
            for (j = 0; j < 64; j++) {
                temp[n][i] += C[n][j] * W[j][i];
            }
        }
    }
    for (n = 0; n < 100; n++) {
        sum[n] = 0;
    }
    for (n = 0; n < 100; n++) {
        for (i = 0; i < 8; i++) {
            sum[n] += temp[n][i];
        }
    }
    for (n = 0; n < 100; n++) {
        for (i = 0; i < 8; i++) {
            F[n][i] += temp[n][i] / sum[n];
        }
    }
}