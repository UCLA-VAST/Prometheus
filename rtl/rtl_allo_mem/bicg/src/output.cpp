
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

#include <algorithm>
#include <cstring>
#include <iostream>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

using namespace std;
void stageS(
  float v0[410][390],
  float v1[410],
  float v2[390]
) {	// L4
  #pragma HLS array_partition variable=v0 complete dim=2
  #pragma HLS array_partition variable=v2 complete dim=1

  l_S_i0_0_i0: for (int i0 = 0; i0 < 410; i0++) {	// L5
  #pragma HLS pipeline II=1
    float v4 = v1[i0];	// L6
    float r;	// L7
    r = v4;	// L8
    l_S_j0_0_j0: for (int j0 = 0; j0 < 390; j0++) {	// L9
      float v7 = v0[i0][j0];	// L10
      float v8 = r;	// L11
      float v9 = v8 * v7;	// L12
      float v10 = v2[j0];	// L13
      float v11 = v10 + v9;	// L14
      v2[j0] = v11;	// L15
    }
  }
}

void stageQ(
  float v12[410][390],
  float v13[390],
  float v14[410]
) {	// L20
  #pragma HLS array_partition variable=v12 complete dim=1
  #pragma HLS array_partition variable=v14 complete dim=1

  l_S_i1_0_j1: for (int j1 = 0; j1 < 390; j1++) {	// L21
  #pragma HLS pipeline II=1
    l_i1: for (int i1 = 0; i1 < 410; i1++) {	// L22
      float v17 = v12[i1][j1];	// L23
      float v18 = v13[j1];	// L24
      float v19 = v17 * v18;	// L25
      float v20 = v14[i1];	// L26
      float v21 = v20 + v19;	// L27
      v14[i1] = v21;	// L28
    }
  }
}

void kernel_nlp(
  float16 vv22[10045], // A
  float16 vv23[10045], // A copy
  float16 vv24[25], // p
  float16 vv25[26], // r
  float16 vv26[26], // q
  float16 vv27[25] // s
) {	// L33


  #pragma HLS interface m_axi port=vv22 offset=slave bundle=gmem0
  #pragma HLS interface m_axi port=vv23 offset=slave bundle=gmem1
  #pragma HLS interface m_axi port=vv24 offset=slave bundle=gmem2
  #pragma HLS interface m_axi port=vv25 offset=slave bundle=gmem3
  #pragma HLS interface m_axi port=vv26 offset=slave bundle=gmem4
  #pragma HLS interface m_axi port=vv27 offset=slave bundle=gmem5



  #pragma HLS INTERFACE s_axilite port = vv22 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv23 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv24 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv25 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv26 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv27 bundle = control


  #pragma HLS INTERFACE s_axilite port = return bundle = control


  float v22[410][390];
  float v23[410][390];
  float v24[390];
  float v25[410];
  float v26[410];
  float v27[390];


  for (int i=0; i<410; i++) {
    for (int j=0; j<400; j+=16) {
        float16 v = vv22[i*400/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 390)
            v22[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<410; i++) {
    for (int j=0; j<400; j+=16) {
        float16 v = vv23[i*400/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 390)
            v23[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<400; i+=16) {
    float16 v = vv24[i/16];
    for (int j=0; j<16; j++) {
        if (i+j < 390)
        v24[i+j] = v[j];
    }
  }

  for (int i=0; i<416; i+=16) {
    float16 v = vv25[i/16];
    for (int j=0; j<16; j++) {
        if (i+j < 410)
        v25[i+j] = v[j];
    }
  }

  for (int i=0; i<416; i+=16) {
    float16 v = vv26[i/16];
    for (int j=0; j<16; j++) {
        if (i+j < 410)
        v26[i+j] = v[j];
    }
  }

  for (int i=0; i<400; i+=16) {
    float16 v = vv27[i/16];
    for (int j=0; j<16; j++) {
        if (i+j < 390)
        v27[i+j] = v[j];
    }
  }


  #pragma HLS dataflow
  #pragma HLS array_partition variable=v22 complete dim=2
  #pragma HLS array_partition variable=v23 complete dim=1
  #pragma HLS array_partition variable=v27 complete dim=1
  #pragma HLS array_partition variable=v26 complete dim=1

  stageS(v22, v25, v27);	// L34
  stageQ(v23, v24, v26);	// L35



  for (int i=0; i<416; i+=16) {
    float16 v;
    for (int j=0; j<16; j++) {
        if (i+j < 410)
        v[j] = v26[i+j];
    }
    vv26[i/16] = v;
  }

  for (int i=0; i<400; i+=16) {
    float16 v;
    for (int j=0; j<16; j++) {
        if (i+j < 390)
        v[j] = v27[i+j];
    }
    vv27[i/16] = v;
  }

}

