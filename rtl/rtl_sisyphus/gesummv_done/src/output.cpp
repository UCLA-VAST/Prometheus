#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_tmp (float tmp[250], float2 vtmp[125]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_tmp = vtmp[i0/2];
        tmp[i0 + 0] = tmp_tmp[0];
        tmp[i0 + 1] = tmp_tmp[1];
    }
}
void load_y (float y[250], float2 vy[125]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_y = vy[i0/2];
        y[i0 + 0] = tmp_y[0];
        y[i0 + 1] = tmp_y[1];
    }
}
void load_x (float x[250], float2 vx[125]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_x = vx[i0/2];
        x[i0 + 0] = tmp_x[0];
        x[i0 + 1] = tmp_x[1];
    }
}
void load_A (float A[250][250], float2 vA[31250]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=1){
        for (int i1 = 0; i1 < 250; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_A = vA[i0 * 125 + i1/2];
            A[i0][i1 + 0] = tmp_A[0];
            A[i0][i1 + 1] = tmp_A[1];
        }
    }
}
void load_B (float B[250][250], float2 vB[31250]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=1){
        for (int i1 = 0; i1 < 250; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_B = vB[i0 * 125 + i1/2];
            B[i0][i1 + 0] = tmp_B[0];
            B[i0][i1 + 1] = tmp_B[1];
        }
    }
}
void store_tmp (float tmp[250], float2 vtmp[125]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_tmp;
        tmp_tmp[0] = tmp[i0 + 0];
        tmp_tmp[1] = tmp[i0 + 1];
        vtmp[i0/2] = tmp_tmp;
    }
}
void store_y (float y[250], float2 vy[125]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 250; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_y;
        tmp_y[0] = y[i0 + 0];
        tmp_y[1] = y[i0 + 1];
        vy[i0/2] = tmp_y;
    }
}

void task0(float tmp[250], float alpha, float beta, float2 vA[31250], float2 vB[31250], float2 vtmp[125], float2 vx[125], float2 vy[125]) {
    int i;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
            for (int i2 = 0; i2 < 125; i2++) {
                i = i0 * 250 + i1 * 125 + i2;
                tmp[i] =0.0 ;
             }
        }
    }
}

void task1(float y[250], float alpha, float beta, float2 vA[31250], float2 vB[31250], float2 vtmp[125], float2 vx[125], float2 vy[125]) {
    int i;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
            for (int i2 = 0; i2 < 125; i2++) {
                i = i0 * 250 + i1 * 125 + i2;
                y[i] =0.0 ;
             }
        }
    }
}

void task2(float tmp[250], float x[250], float A[250][250], float alpha, float beta, float2 vA[31250], float2 vB[31250], float2 vtmp[125], float2 vx[125], float2 vy[125]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i1 = 0; i1 < 125; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 2; i2++) {
                    float red = 0;
                    for (int j2 = 0; j2 < 250; j2++) {
                        i = i0 * 250 + i1 * 2 + i2;
                        j = j0 * 250 + j2;
                        red += A[i][j] * x[j] ;
                     }
                    tmp[i] = red;
                }
            }
        }
    }
}

void task3(float B[250][250], float y[250], float x[250], float alpha, float beta, float2 vA[31250], float2 vB[31250], float2 vtmp[125], float2 vx[125], float2 vy[125]) {
    int i;
    int j;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int j0 = 0; j0 < 1; j0++) {
            for (int i1 = 0; i1 < 125; i1++) {
#pragma HLS pipeline
                for (int i2 = 0; i2 < 2; i2++) {
                    float red = 0;
                    for (int j2 = 0; j2 < 250; j2++) {
                        i = i0 * 250 + i1 * 2 + i2;
                        j = j0 * 250 + j2;
                        red += B[i][j] * x[j] ;
                     }
                    y[i] = red;
                }
            }
        }
    }
}

void task4(float y[250], float tmp[250], float alpha, float beta, float2 vA[31250], float2 vB[31250], float2 vtmp[125], float2 vx[125], float2 vy[125]) {
    int i;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
            for (int i2 = 0; i2 < 125; i2++) {
                i = i0 * 250 + i1 * 125 + i2;
                y[i] =alpha * tmp[i] + beta * y[i] ;
             }
        }
    }
}

void kernel_nlp(float alpha, float beta, float2 vA[31250], float2 vB[31250], float2 vtmp[125], float2 vx[125], float2 vy[125]) {

#pragma HLS INTERFACE m_axi port=alpha offset=slave bundle=kernel_alpha
#pragma HLS INTERFACE m_axi port=beta offset=slave bundle=kernel_beta
#pragma HLS INTERFACE m_axi port=vB offset=slave bundle=kernel_B
#pragma HLS INTERFACE m_axi port=vy offset=slave bundle=kernel_y
#pragma HLS INTERFACE m_axi port=vtmp offset=slave bundle=kernel_tmp
#pragma HLS INTERFACE m_axi port=vx offset=slave bundle=kernel_x
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE s_axilite port=alpha bundle=control
#pragma HLS INTERFACE s_axilite port=beta bundle=control
#pragma HLS INTERFACE s_axilite port=vB bundle=control
#pragma HLS INTERFACE s_axilite port=vy bundle=control
#pragma HLS INTERFACE s_axilite port=vtmp bundle=control
#pragma HLS INTERFACE s_axilite port=vx bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float B[250][250];
    float y[250];
    float tmp[250];
    float x[250];
    float A[250][250];

#pragma HLS ARRAY_PARTITION variable=B cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=B cyclic factor=250 dim=2
#pragma HLS ARRAY_PARTITION variable=y cyclic factor=250 dim=1
#pragma HLS ARRAY_PARTITION variable=tmp cyclic factor=250 dim=1
#pragma HLS ARRAY_PARTITION variable=x cyclic factor=250 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=4 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=250 dim=2

    load_tmp(tmp, vtmp);
    load_y(y, vy);
    load_x(x, vx);
    load_A(A, vA);
    load_B(B, vB);
    task0(tmp, alpha, beta, vA, vB, vtmp, vx, vy);
    task1(y, alpha, beta, vA, vB, vtmp, vx, vy);
    task2(tmp, x, A, alpha, beta, vA, vB, vtmp, vx, vy);
    task3(B, y, x, alpha, beta, vA, vB, vtmp, vx, vy);
    task4(y, tmp, alpha, beta, vA, vB, vtmp, vx, vy);
    store_tmp(tmp, vtmp);
    store_y(y, vy);
}
