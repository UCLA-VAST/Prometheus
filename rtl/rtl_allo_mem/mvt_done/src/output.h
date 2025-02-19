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
  float16 vv28[10000],
  float16 vv29[10000],
  float16 vv30[25],
  float16 vv31[25],
  float16 vv32[25],
  float16 vv33[25],
  float16 vv34[25],
  float16 vv35[25]
);
#endif  // PROMETHEUS_H
