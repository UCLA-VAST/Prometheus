


void mlp_softmax1(float W[10][500], float b[10], float input[500], float output[10]) {
    
    float sum = 0.0;
    float temp[10];
    int i, j;

    // Matrix-vector product with bias and ReLU
    for (i = 0; i < 10; i++) {
        temp[i] = b[i];
    }
    for (i = 0; i < 10; i++) {
        for (j = 0; j < 500; j++) {
            temp[i] += W[i][j] * input[j];
        }
    }
    for (i = 0; i < 10; i++) {
        temp[i] = (temp[i] > 0) ? temp[i] : 0;  // ReLU activation
    }

    for (i = 0; i < 10; i++) {
        sum += expf(temp[i]);
    }
    for (i = 0; i < 10; i++) {
        output[i] = expf(temp[i]) / sum;
    }
}