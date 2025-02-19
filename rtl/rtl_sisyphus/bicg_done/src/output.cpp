#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>
#include <cstring>

typedef hls::vector<float,16> float16;
typedef hls::vector<float,8> float8;
typedef hls::vector<float,4> float4;
typedef hls::vector<float,2> float2;
typedef hls::vector<float,1> float1;

void load_s (float s[390], float2 vs[195]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 390; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_s = vs[i0/2];
        s[i0 + 0] = tmp_s[0];
        s[i0 + 1] = tmp_s[1];
    }
}
void load_q (float q[410], float2 vq[205]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_q = vq[i0/2];
        q[i0 + 0] = tmp_q[0];
        q[i0 + 1] = tmp_q[1];
    }
}
void load_A (float A[410][390], float2 vA[79950]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=1){
        for (int i1 = 0; i1 < 390; i1+=2){
#pragma HLS pipeline II=1
            float2 tmp_A = vA[i0 * 195 + i1/2];
            A[i0][i1 + 0] = tmp_A[0];
            A[i0][i1 + 1] = tmp_A[1];
        }
    }
}
void load_r (float r[410], float2 vr[205]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_r = vr[i0/2];
        r[i0 + 0] = tmp_r[0];
        r[i0 + 1] = tmp_r[1];
    }
}
void load_p (float p[390], float2 vp[195]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 390; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_p = vp[i0/2];
        p[i0 + 0] = tmp_p[0];
        p[i0 + 1] = tmp_p[1];
    }
}
void store_s (float s[390], float2 vs[195]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 390; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_s;
        tmp_s[0] = s[i0 + 0];
        tmp_s[1] = s[i0 + 1];
        vs[i0/2] = tmp_s;
    }
}
void store_q (float q[410], float2 vq[205]) {
#pragma HLS inline off
    for (int i0 = 0; i0 < 410; i0+=2){
#pragma HLS pipeline II=1
        float2 tmp_q;
        tmp_q[0] = q[i0 + 0];
        tmp_q[1] = q[i0 + 1];
        vq[i0/2] = tmp_q;
    }
}

void task0(float s[390], float2 vA[79950], float2 vs[195], float2 vq[205], float2 vp[195], float2 vr[205]) {
    int i;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
            for (int i2 = 0; i2 < 195; i2++) {
                i = i0 * 390 + i1 * 195 + i2;
                s[i] =0.0 ;
             }
        }
    }
}

void task1(float q[410], float2 vA[79950], float2 vs[195], float2 vq[205], float2 vp[195], float2 vr[205]) {
    int i;
    for (int i0 = 0; i0 < 1; i0++) {
        for (int i1 = 0; i1 < 2; i1++) {
#pragma HLS pipeline
            for (int i2 = 0; i2 < 205; i2++) {
                i = i0 * 410 + i1 * 205 + i2;
                q[i] =0.0 ;
             }
        }
    }
}

void task2(float s[390], float A[410][390], float r[410], float2 vA[79950], float2 vs[195], float2 vq[205], float2 vp[195], float2 vr[205]) {
    int j;
    int i;
    for (int j0 = 0; j0 < 1; j0++) {
        for (int i0 = 0; i0 < 1; i0++) {
            for (int j1 = 0; j1 < 195; j1++) {
#pragma HLS pipeline
                for (int j2 = 0; j2 < 2; j2++) {
                    float red = 0;
                    for (int i2 = 0; i2 < 410; i2++) {
                        j = j0 * 390 + j1 * 2 + j2;
                        i = i0 * 410 + i2;
                        red +=  + r[i] * A[i][j] ;
                     }
                    s[j] = red;
                }
            }
        }
    }
}

void task3(float q[410], float A[410][390], float p[390], float2 vA[79950], float2 vs[195], float2 vq[205], float2 vp[195], float2 vr[205]) {
    int j;
    int i;
    for (int j0 = 0; j0 < 1; j0++) {
        for (int i0 = 0; i0 < 1; i0++) {
            for (int j1 = 0; j1 < 195; j1++) {
#pragma HLS pipeline
                    for (int i2 = 0; i2 < 410; i2++) {
                for (int j2 = 0; j2 < 2; j2++) {
                        j = j0 * 390 + j1 * 2 + j2;
                        i = i0 * 410 + i2;
                        q[i] =q[i] + A[i][j] * p[j] ;
                     }
                }
            }
        }
    }
}

void kernel_nlp(float2 vA[79950], float2 vs[195], float2 vq[205], float2 vp[195], float2 vr[205]) {

#pragma HLS INTERFACE m_axi port=vq offset=slave bundle=kernel_q
#pragma HLS INTERFACE m_axi port=vs offset=slave bundle=kernel_s
#pragma HLS INTERFACE m_axi port=vA offset=slave bundle=kernel_A
#pragma HLS INTERFACE m_axi port=vp offset=slave bundle=kernel_p
#pragma HLS INTERFACE m_axi port=vr offset=slave bundle=kernel_r
#pragma HLS INTERFACE s_axilite port=vq bundle=control
#pragma HLS INTERFACE s_axilite port=vs bundle=control
#pragma HLS INTERFACE s_axilite port=vA bundle=control
#pragma HLS INTERFACE s_axilite port=vp bundle=control
#pragma HLS INTERFACE s_axilite port=vr bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float q[410];
    float s[390];
    float A[410][390];
    float p[390];
    float r[410];

#pragma HLS ARRAY_PARTITION variable=q cyclic factor=410 dim=1
#pragma HLS ARRAY_PARTITION variable=s cyclic factor=390 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=410 dim=1
#pragma HLS ARRAY_PARTITION variable=A cyclic factor=2 dim=2
#pragma HLS ARRAY_PARTITION variable=p cyclic factor=390 dim=1
#pragma HLS ARRAY_PARTITION variable=r cyclic factor=410 dim=1

    load_s(s, vs);
    load_q(q, vq);
    load_A(A, vA);
    load_r(r, vr);
    load_p(p, vp);
    task0(s, vA, vs, vq, vp, vr);
    task1(q, vA, vs, vq, vp, vr);
    task2(s, A, r, vA, vs, vq, vp, vr);
    task3(q, A, p, vA, vs, vq, vp, vr);
    store_s(s, vs);
    store_q(q, vq);
}
