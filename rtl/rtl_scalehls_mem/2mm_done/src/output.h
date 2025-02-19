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
  float16 vv0[2520],
  float16 vv1[2520],
  float16 vv2[2660],
  float16 vv3[2520],
  float16 vv4[2520],
  float v5,
  float v6,
  float16 vv7[2160],
  float16 vv8[2520]
);

#endif  // PROMETHEUS_H
