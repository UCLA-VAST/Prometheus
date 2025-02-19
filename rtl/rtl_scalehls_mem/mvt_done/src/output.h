#ifndef PROMETHEUS_H
#define PROMETHEUS_H

#include <ap_int.h>
#include <hls_stream.h>
#include <hls_vector.h>

#include <algorithm>
#include <cstring>
#include <iostream>

typedef hls::vector<float, 16> float16;
typedef hls::vector<float, 8> float8;
typedef hls::vector<float, 4> float4;
typedef hls::vector<float, 2> float2;
typedef hls::vector<float, 1> float1;

void kernel_nlp(
  float16 vv0[10000],
  float16 vv1[25],
  float16 vv2[25],
  float16 vv3[25],
  float16 vv4[25]
);

#endif  // PROMETHEUS_H
