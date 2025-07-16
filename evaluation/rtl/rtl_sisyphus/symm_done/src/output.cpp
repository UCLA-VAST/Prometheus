#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_temp2 (float temp2[200][240], float16 vtemp2[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_temp2 = vtemp2[i0 * 15 + i1/16];
            temp2[i0][i1 + 0] = tmp_temp2[0];
            temp2[i0][i1 + 1] = tmp_temp2[1];
            temp2[i0][i1 + 2] = tmp_temp2[2];
            temp2[i0][i1 + 3] = tmp_temp2[3];
            temp2[i0][i1 + 4] = tmp_temp2[4];
            temp2[i0][i1 + 5] = tmp_temp2[5];
            temp2[i0][i1 + 6] = tmp_temp2[6];
            temp2[i0][i1 + 7] = tmp_temp2[7];
            temp2[i0][i1 + 8] = tmp_temp2[8];
            temp2[i0][i1 + 9] = tmp_temp2[9];
            temp2[i0][i1 + 10] = tmp_temp2[10];
            temp2[i0][i1 + 11] = tmp_temp2[11];
            temp2[i0][i1 + 12] = tmp_temp2[12];
            temp2[i0][i1 + 13] = tmp_temp2[13];
            temp2[i0][i1 + 14] = tmp_temp2[14];
            temp2[i0][i1 + 15] = tmp_temp2[15];
        }
    }
}
void load_B (float B[200][240], float16 vB[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_B = vB[i0 * 15 + i1/16];
            B[i0][i1 + 0] = tmp_B[0];
            B[i0][i1 + 1] = tmp_B[1];
            B[i0][i1 + 2] = tmp_B[2];
            B[i0][i1 + 3] = tmp_B[3];
            B[i0][i1 + 4] = tmp_B[4];
            B[i0][i1 + 5] = tmp_B[5];
            B[i0][i1 + 6] = tmp_B[6];
            B[i0][i1 + 7] = tmp_B[7];
            B[i0][i1 + 8] = tmp_B[8];
            B[i0][i1 + 9] = tmp_B[9];
            B[i0][i1 + 10] = tmp_B[10];
            B[i0][i1 + 11] = tmp_B[11];
            B[i0][i1 + 12] = tmp_B[12];
            B[i0][i1 + 13] = tmp_B[13];
            B[i0][i1 + 14] = tmp_B[14];
            B[i0][i1 + 15] = tmp_B[15];
        }
    }
}
void load_A (float A[200][200], float8 vA[5000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
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
void load_C (float C[200][240], float16 vC[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_C = vC[i0 * 15 + i1/16];
            C[i0][i1 + 0] = tmp_C[0];
            C[i0][i1 + 1] = tmp_C[1];
            C[i0][i1 + 2] = tmp_C[2];
            C[i0][i1 + 3] = tmp_C[3];
            C[i0][i1 + 4] = tmp_C[4];
            C[i0][i1 + 5] = tmp_C[5];
            C[i0][i1 + 6] = tmp_C[6];
            C[i0][i1 + 7] = tmp_C[7];
            C[i0][i1 + 8] = tmp_C[8];
            C[i0][i1 + 9] = tmp_C[9];
            C[i0][i1 + 10] = tmp_C[10];
            C[i0][i1 + 11] = tmp_C[11];
            C[i0][i1 + 12] = tmp_C[12];
            C[i0][i1 + 13] = tmp_C[13];
            C[i0][i1 + 14] = tmp_C[14];
            C[i0][i1 + 15] = tmp_C[15];
        }
    }
}
void store_temp2 (float temp2[200][240], float16 vtemp2[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_temp2;
            tmp_temp2[0] = temp2[i0][i1 + 0];
            tmp_temp2[1] = temp2[i0][i1 + 1];
            tmp_temp2[2] = temp2[i0][i1 + 2];
            tmp_temp2[3] = temp2[i0][i1 + 3];
            tmp_temp2[4] = temp2[i0][i1 + 4];
            tmp_temp2[5] = temp2[i0][i1 + 5];
            tmp_temp2[6] = temp2[i0][i1 + 6];
            tmp_temp2[7] = temp2[i0][i1 + 7];
            tmp_temp2[8] = temp2[i0][i1 + 8];
            tmp_temp2[9] = temp2[i0][i1 + 9];
            tmp_temp2[10] = temp2[i0][i1 + 10];
            tmp_temp2[11] = temp2[i0][i1 + 11];
            tmp_temp2[12] = temp2[i0][i1 + 12];
            tmp_temp2[13] = temp2[i0][i1 + 13];
            tmp_temp2[14] = temp2[i0][i1 + 14];
            tmp_temp2[15] = temp2[i0][i1 + 15];
            vtemp2[i0 * 15 + i1/16] = tmp_temp2;
        }
    }
}
void store_C (float C[200][240], float16 vC[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_C;
            tmp_C[0] = C[i0][i1 + 0];
            tmp_C[1] = C[i0][i1 + 1];
            tmp_C[2] = C[i0][i1 + 2];
            tmp_C[3] = C[i0][i1 + 3];
            tmp_C[4] = C[i0][i1 + 4];
            tmp_C[5] = C[i0][i1 + 5];
            tmp_C[6] = C[i0][i1 + 6];
            tmp_C[7] = C[i0][i1 + 7];
            tmp_C[8] = C[i0][i1 + 8];
            tmp_C[9] = C[i0][i1 + 9];
            tmp_C[10] = C[i0][i1 + 10];
            tmp_C[11] = C[i0][i1 + 11];
            tmp_C[12] = C[i0][i1 + 12];
            tmp_C[13] = C[i0][i1 + 13];
            tmp_C[14] = C[i0][i1 + 14];
            tmp_C[15] = C[i0][i1 + 15];
            vC[i0 * 15 + i1/16] = tmp_C;
        }
    }
}

void task0(float temp2[200][240], float alpha, float beta, float16 vtemp2[3000], float16 vC[3000], float8 vA[5000], float16 vB[3000]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 25; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 4; i2++) {
                    for (int j2 = 0; j2 < 240; j2++) {
                        i = i0 * 8 + i1 * 4 + i2;
                        j = j0 * 240 + j2;
                        temp2[i][j] =0 ;
                     }
                }
            }
        }
    }
}

float compute_operation_task1(    float output,    float arg0,    float arg1,    float arg2,    int k,    int i) {
    if ( k < i){
        return arg0 + arg1 * arg2;
    }
    else{
        return output;
    }
}
void task1(float temp2[200][240], float B[200][240], float A[200][200], float alpha, float beta, float16 vtemp2[3000], float16 vC[3000], float8 vA[5000], float16 vB[3000]) {
    int j;
    int i;
    int k;
    for (int j0 = 0; j0 < 1; j0++) {
        for (int i0 = 0; i0 < 1; i0++) {
            for (int k0 = 0; k0 < 199; k0++) {
                for (int i1 = 0; i1 < 100; i1++) {
#pragma HLS pipeline
                    for (int j2 = 0; j2 < 240; j2++) {
                        for (int i2 = 0; i2 < 2; i2++) {
                            for (int k2 = 0; k2 < 1; k2++) {
                                j = j0 * 240 + j2;
                                i = i0 * 200 + i1 * 2 + i2;
                                k = k0 * 1 + k2;
//                                temp2[i][j] +=B[k][j] * A[i][k] ;
                                temp2[i][j] = compute_operation_task1(temp2[i][j], temp2[i][j], B[k][j], A[i][k], k, i);
                             }
                        }
                    }
                }
            }
        }
    }
}

void task2(float temp2[200][240], float C[200][240], float B[200][240], float A[200][200], float alpha, float beta, float16 vtemp2[3000], float16 vC[3000], float8 vA[5000], float16 vB[3000]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 8; j0++) {
            for (int i1 = 0; i1 < 200; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 1; i2++) {
                    for (int j2 = 0; j2 < 30; j2++) {
                        i = i0 * 200 + i1 * 1 + i2;
                        j = j0 * 30 + j2;
                        C[i][j] =beta * C[i][j] + alpha * B[i][j] * A[i][i] + alpha * temp2[i][j] ;
                     }
                }
            }
        }
    }
}

float compute_operation_task3(    float output,    float arg0,    float arg1,    float arg2,    float arg3,    int k,    int i) {
    if ( k < i){
        return arg0 + arg1 * arg2 * arg3;
    }
    else{
        return output;
    }
}
void task3(float C[200][240], float B[200][240], float A[200][200], float alpha, float beta, float16 vtemp2[3000], float16 vC[3000], float8 vA[5000], float16 vB[3000]) {
    int i;
    int j;
    int k;
    for (int i0 = 0; i0 < 100; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int k0 = 0; k0 < 1; k0++) {
                for (int k1 = 0; k1 < 199; k1++) {
#pragma HLS pipeline
                        for (int j2 = 0; j2 < 240; j2++) {
                            for (int k2 = 0; k2 < 1; k2++) {
                    for (int i2 = 0; i2 < 2; i2++) {
                                i = i0 * 2 + i2;
                                j = j0 * 240 + j2;
                                k = k0 * 199 + k1 * 1 + k2;
//                                C[k][j] +=alpha * B[i][j] * A[i][k] ;
                                C[k][j] = compute_operation_task3(C[k][j], C[k][j], alpha, B[i][j], A[i][k], k, i);
                             }
                        }
                    }
                }
            }
        }
    }
}

void kernel_nlp(float alpha, float beta, float16 vtemp2[3000], float16 vC[3000], float8 vA[5000], float16 vB[3000]) {

#pragma HLS INTERFACE m_axi port=alpha offset=slave bundle=kernel_alpha
#pragma HLS INTERFACE m_axi port=beta offset=slave bundle=kernel_beta
#pragma HLS INTERFACE m_axi port=vtemp2 offset=slave bundle=kernel_temp2
#pragma HLS INTERFACE m_axi port=vC offset=slave bundle=kernel_C
#pragma HLS INTERFACE m_axi port=vB offset=slave bundle=kernel_B
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=beta bundle=control
#pragma HLS INTERFACE s_axilite port=vtemp2 bundle=control
#pragma HLS INTERFACE s_axilite port=vC bundle=control
#pragma HLS INTERFACE s_axilite port=vB bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float temp2[200][240];
    float C[200][240];
    float B[200][240];
    float A[200][200];

#pragma HLS ARRAY_PARTITION variable=temp2 cyclic factor=4 dim=1
#pragma HLS ARRAY_PARTITION variable=temp2 cyclic factor=240 dim=2
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=1 dim=1
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=240 dim=2
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=240 dim=2
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=8 dim=2

    load_temp2(temp2, vtemp2);
    load_B(B, vB);
    load_A(A, vA);
    load_C(C, vC);
    task0(temp2, alpha, beta, vtemp2, vC, vA, vB);
    task1(temp2, B, A, alpha, beta, vtemp2, vC, vA, vB);
    task2(temp2, C, B, A, alpha, beta, vtemp2, vC, vA, vB);
    task3(C, B, A, alpha, beta, vtemp2, vC, vA, vB);
    store_temp2(temp2, vtemp2);
    store_C(C, vC);
}