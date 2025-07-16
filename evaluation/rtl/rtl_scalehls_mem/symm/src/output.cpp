
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
#include <string.h>
#include <hls_vector.h>

using namespace std;

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

/// This is top function.
/// Latency=124800012, interval=124800012
/// DSP=5, BRAM=0
void kernel_nlp(
  float16 vv0[200 * 208 / 16],
  float16 vv1[200 * 240 / 16],
  float16 vv2[200 * 240 / 16],
  float v3,
  float v4
) {	// L5, [0,124800012)
  #pragma HLS interface m_axi port=vv0 offset=slave bundle=gmem0
  #pragma HLS interface m_axi port=vv1 offset=slave bundle=gmem1
  #pragma HLS interface m_axi port=vv2 offset=slave bundle=gmem2
  #pragma HLS interface m_axi port=v3 offset=slave bundle=gmem3
  #pragma HLS interface m_axi port=v4 offset=slave bundle=gmem4

  #pragma HLS INTERFACE s_axilite port = vv0 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv1 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv2 bundle = control
  #pragma HLS INTERFACE s_axilite port = v3 bundle = control
  #pragma HLS INTERFACE s_axilite port = v4 bundle = control

  #pragma HLS INTERFACE s_axilite port = return bundle = control



  float v0[200][200];
  float v1[200][240];
  float v2[200][240];

  for (int i=0; i<200; i++) {
    for (int j=0; j<208; j+=16) {
        float16 v = vv0[i*208/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 200)
            v0[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<200; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv1[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v1[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<200; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v = vv2[i*240/16+j/16];
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v2[i][j+k] = v[k];
        }
    }
  }


  #pragma HLS resource variable=v0 core=ram_t2p_bram

  #pragma HLS resource variable=v1 core=ram_t2p_bram

  #pragma HLS resource variable=v2 core=ram_t2p_bram

  float v5;	// L7, [0,0)
  for (int v6 = 0; v6 < 200; v6 += 1) {	// L8, [0,124800010), iterCycle=21, II=13
    for (int v7 = 0; v7 < 240; v7 += 1) {	// L9, [0,624010), iterCycle=21, II=13
      for (int v8 = 0; v8 < 200; v8 += 1) {	// L10, [0,2610), iterCycle=21, II=13
        #pragma HLS pipeline II=13
        float v9 = v5;	// L11, [8,9)
        float v10 = (v8 == 0) ? (float)0.000000 : v9;	// L12, [9,9)
        v5 = v10;	// L13, [9,10)
        if (((v6 - v8) - 1) >= 0) {	// L14, [5,21)
          float v11 = v2[v8][v7];	// L15, [13,15)
          float v12 = v1[v6][v7];	// L16, [5,7)
          float v13 = v3 * v12;	// L17, [7,11)
          float v14 = v0[v6][v8];	// L18, [9,11)
          float v15 = v13 * v14;	// L19, [11,15)
          float v16 = v11 + v15;	// L20, [15,20)
          v2[v8][v7] = v16;	// L21, [20,21)
          float v17 = v1[v8][v7];	// L22, [9,11)
          float v18 = v17 * v14;	// L23, [11,15)
          float v19 = v10 + v18;	// L24, [15,20)
          v5 = v19;	// L25, [20,21)
        }
        float v20 = v2[v6][v7];	// L27, [4,6)
        float v21 = v4 * v20;	// L28, [6,10)
        float v22 = v1[v6][v7];	// L29, [0,2)
        float v23 = v3 * v22;	// L30, [2,6)
        float v24 = v0[v6][v6];	// L31, [4,6)
        float v25 = v23 * v24;	// L32, [6,10)
        float v26 = v21 + v25;	// L33, [10,15)
        float v27 = v5;	// L34, [10,11)
        float v28 = v3 * v27;	// L35, [11,15)
        float v29 = v26 + v28;	// L36, [15,20)
        if (((-v8) + 199) == 0) {	// L37, [20,21)
          v2[v6][v7] = v29;	// L38, [20,21)
        }
      }
    }
  }



  for (int i=0; i<200; i++) {
    for (int j=0; j<240; j+=16) {
        float16 v;
        for (int k=0; k<16; k++) {
            // if (j+k < 200)
            v[k] = v2[i][j+k];
        }
        vv2[i*240/16+j/16] = v;
    }
  }
}

