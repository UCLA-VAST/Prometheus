#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_C (float C[240][240], float16 vC[3600]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 240; i0+=1){
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
void load_A_S1 (float A[120][200], float8 vA[6000], int d0) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 120; i0+=1){
        for (int i1 = 0; i1 < 200; i1+=8){
#pragma HLS pipeline II=1
            float8 tmp_A = vA[(i0 + d0 * 120) * 25 + i1/8];
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
void store_C (float C[240][240], float16 vC[3600]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 240; i0+=1){
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

float compute_operation_task0(    float output,    float arg0,    float arg1,    int j,    int i) {
    if ( j < i + 1){
        return arg0 * arg1;
    }
    else{
        return output;
    }
}
void task0(float C[240][240], float alpha, float beta, float16 vC[3600], float8 vA[6000]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i1 = 0; i1 < 80; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 3; i2++) {
                    for (int j2 = 0; j2 < 240; j2++) {
                        i = i0 * 240 + i1 * 3 + i2;
                        j = j0 * 240 + j2;
//                        C[i][j] *=beta ;
                        C[i][j] = compute_operation_task0(C[i][j], C[i][j], beta, j, i);
                     }
                }
            }
        }
    }
}

float compute_operation_task1(    float output,    float arg0,    float arg1,    float arg2,    float arg3,    int j,    int i) {
    if ( j < i + 1){
        return arg0 + arg1 * arg2 * arg3;
    }
    else{
        return output;
    }
}
void task1(float C[240][240], float A[120][200], float alpha, float beta, float16 vC[3600], float8 vA[6000]) {
    int j;
    int i;
    int k;
    for (int j0 = 0; j0 < 1; j0++) {
        for (int i0 = 0; i0 < 2; i0++) {
            load_A_S1(A, vA, i0);
            for (int k0 = 0; k0 < 200; k0++) {
                for (int i1 = 0; i1 < 40; i1++) {
#pragma HLS pipeline
                    for (int j2 = 0; j2 < 240; j2++) {
                        for (int i2 = 0; i2 < 3; i2++) {
                            for (int k2 = 0; k2 < 1; k2++) {
                                j = j0 * 240 + j2;
                                i = i0 * 120 + i1 * 3 + i2;
                                k = k0 * 1 + k2;
//                                C[i][j] +=alpha * A[i1*3 + i2][k] * A[j][k] ;
                                C[i][j] = compute_operation_task1(C[i][j], C[i][j], alpha, A[i1*3+i2][k], A[j][k], j, i);
                             }
                        }
                    }
                }
            }
        }
    }
}

void kernel_nlp(float alpha, float beta, float16 vC[3600], float8 vA[6000]) {

#pragma HLS INTERFACE m_axi port=alpha offset=slave bundle=kernel_alpha
#pragma HLS INTERFACE m_axi port=beta offset=slave bundle=kernel_beta
#pragma HLS INTERFACE m_axi port=vC offset=slave bundle=kernel_C
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=beta bundle=control
#pragma HLS INTERFACE s_axilite port=vC bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float C[240][240];
    float A_S1[120][200];

#pragma HLS ARRAY_PARTITION variable=C cyclic factor=3 dim=1
#pragma HLS ARRAY_PARTITION variable=C cyclic factor=240 dim=2
#pragma HLS ARRAY_PARTITION variable=A_S1 cyclic factor=240 dim=1
#pragma HLS ARRAY_PARTITION variable=A_S1 cyclic factor=1 dim=2

    load_C(C, vC);
    task0(C, alpha, beta, vC, vA);
    task1(C, A_S1, alpha, beta, vC, vA);
    store_C(C, vC);
}
