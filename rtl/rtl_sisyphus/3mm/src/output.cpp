#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_E (float E[180][190], float2 vE[17100]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 190; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_E = vE[i0 * 95 + i1/2];
            E[i0][i1 + 0] = tmp_E[0];
            E[i0][i1 + 1] = tmp_E[1];
        }
    }
}
void load_B (float B[200][190], float2 vB[19000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 190; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_B = vB[i0 * 95 + i1/2];
            B[i0][i1 + 0] = tmp_B[0];
            B[i0][i1 + 1] = tmp_B[1];
        }
    }
}
void load_A (float A[180][200], float8 vA[4500]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 200; i1+=8){
#pragma HLS pipeline II=1
            float8 tmp_A = vA[i0 * 25 + i1/8];
            A[i0][i1 + 0] = tmp_A[0];
            A[i0][i1 + 1] = tmp_A[1];
            A[i0][i1 + 2] = tmp_A[2];
            A[i0][i1 + 3] = tmp_A[3];
            A[i0][i1 + 4] = tmp_A[4];
            A[i0][i1 + 5] = tmp_A[5];
            A[i0][i1 + 6] = tmp_A[6];
            A[i0][i1 + 7] = tmp_A[7];
        }
    }
}
void load_F (float F[190][210], float2 vF[19950]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 190; i0+=1){
        for (int i1 = 0; i1 < 210; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_F = vF[i0 * 105 + i1/2];
            F[i0][i1 + 0] = tmp_F[0];
            F[i0][i1 + 1] = tmp_F[1];
        }
    }
}
void load_C (float C[190][220], float4 vC[10450]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 190; i0+=1){
        for (int i1 = 0; i1 < 220; i1+=4){
#pragma HLS pipeline II=1
            float4 tmp_C = vC[i0 * 55 + i1/4];
            C[i0][i1 + 0] = tmp_C[0];
            C[i0][i1 + 1] = tmp_C[1];
            C[i0][i1 + 2] = tmp_C[2];
            C[i0][i1 + 3] = tmp_C[3];
        }
    }
}
void load_D (float D[220][210], float2 vD[23100]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 220; i0+=1){
        for (int i1 = 0; i1 < 210; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_D = vD[i0 * 105 + i1/2];
            D[i0][i1 + 0] = tmp_D[0];
            D[i0][i1 + 1] = tmp_D[1];
        }
    }
}
void load_G (float G[180][210], float2 vG[18900]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 210; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_G = vG[i0 * 105 + i1/2];
            G[i0][i1 + 0] = tmp_G[0];
            G[i0][i1 + 1] = tmp_G[1];
        }
    }
}
void store_E (float E[180][190], float2 vE[17100]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 190; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_E;
            tmp_E[0] = E[i0][i1 + 0];
            tmp_E[1] = E[i0][i1 + 1];
            vE[i0 * 95 + i1/2] = tmp_E;
        }
    }
}
void store_F (float F[190][210], float2 vF[19950]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 190; i0+=1){
        for (int i1 = 0; i1 < 210; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_F;
            tmp_F[0] = F[i0][i1 + 0];
            tmp_F[1] = F[i0][i1 + 1];
            vF[i0 * 105 + i1/2] = tmp_F;
        }
    }
}
void store_G (float G[180][210], float2 vG[18900]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 210; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_G;
            tmp_G[0] = G[i0][i1 + 0];
            tmp_G[1] = G[i0][i1 + 1];
            vG[i0 * 105 + i1/2] = tmp_G;
        }
    }
}

void task0(float E[180][190], float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    int j;
    int i;
    for (int j0 = 0; j0 < 19; j0++) {
        for (int i0 = 0; i0 < 1; i0++) {
            for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
                for (int j2 = 0; j2 < 10; j2++) {
                    for (int i2 = 0; i2 < 90; i2++) {
                        j = j0 * 10 + j2;
                        i = i0 * 180 + i1 * 90 + i2;
                        E[i][j] =0.0 ;
                     }
                }
            }
        }
    }
}

void task1(float B[200][190], float A[180][200], float E[180][190], float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    int j;
    int i;
    int k;
    for (int j0 = 0; j0 < 19; j0++) {
        for (int i0 = 0; i0 < 2; i0++) {
            for (int k0 = 0; k0 < 1; k0++) {
                for (int k1 = 0; k1 < 25; k1++) {
#pragma HLS pipeline
                    for (int j2 = 0; j2 < 10; j2++) {
                        for (int i2 = 0; i2 < 90; i2++) {
                            for (int k2 = 0; k2 < 8; k2++) {
                                j = j0 * 10 + j2;
                                i = i0 * 90 + i2;
                                k = k0 * 200 + k1 * 8 + k2;
                                E[i][j] +=A[i][k] * B[k][j] ;
                             }
                        }
                    }
                }
            }
        }
    }
}

void task2(float F[190][210], float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 19; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int j1 = 0; j1 < 3; j1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 10; i2++) {
                    for (int j2 = 0; j2 < 70; j2++) {
                        i = i0 * 10 + i2;
                        j = j0 * 210 + j1 * 70 + j2;
                        F[i][j] =0.0 ;
                     }
                }
            }
        }
    }
}

void task3(float C[190][220], float F[190][210], float D[220][210], float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    int k;
    int i;
    int j;
    for (int k0 = 0; k0 < 1; k0++) {
        for (int i0 = 0; i0 < 19; i0++) {
            for (int j0 = 0; j0 < 3; j0++) {
                for (int k1 = 0; k1 < 44; k1++) {
#pragma HLS pipeline
                        for (int i2 = 0; i2 < 10; i2++) {
                            for (int j2 = 0; j2 < 70; j2++) {
                    for (int k2 = 0; k2 < 5; k2++) {
                                k = k0 * 220 + k1 * 5 + k2;
                                i = i0 * 10 + i2;
                                j = j0 * 70 + j2;
                                F[i][j] +=C[i][k] * D[k][j] ;
                             }
                        }
                    }
                }
            }
        }
    }
}

void task4(float G[180][210], float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    int j;
    int i;
    for (int j0 = 0; j0 < 3; j0++) {
        for (int i0 = 0; i0 < 2; i0++) {
            for (int j1 = 0; j1 < 7; j1++) {
#pragma HLS pipeline
                for (int j2 = 0; j2 < 10; j2++) {
                    for (int i2 = 0; i2 < 90; i2++) {
                        j = j0 * 70 + j1 * 10 + j2;
                        i = i0 * 90 + i2;
                        G[i][j] =0.0 ;
                     }
                }
            }
        }
    }
}

void task5(float G[180][210], float E[180][190], float F[190][210], float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {
    int k;
    int j;
    int i;
    for (int k0 = 0; k0 < 1; k0++) {
        for (int j0 = 0; j0 < 21; j0++) {
            for (int i0 = 0; i0 < 2; i0++) {
                for (int k1 = 0; k1 < 38; k1++) {
#pragma HLS pipeline
                        for (int j2 = 0; j2 < 10; j2++) {
                            for (int i2 = 0; i2 < 90; i2++) {
                    for (int k2 = 0; k2 < 5; k2++) {
                                k = k0 * 190 + k1 * 5 + k2;
                                j = j0 * 10 + j2;
                                i = i0 * 90 + i2;
                                G[i][j] +=E[i][k] * F[k][j] ;
                             }
                        }
                    }
                }
            }
        }
    }
}

void kernel_nlp(float2 vE[17100], float8 vA[4500], float2 vB[19000], float2 vF[19950], float4 vC[10450], float2 vD[23100], float2 vG[18900]) {

#pragma HLS INTERFACE m_axi port=vB offset=slave bundle=kernel_B
#pragma HLS INTERFACE m_axi port=vC offset=slave bundle=kernel_C
#pragma HLS INTERFACE m_axi port=vG offset=slave bundle=kernel_G
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE m_axi port=vE offset=slave bundle=kernel_E
#pragma HLS INTERFACE m_axi port=vF offset=slave bundle=kernel_F
#pragma HLS INTERFACE m_axi port=vD offset=slave bundle=kernel_D
#pragma HLS INTERFACE s_axilite port=vB bundle=control
#pragma HLS INTERFACE s_axilite port=vC bundle=control
#pragma HLS INTERFACE s_axilite port=vG bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=vE bundle=control
#pragma HLS INTERFACE s_axilite port=vF bundle=control
#pragma HLS INTERFACE s_axilite port=vD bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float B[200][190];
    float C[190][220];
    float G[180][210];
    float A[180][200];
    float E[180][190];
    float F[190][210];
    float D[220][210];

#pragma HLS ARRAY_PARTITION variable=B cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=10 dim=2
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=10 dim=1
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=20 dim=2
#pragma HLS ARRAY_PARTITION variable=G cyclic factor=90 dim=1
#pragma HLS ARRAY_PARTITION variable=G cyclic factor=10 dim=2
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=90 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=8 dim=2
#pragma HLS ARRAY_PARTITION variable=E cyclic factor=90 dim=1
#pragma HLS ARRAY_PARTITION variable=E cyclic factor=10 dim=2
#pragma HLS ARRAY_PARTITION variable=F cyclic factor=10 dim=1
#pragma HLS ARRAY_PARTITION variable=F cyclic factor=70 dim=2
#pragma HLS ARRAY_PARTITION variable=D cyclic factor=5 dim=1
#pragma HLS ARRAY_PARTITION variable=D cyclic factor=70 dim=2

    load_E(E, vE);
    load_B(B, vB);
    load_A(A, vA);
    load_F(F, vF);
    load_C(C, vC);
    load_D(D, vD);
    load_G(G, vG);
    task0(E, vE, vA, vB, vF, vC, vD, vG);
    task1(B, A, E, vE, vA, vB, vF, vC, vD, vG);
    task2(F, vE, vA, vB, vF, vC, vD, vG);
    task3(C, F, D, vE, vA, vB, vF, vC, vD, vG);
    task4(G, vE, vA, vB, vF, vC, vD, vG);
    task5(G, E, F, vE, vA, vB, vF, vC, vD, vG);
    store_E(E, vE);
    store_F(F, vF);
    store_G(G, vG);
}
