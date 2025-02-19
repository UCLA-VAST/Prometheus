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
  float16 vv28[240 * 208 / 16],
  float16 vv29[240 * 208 / 16],
  float16 vv30[240 * 240 / 16],
  float16 vv31[240 * 240 / 16]
);
#endif  // PROMETHEUS_H
