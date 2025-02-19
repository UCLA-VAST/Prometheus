
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
using namespace std;

#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

void compute_tmp(
  // float v0[250],
  hls::stream<float> &v0,
  // float v1[250],
  hls::stream<float> &v1,
  float v2[250][250],
  float v3[250][250],
  float v4[250],
  // float v5[250]
  hls::stream<float> &v5
) {	// L2
#pragma HLS array_partition variable=v2 complete dim=1
#pragma HLS array_partition variable=v3 complete dim=1

  float tt[250];	// L3
  #pragma HLS array_partition variable=tt complete dim=0
  for (int v7 = 0; v7 < 250; v7++) {	// L5
  #pragma HLS unroll
    tt[v7] = 0.000000;	// L5
  }
  float yy[250];	// L6
  #pragma HLS array_partition variable=yy complete dim=0
  l_load_i0: for (int i0 = 0; i0 < 250; i0++) {	// L7
  #pragma HLS pipeline II=1
    // float v10 = v0[i0];	// L8
    float v10 = v0.read();	// L8
    yy[i0] = v10;	// L9
  }
  l_tmp_j: for (int j = 0; j < 250; j++) {	// L11
  #pragma HLS pipeline II=1
    l_i: for (int i = 0; i < 250; i++) {	// L12
      float v13 = v2[i][j];	// L13
      float v14 = v4[j];	// L14
      float v15 = v13 * v14;	// L15
      float v16 = tt[i];	// L16
      float v17 = v16 + v15;	// L17
      tt[i] = v17;	// L18
      float v18 = v3[i][j];	// L19
      float v19 = v4[j];	// L20
      float v20 = v18 * v19;	// L21
      float v21 = yy[i];	// L22
      float v22 = v21 + v20;	// L23
      yy[i] = v22;	// L24
    }
  }
  l_store_i1: for (int i1 = 0; i1 < 250; i1++) {	// L27
    float v24 = tt[i1];	// L28
    // v5[i1] = v24;	// L29
    v5.write(v24);
    float v25 = yy[i1];	// L30
    // v1[i1] = v25;	// L31
    v1.write(v25);
  }
}

void compute_y(
  // float v26[250],
  hls::stream<float> &v26,
  float v27[250],
  // float v28[250]
  hls::stream<float> &v28
) {	// L35
  l_load_i01: for (int i01 = 0; i01 < 250; i01++) {	// L36
  #pragma HLS pipeline II=1
    // float v30 = v28[i01];	// L37
    float v30 = v28.read();	// L37
    float v31 = v30 * 0.100000;	// L39
    // float v32 = v26[i01];	// L40
    float v32 = v26.read();	// L40
    float v33 = v32 * 0.100000;	// L41
    float v34 = v31 + v33;	// L42
    v27[i01] = v34;	// L43
  }
}

void kernel_nlp(
  float16 vv35[250*256/16],
  float16 vv36[250*256/16],
  float16 vv37[256/16],
  float16 vv38[256/16]
) {	// L47

  #pragma HLS interface m_axi port=vv35 offset=slave bundle=gmem0
  #pragma HLS interface m_axi port=vv36 offset=slave bundle=gmem1
  #pragma HLS interface m_axi port=vv37 offset=slave bundle=gmem2
  #pragma HLS interface m_axi port=vv38 offset=slave bundle=gmem3


  #pragma HLS INTERFACE s_axilite port = vv35 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv36 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv37 bundle = control
  #pragma HLS INTERFACE s_axilite port = vv38 bundle = control



  #pragma HLS INTERFACE s_axilite port = return bundle = control

  float v35[250][250];
  float v36[250][250];
  float v37[250];
  float v38[250];

  for (int i=0; i<250; i++) {
    for (int j=0; j<256; j+=16) {
        float16 v = vv35[i*256/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 250)
            v35[i][j+k] = v[k];
        }
    }
  }

  for (int i=0; i<250; i++) {
    for (int j=0; j<256; j+=16) {
        float16 v = vv36[i*256/16+j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 250)
            v36[i][j+k] = v[k];
        }
    }
  }

  for (int j=0; j<256; j+=16) {
        float16 v = vv37[j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 250)
            v37[j+k] = v[k];
        }
    }

    for (int j=0; j<256; j+=16) {
        float16 v = vv38[j/16];
        for (int k=0; k<16; k++) {
            if (j+k < 250)
            v38[j+k] = v[k];
        }
    }

  

#pragma HLS dataflow
  // float y_init[250];	// L48
  hls::stream<float> y_init;
  #pragma HLS stream variable=y_init depth=250

  for (int v40 = 0; v40 < 250; v40++) {	// L50
    // y_init[v40] = 0.000000;	// L50
    y_init.write(0.000000);
  }
  // float y_fifo[250];	// L51
  hls::stream<float> y_fifo;
  #pragma HLS stream variable=y_fifo depth=250
  // float tmp[250];	// L52
  hls::stream<float> tmp;
  #pragma HLS stream variable=tmp depth=250

  compute_tmp(y_init, y_fifo, v35, v36, v37, tmp);	// L53
  compute_y(y_fifo, v38, tmp);	// L54

  for (int j=0; j<256; j+=16) {
        float16 v;
        for (int k=0; k<16; k++) {
            if (j+k < 250)
             v[k] = v38[j+k];
        }
        vv38[j/16] = v;
    }
}

