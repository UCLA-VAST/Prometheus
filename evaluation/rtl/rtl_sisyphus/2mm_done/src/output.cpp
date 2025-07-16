#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_tmp (float tmp[180][190], float2 vtmp[17100]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 190; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_tmp = vtmp[i0 * 95 + i1/2];
            tmp[i0][i1 + 0] = tmp_tmp[0];
            tmp[i0][i1 + 1] = tmp_tmp[1];
        }
    }
}
void load_A (float A[180][210], float2 vA[18900]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 210; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_A = vA[i0 * 105 + i1/2];
            A[i0][i1 + 0] = tmp_A[0];
            A[i0][i1 + 1] = tmp_A[1];
        }
    }
}
void load_B (float B[210][190], float2 vB[19950]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 210; i0+=1){
        for (int i1 = 0; i1 < 190; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_B = vB[i0 * 95 + i1/2];
            B[i0][i1 + 0] = tmp_B[0];
            B[i0][i1 + 1] = tmp_B[1];
        }
    }
}
void load_D (float D[180][220], float4 vD[9900]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 220; i1+=4){
#pragma HLS pipeline II=1
            float4 tmp_D = vD[i0 * 55 + i1/4];
            D[i0][i1 + 0] = tmp_D[0];
            D[i0][i1 + 1] = tmp_D[1];
            D[i0][i1 + 2] = tmp_D[2];
            D[i0][i1 + 3] = tmp_D[3];
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
void store_tmp (float tmp[180][190], float2 vtmp[17100]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 190; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_tmp;
            tmp_tmp[0] = tmp[i0][i1 + 0];
            tmp_tmp[1] = tmp[i0][i1 + 1];
            vtmp[i0 * 95 + i1/2] = tmp_tmp;
        }
    }
}
void store_D (float D[180][220], float4 vD[9900]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 180; i0+=1){
        for (int i1 = 0; i1 < 220; i1+=4){
#pragma HLS pipeline II=1
            float4 tmp_D;
            tmp_D[0] = D[i0][i1 + 0];
            tmp_D[1] = D[i0][i1 + 1];
            tmp_D[2] = D[i0][i1 + 2];
            tmp_D[3] = D[i0][i1 + 3];
            vD[i0 * 55 + i1/4] = tmp_D;
        }
    }
}

void task0(float tmp[180][190], float alpha, float beta, float2 vtmp[17100], float2 vA[18900], float2 vB[19950], float4 vC[10450], float4 vD[9900]) {
    int j;
    int i;
    for (int j0 = 0; j0 < 1; j0++) {
        for (int i0 = 0; i0 < 3; i0++) {
            for (int j1 = 0; j1 < 19; j1++) {
#pragma HLS pipeline
                for (int j2 = 0; j2 < 10; j2++) {
                    for (int i2 = 0; i2 < 60; i2++) {
                        j = j0 * 190 + j1 * 10 + j2;
                        i = i0 * 60 + i2;
                        tmp[i][j] =0.0 ;
                     }
                }
            }
        }
    }
}

void task1(float A[180][210], float B[210][190], float tmp[180][190], float alpha, float beta, float2 vtmp[17100], float2 vA[18900], float2 vB[19950], float4 vC[10450], float4 vD[9900]) {
    int k;
    int j;
    int i;
    for (int k0 = 0; k0 < 15; k0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i0 = 0; i0 < 3; i0++) {
                for (int j1 = 0; j1 < 190; j1++) {
#pragma HLS pipeline
                        for (int j2 = 0; j2 < 1; j2++) {
                            for (int i2 = 0; i2 < 60; i2++) {
                    for (int k2 = 0; k2 < 14; k2++) {
                                k = k0 * 14 + k2;
                                j = j0 * 190 + j1 * 1 + j2;
                                i = i0 * 60 + i2;
                                tmp[i][j] +=alpha * A[i][k] * B[k][j] ;
                             }
                        }
                    }
                }
            }
        }
    }
}

void task2(float D[180][220], float alpha, float beta, float2 vtmp[17100], float2 vA[18900], float2 vB[19950], float4 vC[10450], float4 vD[9900]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 10; j0++) {
            for (int i1 = 0; i1 < 60; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 3; i2++) {
                    for (int j2 = 0; j2 < 22; j2++) {
                        i = i0 * 180 + i1 * 3 + i2;
                        j = j0 * 22 + j2;
                        D[i][j] *=beta ;
                     }
                }
            }
        }
    }
}

void task3(float D[180][220], float tmp[180][190], float C[190][220], float alpha, float beta, float2 vtmp[17100], float2 vA[18900], float2 vB[19950], float4 vC[10450], float4 vD[9900]) {
    int i;
    int j;
    int k;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int k0 = 0; k0 < 95; k0++) {
                for (int i1 = 0; i1 < 60; i1++) {
#pragma HLS pipeline
                    for (int i2 = 0; i2 < 3; i2++) {
                        for (int j2 = 0; j2 < 220; j2++) {
                            for (int k2 = 0; k2 < 2; k2++) {
                                i = i0 * 180 + i1 * 3 + i2;
                                j = j0 * 220 + j2;
                                k = k0 * 2 + k2;
                                D[i][j] +=tmp[i][k] * C[k][j] ;
                             }
                        }
                    }
                }
            }
        }
    }
}

void kernel_nlp(float alpha, float beta, float2 vtmp[17100], float2 vA[18900], float2 vB[19950], float4 vC[10450], float4 vD[9900]) {

#pragma HLS INTERFACE m_axi port=alpha offset=slave bundle=kernel_alpha
#pragma HLS INTERFACE m_axi port=beta offset=slave bundle=kernel_beta
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE m_axi port=vB offset=slave bundle=kernel_B
#pragma HLS INTERFACE m_axi port=vD offset=slave bundle=kernel_D
#pragma HLS INTERFACE m_axi port=vtmp offset=slave bundle=kernel_tmp
#pragma HLS INTERFACE m_axi port=vC offset=slave bundle=kernel_C
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=beta bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=vB bundle=control
#pragma HLS INTERFACE s_axilite port=vD bundle=control
#pragma HLS INTERFACE s_axilite port=vtmp bundle=control
#pragma HLS INTERFACE s_axilite port=vC bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float A[180][210];
    float B[210][190];
    float D[180][220];
    float tmp[180][190];
    float C[190][220];

#pragma HLS ARRAY_PARTITION variable=A cyclic factor=60 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=14 dim=2
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=14 dim=1
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=2 dim=2
#pragma HLS ARRAY_PARTITION variable=D cyclic factor=3 dim=1
#pragma HLS ARRAY_PARTITION variable=D cyclic factor=220 dim=2
#pragma HLS ARRAY_PARTITION variable=tmp cyclic factor=60 dim=1
#pragma HLS ARRAY_PARTITION variable=tmp cyclic factor=10 dim=2
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=220 dim=2

    load_tmp(tmp, vtmp);
    load_A(A, vA);
    load_B(B, vB);
    load_D(D, vD);
    load_C(C, vC);
    task0(tmp, alpha, beta, vtmp, vA, vB, vC, vD);
    task1(A, B, tmp, alpha, beta, vtmp, vA, vB, vC, vD);
    task2(D, alpha, beta, vtmp, vA, vB, vC, vD);
    task3(D, tmp, C, alpha, beta, vtmp, vA, vB, vC, vD);
    store_tmp(tmp, vtmp);
    store_D(D, vD);
}
