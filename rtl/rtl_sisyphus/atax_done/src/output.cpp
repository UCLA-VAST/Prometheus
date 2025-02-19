#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_y (float y[410], float2 vy[205]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_y = vy[i0/2];
        y[i0 + 0] = tmp_y[0];
        y[i0 + 1] = tmp_y[1];
    }
}
void load_tmp (float tmp[390], float2 vtmp[195]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 390; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_tmp = vtmp[i0/2];
        tmp[i0 + 0] = tmp_tmp[0];
        tmp[i0 + 1] = tmp_tmp[1];
    }
}
void load_x (float x[410], float2 vx[205]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_x = vx[i0/2];
        x[i0 + 0] = tmp_x[0];
        x[i0 + 1] = tmp_x[1];
    }
}
void load_A (float A[390][410], float2 vA[79950]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 390; i0+=1){
        for (int i1 = 0; i1 < 410; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_A = vA[i0 * 205 + i1/2];
            A[i0][i1 + 0] = tmp_A[0];
            A[i0][i1 + 1] = tmp_A[1];
        }
    }
}
void store_y (float y[410], float2 vy[205]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_y;
        tmp_y[0] = y[i0 + 0];
        tmp_y[1] = y[i0 + 1];
        vy[i0/2] = tmp_y;
    }
}
void store_tmp (float tmp[390], float2 vtmp[195]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 390; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_tmp;
        tmp_tmp[0] = tmp[i0 + 0];
        tmp_tmp[1] = tmp[i0 + 1];
        vtmp[i0/2] = tmp_tmp;
    }
}

void task0(float y[410], float2 vA[79950], float2 vx[205], float2 vy[205], float2 vtmp[195]) {
    int j;
    for (int j0 = 0; j0 < 1; j0++) {
        for (int j1 = 0; j1 < 2; j1++) {
#pragma HLS pipeline
            for (int j2 = 0; j2 < 205; j2++) {
                j = j0 * 410 + j1 * 205 + j2;
                y[j] =0.0 ;
             }
        }
    }
}

void task1(float tmp[390], float2 vA[79950], float2 vx[205], float2 vy[205], float2 vtmp[195]) {
    int i;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
            for (int i2 = 0; i2 < 195; i2++) {
                i = i0 * 390 + i1 * 195 + i2;
                tmp[i] =0.0 ;
             }
        }
    }
}

void task2(float x[410], float A[390][410], float tmp[390], float2 vA[79950], float2 vx[205], float2 vy[205], float2 vtmp[195]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i1 = 0; i1 < 195; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 2; i2++) {
                    float red = 0;
                    for (int j2 = 0; j2 < 410; j2++) {
                        i = i0 * 390 + i1 * 2 + i2;
                        j = j0 * 410 + j2;
                        red +=  + A[i][j] * x[j] ;
                     }
                    tmp[i] = red;
                }
            }
        }
    }
}

void task3(float y[410], float A[390][410], float tmp[390], float2 vA[79950], float2 vx[205], float2 vy[205], float2 vtmp[195]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i1 = 0; i1 < 195; i1++) {
#pragma HLS pipeline
                    for (int j2 = 0; j2 < 410; j2++) {
                for (int i2 = 0; i2 < 2; i2++) {
                        i = i0 * 390 + i1 * 2 + i2;
                        j = j0 * 410 + j2;
                        y[j] =y[j] + A[i][j] * tmp[i] ;
                     }
                }
            }
        }
    }
}

void kernel_nlp(float2 vA[79950], float2 vx[205], float2 vy[205], float2 vtmp[195]) {

#pragma HLS INTERFACE m_axi port=vx offset=slave bundle=kernel_x
#pragma HLS INTERFACE m_axi port=vy offset=slave bundle=kernel_y
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE m_axi port=vtmp offset=slave bundle=kernel_tmp
#pragma HLS INTERFACE s_axilite port=vx bundle=control
#pragma HLS INTERFACE s_axilite port=vy bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=vtmp bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float x[410];
    float y[410];
    float A[390][410];
    float tmp[390];

#pragma HLS ARRAY_PARTITION variable=x cyclic factor=410 dim=1
#pragma HLS ARRAY_PARTITION variable=y cyclic factor=410 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=410 dim=2
#pragma HLS ARRAY_PARTITION variable=tmp cyclic factor=390 dim=1

    load_y(y, vy);
    load_tmp(tmp, vtmp);
    load_x(x, vx);
    load_A(A, vA);
    task0(y, vA, vx, vy, vtmp);
    task1(tmp, vA, vx, vy, vtmp);
    task2(x, A, tmp, vA, vx, vy, vtmp);
    task3(y, A, tmp, vA, vx, vy, vtmp);
    store_tmp(tmp, vtmp);
    store_y(y, vy);
}
