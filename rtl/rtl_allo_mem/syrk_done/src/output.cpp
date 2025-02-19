
//===------------------------------------------------------------*- C++ -*-===//
//
// Automatically generated file for High-level Synthesis (HLS).
//
//===----------------------------------------------------------------------===//
#include <algorithm>
#include <ap_axi_sdata.h>
#include <ap_fixed.h>
#include <ap_int.h>
#include <hls_math.h>
#include <hls_stream.h>
#include <math.h>
#include <stdint.h>

#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

using namespace std;
void update_C(
  float v0[240][240],
  float v1[240][240]
) {	// L4
  #pragma HLS array_partition variable=v0 complete dim=2

  #pragma HLS array_partition variable=v1 complete dim=2

  l_update_i0: for (int i0 = 0; i0 < 240; i0++) {	// L5
  #pragma HLS pipeline II=1
    l_j0: for (int j0 = 0; j0 < 240; j0++) {	// L6
      bool v4 = j0 <= i0;	// L7
      if (v4) {	// L8
        float v5 = v0[i0][j0];	// L9
        float v6 = v5 * 1.200000;	// L11
        v1[i0][j0] = v6;	// L12
      }
    }
  }
}

void compute_sum(
  float v7[240][200],
  float v8[240][200],
  float v9[240][240],
  float v10[240][240]
) {	// L18
  #pragma HLS array_partition variable=v8 complete dim=1

  #pragma HLS array_partition variable=v9 complete dim=2

  #pragma HLS array_partition variable=v10 complete dim=2

  float buffer[240][240];	// L19
  #pragma HLS array_partition variable=buffer complete dim=2

  l_load_i01: for (int i01 = 0; i01 < 240; i01++) {	// L20
  #pragma HLS pipeline II=1
    l_j01: for (int j01 = 0; j01 < 240; j01++) {	// L21
      float v14 = v9[i01][j01];	// L22
      buffer[i01][j01] = v14;	// L23
    }
  }
  l_sum_i1: for (int i1 = 0; i1 < 240; i1++) {	// L26
    l_k1: for (int k1 = 0; k1 < 200; k1++) {	// L27
    #pragma HLS pipeline II=1
      l_j1: for (int j1 = 0; j1 < 240; j1++) {	// L28
        bool v18 = j1 <= i1;	// L29
        if (v18) {	// L30
          float v19 = v7[i1][k1];	// L31
          float v20 = v19 * 1.500000;	// L33
          float v21 = v8[j1][k1];	// L34
          float v22 = v20 * v21;	// L35
          float v23 = buffer[i1][j1];	// L36
          float v24 = v23 + v22;	// L37
          buffer[i1][j1] = v24;	// L38
        }
      }
    }
  }
  l_store_i2: for (int i2 = 0; i2 < 240; i2++) {	// L43
  #pragma HLS pipeline II=1
    l_j2: for (int j2 = 0; j2 < 240; j2++) {	// L44
      float v27 = buffer[i2][j2];	// L45
      v10[i2][j2] = v27;	// L46
    }
  }
}

void kernel_nlp(
  float16 vv28[240 * 208 / 16],
  float16 vv29[240 * 208 / 16],
  float16 vv30[240 * 240 / 16],
  float16 vv31[240 * 240 / 16]
) {	// L51

  #pragma HLS interface m_axi port=vv28 offset=slave bundle=gmem0
  #pragma HLS interface m_axi port=vv29 offset=slave bundle=gmem1
  #pragma HLS interface m_axi port=vv30 offset=slave bundle=gmem2
  #pragma HLS interface m_axi port=vv31 offset=slave bundle=gmem3

  #pragma HLS INTERFACE s_axilite port = vv28 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv29 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv30 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv31 bundle = control


  #pragma HLS INTERFACE s_axilite port = return bundle = control

  float v28[240][200];
  float v29[240][200];
  float v30[240][240];
  float v31[240][240];

  #pragma HLS dataflow
  #pragma HLS array_partition variable=v29 complete dim=1

  #pragma HLS array_partition variable=v30 complete dim=2

  #pragma HLS array_partition variable=v31 complete dim=2

  float C[240][240];	// L52
  #pragma HLS array_partition variable=C complete dim=2

  for (int i=0; i<240; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv28[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v28[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv29[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v29[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv30[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v30[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv31[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v31[i][j+k] = v[k];
        }
    }
  }


  update_C(v30, C);	// L53
  compute_sum(v28, v29, C, v31);	// L54

  for (int i=0; i<240; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v;
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
          v[k] = v31[i][j+k];
        }
        vv31[i*240/16+j/16] = v;
    }
  }
}

