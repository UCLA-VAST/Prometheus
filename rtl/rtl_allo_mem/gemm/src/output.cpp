
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


#include <hls_vector.h>
#include <iostream>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

using namespace std;
void mm1(
  float v0[200][240],
  float v1[240][220],
  float v2[200][220]
) {	// L2
#pragma HLS dataflow
#pragma HLS array_partition variable=v1 complete dim=2
  l_mm1_i0: for (int i0 = 0; i0 < 200; i0++) {	// L3
  #pragma HLS dataflow
    float v4[220];	// L4
    #pragma HLS array_partition variable=v4 complete dim=1
    l_j0_init: for (int j0_init = 0; j0_init < 220; j0_init++) {	// L6
    // #pragma HLS pipeline II=1
    #pragma HLS unroll
      v4[j0_init] = 0.000000;	// L7
    }
    l_S_k0_0_k0: for (int k0 = 0; k0 < 240; k0++) {	// L9
    #pragma HLS pipeline II=4
      l_j0: for (int j0 = 0; j0 < 220; j0++) {	// L10
        float v8 = v0[i0][k0];	// L11
        float v9 = v1[k0][j0];	// L12
        float v10 = v8 * v9;	// L13
        float v11 = v4[j0];	// L14
        float v12 = v11 + v10;	// L15
        v4[j0] = v12;	// L16
      }
    }
    l_j0_back: for (int j0_back = 0; j0_back < 220; j0_back++) {	// L19
    // #pragma HLS pipeline II=1
    #pragma HLS unroll
      float v14 = v4[j0_back];	// L20
      v2[i0][j0_back] = v14;	// L21
    }
  }
}

void ele_add(
  float v15[200][220],
  float v16[200][220],
  float v17[200][220]
) {	// L26
#pragma HLS array_partition variable=v15 complete dim=2
#pragma HLS array_partition variable=v16 complete dim=2
#pragma HLS array_partition variable=v17 complete dim=2
  l_S_i2_j2_0_i2: for (int i2 = 0; i2 < 200; i2++) {	// L27
    l_j2: for (int j2 = 0; j2 < 220; j2++) {	// L28
      #pragma HLS pipeline II=1
      float v20 = v16[i2][j2];	// L29
      float v21 = v20 * 0.100000;	// L31
      float v22 = v15[i2][j2];	// L32
      float v23 = v21 + v22;	// L33
      v17[i2][j2] = v23;	// L34
    }
  }
}

void kernel_nlp(
  float16 vv24[3000],
  float16 vv25[3360],
  float16 vv26[2800],
  float16 vv27[2800]
) {	// L39


  #pragma HLS interface m_axi port=vv24 offset=slave bundle=gmem2
  #pragma HLS interface m_axi port=vv25 offset=slave bundle=gmem3
  #pragma HLS interface m_axi port=vv26 offset=slave bundle=gmem4
  #pragma HLS interface m_axi port=vv27 offset=slave bundle=gmem5



  #pragma HLS INTERFACE s_axilite port = vv24 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv25 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv26 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv27 bundle = control


  #pragma HLS INTERFACE s_axilite port = return bundle = control

  float v24[200][240];
  float v25[240][220];
  float v26[200][220];
  float v27[200][220];

  for (int i=0; i<200; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv24[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 240)
            v24[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<240; i++) {
    for (int j=0; j<224; j+=16) {
        float16 v = vv25[i*224/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 220)
            v25[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<200; i++) {
    for (int j=0; j<224; j+=16) {
        float16 v = vv26[i*224/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 220)
            v26[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<200; i++) {
    for (int j=0; j<224; j+=16) {
        float16 v = vv27[i*224/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 220)
            v27[i][j+k] = v[k];
        }
    }
  }


#pragma HLS dataflow
  float out_AB[200][220];	// L40
  mm1(v24, v25, out_AB);	// L41
  ele_add(out_AB, v26, v27);	// L42

  for (int i=0; i<200; i++) {
    for (int j=0; j<224; j+=16) {
        float16 v;
        for (int k=0; k<16; k++) {
            if (j+k < 220)
            v[k] = v27[i][j+k];
        }
        vv27[i*224/16+j/16] = v;
    }
  }

}

