#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

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
void load_B2 (float B2[200][240], float16 vB2[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_B2 = vB2[i0 * 15 + i1/16];
            B2[i0][i1 + 0] = tmp_B2[0];
            B2[i0][i1 + 1] = tmp_B2[1];
            B2[i0][i1 + 2] = tmp_B2[2];
            B2[i0][i1 + 3] = tmp_B2[3];
            B2[i0][i1 + 4] = tmp_B2[4];
            B2[i0][i1 + 5] = tmp_B2[5];
            B2[i0][i1 + 6] = tmp_B2[6];
            B2[i0][i1 + 7] = tmp_B2[7];
            B2[i0][i1 + 8] = tmp_B2[8];
            B2[i0][i1 + 9] = tmp_B2[9];
            B2[i0][i1 + 10] = tmp_B2[10];
            B2[i0][i1 + 11] = tmp_B2[11];
            B2[i0][i1 + 12] = tmp_B2[12];
            B2[i0][i1 + 13] = tmp_B2[13];
            B2[i0][i1 + 14] = tmp_B2[14];
            B2[i0][i1 + 15] = tmp_B2[15];
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
void store_B (float B[200][240], float16 vB[3000]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 200; i0+=1){
        for (int i1 = 0; i1 < 240; i1+=16){
#pragma HLS pipeline II=1
            float16 tmp_B;
            tmp_B[0] = B[i0][i1 + 0];
            tmp_B[1] = B[i0][i1 + 1];
            tmp_B[2] = B[i0][i1 + 2];
            tmp_B[3] = B[i0][i1 + 3];
            tmp_B[4] = B[i0][i1 + 4];
            tmp_B[5] = B[i0][i1 + 5];
            tmp_B[6] = B[i0][i1 + 6];
            tmp_B[7] = B[i0][i1 + 7];
            tmp_B[8] = B[i0][i1 + 8];
            tmp_B[9] = B[i0][i1 + 9];
            tmp_B[10] = B[i0][i1 + 10];
            tmp_B[11] = B[i0][i1 + 11];
            tmp_B[12] = B[i0][i1 + 12];
            tmp_B[13] = B[i0][i1 + 13];
            tmp_B[14] = B[i0][i1 + 14];
            tmp_B[15] = B[i0][i1 + 15];
            vB[i0 * 15 + i1/16] = tmp_B;
        }
    }
}

float compute_operation_task0(    float output,    float arg0,    float arg1,    float arg2,    int i,    int k) {
    if ( k >= i + 1){
        return arg0 + arg1 * arg2;
    }
    else{
        return output;
    }
}
void task0(float B[200][240], float B2[200][240], float A[200][200], float alpha, float8 vA[5000], float16 vB[3000], float16 vB2[3000]) {
    int k;
    int j;
    int i;
    for (int k0 = 0; k0 < 25; k0++) {
        for (int j0 = 0; j0 < 3; j0++) {
            for (int i0 = 0; i0 < 1; i0++) {
                for (int i1 = 0; i1 < 100; i1++) {
#pragma HLS pipeline
                        for (int j2 = 0; j2 < 80; j2++) {
                            for (int i2 = 0; i2 < 2; i2++) {
                    for (int k2 = 0; k2 < 8; k2++) {
                                k = k0 * 8 + k2;
                                j = j0 * 80 + j2;
                                i = i0 * 200 + i1 * 2 + i2;
//                                B[i][j] +=A[k][i] * B2[k][j] ;
                                B[i][j] = compute_operation_task0(B[i][j], B[i][j], A[k][i], B2[k][j], i, k);
                             }
                        }
                    }
                }
            }
        }
    }
}

void task1(float B[200][240], float alpha, float8 vA[5000], float16 vB[3000], float16 vB2[3000]) {
    int j;
    int i;
    for (int j0 = 0; j0 < 3; j0++) {
        for (int i0 = 0; i0 < 1; i0++) {
            for (int i1 = 0; i1 < 25; i1++) {
#pragma HLS pipeline
                for (int j2 = 0; j2 < 80; j2++) {
                    for (int i2 = 0; i2 < 8; i2++) {
                        j = j0 * 80 + j2;
                        i = i0 * 200 + i1 * 8 + i2;
                        B[i][j] =alpha * B[i][j] ;
                     }
                }
            }
        }
    }
}

void kernel_nlp(float alpha, float8 vA[5000], float16 vB[3000], float16 vB2[3000]) {

#pragma HLS INTERFACE m_axi port=alpha offset=slave bundle=kernel_alpha
#pragma HLS INTERFACE m_axi port=vB offset=slave bundle=kernel_B
#pragma HLS INTERFACE m_axi port=vB2 offset=slave bundle=kernel_B2
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=vB bundle=control
#pragma HLS INTERFACE s_axilite port=vB2 bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float B[200][240];
    float B2[200][240];
    float A[200][200];

#pragma HLS ARRAY_PARTITION variable=B cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=B2 cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=80 dim=2
#pragma HLS ARRAY_PARTITION variable=B2 cyclic factor=80 dim=2
#pragma HLS ARRAY_PARTITION variable=B2 cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=B2 cyclic factor=80 dim=2
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=128 dim=2

    load_B(B, vB);
    load_B2(B2, vB2);
    load_A(A, vA);
    task0(B, B2, A, alpha, vA, vB, vB2);
    task1(B, alpha, vA, vB, vB2);
    store_B(B, vB);
}
