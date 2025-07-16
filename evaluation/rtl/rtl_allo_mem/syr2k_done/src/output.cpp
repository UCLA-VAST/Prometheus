
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
  float v9[240][200],
  float v10[240][200],
  float v11[240][240],
  float v12[240][240]
) {	// L18
  #pragma HLS array_partition variable=v7 complete dim=1

  #pragma HLS array_partition variable=v10 complete dim=1

  #pragma HLS array_partition variable=v11 complete dim=2

  #pragma HLS array_partition variable=v12 complete dim=2

  float buffer[240][240];	// L19
  #pragma HLS array_partition variable=buffer complete dim=2

  l_load_i01: for (int i01 = 0; i01 < 240; i01++) {	// L20
  #pragma HLS pipeline II=1
    l_j01: for (int j01 = 0; j01 < 240; j01++) {	// L21
      float v16 = v11[i01][j01];	// L22
      buffer[i01][j01] = v16;	// L23
    }
  }
  l_sum_i1: for (int i1 = 0; i1 < 240; i1++) {	// L26
    l_k1: for (int k1 = 0; k1 < 200; k1++) {	// L27
    #pragma HLS pipeline II=1
      l_j1: for (int j1 = 0; j1 < 240; j1++) {	// L28
        bool v20 = j1 <= i1;	// L29
        if (v20) {	// L30
          float v21 = v7[j1][k1];	// L31
          float v22 = v21 * 1.500000;	// L33
          float v23 = v9[i1][k1];	// L34
          float v24 = v22 * v23;	// L35
          float v25 = v10[j1][k1];	// L36
          float v26 = v25 * 1.500000;	// L37
          float v27 = v8[i1][k1];	// L38
          float v28 = v26 * v27;	// L39
          float v29 = v24 + v28;	// L40
          float v30 = buffer[i1][j1];	// L41
          float v31 = v30 + v29;	// L42
          buffer[i1][j1] = v31;	// L43
        }
      }
    }
  }
  l_store_i2: for (int i2 = 0; i2 < 240; i2++) {	// L48
  #pragma HLS pipeline II=1
    l_j2: for (int j2 = 0; j2 < 240; j2++) {	// L49
      float v34 = buffer[i2][j2];	// L50
      v12[i2][j2] = v34;	// L51
    }
  }
}

void kernel_nlp(
  float16 vv35[240 * 208 / 16],
  float16 vv36[240 * 208 / 16],
  float16 vv37[240 * 208 / 16],
  float16 vv38[240 * 208 / 16],
  float16 vv39[240 * 240 / 16],
  float16 vv40[240 * 240 / 16]
) {	// L56

  #pragma HLS interface m_axi port=vv35 offset=slave bundle=gmem0
  #pragma HLS interface m_axi port=vv36 offset=slave bundle=gmem1
  #pragma HLS interface m_axi port=vv37 offset=slave bundle=gmem2
  #pragma HLS interface m_axi port=vv38 offset=slave bundle=gmem3
  #pragma HLS interface m_axi port=vv39 offset=slave bundle=gmem4
  #pragma HLS interface m_axi port=vv40 offset=slave bundle=gmem5

  #pragma HLS INTERFACE s_axilite port = vv35 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv36 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv37 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv38 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv39 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv40 bundle = control


  #pragma HLS INTERFACE s_axilite port = return bundle = control

  float v35[240][200 ];
  float v36[240][200 ];
  float v37[240][200 ];
  float v38[240][200 ];
  float v39[240][240 ];
  float v40[240][240 ];



#pragma HLS dataflow
  #pragma HLS array_partition variable=v35 complete dim=1

  #pragma HLS array_partition variable=v38 complete dim=1

  #pragma HLS array_partition variable=v39 complete dim=2

  #pragma HLS array_partition variable=v40 complete dim=2

  float C[240][240];	// L57
  #pragma HLS array_partition variable=C complete dim=2

  for (int i=0; i<240; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv35[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v35[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv36[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v36[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv37[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v37[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv38[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v38[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv39[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v39[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv40[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v40[i][j+k] = v[k];
        }
    }
  }

  update_C(v39, C);	// L58
  compute_sum(v35, v36, v37, v38, C, v40);	// L59

  for (int i=0; i<240; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v;
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
          v[k] = v40[i][j+k];
        }
        vv40[i*240/16+j/16] = v;
    }
  }
}

