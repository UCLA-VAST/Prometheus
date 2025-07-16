



void attention_softmax1(float Q[128], float K[128][100], float scores[100], float temp[100]) {
    
    float sum = 1.0;
    int i;

    // Dot product between query Q and each key vector K[:,i]
    for (i = 0; i < 100; i++) {
        temp[i] = 0.0;
    }
    for (i = 0; i < 100; i++) {
        for (int j = 0; j < 128; j++) {
            temp[i] += Q[j] * K[j][i];  // Score: Q · K_i
        }
    }

    // // Softmax over scores
    // for (i = 0; i < 100; i++){
    //     sum += temp[i];
    // }
    for (i = 0; i < 100; i++) {
        scores[i] += temp[i] / sum;
    }
}